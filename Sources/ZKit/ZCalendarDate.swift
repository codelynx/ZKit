//
//	ZCalendarDate.swift
//	ZKit
//
//	The MIT License (MIT)
//
//	Copyright (c) 2020 Electricwoods LLC, Kaz Yoshikawa.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

import Foundation


//
//	ZCalendarDayOfWeek
//

public enum ZCalendarDayOfWeek: Int {
	case sunday = 1
	case monday = 2
	case tuesday = 3
	case wednesday = 4
	case thrusday = 5
	case friday = 6
	case saturday = 7
}

private let _gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
private let _secondsADay = 60.0 * 60.0 * 24.0


//
//	ZCalendarType
//

public protocol ZCalendarType: Comparable, CustomStringConvertible {
	var integerValue: Int { get }
}

public protocol ZCalendarYearType: ZCalendarType {
	var year: Int { get }
	var firstCalendarMonthOfYear: ZCalendarMonth { get }
	var lastCalendarMonthOfYear: ZCalendarMonth { get }
}

public protocol ZCalendarMonthType: ZCalendarYearType {
	var month: Int { get }
	var firstCalendarDateOfMonth: ZCalendarDate { get }
	var lastCalendarDateOfMonth: ZCalendarDate { get }
	func calendarMonth(offsetByMonths: Int) -> ZCalendarMonth
	func offsetMonths(_ calendarMonth: ZCalendarMonth) -> Int
	var previousCalendarMonth: ZCalendarMonth { get }
	var nextCalendarMonth: ZCalendarMonth { get }
}

public protocol ZCalendarDateType: ZCalendarMonthType {
	var day: Int { get }
	var calendarDayOfWeek: ZCalendarDayOfWeek { get }
	var firstCalendarDayOfYear: ZCalendarDate { get }
	var previousCalendarDate: ZCalendarDate { get }
	var nextCalendarDate: ZCalendarDate { get }
	func calendarDate(offsetByDays days: Int) -> ZCalendarDate
	func calendarDate(offsetByMonths months: Int) -> ZCalendarDate
	func days(sinceCalendarDate calendarDate: ZCalendarDate) -> Int
}


//
//	ZCalendarYear
//

public struct ZCalendarYear: ZCalendarYearType, Hashable {
	public let year: Int
	public init(year: Int) {
		self.year = year
	}
	public var description: String {
		return String(format: "%04d", self.year)
	}
	public var integerValue: Int {
		return year
	}
	public var firstCalendarMonthOfYear: ZCalendarMonth {
		return ZCalendarMonth(year: self.year, month: 1)
	}
	public var lastCalendarMonthOfYear: ZCalendarMonth {
		return ZCalendarMonth(year: self.year, month: 12)
	}
	public static func == (lhs: ZCalendarYear, rhs: ZCalendarYear) -> Bool {
		return lhs.year == rhs.year
	}
	public static func < (lhs: ZCalendarYear, rhs: ZCalendarYear) -> Bool {
		return lhs.year < rhs.year
	}
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.year)
	}
}


//
//	ZCalendarMonth
//

