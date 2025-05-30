//
//  VisWakeClockUITestsLaunchTests.swift
//  VisWakeClockUITests
//
//  Created by Eric Masiello on 12/20/24.
//

import XCTest

final class VisWakeClockUITestsLaunchTests: XCTestCase {
  override class var runsForEachTargetApplicationUIConfiguration: Bool {
    true
  }

  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  @MainActor
  func testLaunch() throws {
    let app = XCUIApplication()
    app.launch()

    // Insert steps here to perform after app launch but before taking a screenshot,
    // such as logging into a test account or navigating somewhere in the app

    let attachment = XCTAttachment(screenshot: app.screenshot())
    attachment.name = "SplashScreen"
    attachment.lifetime = .keepAlways
    add(attachment)
  }
}
