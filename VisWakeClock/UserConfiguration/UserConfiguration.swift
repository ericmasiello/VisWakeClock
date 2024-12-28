//
//  UserConfiguration.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 11/19/24.
//

import Foundation
import SwiftData

struct CountdownEvent: Codable, Identifiable, Equatable {
  var id = UUID()
  var date: Date
  var name: String
}

@Model
class UserConfiguration {
  var id: UUID = UUID()
  var wakeupTime: Date? = Date.now
  var wakeupDuration: Double = 45
  var isIdleTimerDisabled: Bool = true
  var countdownEvents: [CountdownEvent] = []
  
  var stringId: String { id.uuidString }

  init(wakeupTime: Date) {
    self.wakeupTime = wakeupTime
  }

  init(wakeupTime: Date, wakeupDuration: Double) {
    self.wakeupTime = wakeupTime
    self.wakeupDuration = wakeupDuration
  }
  
  var sortedCountdownEvents: [CountdownEvent] {
    countdownEvents.sorted(by: { $0.date < $1.date })
  }
}
