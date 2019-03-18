//
//	UIColor+Z.swift
//	Metal2DScroll
//
//	Created by Kaz Yoshikawa on 12/18/16.
//	Copyright © 2016 Electricwoods LLC. All rights reserved.
//

import UIKit


extension UIColor {
	
	public var rgba: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
		var (r, g, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
		self.getRed(&r, green: &g, blue: &b, alpha: &a)
		return (r, g, b, a)
	}
	
	public var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
		var (h, s, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
		self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
		return (h, s, b, a)
	}
	
	public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
		self.init(red: r, green: g, blue: b, alpha: a)
	}
	
	public convenience init(h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
		self.init(hue: h, saturation: s, brightness: b, alpha: a)
	}
	
}




