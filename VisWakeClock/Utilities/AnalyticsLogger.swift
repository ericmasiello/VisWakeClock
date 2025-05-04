//
//  AnalyticsLogger.swift
//  VisWakeClock
//
//  Created by Eric Masiello on 5/3/25.
//

import Statsig
import SwiftUI

class AnalyticsLogger {
  static func initialize() {
    // Only initialize Statsig if we're not in a test or simulator environment
    if EnvironmentHelper.shouldSendToAnalytics() == false {
      return
    }
    Statsig.initialize(sdkKey: "client-hnmNZKXyozBgNH11IxjD2iAwTZ1b9YlYQrq4fHQwC56") { error in
      if let error = error {
        /**
         note: this can happen if the user is offline so we may want to expore batter patterns for this or potentially
         not logging it whatsoever.
         */
        ErrorLogger.log(message: "Failed to initialized Statsig with error \(String(describing: error))")
        return
      }
    }
  }
  
  static func shutDown(scenePhase: ScenePhase) {
    if EnvironmentHelper.shouldSendToAnalytics() == false {
      return
    }
    
    /**
     I'm unclear if this is the best pattern but the Statsig docs recommend flushing the events when the app goes inactive/background.
     See https://docs.statsig.com/client/iosClientSDK#shutting-statsig-down
     */
    if scenePhase == .inactive || scenePhase == .background {
      Statsig.shutdown()
    }
  }
  
  static func updateUserWithResult(userId: String) {
    if EnvironmentHelper.shouldSendToAnalytics() {
      Statsig.updateUserWithResult(StatsigUser(userID: userId))
    }
  }
  
  static func log(eventName: String, metadata: [String: String]? = nil) {
    if EnvironmentHelper.shouldSendToAnalytics() {
      Statsig.logEvent(eventName, metadata: metadata)
    }
  }
  
  static func checkGate(gateName: String) -> Bool {
    Statsig.checkGate("edit_event")
  }
}
