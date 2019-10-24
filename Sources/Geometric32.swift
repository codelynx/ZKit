//
//	Geometric32.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 10/24/19.
//	Copyright © 2019 Electricwoods LLC. All rights reserved.
//

import Foundation
import CoreGraphics

struct Point: Hashable, CustomStringConvertible {
	
	var x: Float
	var y: Float
	
	static func - (lhs: Point, rhs: Point) -> Point {
		return Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
	}
	
	static func + (lhs: Point, rhs: Point) -> Point {
		return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
	
	static func * (lhs: Point, rhs: Float) -> Point {
		return Point(x: lhs.x * rhs, y: lhs.y * rhs)
	}
	
	static func / (lhs: Point, rhs: Float) -> Point {
		return Point(x: lhs.x / rhs, y: lhs.y / rhs)
	}
	
	static func • (lhs: Point, rhs: Point) -> Float { // dot product
		return lhs.x * rhs.x + lhs.y * rhs.y
	}
	
	static func × (lhs: Point, rhs: Point) -> Float { // cross product
		return lhs.x * rhs.y - lhs.y * rhs.x
	}
	
	init<X: FloatCovertible, Y: FloatCovertible>(_ x: X, _ y: Y) {
		self.x = x.floatValue
		self.y = y.floatValue
	}
	init<X: FloatCovertible, Y: FloatCovertible>(x: X, y: Y) {
		self.x = x.floatValue
		self.y = y.floatValue
	}
	init(_ point: CGPoint) {
		self.x = Float(point.x)
		self.y = Float(point.y)
	}
	
	var length²: Float {
		return (x * x) + (y * y)
	}
	
	var length: Float {
		return sqrt(self.length²)
	}
	
	var normalized: Point {
		let length = self.length
		return Point(x: x/length, y: y/length)
	}
	
	func angle(to: Point) -> Float {
		return atan2(to.y - self.y, to.x - self.x)
	}
	
	func angle(from: Point) -> Float {
		return atan2(self.y - from.y, self.x - from.x)
	}
	
	static func == (lhs: Point, rhs: Point) -> Bool {
		return lhs.x == rhs.y && lhs.y == rhs.y
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(self.x)
		hasher.combine(self.y)
	}

	var description: String {
		return "(x:\(x), y:\(y))"
	}
	
	static let zero = Point(x: 0, y: 0)
	static let nan = Point(x: Float.nan, y: Float.nan)
	
	func offsetBy(x: Float, y: Float) -> Point {
		return Point(x: self.x + x, y: self.y + y)
	}
}


struct Size: CustomStringConvertible {
	var width: Float
	var height: Float
	
	init<W: FloatCovertible, H: FloatCovertible>(_ width: W, _ height: H) {
		self.width = width.floatValue
		self.height = height.floatValue
	}
	
	init<W: FloatCovertible, H: FloatCovertible>(width: W, height: H) {
		self.width = width.floatValue
		self.height = height.floatValue
	}
	init(_ size: CGSize) {
		self.width = Float(size.width)
		self.height = Float(size.height)
	}
	var description: String {
		return "(w:\(width), h:\(height))"
	}
}


struct Rect: CustomStringConvertible {
	var origin: Point
	var size: Size
	
	init(origin: Point, size: Size) {
		self.origin = origin; self.size = size
	}
	init(_ origin: Point, _ size: Size) {
		self.origin = origin; self.size = size
	}
	init<X: FloatCovertible, Y: FloatCovertible, W: FloatCovertible, H: FloatCovertible>(_ x: X, _ y: Y, _ width: W, _ height: H) {
		self.origin = Point(x: x, y: y)
		self.size = Size(width: width, height: height)
	}
	init<X: FloatCovertible, Y: FloatCovertible, W: FloatCovertible, H: FloatCovertible>(x: X, y: Y, width: W, height: H) {
		self.origin = Point(x: x, y: y)
		self.size = Size(width: width, height: height)
	}
	init(_ rect: CGRect) {
		self.origin = Point(rect.origin)
		self.size = Size(rect.size)
	}
	
	var width: Float { return size.width }
	var height: Float { return size.height }
	
	var minX: Float { return min(origin.x, origin.x + size.width) }
	var maxX: Float { return max(origin.x, origin.x + size.width) }
	var midX: Float { return (origin.x + origin.x + size.width) / 2.0 }
	var minY: Float { return min(origin.y, origin.y + size.height) }
	var maxY: Float { return max(origin.y, origin.y + size.height) }
	var midY: Float { return (origin.y + origin.y + size.height) / 2.0 }
	
	var minXminY: Point { return Point(x: minX, y: minY) }
	var midXminY: Point { return Point(x: midX, y: minY) }
	var maxXminY: Point { return Point(x: maxX, y: minY) }
	
	var minXmidY: Point { return Point(x: minX, y: midY) }
	var midXmidY: Point { return Point(x: midX, y: midY) }
	var maxXmidY: Point { return Point(x: maxX, y: midY) }
	
	var minXmaxY: Point { return Point(x: minX, y: maxY) }
	var midXmaxY: Point { return Point(x: midX, y: maxY) }
	var maxXmaxY: Point { return Point(x: maxX, y: maxY) }
	
	var cgRectValue: CGRect { return CGRect(x: CGFloat(origin.x), y: CGFloat(origin.y), width: CGFloat(size.width), height: CGFloat(size.height)) }
	var description: String { return "{Rect: (\(origin.x),\(origin.y))-(\(size.width), \(size.height))}" }
	
	static var zero = Rect(x: 0, y: 0, width: 0, height: 0)
	
	func offsetBy(x: Float, y: Float) -> Rect {
		return Rect(origin: self.origin.offsetBy(x: x, y: y), size: self.size)
	}
	
	func offsetBy(point: Point) -> Rect {
		return Rect(origin: self.origin + point, size: self.size)
	}
	
	func insetBy(dx: Float, dy: Float) -> Rect {
		return Rect(CGRect(self).insetBy(dx: CGFloat(dx), dy: CGFloat(dy)))
	}
}


extension CGPoint {

	init(_ point: Point) {
		self.init(x: CGFloat(point.x), y: CGFloat(point.y))
	}

}

extension CGRect {

	init(_ rect: Rect) {
		self.init(origin: CGPoint(rect.origin), size: CGSize(rect.size))
	}

}
