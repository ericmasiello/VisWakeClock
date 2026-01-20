//
//  CountdownManager.swift
//  VisWakeClock
//
//  Created by Eric Masiello on 1/19/26.
//

import Combine
import Foundation

@MainActor
final class CountdownManager: ObservableObject {

  /// Represents what should be shown to the UI: minutes when >= 60s remain, otherwise seconds
  enum DisplayUnit {
    case minutes, seconds

    var name: String {
      switch self {
        case .minutes: return "min"
        case .seconds: return "sec"
      }
    }
  }

  @Published private(set) var displayValue: Int = 0
  @Published private(set) var displayUnit: DisplayUnit = .minutes
  /// The number of seconds remaining
  private var secondsRemaining: Int = 0
  /// The timer task
  private var timer: Task<Void, Never>?

  /// Start a countdown for the specified number of minutes.
  func startCountdown(seconds: Int) {
    stopCountdown()
    let minutes = seconds / 60
    secondsRemaining = seconds
    let minutesLeft = max(0, minutes)
    if secondsRemaining >= 60 {
      displayUnit = .minutes
      displayValue = minutesLeft
    } else {
      displayUnit = .seconds
      displayValue = secondsRemaining
    }
    timer = Task {
      while secondsRemaining > 0 && !Task.isCancelled {
        try? await Task.sleep(for: .seconds(1))
        secondsRemaining -= 1
        let nextMinutes = max(0, secondsRemaining / 60)
//        if nextMinutes != minutesLeft {
//          minutesLeft = nextMinutes
//        }
        // Update display mode/value: show minutes when >= 60s remain, otherwise seconds
        if secondsRemaining >= 60 {
          if displayUnit != .minutes { displayUnit = .minutes }
          if displayValue != minutesLeft { displayValue = minutesLeft }
        } else {
          if displayUnit != .seconds { displayUnit = .seconds }
          if displayValue != secondsRemaining { displayValue = secondsRemaining }
        }
      }
      if secondsRemaining <= 0 {
//        minutesLeft = 0
        displayUnit = .seconds
        displayValue = 0
      }
    }
  }

  /// Cancel any countdown in progress
  func stopCountdown() {
    timer?.cancel()
    timer = nil
  }

  deinit {
    timer?.cancel()
    timer = nil
  }
}

// Usage Example (not included in build):
// let countdown = CountdownManager()
// countdown.startCountdown(minutes: 5)
// countdown.$minutesLeft.sink { print("Minutes Left: \($0)") }

