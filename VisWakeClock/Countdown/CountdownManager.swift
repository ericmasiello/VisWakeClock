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
    if secondsRemaining >= 60 {
      // break the self.secondsRemining into minutes and seconds
      let minutes = String(secondsRemaining / 60)
      var seconds = String(secondsRemaining.remainderReportingOverflow(dividingBy: 60).partialValue)

      // pad the seconds to always be at least 2 characters long, starting with a zero
      seconds = String(repeating: "0", count: 2 - seconds.count) + seconds

      return "\(minutes):\(seconds) min"
    }

    return "\(secondsRemaining) sec"
  }

  var isRunning: Bool {
    if timer != nil && !timer!.isCancelled && secondsRemaining > 0 {
      return true
    }
    return false
  }

  @Published private(set) var secondsRemaining: Int = 0

  // TODO: can i get rid of this duplicate value?
  /// The number of seconds remaining
//  private var temp_secondsRemaining: Int = 0
  /// The timer task
  private var timer: Task<Void, Never>?

  /// Start a countdown for the specified number of minutes.
  func startCountdown(seconds: Int) {
    stopCountdown()

    var temp_secondsRemaining = max(0, seconds)
    secondsRemaining = temp_secondsRemaining

    timer = Task { [weak self] in
      guard let self = self else { return }

      while temp_secondsRemaining > 0 && !Task.isCancelled {
        try? await Task.sleep(for: .seconds(1))
        temp_secondsRemaining -= 1

        if self.secondsRemaining != temp_secondsRemaining {
          self.secondsRemaining = temp_secondsRemaining
        }
      }

      if temp_secondsRemaining <= 0 {
        secondsRemaining = 0
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
