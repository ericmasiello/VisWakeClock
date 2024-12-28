//
//  DaysUntilView.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 12/17/24.
//

import SwiftUI

enum EventErrorKind: Error {
  case invalidDate(String, Date)
  case invalidDateRange(String, Date, Date)
}

public struct DaysUntilView: View {
  var events: [CountdownEvent]
  var referenceDate: Date = Date()
  
  func daysUntilEvent(_ event: CountdownEvent) throws -> Int {
    guard let eventDate = DateHelper.normalizeTimeFromDate(event.date) else {
      throw EventErrorKind.invalidDate("Invalid event date", event.date)
    }
    guard let referenceDate = DateHelper.normalizeTimeFromDate(referenceDate) else {
      throw EventErrorKind.invalidDate("Invalid reference date", referenceDate)
    }
    
    guard let result = Calendar.current.dateComponents([.day], from: referenceDate, to: eventDate).day else {
      throw EventErrorKind.invalidDateRange("Invalid days until", referenceDate, eventDate)
    }
    
    return result
  }
  
  public var body: some View {
    
    if let event = EventHelper.nextEvent(events, from: referenceDate), let days = try? daysUntilEvent(event) {
      switch days {
      case 0:
        Text("Today is \(event.name)!")
      case 1:
        Text("Tomorrow is \(event.name)!")
      default:
        Text("\(days) days until \(event.name)")
      }
    } else {
      EmptyView()
    }
  }
}

#Preview("Multiple days countdown") {
  let referenceDate = DateHelper.createDateFromString(year: 2024, month: 12, day: 17)!
  
  let events: [CountdownEvent] = [
    CountdownEvent(date: DateHelper.createDateFromString(year: 2024, month: 12, day: 31)!, name: "NYE"),
    CountdownEvent(date: DateHelper.createDateFromString(year: 2024, month: 12, day: 25)!, name: "Christmas"),
  ]
  
  return DaysUntilView(events: events, referenceDate: referenceDate)
}

#Preview("Day before countdown") {
  let referenceDate = DateHelper.createDateFromString(year: 2024, month: 12, day: 24)!
  
  let events: [CountdownEvent] = [
    CountdownEvent(date: DateHelper.createDateFromString(year: 2024, month: 12, day: 31)!, name: "NYE"),
    CountdownEvent(date: DateHelper.createDateFromString(year: 2024, month: 12, day: 25)!, name: "Christmas"),
  ]
  
  return DaysUntilView(events: events, referenceDate: referenceDate)
}

#Preview("Zero days") {
  let referenceDate = DateHelper.createDateFromString(year: 2024, month: 12, day: 25)!
  
  let events: [CountdownEvent] = [
    CountdownEvent(date: DateHelper.createDateFromString(year: 2024, month: 12, day: 31)!, name: "NYE"),
    CountdownEvent(date: DateHelper.createDateFromString(year: 2024, month: 12, day: 25)!, name: "Christmas"),
  ]
  
  return DaysUntilView(events: events, referenceDate: referenceDate)
}

#Preview("Next event") {
  let referenceDate = DateHelper.createDateFromString(year: 2024, month: 12, day: 26)!
  
  let events: [CountdownEvent] = [
    CountdownEvent(date: DateHelper.createDateFromString(year: 2024, month: 12, day: 31)!, name: "NYE"),
    CountdownEvent(date: DateHelper.createDateFromString(year: 2024, month: 12, day: 25)!, name: "Christmas"),
  ]
  
  return DaysUntilView(events: events, referenceDate: referenceDate)
}

#Preview("No Events") {
  let referenceDate = DateHelper.createDateFromString(year: 2025, month: 01, day: 01)!
  
  let events: [CountdownEvent] = [
    CountdownEvent(date: DateHelper.createDateFromString(year: 2024, month: 12, day: 31)!, name: "NYE"),
    CountdownEvent(date: DateHelper.createDateFromString(year: 2024, month: 12, day: 25)!, name: "Christmas"),
  ]
  
  return DaysUntilView(events: events, referenceDate: referenceDate)
}
