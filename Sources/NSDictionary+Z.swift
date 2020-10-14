//
//	NSDictionary+Z.swift
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


public extension NSDictionary {
	
	var data: Data? {
		get {
			return try? PropertyListSerialization.data(fromPropertyList: self, format: .xml, options: 0)
		}
	}
	
	func dictionaryByRemovingValues(keyKeys: [String]) -> NSDictionary {
		let dictionary = self.mutableCopy() as! NSMutableDictionary
		for key in keyKeys {
			dictionary.removeObject(forKey: key)
		}
		return dictionary
	}
	
	func dictionaryByRemovingValue(forKey: String) -> NSDictionary {
		let dictionary = NSMutableDictionary(dictionary: self)
		dictionary.removeObject(forKey: forKey)
		return dictionary
	}
	
	func dictionaryByAddingValue(_ value: Any?, for key: String) -> NSDictionary {
		let dictionary = NSMutableDictionary(dictionary: self)
		dictionary.setValue(value, forKey: key)
		return dictionary
	}
	
	static func + (lhs: NSDictionary, rhs: NSDictionary) -> NSDictionary {
		let dictionary = NSMutableDictionary()
		for (key, value) in lhs {
			if let key = key as? NSCopying {
				dictionary[key] = value
			}
		}
		for (key, valueR) in rhs {
			if let key = key as? NSCopying {
				if let valueL = lhs[key] {
					switch (valueL, valueR) {
					case (let dictionaryL as NSDictionary, let dictionaryR as NSDictionary):
						dictionary[key] = dictionaryL + dictionaryR
						break
					case (let arrayL as NSArray, let arrayR as NSArray):
						dictionary[key] = arrayL + arrayR
					default:
						dictionary[key] = valueR
					}
				}
				else {
					dictionary[key] = valueR
				}
			}
		}
		return dictionary
	}
	
}

public extension NSMutableDictionary {
	
	static func += (lhs: inout NSMutableDictionary, rhs: NSDictionary) {
		for (key, valueR) in rhs {
			if let valueL = lhs[key] {
				switch (valueL, valueR) {
				case (let dictionaryL as NSDictionary, let dictionaryR as NSDictionary):
					lhs[key] = dictionaryL + dictionaryR
				case (let arrayL as NSArray, let arrayR as NSArray):
					lhs[key] = arrayL + arrayR
				default:
					lhs[key] = valueR
				}
			}
			else {
				lhs[key] = valueR
			}
		}
	}

	func setDictionary(_ dictionary: NSDictionary) {
		self.setDictionary(dictionary as! [AnyHashable: Any])
	}
}

public extension NSArray {
	
	static func + (lhs: NSArray, rhs: NSArray) -> NSArray {
		let array = NSMutableArray()
		lhs.forEach { array.add($0) }
		rhs.forEach { array.add($0) }
		return array
	}
	
}

public extension NSMutableArray {
	
	static func += (lhs: inout NSMutableArray, rhs: NSArray) {
		for value in rhs {
			lhs.add(value)
		}
	}
	
}


