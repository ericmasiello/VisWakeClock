//
//  HomeClockView.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 11/11/24.
//

import SwiftUI

typealias HandleBackTapped = () -> Void

struct HomeClockView: View {
  @Bindable var userConfiguration: UserConfiguration
  @StateObject private var locationManager: LocationManager
  @StateObject private var weatherManager: WeatherManager
  @StateObject private var dateTimeManager: DateTimeManager
  @State private var fontSize: CGFloat = 0
  var handleBackTapped: HandleBackTapped

  init(userConfiguration config: UserConfiguration, handleBackTapped closure: @escaping HandleBackTapped) {
    userConfiguration = config
    let lm = LocationManager()
    _locationManager = StateObject(wrappedValue: lm)
    _weatherManager = StateObject(wrappedValue: WeatherManager(locationManager: lm))
    _dateTimeManager = StateObject(wrappedValue: DateTimeManager())
    handleBackTapped = closure
    _fontSize = State(wrappedValue: computeSize())
  }

  func computeSize() -> CGFloat {
    let denominator = 5.0
    var fudge = (((denominator - 1) * 2) * -1) // - 32

    /**
     * TODO: this could use some work but these values appear to work reasonably at the moment.
     * We should validate it against more device sizes like smaller iPhones, bigger iPhones, and even
     * an iPad Mini
     */
    if UIDevice.current.userInterfaceIdiom == .phone {
      fudge -= 12
    } else if UIDevice.current.userInterfaceIdiom == .pad {
      fudge -= 32
    }

    #if os(iOS)
      let size = (UIScreen.main.bounds.width / denominator) + fudge
    #else
      #warning("TODO: Unsupported platform")
      let size = CGFloat(0)
    #endif
    return size
  }

  func formatTime(_ date: Date?) -> String {
    guard let date = date else {
      return "Unknown"
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"

    return formatter.string(from: date)
  }

  private var emojiOption: EmojiOption {
    EmojiManager.option(by: dateTimeManager.now)
  }

  private var viewMode: ViewMode {
    guard let wakeupTime = userConfiguration.wakeupTime else {
      return .dim
    }

    return ViewModeManager.mode(
      by: dateTimeManager.now, wakeup: wakeupTime, wakeupDuration: userConfiguration.wakeupDuration)
  }

  private var currentTime: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"

    return dateFormatter.string(from: Date.now)
  }

  var body: some View {
    BounceView(recomputeValue: fontSize) {
      Button(action: {
        handleBackTapped()
      }) {
        VStack(alignment: .leading, spacing: 0) {
          if viewMode == .active {
            EmojiView(option: emojiOption, size: fontSize)
          }
          DaysUntilView(events: userConfiguration.countdownEvents).padding(.bottom, 8).font(.headline)
          ClockView(size: fontSize, viewMode: viewMode, now: dateTimeManager.now)
          HStack {
            Text("Wake up time \(formatTime(userConfiguration.wakeupTime))")
            Spacer()
            TemperatureView(temperatureF: weatherManager.weather?.current.temperature2m ?? 0.0)
              .opacity(weatherManager.weather?.current.temperature2m == nil ? 0.0 : 1.0)
          }
        }
        .fixedSize() // constrains it to widest element
        .opacity(viewMode == .dim ? 0.65 : 1)
      }
    }
    .accessibilityLabel(Text("Current time is \(currentTime). Tap to return the main view"))
    .buttonStyle(.plain)
    .onAppear {
      AnalyticsLogger.log(eventName: "homeClockViewDidAppear")
      #if os(iOS)
        UIApplication.shared.isIdleTimerDisabled = self.userConfiguration.isIdleTimerDisabled
      #endif
    }
    .onChange(of: UIScreen.main.bounds.width) {
      // recompute fontSize whenever screen size changes
      fontSize = computeSize()
    }
    .navigationBarBackButtonHidden()
  }
}
