//
//  DateHelper.swift
//  VisWakeClock
//
//  Created by Eric Masiello on 12/20/24.
//
import Foundation

class DateHelper {
  static func createDateFromString(year: Int, month: Int, day: Int) -> Date? {
    return DateHelper.createDateFromString(year: year, month: month, day: day, hour: nil, minute: nil)
  }
  
  static func createDateFromString(hour: Int, minute: Int) -> Date? {
    let now = Date()
    return DateHelper.createDateFromString(year: now.component(.year), month: now.component(.month), day: now.component(.day), hour: hour, minute: minute)
  }
  
  static func createDateFromString(year: Int, month: Int, day: Int, hour: Int?, minute: Int?) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    let hour = hour ?? 0
    let minute = minute ?? 0
    return formatter.date(from: "\(year)/\(month)/\(day) \(hour):\(minute)")
  }
  /**
   * Returns a new date with the hour, minute, and second values set to `0`.
   * This is useful when comparing two dates but you want to ignore the time component.
   */
  static func normalizeTimeFromDate(_ date: Date) -> Date? {
    var dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
    dateComponents.hour = 0
    dateComponents.minute = 0
    dateComponents.second = 0
    
    return Calendar.current.date(from: dateComponents)
  }
}