public struct ZCalendarMonth: ZCalendarMonthType, Hashable {
	fileprivate let calendarYear: ZCalendarYear
	public let month: Int
	public var year: Int { return calendarYear.year }
	public init(year: Int, month: Int) {
		self.calendarYear = ZCalendarYear(year: year)
		self.month = month
	}
	public init?(integerValue: Int) {
		var value = integerValue
		let month = value % 100; value /= 100
		let year = value
		var componets = DateComponents()
		componets.year = year
		componets.month = month
		componets.day = 1
		if let _ = _gregorian.date(from: componets) {
			self.calendarYear = ZCalendarYear(year: year)
			self.month = month
		}
		else {
			return nil
		}
	}
	public var description: String {
		return String(format: "%04d/%02d", self.calendarYear.year, self.month)
	}
	public var integerValue: Int {
		return 100 * self.calendarYear.year + self.month;
	}
	public var firstCalendarDateOfMonth: ZCalendarDate {
		return ZCalendarDate(year: self.calendarYear.year, month: month, day: 1)
	}
	public var lastCalendarDateOfMonth: ZCalendarDate {
		let firstDateOfMonth = self.firstCalendarDateOfMonth.date
		let range = (_gregorian as NSCalendar).range(of: .day, in: .month, for: firstDateOfMonth)
		return ZCalendarDate(year: self.calendarYear.year, month: self.month, day: range.length)
	}
	public func calendarMonth(offsetByMonths months: Int) -> ZCalendarMonth {
		var offsetComponents = DateComponents()
		offsetComponents.month = months % 12
		offsetComponents.year = months / 12
		let date = _gregorian.date(byAdding: offsetComponents, to: self.firstCalendarDateOfMonth.date)
		let components = _gregorian.dateComponents([.year, .month], from: date!)
		return ZCalendarMonth(year: components.year!, month: components.month!)
	}
	public func offsetMonths(_ calendarMonth: ZCalendarMonth) -> Int {
		return (self.calendarYear.year * 12 + self.month) - (calendarMonth.year * 12 + calendarMonth.month)
	}
	public var previousCalendarMonth: ZCalendarMonth {
		return calendarMonth(offsetByMonths: -1)
	}
	public var nextCalendarMonth: ZCalendarMonth {
		return calendarMonth(offsetByMonths: 1)
	}
	public var daysInMonth: Int {
		let firstDayOfMonth = self.firstCalendarDateOfMonth.date
		let range = (_gregorian as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: firstDayOfMonth)
		assert(range.location != NSNotFound)
		assert(range.length != NSNotFound)
		return range.length
	}
	public func day(_ day: Int) -> ZCalendarDate {
		return ZCalendarDate(year: self.calendarYear.year, month: self.month, day: day)
	}
	public var firstCalendarMonthOfYear: ZCalendarMonth { return self.calendarYear.firstCalendarMonthOfYear }
	public var lastCalendarMonthOfYear: ZCalendarMonth { return self.calendarYear.lastCalendarMonthOfYear }
	public static func == (lhs: ZCalendarMonth, rhs: ZCalendarMonth) -> Bool {
		return lhs.year == rhs.year && lhs.month == rhs.month
	}
	public static func < (lhs: ZCalendarMonth, rhs: ZCalendarMonth) -> Bool {
		return lhs.integerValue < rhs.integerValue
	}
	public static func + (lhs: ZCalendarMonth, rhs: Int) -> ZCalendarMonth {
		return lhs.calendarMonth(offsetByMonths: rhs)
	}
	public static func - (lhs: ZCalendarMonth, rhs: Int) -> ZCalendarMonth {
		return lhs.calendarMonth(offsetByMonths: -rhs)
	}
	public static func - (lhs: ZCalendarMonth, rhs: ZCalendarMonth) -> Int {
		return lhs.offsetMonths(rhs)
	}
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.year)
		hasher.combine(self.month)
	}
}


//
//	ZCalendarDate
//

