//
//	Data+Z.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 9/6/21.
//

import Foundation


public extension Data {

	func hexadecimalString() -> String {
		let n = 16
		var string = ""
		for base in stride(from: 0, to: self.count, by: n) {
			string += ((0 ..< n).compactMap { base+$0 < self.count ? String(format: "%02x", self[base+$0]) : nil }.joined()) + "\r"
		}
		return string
	}

}
