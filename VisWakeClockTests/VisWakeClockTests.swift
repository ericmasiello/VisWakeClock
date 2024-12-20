//
//  VisWakeClockTests.swift
//  VisWakeClockTests
//
//  Created by Eric Masiello on 12/20/24.
//

import Testing
@testable import VisWakeClock

struct VisWakeClockTests {
  @Test func example() async throws {
    #expect(EmojiManager.option(by: DateHelper.createDateFromString(year: 2024, month: 12, day: 20)!) == .snow)
  }
}
