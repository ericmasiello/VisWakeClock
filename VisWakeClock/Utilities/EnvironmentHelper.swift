//
//  EnvironmentHelper.swift
//  VisWakeClock
//
//  Created by Claude on 5/1/2025.
//

import Foundation

enum EnvironmentHelper {
  /// Determines if the app is running in a test or simulator environment
  /// - Returns: Boolean indicating if we're in a test or simulator environment
  static func isTestOrSimulatorEnvironment() -> Bool {
    #if targetEnvironment(simulator)
      return true
    #else
      // Check for XCTest presence
      let isRunningXCTest = NSClassFromString("XCTestCase") != nil
      return isRunningXCTest
    #endif
  }

  /// Determines if we should send data to analytics/monitoring services
  /// - Returns: Boolean indicating if we should send data
  static func shouldSendToAnalytics() -> Bool {
    return !isTestOrSimulatorEnvironment()
  }
}
