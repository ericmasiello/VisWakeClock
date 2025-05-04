//
//  ErrorLogger.swift
//  VisWakeClock
//
//  Created by Eric Masiello on 5/3/25.
//

import Sentry

class ErrorLogger {
  static func initialize() {
    guard !EnvironmentHelper.shouldSendToAnalytics() else {
      return
    }

    SentrySDK.start { options in
      options.dsn = "https://8a8857516c36a9daf0014ff6e680d6bd@o218382.ingest.us.sentry.io/4508480854032384"
      options.debug = true // Enabled debug when first installing is always helpful
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0

      // Sample rate for profiling, applied on top of TracesSampleRate.
      // We recommend adjusting this value in production.
      options.profilesSampleRate = 1.0

      // Uncomment the following lines to add more data to your events
      options.attachScreenshot = true // This adds a screenshot to the error events
      options.attachViewHierarchy = true // This adds the view hierarchy to the error events
    }
  }

  static func log(error: Error) {
    guard !EnvironmentHelper.shouldSendToAnalytics() else {
      return
    }
    SentrySDK.capture(error: error)
  }

  static func log(message: String) {
    guard !EnvironmentHelper.shouldSendToAnalytics() else {
      return
    }
    SentrySDK.capture(message: message)
  }
}
