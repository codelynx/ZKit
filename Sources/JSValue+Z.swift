//
//	JSValue+Z.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 3/13/18.
//	Copyright © 2018 Electricwoods LLC. All rights reserved.
//

import Foundation
import JavaScriptCore

extension Int {
	init(_ value: JSValue) {
		self.init(value.toInt32())
	}
}

extension Bool {
	init(_ value: JSValue) {
		self.init(value.toBool())
	}
}

extension Double {
	init(_ value: JSValue) {
		self.init(value.toDouble())
	}
}

extension Int32 {
	init(_ value: JSValue) {
		self.init(value.toInt32())
	}
}

extension UInt32 {
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

extension Date {
	init?(_ value: JSValue) {
		if let date = value.toDate() {
			self.init(timeInterval: 0, since: date)
		}
		else { return nil }
	}
}

extension NSArray {
	convenience init?(_ value: JSValue) {
		if let array = value.toArray() as NSArray? {
			self.init(array: array)
		}
		else { return nil }
	}
}

extension NSDictionary {
	convenience init?(_ value: JSValue) {
		if let dictionary = value.toDictionary() as NSDictionary? {
			self.init(dictionary: dictionary)
		}
		else { return nil }
	}
}

extension JSContext {
	subscript(key: String) -> Any? {
		get { return self.objectForKeyedSubscript(key as NSString) }
		set { self.setObject(newValue, forKeyedSubscript: key as NSString) }
	}
}
