//
//	simd+Z.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 10/13/21.
//

import UIKit
import simd


public extension simd_float4 {
	init(_ color: UIColor) {
		var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
		color.getRed(&r, green: &g, blue: &b, alpha: &a)
		self = simd_float4(Float(r), Float(g), Float(b), Float(a))
	}
	init<T: BinaryFloatingPoint>(_ color: ZRGBA<T>) {
		self = simd_float4(Float(color.r), Float(color.g), Float(color.b), Float(color.a))
	}
}
