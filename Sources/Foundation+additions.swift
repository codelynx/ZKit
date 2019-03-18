//
//	Foundation+additions.swift
//	SSI-ios
//
//	Created by Kaz Yoshikawa on 2/19/18.
//	Copyright © 2018 Electricwoods LLC. All rights reserved.
//

import Foundation

extension NSDecimalNumber: Comparable {
	
	public static func == (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
		return lhs.compare(rhs) == .orderedSame
	}
	
	public static func < (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
		return lhs.compare(rhs) == .orderedAscending
	}
	
	// MARK: - Arithmetic Operators
	
	public static prefix func - (value: NSDecimalNumber) -> NSDecimalNumber {
		return value.multiplying(by: NSDecimalNumber(mantissa: 1, exponent: 0, isNegative: true))
	}
	
	public static func + (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
		return lhs.adding(rhs)
	}
	
	public static func - (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
		return lhs.subtracting(rhs)
	}
	
	public static func * (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
		return lhs.multiplying(by: rhs)
	}
	
	public static func / (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
		return lhs.dividing(by: rhs)
	}
	
	public static func ^ (lhs: NSDecimalNumber, rhs: Int) -> NSDecimalNumber {
		return lhs.raising(toPower: rhs)
	}
}


