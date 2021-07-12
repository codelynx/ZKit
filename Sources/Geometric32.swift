//
//	Geometric32.swift
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

infix operator •
infix operator ×

public struct Point<T: BinaryFloatingPoint & Codable>: Hashable, CustomStringConvertible, Codable {
	
	public var x: T
	public var y: T
	
	static public func - (lhs: Point, rhs: Point) -> Point {
		return Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
	}
	
	static public func + (lhs: Point, rhs: Point) -> Point {
		return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
	
	static public func * (lhs: Point, rhs: T) -> Point {
		return Point(x: lhs.x * rhs, y: lhs.y * rhs)
	}
	
	static public func / (lhs: Point, rhs: T) -> Point {
		return Point(x: lhs.x / rhs, y: lhs.y / rhs)
	}
	
	static public func • (lhs: Point, rhs: Point) -> T { // dot product
		return lhs.x * rhs.x + lhs.y * rhs.y
	}
	
	static public func × (lhs: Point, rhs: Point) -> T { // cross product
		return lhs.x * rhs.y - lhs.y * rhs.x
	}
	
	public init<X: BinaryFloatingPoint, Y: BinaryFloatingPoint>(_ x: X, _ y: Y) {
		self.x = T(x)
		self.y = T(y)
	}
	public init<X: BinaryFloatingPoint, Y: BinaryFloatingPoint>(x: X, y: Y) {
		self.x = T(x)
		self.y = T(y)
	}
	public init<U: BinaryFloatingPoint>(_ point: Point<U>) {
		self.x = T(point.x)
		self.y = T(point.y)
	}
	public init(_ point: CGPoint) {
		self.x = T(point.x)
		self.y = T(point.y)
	}
	public var length²: T {
		return (x * x) + (y * y)
	}
	
	public var length: T {
		return sqrt(self.length²)
	}
	
	public var normalized: Point {
		let length = self.length
		return Point(x: x/length, y: y/length)
	}
	
	public func angle(to: Point) -> T {
		return T(atan2(CGFloat(to.y - self.y), CGFloat(to.x - self.x)))
	}
	
	public func angle(from: Point) -> T {
		return T(atan2(CGFloat(self.y - from.y), CGFloat(self.x - from.x)))
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
	
	static public var zero: Point { Point(x: 0, y: 0) }
	static public var nan: Point { Point(x: Float.nan, y: Float.nan) }
	
	public func offsetBy(x: T, y: T) -> Point {
		return Point(x: self.x + x, y: self.y + y)
	}
}


public struct Size<T: BinaryFloatingPoint & Codable>: CustomStringConvertible, Codable {
	public var width: T
	public var height: T
	public init<W: BinaryFloatingPoint, H: BinaryFloatingPoint>(_ width: W, _ height: H) {
		self.width = T(width)
		self.height = T(height)
	}
	public init<W: BinaryFloatingPoint, H: BinaryFloatingPoint>(width: W, height: H) {
		self.width = T(width)
		self.height = T(height)
	}
	public init(_ size: CGSize) {
		self.width = T(size.width)
		self.height = T(size.height)
	}
	public init<U: BinaryFloatingPoint>(_ size: Size<U>) {
		self.width = T(size.width)
		self.height = T(size.height)
	}
	public var description: String {
		return "(w:\(width), h:\(height))"
	}
}


public struct Rect<T: BinaryFloatingPoint & Codable>: CustomStringConvertible, Codable {
	public var origin: Point<T>
	public var size: Size<T>
	
	public init(origin: Point<T>, size: Size<T>) {
		self.origin = origin; self.size = size
	}
	public init(_ origin: Point<T>, _ size: Size<T>) {
		self.origin = origin; self.size = size
	}
	public init<X: BinaryFloatingPoint, Y: BinaryFloatingPoint, W: BinaryFloatingPoint, H: BinaryFloatingPoint>(_ x: X, _ y: Y, _ width: W, _ height: H) {
		self.origin = Point<T>(x: x, y: y)
		self.size = Size<T>(width: width, height: height)
	}
	public init<X: BinaryFloatingPoint, Y: BinaryFloatingPoint, W: BinaryFloatingPoint, H: BinaryFloatingPoint>(x: X, y: Y, width: W, height: H) {
		self.origin = Point<T>(x: x, y: y)
		self.size = Size<T>(width: width, height: height)
	}
	public init<U: BinaryFloatingPoint>(_ rect: Rect<U>) {
		self.origin = Point<T>(rect.origin)
		self.size = Size<T>(rect.size)
	}
	public init(_ rect: CGRect) {
		self.origin = Point(rect.origin)
		self.size = Size(rect.size)
	}
	
	public var width: T { return size.width }
	public var height: T { return size.height }
	
	public var minX: T { return min(origin.x, origin.x + size.width) }
	public var maxX: T { return max(origin.x, origin.x + size.width) }
	public var midX: T { return (origin.x + origin.x + size.width) / 2.0 }
	public var minY: T { return min(origin.y, origin.y + size.height) }
	public var maxY: T { return max(origin.y, origin.y + size.height) }
	public var midY: T { return (origin.y + origin.y + size.height) / 2.0 }
	
	public var minXminY: Point<T> { return Point(x: minX, y: minY) }
	public var midXminY: Point<T> { return Point(x: midX, y: minY) }
	public var maxXminY: Point<T> { return Point(x: maxX, y: minY) }
	
	public var minXmidY: Point<T> { return Point(x: minX, y: midY) }
	public var midXmidY: Point<T> { return Point(x: midX, y: midY) }
	public var maxXmidY: Point<T> { return Point(x: maxX, y: midY) }
	
	public var minXmaxY: Point<T> { return Point(x: minX, y: maxY) }
	public var midXmaxY: Point<T> { return Point(x: midX, y: maxY) }
	public var maxXmaxY: Point<T> { return Point(x: maxX, y: maxY) }
	
	public var cgRectValue: CGRect { return CGRect(x: CGFloat(origin.x), y: CGFloat(origin.y), width: CGFloat(size.width), height: CGFloat(size.height)) }
	public var description: String { return "{Rect: (\(origin.x),\(origin.y))-(\(size.width), \(size.height))}" }
	
	static public var zero: Rect { Rect(x: 0, y: 0, width: 0, height: 0) }
	
	public func offsetBy(x: T, y: T) -> Rect {
		return Rect(origin: self.origin.offsetBy(x: x, y: y), size: self.size)
	}
	
	public func offsetBy(point: Point<T>) -> Rect {
		return Rect(origin: self.origin + point, size: self.size)
	}
	
	public func insetBy(dx: T, dy: T) -> Rect {
		return Rect(CGRect(self).insetBy(dx: CGFloat(dx), dy: CGFloat(dy)))
	}
}


extension CGPoint {

	public init<T: BinaryFloatingPoint>(_ point: Point<T>) {
		self.init(x: CGFloat(point.x), y: CGFloat(point.y))
	}

}

extension CGSize {

	public init<T: BinaryFloatingPoint>(_ size: Size<T>) {
		self.init(width: CGFloat(size.width), height: CGFloat(size.height))
	}

}

extension CGRect {

	public init<T: BinaryFloatingPoint>(_ rect: Rect<T>) {
		self.init(origin: CGPoint(rect.origin), size: CGSize(rect.size))
	}

}

