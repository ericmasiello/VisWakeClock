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

    secondsRemaining = max(0, seconds)

    // Initialize display based on starting seconds
    if secondsRemaining >= 60 {
      displayUnit = .minutes
      displayValue = secondsRemaining / 60
    } else {
      displayUnit = .seconds
      displayValue = secondsRemaining
    }

    timer = Task { [weak self] in
      guard let self = self else { return }
      while self.secondsRemaining > 0 && !Task.isCancelled {
        try? await Task.sleep(for: .seconds(1))
        self.secondsRemaining -= 1

        if self.secondsRemaining >= 60 {
          let currentMinutes = self.secondsRemaining / 60
          if self.displayUnit != .minutes { self.displayUnit = .minutes }
          if self.displayValue != currentMinutes { self.displayValue = currentMinutes }
        } else {
          if self.displayUnit != .seconds { self.displayUnit = .seconds }
          if self.displayValue != self.secondsRemaining { self.displayValue = self.secondsRemaining }
        }
      }

      if self.secondsRemaining <= 0 {
        self.displayUnit = .seconds
        self.displayValue = 0
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

