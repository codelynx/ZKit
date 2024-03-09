//
//	simd+Z.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 10/13/21.
//

#if os(iOS) || os(visionOS)
import UIKit
#endif

#if os(macOS)
import AppKit
#endif

import simd


public extension simd_float4 {
	init(_ color: XColor) {
		var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
		color.getRed(&r, green: &g, blue: &b, alpha: &a)
		self = simd_float4(Float(r), Float(g), Float(b), Float(a))
	}
	init<T: BinaryFloatingPoint>(_ color: ZRGBA<T>) {
		self = simd_float4(Float(color.r), Float(color.g), Float(color.b), Float(color.a))
	}
}
