//
//	Int+Z.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 3/15/19.
//	Copyright © 2019 Electricwoods. All rights reserved.
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

extension Int {

	public init?(any: Any?) {
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
