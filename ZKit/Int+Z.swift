//
//	Int+Z.swift
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

//	Usage:
//
//	let a = 10
//	let b = "25"
//	let c = 3.14
//	let d: [String: Any] = ["x": 124, "y": "98", "z": 1.25]
//
//	Int(any: a)			// Optional(10)
//	Int(any: b)			// Optional(25)
//	Int(any: c)			// Optional(3)
//	Int(any: d["x"])	// Optional(124)
//	Int(any: d["y"])	// Optional(98)
//	Int(any: d["z"])	// Optional(1)
//	Int(any: d["q"])	// nil

public extension Int {

	init?(any: Any?) {
		switch any {
		case let value as Int: self.init(value)
		case let value as NSNumber: self.init(value.intValue)
		case let string as String:
			if let value = Int(string) { self.init(value) }
			else { return nil }
		default: return nil
		}
	}

}
