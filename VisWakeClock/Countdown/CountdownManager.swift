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
  
  var value: String {
    
    if self.secondsRemaining >= 60 {
      
      // break the self.secondsRemining into minutes and seconds
      let minutes = String(self.secondsRemaining / 60)
      var seconds = String(self.secondsRemaining.remainderReportingOverflow(dividingBy: 60).partialValue)
      
      // pad the seconds to always be at least 2 characters long, starting with a zero
      seconds = String(repeating: "0", count: 2 - seconds.count) + seconds
      
      return "\(minutes):\(seconds) min"
    }
    
    return "\(self.secondsRemaining) sec"
    
  }
  
  var isRunning: Bool {
    if timer != nil && !timer!.isCancelled && self.secondsRemaining > 0 {
      return true
    }
    return false
  }

  // TODO: make these both private
  @Published private(set) var secondsRemaining: Int = 0
  // TODO: make these both private
  @Published private(set) var displayUnit: DisplayUnit = .minutes
  
  // TODO: can i get rid of this duplicate value?
  /// The number of seconds remaining
  private var temp_secondsRemaining: Int = 0
  /// The timer task
  private var timer: Task<Void, Never>?

  /// Start a countdown for the specified number of minutes.
  func startCountdown(seconds: Int) {
    stopCountdown()

    temp_secondsRemaining = max(0, seconds)

    // Initialize display based on starting seconds
    if temp_secondsRemaining >= 60 {
      displayUnit = .minutes
    } else {
      displayUnit = .seconds
    }
    
    secondsRemaining = temp_secondsRemaining

    timer = Task { [weak self] in
      guard let self = self else { return }
      while self.temp_secondsRemaining > 0 && !Task.isCancelled {
        try? await Task.sleep(for: .seconds(1))
        self.temp_secondsRemaining -= 1

        if self.temp_secondsRemaining >= 60 {
//          let currentMinutes = self.secondsRemaining / 60
          if self.displayUnit != .minutes {
            self.displayUnit = .minutes
          }
//          if self.internalValue != currentMinutes { self.internalValue = currentMinutes }
        } else {
          if self.displayUnit != .seconds {
            self.displayUnit = .seconds
          }
        }
        
        if self.secondsRemaining != self.temp_secondsRemaining {
          self.secondsRemaining = self.temp_secondsRemaining
        }
      }

      if self.temp_secondsRemaining <= 0 {
        self.displayUnit = .seconds
        self.secondsRemaining = 0
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

