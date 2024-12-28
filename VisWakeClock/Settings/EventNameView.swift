//
//  EventName.swift
//  VisWakeClock
//
//  Created by Eric Masiello on 12/28/24.
//
import SwiftUI

typealias CountdownEventHandler = (CountdownEvent) -> Void

enum EventNameMode {
  case readonly
  case editable
}

struct EventNameView: View {
  var event: CountdownEvent
  var mode = EventNameMode.readonly
  var handleRemoveEvent: CountdownEventHandler
  var handleUpdateEvent: CountdownEventHandler?

  init(event: CountdownEvent, handleRemoveEvent: @escaping CountdownEventHandler) {
    self.event = event
    self.mode = .readonly
    self.handleRemoveEvent = handleRemoveEvent
    self.handleUpdateEvent = nil
  }

  init(event: CountdownEvent, mode: EventNameMode, handleRemoveEvent: @escaping CountdownEventHandler, handleUpdateEvent: @escaping CountdownEventHandler) {
    self.event = event
    self.mode = mode
    self.handleRemoveEvent = handleRemoveEvent
    self.handleUpdateEvent = handleUpdateEvent
  }

  func formatEventDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: date)
  }

  var body: some View {
    let swipeActionButton = Button(role: .destructive, action: {
      handleRemoveEvent(event)
    }) {
      Image(systemName: "trash")
    }

    if mode == .editable {
      Button(action: {
        handleUpdateEvent?(event)
      }) {
        Text("\(event.name) on \(formatEventDate(event.date))")
      }
      .swipeActions {
        swipeActionButton
      }
    } else {
      Text("\(event.name) on \(formatEventDate(event.date))")
        .swipeActions {
          swipeActionButton
        }
    }
  }
}

#Preview("Read only") {
  EventNameView(event: CountdownEvent(date: Date(), name: "My Event"), handleRemoveEvent: { _ in
    // handle remove
  })
}

#Preview("Editable") {
  EventNameView(event: CountdownEvent(date: Date(), name: "My Event"), mode: .editable, handleRemoveEvent: { _ in
    // handle remove
  }) { _ in
    // handle update
  }
}
