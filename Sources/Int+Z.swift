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

	init?(any: Any?) {
		if let value = ((any as? Int) ?? (any as? NSNumber).flatMap { $0.intValue }) {
			self.init(value)
		}
 		else if let value = ((any as? String).flatMap { Int($0) }) {
			self.init(value)
		}
		else { return nil }
	}

}
