//
//	XColor.swift
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

#if os(iOS) || os(visionOS)
import UIKit
public typealias XColor = UIColor
#elseif os(macOS)
import AppKit
public typealias XColor = NSColor
#endif

public typealias XRGBA = (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)
public typealias XHSBA = (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat)

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


public extension XColor {

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

	var rgba: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
		var (r, g, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
		self.getRed(&r, green: &g, blue: &b, alpha: &a)
		return (r, g, b, a)
	}
	
	var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
		var (h, s, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
		self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
		return (h, s, b, a)
	}
	
	convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
		self.init(red: r, green: g, blue: b, alpha: a)
	}

	convenience init(r: Double, g: Double, b: Double, a: Double) {
		self.init(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
	}

	convenience init(r: Float, g: Float, b: Float, a: Float) {
		self.init(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
	}

	convenience init(h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
		self.init(hue: h, saturation: s, brightness: b, alpha: a)
	}

	convenience init(h: Double, s: Double, b: Double, a: Double) {
		self.init(hue: CGFloat(h), saturation: CGFloat(s), brightness: CGFloat(b), alpha: CGFloat(a))
	}

	convenience init(h: Float, s: Float, b: Float, a: Float) {
		self.init(hue: CGFloat(h), saturation: CGFloat(s), brightness: CGFloat(b), alpha: CGFloat(a))
	}

	#if os(macOS)
	var ciColor: CIColor {
		return CIColor(cgColor: cgColor)
	}
	#endif

	func with(hue: CGFloat? = nil, saturation: CGFloat? = nil, brightness: CGFloat? = nil, alpha: CGFloat? = nil) -> XColor {
		self.withAlphaComponent(0.5)
		var (h, s, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
		self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
		return XColor(hue: hue ?? h, saturation: saturation ?? s, brightness: brightness ?? b, alpha: alpha ?? a)
	}

}




