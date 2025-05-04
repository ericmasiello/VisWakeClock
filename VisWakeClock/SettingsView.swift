//
//  SettingsView.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 11/11/24.
//
import SwiftData
import SwiftUI

struct SettingsView: View {
  @Bindable var userConfiguration: UserConfiguration
  @State private var wakeupTime: Date
  @State private var isIdleTimerDisabled: Bool
  @State private var newCountdownEvent = CountdownEvent(date: Date(), name: "")
  @State private var newCountdownEventMode: EditEventMode = .add

  init(userConfiguration: UserConfiguration) {
    self.userConfiguration = userConfiguration
    self.isIdleTimerDisabled = userConfiguration.isIdleTimerDisabled
    
    self.wakeupTime = userConfiguration.wakeupTime ?? DateHelper.createDateFromString(hour: 12, minute: 0) ?? Date()
  }

  func formatTime(_ date: Date?) -> String {
    guard let date = date else {
      return "Unknown"
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
  }
  
  var body: some View {
    Form {
      Section {
        DatePicker(
          "Wake up time",
          selection: $wakeupTime,
          displayedComponents: [.hourAndMinute]
        )
        .onChange(of: wakeupTime) { _, newValue in
          
          if newValue == self.userConfiguration.wakeupTime {
            return
          }
          
          self.userConfiguration.wakeupTime = newValue
          AnalyticsLogger.log(eventName: "settingsView.wakeUpTimeChanged")
        }
        
        Toggle("Keep screen on", isOn: $isIdleTimerDisabled)
          .onChange(of: isIdleTimerDisabled) { _, newValue in
            if newValue == self.userConfiguration.isIdleTimerDisabled {
              return
            }
            self.userConfiguration.isIdleTimerDisabled = newValue
            AnalyticsLogger.log(eventName: "settingsView.keepScreenOnChanged", metadata: ["state": String(newValue)])
          }
      }
      
      // Explore converting to a popup sheet
      Section("New Event") {
        TextField("Event name", text: $newCountdownEvent.name)
        DatePicker(
          "Date",
          selection: $newCountdownEvent.date,
          displayedComponents: [.date]
        )
        
        switch newCountdownEventMode {
          case .add:
            Button("Add Event") {
              userConfiguration.countdownEvents.append(newCountdownEvent)
              newCountdownEvent = CountdownEvent(date: Date(), name: "")
              
              AnalyticsLogger.log(eventName: "settingsView.newEventAdded")
            }
            .disabled(newCountdownEvent.name.isEmpty)
          case .edit(id: let id):
            Button("Update Event") {
              userConfiguration.countdownEvents.removeAll { $0.id == id }
              userConfiguration.countdownEvents.append(newCountdownEvent)
              newCountdownEvent = CountdownEvent(date: Date(), name: "")
              newCountdownEventMode = .add
              
              AnalyticsLogger.log(eventName: "settingsView.existingEventUpdated")
            }
            .disabled(newCountdownEvent.name.isEmpty)
        }
      }
      
      Section("Countdown Events") {
        List(userConfiguration.sortedCountdownEvents) { event in
          EventNameView(event: event, mode: AnalyticsLogger.checkGate(gateName: "edit_event") ? .editable : .readonly, handleRemoveEvent: { event in
            guard let index = userConfiguration.countdownEvents.firstIndex(of: event) else {
              return
            }
                  
            userConfiguration.countdownEvents.remove(at: index)
            AnalyticsLogger.log(eventName: "settingsView.eventDeleted")
          }) { updateEvent in
            newCountdownEvent.name = updateEvent.name
            newCountdownEvent.date = updateEvent.date
            newCountdownEventMode = .edit(id: event.id)
          }
        }
        if userConfiguration.sortedCountdownEvents.count == 0 {
          Text("No events added yet")
        }
      }
    }
    .navigationTitle("Edit Settings")
    #if os(iOS)
      .navigationBarTitleDisplayMode(.inline)
    #endif
      .onAppear {
        AnalyticsLogger.log(eventName: "settingsViewDidAppear")
      }
  }
}

#Preview {
  let config = ModelConfiguration(isStoredInMemoryOnly: true)
  let container = try! ModelContainer(for: UserConfiguration.self, configurations: config)
  let userConfig = UserConfiguration(
    wakeupTime: DateHelper.createDateFromString(hour: 6, minute: 15)!
  )

  NavigationStack {
    SettingsView(userConfiguration: userConfig).modelContainer(container)
  }
}
