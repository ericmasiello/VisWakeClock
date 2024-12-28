//
//  VisWakeClockTests.swift
//  VisWakeClockTests
//
//  Created by Eric Masiello on 12/20/24.
//

import Testing
@testable import VisWakeClock

@Suite("Emoji Manager Tests") struct EmojiManagerTests {
  
  @Test("should return the halloween emoji when the month is October") func shouldReturnHalloweenEmojiForDate() async throws {
    #expect(EmojiManager.option(by: DateHelper.createDateFromString(year: 2024, month: 10, day: 01)!) == .halloween)
  }
  
  @Test("should return the thanksgiving emoji when the month is November") func shouldReturnThanksgivingEmojiForDate() async throws {
    #expect(EmojiManager.option(by: DateHelper.createDateFromString(year: 2024, month: 11, day: 01)!) == .thanksgiving)
  }
  
  @Test("should return the snow emoji when the month is December") func shouldReturnSnowEmojiForDate() async throws {
    #expect(EmojiManager.option(by: DateHelper.createDateFromString(year: 2024, month: 12, day: 01)!) == .snow)
  }
  
  @Test("should return the sparkles emoji every other month") func shouldReturnSparklesForEveryOtherMonth() async throws {
    #expect(EmojiManager.option(by: DateHelper.createDateFromString(year: 2024, month: 1, day: 01)!) == .sparkles)
    #expect(EmojiManager.option(by: DateHelper.createDateFromString(year: 2024, month: 2, day: 01)!) == .sparkles)
    #expect(EmojiManager.option(by: DateHelper.createDateFromString(year: 2024, month: 3, day: 01)!) == .sparkles)
    #expect(EmojiManager.option(by: DateHelper.createDateFromString(year: 2024, month: 4, day: 01)!) == .sparkles)
    #expect(EmojiManager.option(by: DateHelper.createDateFromString(year: 2024, month: 5, day: 01)!) == .sparkles)
    #expect(EmojiManager.option(by: DateHelper.createDateFromString(year: 2024, month: 6, day: 01)!) == .sparkles)
    #expect(EmojiManager.option(by: DateHelper.createDateFromString(year: 2024, month: 7, day: 01)!) == .sparkles)
    #expect(EmojiManager.option(by: DateHelper.createDateFromString(year: 2024, month: 8, day: 01)!) == .sparkles)
    #expect(EmojiManager.option(by: DateHelper.createDateFromString(year: 2024, month: 9, day: 01)!) == .sparkles)
  }
}
