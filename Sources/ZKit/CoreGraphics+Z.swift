//
//	CoreGraphics+Z.swift
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
import CoreGraphics
import QuartzCore
import simd

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif


infix operator •
infix operator ×


public extension CGContext {
	#if os(macOS)
	static var current : CGContext? {
		return NSGraphicsContext.current?.cgContext
	}
	#endif
}


public extension CGRect {
	
	/// Make `CGRect` from `CGSize` by assuming `origin` is `(0, 0)`
	/// - Parameter size: size
	init(size: CGSize) {
		self.init(origin: .zero, size: size)
	}
	
	/// Utility computed property to make `CGPath` from `CGRect`
	var cgPath: CGPath {
		return CGPath(rect: self, transform: nil)
	}
	
	/// Utility function to make `CGPath` from `CGRect` with givin corner radius.
	/// - Parameter cornerRadius: corner radius by point
	/// - Returns: `CGPath`
	func cgPath(cornerRadius: CGFloat) -> CGPath {
		
		//	+7-------------6+
		//	0				5
		//	|				|
		//	1				4
		//	+2-------------3+
		
		let cornerRadius = min(size.width * 0.5, size.height * 0.5, cornerRadius)
		let path = CGMutablePath()
		path.move(to: minXmidY + CGPoint(x: 0, y: cornerRadius)) // (0)
		path.addLine(to: minXmaxY - CGPoint(x: 0, y: cornerRadius)) // (1)
		path.addQuadCurve(to: minXmaxY + CGPoint(x: cornerRadius, y: 0), control: minXmaxY) // (2)
		path.addLine(to: maxXmaxY - CGPoint(x: cornerRadius, y: 0)) // (3)
		path.addQuadCurve(to: maxXmaxY - CGPoint(x: 0, y: cornerRadius), control: maxXmaxY) // (4)
		path.addLine(to: maxXminY + CGPoint(x: 0, y: cornerRadius)) // (5)
		path.addQuadCurve(to: maxXminY - CGPoint(x: cornerRadius, y: 0), control: maxXminY) // (6)
		path.addLine(to: minXminY + CGPoint(x: cornerRadius, y: 0)) // (7)
		path.addQuadCurve(to: minXminY + CGPoint(x: 0, y: cornerRadius), control: minXminY) // (0)
		path.closeSubpath()
		return path
	}
	
	var minXminY: CGPoint { return CGPoint(x: minX, y: minY) }
	var midXminY: CGPoint { return CGPoint(x: midX, y: minY) }
	var maxXminY: CGPoint { return CGPoint(x: maxX, y: minY) }
	
	var minXmidY: CGPoint { return CGPoint(x: minX, y: midY) }
	var midXmidY: CGPoint { return CGPoint(x: midX, y: midY) }
	var maxXmidY: CGPoint { return CGPoint(x: maxX, y: midY) }
	
	var minXmaxY: CGPoint { return CGPoint(x: minX, y: maxY) }
	var midXmaxY: CGPoint { return CGPoint(x: midX, y: maxY) }
	var maxXmaxY: CGPoint { return CGPoint(x: maxX, y: maxY) }
	
	/// Utility function to compute `CGRect` that fills of this rect.
	/// - Parameter size: <#size description#>
	/// - Returns: <#description#>
	func aspectFill(_ size: CGSize) -> CGRect {
		let result: CGRect
		let margin: CGFloat
		let horizontalRatioToFit = size.width / size.width
		let verticalRatioToFit = size.height / size.height
		let imageHeightWhenItFitsHorizontally = horizontalRatioToFit * size.height
		let imageWidthWhenItFitsVertically = verticalRatioToFit * size.width
		if (imageHeightWhenItFitsHorizontally > size.height) {
			margin = (imageHeightWhenItFitsHorizontally - size.height) * 0.5
			result = CGRect(x: minX, y: minY - margin, width: size.width * horizontalRatioToFit, height: size.height * horizontalRatioToFit)
		}
		else {
			margin = (imageWidthWhenItFitsVertically - size.width) * 0.5
			result = CGRect(x: minX - margin, y: minY, width: size.width * verticalRatioToFit, height: size.height * verticalRatioToFit)
		}
		return result
	}
	
	func aspectFit(_ size: CGSize) -> CGRect {
		let widthRatio = self.size.width / size.width
		let heightRatio = self.size.height / size.height
		let ratio = min(widthRatio, heightRatio)
		let width = size.width * ratio
		let height = size.height * ratio
		let xmargin = (self.size.width - width) / 2.0
		let ymargin = (self.size.height - height) / 2.0
		return CGRect(x: minX + xmargin, y: minY + ymargin, width: width, height: height)
	}
	