public struct ZCalendarDate: ZCalendarDateType, Hashable {
	public let calendarMonth: ZCalendarMonth
	public let day: Int
	public var month: Int { return calendarMonth.month }
	public var year: Int { return calendarMonth.year }
	public init(year: Int, month: Int, day: Int) {
		self.calendarMonth = ZCalendarMonth(year: year, month: month)
		self.day = day
	}
	public init(date: Date = Date()) {
		let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
		let options: NSCalendar.Unit = [.year, .month, .day]
		let components = (calendar as NSCalendar).components(options, from: date)
		self.calendarMonth = ZCalendarMonth(year: components.year!, month: components.month!)
		self.day = components.day!
	}
	public init?(integerValue: Int) {
		var value = integerValue
		let day = value % 100; value /= 100
		let month = value % 100; value /= 100
		let year = value
		var componets = DateComponents()
		componets.year = year
		componets.month = month
		componets.day = day
		if let _ = _gregorian.date(from: componets) {
			self.calendarMonth = ZCalendarMonth(year: year, month: month)
			self.day = day
		}
		else {
			return nil
		}
	}
	public var description: String {
		return String(format: "%04d/%02d/%02d", year, self.month, self.day)
	}
	public var integerValue: Int {
		return 10_000 * year + 100 * self.month + self.day;
	}
	public var date: Date {
		return _gregorian.date(from: self.dateComponents)!
	}
	public var dateComponents: DateComponents {
		var componets = DateComponents()
		componets.year = year
		componets.month = month
		componets.day = day
		return componets
	}
	public var calendarDayOfWeek: ZCalendarDayOfWeek {
		let components = _gregorian.dateComponents([.weekday], from: self.date)
		return ZCalendarDayOfWeek(rawValue: components.weekday!)!
	}
	public var firstCalendarDayOfYear: ZCalendarDate {
		return ZCalendarDate(year: year, month: 1, day: 1)
	}
	public var previousCalendarDate: ZCalendarDate {
		return self.calendarDate(offsetByDays: -1)
	}
	public var nextCalendarDate: ZCalendarDate {
		return self.calendarDate(offsetByDays: 1)
	}
	public func calendarDate(offsetByDays days: Int) -> ZCalendarDate {
		var offsetComponets = DateComponents()
		offsetComponets.day = days
		let date = _gregorian.date(byAdding: offsetComponets, to: self.date)
		return ZCalendarDate(date: date!)
	}
	public func calendarDate(offsetByMonths months: Int) -> ZCalendarDate {
		var offsetComponets = DateComponents()
		offsetComponets.month = months
		let date = _gregorian.date(byAdding: offsetComponets, to: self.date)
		return ZCalendarDate(date: date!)
	}
	public func days(sinceCalendarDate calendarDate: ZCalendarDate) -> Int {
		let t1 = self.date.timeIntervalSinceReferenceDate
		let t2 = calendarDate.date.timeIntervalSinceReferenceDate
		let secondsInDay: TimeInterval = 60 * 60 * 24
		return Int(floor((t2 - t1) / secondsInDay))
	}
	public var firstCalendarMonthOfYear: ZCalendarMonth { return self.calendarMonth.firstCalendarMonthOfYear }
	public var lastCalendarMonthOfYear: ZCalendarMonth { return self.calendarMonth.lastCalendarMonthOfYear }
	public var firstCalendarDateOfMonth: ZCalendarDate { return self.calendarMonth.firstCalendarDateOfMonth }
	public var lastCalendarDateOfMonth: ZCalendarDate { return self.calendarMonth.lastCalendarDateOfMonth }
	public func calendarMonth(offsetByMonths months: Int) -> ZCalendarMonth { return self.calendarMonth.calendarMonth(offsetByMonths: months) }
	public func offsetMonths(_ calendarMonth: ZCalendarMonth) -> Int { return self.calendarMonth.offsetMonths(calendarMonth) }
	public var previousCalendarMonth: ZCalendarMonth { return self.calendarMonth.previousCalendarMonth }
	public var nextCalendarMonth: ZCalendarMonth { return self.calendarMonth.nextCalendarMonth }
	public static var today: ZCalendarDate { return ZCalendarDate(date: Date()) }
	public static func == (lhs: ZCalendarDate, rhs: ZCalendarDate) -> Bool {
		return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
	}
	public static func < (lhs: ZCalendarDate, rhs: ZCalendarDate) -> Bool {
		return lhs.integerValue < rhs.integerValue
	}
	public static func - (lhs: ZCalendarDate, rhs: ZCalendarDate) -> Int {
		let d1 = lhs.date
		let d2 = rhs.date
		let t = d1.timeIntervalSinceReferenceDate - d2.timeIntervalSinceReferenceDate
		let days = ceil(t / _secondsADay)
		return Int(days)
	}
	public static func + (lhs: ZCalendarDate, rhs: Int) -> ZCalendarDate {
		let interval = _secondsADay * Double(rhs)
		return ZCalendarDate(date: lhs.date.addingTimeInterval(interval))
	}
	public static func - (lhs: ZCalendarDate, rhs: Int) -> ZCalendarDate {
		let interval = _secondsADay * Double(rhs)
		return ZCalendarDate(date: lhs.date.addingTimeInterval(-interval))
	}
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.year)
		hasher.combine(self.month)
		hasher.combine(self.day)
	}
}

