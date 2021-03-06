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
import simd


infix operator •
infix operator ×

public protocol FloatingPointType: FloatingPoint, Codable {
	static func + (lhs: Self, rhs: Self) -> Self
	static func - (lhs: Self, rhs: Self) -> Self
	static func * (lhs: Self, rhs: Self) -> Self
	static func / (lhs: Self, rhs: Self) -> Self
	static func atan2(_ lhs: Self, _ rhs: Self) -> Self
	init(_ value: CGFloat)
	var doubleValue: Double { get }
	var floatValue: Float { get }
}

public extension FloatingPointType {
	static func + (lhs: Self, rhs: Self) -> Self { return lhs + rhs }
	static func - (lhs: Self, rhs: Self) -> Self { return lhs - rhs }
	static func * (lhs: Self, rhs: Self) -> Self { return lhs * rhs }
	static func / (lhs: Self, rhs: Self) -> Self { return lhs / rhs }
	var zero: Self { return Self(0) }
	var one: Self { return Self(1) }
	var nan: Self { return Self.nan }
}

extension CGFloat: FloatingPointType {
	public static func atan2(_ lhs: CGFloat, _ rhs: CGFloat) -> CGFloat { CoreGraphics.atan2(lhs, rhs) }
	public var doubleValue: Double { Double(self) }
	public var floatValue: Float { Float(self) }
}

extension Double: FloatingPointType {
	public static func atan2(_ lhs: Double, _ rhs: Double) -> Double { CoreGraphics.atan2(lhs, rhs) }
	public var doubleValue: Double { Double(self) }
	public var floatValue: Float { Float(self) }
}

extension Float: FloatingPointType {
	public static func atan2(_ lhs: Float, _ rhs: Float) -> Float { CoreGraphics.atan2(lhs, rhs) }
	public var doubleValue: Double { Double(self) }
	public var floatValue: Float { Float(self) }
}

extension Half: FloatingPointType {
	public static func atan2(_ lhs: Half, _ rhs: Half) -> Half { Half(CoreGraphics.atan2(CGFloat(lhs), CGFloat(rhs))) }
	public var doubleValue: Double { Double(self) }
	public var floatValue: Float { Float(self) }
}

/*
extension Float {
	static func atan2(_ lhs: Self, _ rhs: Self) -> Self {
		return Float(CoreGraphics.atan2(CGFloat(lhs), CGFloat(rhs)))
	}
}
*/

public struct Point<T: FloatingPointType>: Hashable, CustomStringConvertible, Codable {
	
	public var x: T
	public var y: T
	
