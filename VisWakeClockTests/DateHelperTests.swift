//
//  DateHelperTests.swift
//  VisWakeClock
//
//  Created by Eric Masiello on 12/28/24.
//

import Foundation
import Testing
@testable import VisWakeClock

@Suite("Date Helper Tests") enum DateHelperTests {
  @Suite("createDateFromString") struct CreateDateFromString {
    @Test("should create a date out of MM/DD/YYYY") func monthDayYear() async throws {
      let d = DateHelper.createDateFromString(year: 2024, month: 12, day: 01)
      
      #expect(d != nil)
      
      let components = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: d!)
      
      #expect(components.month == 12)
      #expect(components.day == 1)
      #expect(components.year == 2024)
    }
    
    @Test("should create a date out of MM/DD/YYYY HH/MM") func monthDayYearHourMin() async throws {
      let d = DateHelper.createDateFromString(year: 2024, month: 12, day: 01, hour: 11, minute: 30)
      
      #expect(d != nil)
      
      let components = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: d!)
      
      #expect(components.month == 12)
      #expect(components.day == 1)
      #expect(components.year == 2024)
      #expect(components.hour == 11)
      #expect(components.minute == 30)
    }
    
    @Test("should return nil when month is invalid") func invalidMonth() async throws {
      let d = DateHelper.createDateFromString(year: 2024, month: 50, day: 01)
      #expect(d == nil)
    }
    
    @Test("should return nil when year is invalid") func invalidYear() async throws {
      let d = DateHelper.createDateFromString(year: -1, month: 01, day: 01)
      #expect(d == nil)
    }
    
    @Test("should return nil when day is invalid") func invalidDay() async throws {
      let d = DateHelper.createDateFromString(year: 2024, month: 01, day: 50)
      #expect(d == nil)
    }
  }
  
  @Suite("normalizeTimeFromDate") struct NormalizeTimeFromDateTests {
    @Test("should treat dates as the same when only time is different") func normalizeTimeFromDate() async throws {
      let d1 = DateHelper.createDateFromString(year: 2024, month: 12, day: 23, hour: 4, minute: 22)
      let d2 = DateHelper.createDateFromString(year: 2024, month: 12, day: 23, hour: 6, minute: 33)
      
      #expect(d1 != nil)
      #expect(d2 != nil)
      
      let normalizedD1 = DateHelper.normalizeTimeFromDate(d1!)
      let normalizedD2 = DateHelper.normalizeTimeFromDate(d1!)
      
      #expect(normalizedD1 != nil)
      #expect(normalizedD2 != nil)
      #expect(normalizedD1 == normalizedD2)
      
      let components = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: normalizedD1!)
      #expect(components.month == 12)
      #expect(components.day == 23)
      #expect(components.year == 2024)
    }
  }
}
