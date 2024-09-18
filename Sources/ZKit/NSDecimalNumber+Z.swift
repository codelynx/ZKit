//
//	NSDecimalNumber+Z.swift
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

infix operator ** : MultiplicationPrecedence

extension NSDecimalNumber: @retroactive Comparable {
	
	public static func < (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
		return lhs.compare(rhs) == .orderedAscending
	}
	
	public static func == (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
		return lhs.compare(rhs) == .orderedSame
	}
}

public extension NSDecimalNumber {
	
	// MARK: - Arithmetic Operators
	
	static prefix func - (value: NSDecimalNumber) -> NSDecimalNumber {
		return value.multiplying(by: NSDecimalNumber(value: -1))
	}
	
	static func + (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
		return lhs.adding(rhs)
	}
	
	static func - (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
		return lhs.subtracting(rhs)
	}
	
	static func * (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
		return lhs.multiplying(by: rhs)
	}
	
	static func / (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
		return lhs.dividing(by: rhs)
	}
	
	static func ** (lhs: NSDecimalNumber, rhs: Int) -> NSDecimalNumber {
		return lhs.raising(toPower: rhs)
	}
	
	// Convenience initializer
	convenience init?(_ number: NSNumber?) {
		guard let number = number else { return nil }
		self.init(decimal: number.decimalValue)
	}
	
	// Computed property
	var isNotANumber: Bool {
		self == NSDecimalNumber.notANumber
	}
}
