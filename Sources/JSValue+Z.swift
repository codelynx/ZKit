//
//	JSValue+Z.swift
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
import JavaScriptCore

public extension Int {
	init(_ value: JSValue) {
		self.init(value.toInt32())
	}
}

public extension Bool {
	init(_ value: JSValue) {
		self.init(value.toBool())
	}
}

public extension Double {
	init(_ value: JSValue) {
		self.init(value.toDouble())
	}
}

public extension Int32 {
	init(_ value: JSValue) {
		self.init(value.toInt32())
	}
}

public extension UInt32 {
	init(_ value: JSValue) {
		self.init(value.toUInt32())
	}
}

/*
extension NSNumber {
convenience init?(_ value: JSValue) {
if let number = value.toNumber() {
// no initializer like this, not sure how we can provide this
self = NSNumber(number: number)
}
return nil
}
}
*/

public extension Date {
	init?(_ value: JSValue) {
		if let date = value.toDate() {
			self.init(timeInterval: 0, since: date)
		}
		else { return nil }
	}
}

public extension NSArray {
	convenience init?(_ value: JSValue) {
		if let array = value.toArray() as NSArray? {
			self.init(array: array)
		}
		else { return nil }
	}
}

public extension NSDictionary {
	convenience init?(_ value: JSValue) {
		if let dictionary = value.toDictionary() as NSDictionary? {
			self.init(dictionary: dictionary)
		}
		else { return nil }
	}
}

public extension JSContext {
	subscript(key: String) -> Any? {
		get { return self.objectForKeyedSubscript(key as NSString) }
		set { self.setObject(newValue, forKeyedSubscript: key as NSString) }
	}
}