	func transform(to rect: CGRect) -> CGAffineTransform {
		var t = CGAffineTransform.identity
		t = t.translatedBy(x: -self.minX, y: -self.minY)
		t = t.translatedBy(x: rect.minX, y: rect.minY)
		t = t.scaledBy(x: 1 / self.width, y: 1 / self.height)
		t = t.scaledBy(x: rect.width, y: rect.height)
		return t
	}
	
	/// returns an array of the four corners in `CGPoint` of the rect
	/// - Returns: array of four geometric corners 
	func corners() -> [CGPoint] {
		return [
			self.minXminY, self.midXminY, self.maxXminY,
			self.minXmidY, self.midXmidY, self.maxXmidY,
			self.minXmaxY, self.midXmaxY, self.maxXmaxY
		]
	}

	static func + (lhs: CGRect, rhs: CGPoint) -> CGRect {
		return CGRect(origin: lhs.origin + rhs, size: lhs.size)
	}

	static func - (lhs: CGRect, rhs: CGPoint) -> CGRect {
		return CGRect(origin: lhs.origin - rhs, size: lhs.size)
	}

	static func + (lhs: CGRect, rhs: CGSize) -> CGRect {
		return CGRect(origin: lhs.origin, size: lhs.size + rhs)
	}

	static func - (lhs: CGRect, rhs: CGSize) -> CGRect {
		return CGRect(origin: lhs.origin, size: lhs.size - rhs)
	}

}


public extension CGSize {
	
	func aspectFit(_ size: CGSize) -> CGSize {
		let widthRatio = self.width / size.width
		let heightRatio = self.height / size.height
		let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
		let width = size.width * ratio
		let height = size.height * ratio
		return CGSize(width: width, height: height)
	}
	
	static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
		return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
	}
	
	static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
		return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
	}
	
	static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
		return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
	}

	static func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
		return CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
	}

	static func * (lhs: CGSize, rhs: CGSize) -> CGSize {
		return CGSize(width: lhs.width * rhs.width , height: lhs.height * rhs.height)
	}

	static func / (lhs: CGSize, rhs: CGSize) -> CGSize {
		return CGSize(width: lhs.width / rhs.width , height: lhs.height / rhs.height)
	}

}


public extension CGAffineTransform {
	
	static func * (lhs: CGAffineTransform, rhs: CGAffineTransform) -> CGAffineTransform {
		return lhs.concatenating(rhs)
	}

	static func *= (lhs: inout CGAffineTransform, rhs: CGAffineTransform) {
		lhs = lhs * rhs
	}

	func translate(point: CGPoint) -> CGAffineTransform {
		return self.translatedBy(x: point.x, y: point.y)
	}

	func scale(point: CGPoint) -> CGAffineTransform {
		return self.scaledBy(x: point.x, y: point.y)
	}

	func scale(size: CGSize) -> CGAffineTransform {
		return self.scaledBy(x: size.width, y: size.height)
	}

	init (translation: CGPoint) {
		self = CGAffineTransform(translationX: translation.x, y: translation.y)
	}
	
	init(scale: CGPoint) {
		self = CGAffineTransform(scaleX: scale.x, y: scale.y)
	}

	init(scale: CGSize) {
		self = CGAffineTransform(scaleX: scale.width, y: scale.height)
	}
	
}


public extension float4x4 {

	init(_ transform: CGAffineTransform) {
		let t = CATransform3DMakeAffineTransform(transform)
		self.init(
			SIMD4<Float>(Float(t.m11), Float(t.m12), Float(t.m13), Float(t.m14)),
			SIMD4<Float>(Float(t.m21), Float(t.m22), Float(t.m23), Float(t.m24)),
			SIMD4<Float>(Float(t.m31), Float(t.m32), Float(t.m33), Float(t.m34)),
			SIMD4<Float>(Float(t.m41), Float(t.m42), Float(t.m43), Float(t.m44)))
	}

}

// MARK: -

public extension CGPoint {

	static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
		return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
	}
	
	static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
		return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
	
	static func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
		return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
	}
	
	static func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
		return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
	}
	
	static func • (lhs: CGPoint, rhs: CGPoint) -> CGFloat { // dot product
		return lhs.x * rhs.x + lhs.y * rhs.y
	}
	
	static func × (lhs: CGPoint, rhs: CGPoint) -> CGFloat { // cross product
		return lhs.x * rhs.y - lhs.y * rhs.x
	}
	
	var length²: CGFloat {
		return (x * x) + (y * y)
	}
	
	var length: CGFloat {
		return sqrt(self.length²)
	}
	
	var normalized: CGPoint {
		return self / length
	}
	
	static func length²(_ lhs: CGPoint, _ rhs: CGPoint) -> CGFloat {
		return	pow(rhs.x - lhs.x, 2.0) + pow(rhs.y - lhs.y, 2.0)
	}
	
	static func length(_ lhs: CGPoint, _ rhs: CGPoint) -> CGFloat {
		return	sqrt(length²(lhs, rhs))
	}
}
