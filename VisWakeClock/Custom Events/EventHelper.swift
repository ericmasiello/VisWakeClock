//
//  EventHelper.swift
//  VisWakeClock
//
//  Created by Eric Masiello on 12/28/24.
//
import Foundation

class EventHelper {
  static func nextEvent(_ events: [CountdownEvent], from referenceDate: Date) -> CountdownEvent? {
    
    events
    // sort events by date
      .sorted { $0.date < $1.date }
    // grab the next one that happens after today
      .first { $0.date >= referenceDate }
  }
}
