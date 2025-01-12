//
//  VisWakeClockUITests.swift
//  VisWakeClockUITests
//
//  Created by Eric Masiello on 12/20/24.
//

import XCTest

final class VisWakeClockUITests: XCTestCase {
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  @MainActor
  func testExample() throws {
    // UI tests must launch the application that they test.
    let app = XCUIApplication()
    app.launch()

    // Debug helper - lets you see all the staticTexts visible
    
//    let staticTexts = app.staticTexts
//    for i in 0 ..< staticTexts.count {
//      let text = staticTexts.element(boundBy: i)
//      print(text.label)
////      if text.label.starts(with: "create account") {
////        text.tap()
////        break
////      }
//    }
    
    /**
     @note using `:` as a proxy for the time. Since I'm not mocking the time, we know the
     clock will always display a ":" between the hours and minutes
     */
    let clockText = app.staticTexts[":"]
    XCTAssert(clockText.exists, "Clock text does not exist")
    
    clockText.tap()
    
    let editSettingsTitle = app.staticTexts["Edit Settings"]
    XCTAssert(editSettingsTitle.exists, "Edit Settings title does not exist")
    
    let eventNameTextField = app.textFields["Event name"]
    XCTAssert(eventNameTextField.exists, "Event name does not exist")
    
    eventNameTextField.tap()
    eventNameTextField.typeText("Test Event")
    let addEventButton = app.buttons["Add Event"]
    
    XCTAssert(addEventButton.exists, "Add Event button does not exist")
    XCTAssert(addEventButton.isEnabled, "Add Event button is not enabled")
    
    addEventButton.tap()
    
    let countDownEventsTitle = app.staticTexts["COUNTDOWN EVENTS"]
    XCTAssert(countDownEventsTitle.exists, "Countdown Events title does not exist")
  }

  @MainActor
  func testLaunchPerformance() throws {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
      // This measures how long it takes to launch your application.
      measure(metrics: [XCTApplicationLaunchMetric()]) {
        XCUIApplication().launch()
      }
    }
  }
}