	static public func - (lhs: Self, rhs: Self) -> Self {
		return Point<T>(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
	}
	
	static public func + (lhs: Self, rhs: Self) -> Point {
		return Point<T>(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
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
	
	public init(x: T, y: T) {
		self.x = x
		self.y = y
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
		return T.atan2(to.y - self.y, to.x - self.x)
	}
	
	public func angle(from: Point) -> T {
		return T.atan2(self.y - from.y, self.x - from.x)
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
	
	static public var zero: Point { return Point(x: T.zero, y: T.zero) }
	static public var nan: Point { return Point(x: T.nan, y: T.nan) }
	
	public func offsetBy(x: T, y: T) -> Point<T> {
		return Point<T>(x: self.x + x, y: self.y + y)
	}

}

public typealias Point64 = Point<Double>
public typealias Point32 = Point<Float>
public typealias Point16 = Point<Half>


public struct Size<T: FloatingPointType>: CustomStringConvertible, Codable {

	public var width: T
	public var height: T
	
	public init(width: T, height: T) {
		(self.width, self.height) = (width, height)
	}
	
	public init(_ size: CGSize) {
		self.width = T(size.width)
		self.height = T(size.height)
	}
	public var description: String {
		return "(w:\(width), h:\(height))"
	}

}


public typealias Size64 = Size<Double>
public typealias Size32 = Size<Float>
public typealias Size16 = Size<Half>


public struct Rect<T: FloatingPointType>: CustomStringConvertible, Codable {

	public var origin: Point<T>
	public var size: Size<T>
	
	public init(origin: Point<T>, size: Size<T>) {
		self.origin = origin; self.size = size
	}
	public init(_ origin: Point<T>, _ size: Size<T>) {
		self.origin = origin; self.size = size
	}
	public init(x: T, y: T, width: T, height: T) {
		self.origin = Point<T>(x: x, y: y)
		self.size = Size<T>(width: width, height: height)
	}
	public init(_ rect: CGRect) {
		self.origin = Point(rect.origin)
		self.size = Size(rect.size)
	}
	
	public var width: T { return size.width }
	public var height: T { return size.height }
	
	public var minX: T { return min(origin.x, origin.x + size.width) }
	public var maxX: T { return max(origin.x, origin.x + size.width) }
	public var midX: T { return (origin.x + origin.x + size.width) / T(2.0) }
	public var minY: T { return min(origin.y, origin.y + size.height) }
	public var maxY: T { return max(origin.y, origin.y + size.height) }
	public var midY: T { return (origin.y + origin.y + size.height) / T(2.0) }
	
	public var minXminY: Point<T> { return Point(x: minX, y: minY) }
	public var midXminY: Point<T> { return Point(x: midX, y: minY) }
	public var maxXminY: Point<T> { return Point(x: maxX, y: minY) }
	
	public var minXmidY: Point<T> { return Point(x: minX, y: midY) }
	public var midXmidY: Point<T> { return Point(x: midX, y: midY) }
	public var maxXmidY: Point<T> { return Point(x: maxX, y: midY) }
	
	public var minXmaxY: Point<T> { return Point(x: minX, y: maxY) }
	public var midXmaxY: Point<T> { return Point(x: midX, y: maxY) }
	public var maxXmaxY: Point<T> { return Point(x: maxX, y: maxY) }
	
	public var description: String { return "{Rect: (\(origin.x),\(origin.y))-(\(size.width), \(size.height))}" }
	
	public static var zero: Rect<T> { Rect<T>(x: 0, y: 0, width: 0, height: 0) }
	
	public func offsetBy(x: T, y: T) -> Rect<T> {
		return Rect<T>(origin: self.origin.offsetBy(x: x, y: y), size: self.size)
	}
	
	public func offsetBy(point: Point<T>) -> Rect<T> {
		return Rect(origin: self.origin + point, size: self.size)
	}
	
	public func insetBy(dx: T, dy: T) -> Rect<T> {
		return Rect(CGRect(self).insetBy(dx: CGFloat(dx.doubleValue), dy: CGFloat(dy.doubleValue)))
	}

}


public typealias Rect64 = Rect<Double>
public typealias Rect32 = Rect<Float>
public typealias Rect16 = Rect<Half>


public extension CGPoint {

	init<T: FloatingPointType>(_ point: Point<T>) {
		self = CGPoint(x: CGFloat(point.x.doubleValue), y: CGFloat(point.y.doubleValue))
	}

}


public extension CGSize {

	init<T: FloatingPointType>(_ size: Size<T>) {
		self.init(width: CGFloat(size.width.doubleValue), height: CGFloat(size.height.doubleValue))
	}

}


public extension CGRect {

	init<T: FloatingPointType>(_ rect: Rect<T>) {
		self.init(origin: CGPoint(rect.origin), size: CGSize(rect.size))
	}

}


public extension Point32 {

	init<T: FloatingPointType>(x: T, y: T) {
		self = Point32(x: x.floatValue, y: y.floatValue)
	}

	init<T: FloatingPointType>(_ point: Point<T>) {
		self = Point32(x: point.x.floatValue, y: point.y.floatValue)
	}

}


public extension Size32 {

	init<T: FloatingPointType>(width: T, height: T) {
		self = Size32(width: width.floatValue, height: height.floatValue)
	}

	init<T: FloatingPointType>(_ size: Size<T>) {
		self = Size32(width: size.width.floatValue, height: size.height.floatValue)
	}

}


public extension Rect32 {

	init<T: FloatingPointType>(origin: Point<T>, size: Size<T>) {
		self = Rect32(origin: Point32(origin), size: Size32(size))
	}

	init<T: FloatingPointType>(_ rect: Rect<T>) {
		self = Rect32(origin: Point32(rect.origin), size: Size32(rect.size))
	}
}
