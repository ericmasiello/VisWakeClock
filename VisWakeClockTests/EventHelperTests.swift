//
//  EmojiManagerTests 2.swift
//  VisWakeClock
//
//  Created by Eric Masiello on 12/28/24.
//

//
//  VisWakeClockTests.swift
//  VisWakeClockTests
//
//  Created by Eric Masiello on 12/20/24.
//

import Foundation
import Testing
@testable import VisWakeClock

@Suite("Event Helper Tests") struct EventHelperTests {
  let events: [CountdownEvent]

  init() async throws {
    events = [CountdownEvent(
      date: DateHelper.createDateFromString(year: 2024, month: 12, day: 25)!, name: "Christmas"
    ), CountdownEvent(
      date: DateHelper.createDateFromString(year: 2025, month: 1, day: 1)!, name: "New Years"
    ),
    CountdownEvent(
      date: DateHelper.createDateFromString(year: 2024, month: 11, day: 28)!, name: "Thanksgiving"
    ), CountdownEvent(
      date: DateHelper.createDateFromString(year: 2024, month: 12, day: 31)!, name: "New Years Eve"
    )]
  }

  @Test("should get the next event when the event has not yet passed") func nextEventUpcoming() async throws {
    let nextEvent = EventHelper.nextEvent(events, from: DateHelper.createDateFromString(year: 2024, month: 12, day: 24)!)
    #expect(nextEvent!.name == "Christmas")
  }
  
  @Test("should get the next event when the event is the same day") func nextEventSameDay() async throws {
    let nextEvent = EventHelper.nextEvent(events, from: DateHelper.createDateFromString(year: 2024, month: 12, day: 25)!)
    #expect(nextEvent!.name == "Christmas")
  }
  
  @Test("should not get an event when all dates have passed") func eventsAllInPast() async throws {
    let nextEvent = EventHelper.nextEvent(events, from: DateHelper.createDateFromString(year: 2025, month: 01, day: 02)!)
    #expect(nextEvent == nil)
  }
}
