//
//	Geometric32.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 10/24/19.
//	Copyright © 2019 Electricwoods LLC. All rights reserved.
//

import Foundation
import CoreGraphics

public struct Point: Hashable, CustomStringConvertible {
	
	public var x: Float
	public var y: Float
	
	static public func - (lhs: Point, rhs: Point) -> Point {
		return Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
	}
	
	static public func + (lhs: Point, rhs: Point) -> Point {
		return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
	
	static public func * (lhs: Point, rhs: Float) -> Point {
		return Point(x: lhs.x * rhs, y: lhs.y * rhs)
	}
	
	static public func / (lhs: Point, rhs: Float) -> Point {
		return Point(x: lhs.x / rhs, y: lhs.y / rhs)
	}
	
	static public func • (lhs: Point, rhs: Point) -> Float { // dot product
		return lhs.x * rhs.x + lhs.y * rhs.y
	}
	
	static public func × (lhs: Point, rhs: Point) -> Float { // cross product
		return lhs.x * rhs.y - lhs.y * rhs.x
	}
	
	public init<X: FloatCovertible, Y: FloatCovertible>(_ x: X, _ y: Y) {
		self.x = x.floatValue
		self.y = y.floatValue
	}
	public init<X: FloatCovertible, Y: FloatCovertible>(x: X, y: Y) {
		self.x = x.floatValue
		self.y = y.floatValue
	}
	public init(_ point: CGPoint) {
		self.x = Float(point.x)
		self.y = Float(point.y)
	}
	
	public var length²: Float {
		return (x * x) + (y * y)
	}
	
	public var length: Float {
		return sqrt(self.length²)
	}
	
	public var normalized: Point {
		let length = self.length
		return Point(x: x/length, y: y/length)
	}
	
	public func angle(to: Point) -> Float {
		return atan2(to.y - self.y, to.x - self.x)
	}
	
	public func angle(from: Point) -> Float {
		return atan2(self.y - from.y, self.x - from.x)
	}
	
	static public func == (lhs: Point, rhs: Point) -> Bool {
		return lhs.x == rhs.y && lhs.y == rhs.y
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.x)
		hasher.combine(self.y)
	}

	public var description: String {
		return "(x:\(x), y:\(y))"
	}
	
	static public let zero = Point(x: 0, y: 0)
	static public let nan = Point(x: Float.nan, y: Float.nan)
	
	public func offsetBy(x: Float, y: Float) -> Point {
		return Point(x: self.x + x, y: self.y + y)
	}
}


public struct Size: CustomStringConvertible {
	var width: Float
	var height: Float
	
	public init<W: FloatCovertible, H: FloatCovertible>(_ width: W, _ height: H) {
		self.width = width.floatValue
		self.height = height.floatValue
	}
	
	public init<W: FloatCovertible, H: FloatCovertible>(width: W, height: H) {
		self.width = width.floatValue
		self.height = height.floatValue
	}
	public init(_ size: CGSize) {
		self.width = Float(size.width)
		self.height = Float(size.height)
	}
	public var description: String {
		return "(w:\(width), h:\(height))"
	}
}


public struct Rect: CustomStringConvertible {
	public var origin: Point
	public var size: Size
	
	public init(origin: Point, size: Size) {
		self.origin = origin; self.size = size
	}
	public init(_ origin: Point, _ size: Size) {
		self.origin = origin; self.size = size
	}
	public init<X: FloatCovertible, Y: FloatCovertible, W: FloatCovertible, H: FloatCovertible>(_ x: X, _ y: Y, _ width: W, _ height: H) {
		self.origin = Point(x: x, y: y)
		self.size = Size(width: width, height: height)
	}
	public init<X: FloatCovertible, Y: FloatCovertible, W: FloatCovertible, H: FloatCovertible>(x: X, y: Y, width: W, height: H) {
		self.origin = Point(x: x, y: y)
		self.size = Size(width: width, height: height)
	}
	public init(_ rect: CGRect) {
		self.origin = Point(rect.origin)
		self.size = Size(rect.size)
	}
	
	public var width: Float { return size.width }
	public var height: Float { return size.height }
	
	public var minX: Float { return min(origin.x, origin.x + size.width) }
	public var maxX: Float { return max(origin.x, origin.x + size.width) }
	public var midX: Float { return (origin.x + origin.x + size.width) / 2.0 }
	public var minY: Float { return min(origin.y, origin.y + size.height) }
	public var maxY: Float { return max(origin.y, origin.y + size.height) }
	public var midY: Float { return (origin.y + origin.y + size.height) / 2.0 }
	
	public var minXminY: Point { return Point(x: minX, y: minY) }
	public var midXminY: Point { return Point(x: midX, y: minY) }
	public var maxXminY: Point { return Point(x: maxX, y: minY) }
	
	public var minXmidY: Point { return Point(x: minX, y: midY) }
	public var midXmidY: Point { return Point(x: midX, y: midY) }
	public var maxXmidY: Point { return Point(x: maxX, y: midY) }
	
	public var minXmaxY: Point { return Point(x: minX, y: maxY) }
	public var midXmaxY: Point { return Point(x: midX, y: maxY) }
	public var maxXmaxY: Point { return Point(x: maxX, y: maxY) }
	
	public var cgRectValue: CGRect { return CGRect(x: CGFloat(origin.x), y: CGFloat(origin.y), width: CGFloat(size.width), height: CGFloat(size.height)) }
	public var description: String { return "{Rect: (\(origin.x),\(origin.y))-(\(size.width), \(size.height))}" }
	
	static public var zero = Rect(x: 0, y: 0, width: 0, height: 0)
	
	public func offsetBy(x: Float, y: Float) -> Rect {
		return Rect(origin: self.origin.offsetBy(x: x, y: y), size: self.size)
	}
	
	public func offsetBy(point: Point) -> Rect {
		return Rect(origin: self.origin + point, size: self.size)
	}
	
	public func insetBy(dx: Float, dy: Float) -> Rect {
		return Rect(CGRect(self).insetBy(dx: CGFloat(dx), dy: CGFloat(dy)))
	}
}


extension CGPoint {

	public init(_ point: Point) {
		self.init(x: CGFloat(point.x), y: CGFloat(point.y))
	}

}

extension CGRect {

	public init(_ rect: Rect) {
		self.init(origin: CGPoint(rect.origin), size: CGSize(rect.size))
	}

}

// MARK: -

public protocol PointConvertible {
	var pointValue: Point { get }
}

extension Point: PointConvertible {
	public var pointValue: Point { return self }
}

extension CGPoint: PointConvertible {
	public var pointValue: Point { return Point(self) }
}

extension CGSize {
	public init(_ size: Size) {
		self.init(width: CGFloat(size.width), height: CGFloat(size.height))
	}
}
