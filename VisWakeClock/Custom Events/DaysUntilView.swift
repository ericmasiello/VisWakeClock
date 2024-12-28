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
      Text("\(days) days until \(event.name)")
    } else {
      EmptyView()
    }
  }
}

#Preview {
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyy/MM/dd HH:mm"
  let referenceDate = formatter.date(from: "2024/12/17 21:59")!
  
  // create a date for 12/31/2024
  let christmasDate = formatter.date(from: "2024/12/25 21:38")!
  
  let nyeDate = formatter.date(from: "2024/12/31 00:01")!
  
  
  let events: [CountdownEvent] = [
    CountdownEvent(date: nyeDate, name: "NYE"),
    CountdownEvent(date: christmasDate, name: "Christmas"),
  ]
  
  return DaysUntilView(events: events, referenceDate: referenceDate)
}
