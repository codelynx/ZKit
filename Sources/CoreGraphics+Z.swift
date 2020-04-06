//
//	CoreGraphics+Z.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 12/12/16.
//	Copyright © 2016 Electricwoods LLC. All rights reserved.
//

import Foundation
import CoreGraphics
import QuartzCore
import simd

infix operator •
infix operator ×


extension CGRect {
	public init(size: CGSize) {
		self.init(origin: .zero, size: size)
	}
	
	public var cgPath: CGPath {
		return CGPath(rect: self, transform: nil)
	}
	
	public func cgPath(cornerRadius: CGFloat) -> CGPath {
		
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
	
	public var minXminY: CGPoint { return CGPoint(x: minX, y: minY) }
	public var midXminY: CGPoint { return CGPoint(x: midX, y: minY) }
	public var maxXminY: CGPoint { return CGPoint(x: maxX, y: minY) }
	
	public var minXmidY: CGPoint { return CGPoint(x: minX, y: midY) }
	public var midXmidY: CGPoint { return CGPoint(x: midX, y: midY) }
	public var maxXmidY: CGPoint { return CGPoint(x: maxX, y: midY) }
	
	public var minXmaxY: CGPoint { return CGPoint(x: minX, y: maxY) }
	public var midXmaxY: CGPoint { return CGPoint(x: midX, y: maxY) }
	public var maxXmaxY: CGPoint { return CGPoint(x: maxX, y: maxY) }
	
	public func aspectFill(_ size: CGSize) -> CGRect {
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
	
	public func aspectFit(_ size: CGSize) -> CGRect {
		let widthRatio = self.size.width / size.width
		let heightRatio = self.size.height / size.height
		let ratio = min(widthRatio, heightRatio)
		let width = size.width * ratio
		let height = size.height * ratio
		let xmargin = (self.size.width - width) / 2.0
		let ymargin = (self.size.height - height) / 2.0
		return CGRect(x: minX + xmargin, y: minY + ymargin, width: width, height: height)
	}
	
	public func transform(to rect: CGRect) -> CGAffineTransform {
		var t = CGAffineTransform.identity
		t = t.translatedBy(x: -self.minX, y: -self.minY)
		t = t.translatedBy(x: rect.minX, y: rect.minY)
		t = t.scaledBy(x: 1 / self.width, y: 1 / self.height)
		t = t.scaledBy(x: rect.width, y: rect.height)
		return t
	}

	static public func + (lhs: CGRect, rhs: CGPoint) -> CGRect {
		return CGRect(origin: lhs.origin + rhs, size: lhs.size)
	}

	static public func - (lhs: CGRect, rhs: CGPoint) -> CGRect {
		return CGRect(origin: lhs.origin - rhs, size: lhs.size)
	}

	static public func + (lhs: CGRect, rhs: CGSize) -> CGRect {
		return CGRect(origin: lhs.origin, size: lhs.size + rhs)
	}

	static public func - (lhs: CGRect, rhs: CGSize) -> CGRect {
		return CGRect(origin: lhs.origin, size: lhs.size - rhs)
	}

}

extension CGSize {
	
	public func aspectFit(_ size: CGSize) -> CGSize {
		let widthRatio = self.width / size.width
		let heightRatio = self.height / size.height
		let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
		let width = size.width * ratio
		let height = size.height * ratio
		return CGSize(width: width, height: height)
	}
	
	static public func - (lhs: CGSize, rhs: CGSize) -> CGSize {
		return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
	}
	
	static public func + (lhs: CGSize, rhs: CGSize) -> CGSize {
		return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
	}
	
	static public func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
		return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
	}

	static public func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
		return CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
	}

	static public func * (lhs: CGSize, rhs: CGSize) -> CGSize {
		return CGSize(width: lhs.width * rhs.width , height: lhs.height * rhs.height)
	}

	static public func / (lhs: CGSize, rhs: CGSize) -> CGSize {
		return CGSize(width: lhs.width / rhs.width , height: lhs.height / rhs.height)
	}

}


extension CGAffineTransform {
	
	static public func * (lhs: CGAffineTransform, rhs: CGAffineTransform) -> CGAffineTransform {
		return lhs.concatenating(rhs)
	}
	
}

extension float4x4 {
	public init(affineTransform: CGAffineTransform) {
		let t = CATransform3DMakeAffineTransform(affineTransform)
		self.init(
			SIMD4<Float>(Float(t.m11), Float(t.m12), Float(t.m13), Float(t.m14)),
			SIMD4<Float>(Float(t.m21), Float(t.m22), Float(t.m23), Float(t.m24)),
			SIMD4<Float>(Float(t.m31), Float(t.m32), Float(t.m33), Float(t.m34)),
			SIMD4<Float>(Float(t.m41), Float(t.m42), Float(t.m43), Float(t.m44)))
	}
}


// MARK: -

public protocol FloatCovertible {
	var floatValue: Float { get }
}

extension CGFloat: FloatCovertible {
	public var floatValue: Float { return Float(self) }
}

extension Int: FloatCovertible {
	public var floatValue: Float { return Float(self) }
}

extension Float: FloatCovertible {
	public var floatValue: Float { return self }
}

// MARK: -

public protocol CGFloatCovertible {
	var cgFloatValue: CGFloat { get }
}

extension CGFloat: CGFloatCovertible {
	public var cgFloatValue: CGFloat { return self }
}

extension Int: CGFloatCovertible {
	public var cgFloatValue: CGFloat { return CGFloat(self) }
}

extension Float: CGFloatCovertible {
	public var cgFloatValue: CGFloat { return CGFloat(self) }
}


// MARK: -

extension CGPoint {
	
	static public func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
		return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
	}
	
	static public func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
		return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
	
	static public func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
		return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
	}
	
	static public func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
		return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
	}
	
	static public func • (lhs: CGPoint, rhs: CGPoint) -> CGFloat { // dot product
		return lhs.x * rhs.x + lhs.y * rhs.y
	}
	
	static public func × (lhs: CGPoint, rhs: CGPoint) -> CGFloat { // cross product
		return lhs.x * rhs.y - lhs.y * rhs.x
	}
	
	public var length²: CGFloat {
		return (x * x) + (y * y)
	}
	
	public var length: CGFloat {
		return sqrt(self.length²)
	}
	
	public var normalized: CGPoint {
		return self / length
	}
	
	static public func length²(_ lhs: CGPoint, _ rhs: CGPoint) -> CGFloat {
		return	pow(rhs.x - lhs.x, 2.0) + pow(rhs.y - lhs.y, 2.0)
	}
	
	static public func length(_ lhs: CGPoint, _ rhs: CGPoint) -> CGFloat {
		return	sqrt(length²(lhs, rhs))
	}
}


extension CGPoint {
	public init<X: CGFloatCovertible, Y: CGFloatCovertible>(_ x: X, _ y: Y) {
		self.init(x: x.cgFloatValue, y: y.cgFloatValue)
	}
}


extension CGSize {
	public init<W: CGFloatCovertible, H: CGFloatCovertible>(_ width: W, _ height: H) {
		self.init(width: width.cgFloatValue, height: height.cgFloatValue)
	}
}

extension CGRect {
	public init<X: CGFloatCovertible, Y: CGFloatCovertible, W: CGFloatCovertible, H: CGFloatCovertible>(_ x: X, _ y: Y, _ width: W, _ height: H) {
		self.init(origin: CGPoint(x, y), size: CGSize(width, height))
	}
}
