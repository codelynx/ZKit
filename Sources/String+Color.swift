//
//	String+Color.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 3/24/16.
//	Copyright © 2016 Electricwoods LLC Inc. The MIT License.
//

import Foundation
import UIKit



fileprivate extension String {
	
	var hexadecimalColorComponents: [CGFloat]? {
		
		let table: [Character : UInt8] = [
			"0": 0x0, "1": 0x1, "2": 0x2, "3": 0x3, "4": 0x4, "5": 0x5, "6": 0x6, "7": 0x7, "8": 0x8, "9": 0x9,
			"a": 0xa, "b": 0xb, "c": 0xc, "d": 0xd, "e": 0xe, "f": 0xf,
			"A": 0xa, "B": 0xb, "C": 0xc, "D": 0xd, "E": 0xe, "F": 0xf
		]
		
		let length = self.count
		if (length == 7) || (length == 9) {
			var components = [CGFloat]()
			var byte: UInt8 = 0
			for (index, character) in self.enumerated() {
				if index == 0 {
					if character != Character("#") { return nil }
				}
				else if let value = table[character] {
					if index % 2 == 1 {
						byte = value
					}
					else {
						byte = byte * 0x10 + value
						components.append(CGFloat(byte) / 255.0)
					}
				}
				else { return nil }
			}
			return components
		}
		else { return nil }
	}
	
}


extension UIColor {
	
	convenience init?(hexadecimalString: String) {
		if let components = hexadecimalString.hexadecimalColorComponents {
			switch components.count {
			case 3: self.init(red: components[0], green: components[1], blue: components[2], alpha: 1.0)
			case 4: self.init(red: components[0], green: components[1], blue: components[2], alpha: components[3])
			default: return nil
			}
		}
		else { return nil }
	}
	
	var hexadecimalString: String {
		var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
		self.getRed(&r, green: &g, blue: &b, alpha: &a)
		return "#" + [r, g, b, a].map { String(format: "%2x", $0) }.joined()
	}
	
}
