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
  static func createDateFromString(year: Int, month: Int, day: Int, hour: Int?, minute: Int?) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    let hour = hour ?? 0
    let minute = minute ?? 0
    return formatter.date(from: "\(year)/\(month)/\(day) \(hour):\(minute)")
  }
}
