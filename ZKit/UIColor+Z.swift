//
//	UIColor+Z.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 9/8/21.
//

import UIKit


public extension UIColor {

	func with(hue: CGFloat? = nil, saturation: CGFloat? = nil, brightness: CGFloat? = nil, alpha: CGFloat? = nil) -> UIColor {
		self.withAlphaComponent(0.5)
		var (h, s, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
		self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
		return UIColor(hue: hue ?? h, saturation: saturation ?? s, brightness: brightness ?? b, alpha: alpha ?? a)
	}

}
