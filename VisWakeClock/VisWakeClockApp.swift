//
//  VisWake_ClockApp.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 9/15/24.
//

// Import the environment helper
import Foundation
import SwiftData
import SwiftUI

@main
struct VisWakeClockApp: App {
  init() {
    ErrorLogger.initialize()
    AnalyticsLogger.initialize()
  }

  var body: some Scene {
    WindowGroup {
      DataResolverView()
    }
    .modelContainer(for: UserConfiguration.self)
  }
}
