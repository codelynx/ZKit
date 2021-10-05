//
//	Geometric.swift
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


public struct Point<T: BinaryFloatingPoint & Codable>: Hashable, CustomStringConvertible, Codable {
	
	public var x: T
	public var y: T
	
	public static func - (lhs: Self, rhs: Self) -> Self {
		return Point<T>(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
	}
	
	public static func + (lhs: Self, rhs: Self) -> Point {
		return Point<T>(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
	
	public static func * (lhs: Point, rhs: T) -> Point {
		return Point(x: lhs.x * rhs, y: lhs.y * rhs)
	}
	
	public static func / (lhs: Point, rhs: T) -> Point {
		return Point(x: lhs.x / rhs, y: lhs.y / rhs)
	}
	
	public static func • (lhs: Point, rhs: Point) -> T { // dot product
		return lhs.x * rhs.x + lhs.y * rhs.y
	}
	
	public static func × (lhs: Point, rhs: Point) -> T { // cross product
		return lhs.x * rhs.y - lhs.y * rhs.x
	}
	
	public init<X: BinaryFloatingPoint, Y: BinaryFloatingPoint>(x: X, y: Y) {
		self.x = T(x)
		self.y = T(y)
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
		return T(CoreGraphics.atan2(CGFloat(to.y) - CGFloat(self.y), CGFloat(to.x) - CGFloat(self.x)))
	}
	
	public func angle(from: Point) -> T {
		return T(CoreGraphics.atan2(CGFloat(self.y) - CGFloat(from.y), CGFloat(self.x) - CGFloat(from.x)))
	}
	
	public static func == (lhs: Point, rhs: Point) -> Bool {
		return lhs.x == rhs.y && lhs.y == rhs.y
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.x)
		hasher.combine(self.y)
	}

	public var description: String {
		return "(x:\(x), y:\(y))"
	}
	
	public static var zero: Point { return Point(x: T.zero, y: T.zero) }
	public static var nan: Point { return Point(x: T.nan, y: T.nan) }
	
	public func offsetBy(x: T, y: T) -> Point<T> {
		return Point<T>(x: self.x + x, y: self.y + y)
	}

	func applying(_ transform: CGAffineTransform) -> Point<T> {
		let point = CGPoint(x: CGFloat(self.x), y: CGFloat(self.y)).applying(transform)
		return Point(x: T(point.x), y: T(point.y))
	}

}

public typealias Point64 = Point<Double>
public typealias Point32 = Point<Float>
@available(iOS 14, *)
public typealias Point16 = Point<Float16>


public struct Size<T: BinaryFloatingPoint & Codable>: CustomStringConvertible, Codable {

	public var width: T
	public var height: T
	
	public init<W: BinaryFloatingPoint, H: BinaryFloatingPoint>(width: W, height: H) {
		(self.width, self.height) = (T(width), T(height))
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
@available(iOS 14, *)
public typealias Size16 = Size<Float16>


public struct Rect<T: BinaryFloatingPoint & Codable>: CustomStringConvertible, Codable {

	public var origin: Point<T>
	public var size: Size<T>
	
	public init(origin: Point<T>, size: Size<T>) {
		self.origin = origin; self.size = size
	}
	public init(_ origin: Point<T>, _ size: Size<T>) {
		self.origin = origin; self.size = size
	}
	public init<X: BinaryFloatingPoint, Y: BinaryFloatingPoint, W: BinaryFloatingPoint, H: BinaryFloatingPoint>(x: X, y: Y, width: W, height: H) {
		self.origin = Point<T>(x: T(x), y: T(y))
		self.size = Size<T>(width: T(width), height: T(height))
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
		return Rect(CGRect(self).insetBy(dx: CGFloat(dx), dy: CGFloat(dy)))
	}

}


public typealias Rect64 = Rect<Double>
public typealias Rect32 = Rect<Float>
@available(iOS 14, *)
public typealias Rect16 = Rect<Float16>

public struct AffineTransform<T: BinaryFloatingPoint & Codable>: CustomStringConvertible, Codable, Equatable {

	var a: T
	var b: T
	var c: T
	var d: T
	var tx: T
	var ty: T

	public init<A: BinaryFloatingPoint, B: BinaryFloatingPoint, C: BinaryFloatingPoint, D: BinaryFloatingPoint, TX: BinaryFloatingPoint, TY: BinaryFloatingPoint>(a: A, b: B, c: C, d: D, tx: TX, ty: TY) {
		self.a = T(a)
		self.b = T(b)
		self.c = T(c)
		self.d = T(d)
		self.tx = T(tx)
		self.ty = T(ty)
	}

	public init(_ transform: CGAffineTransform) {
		self.a = T(transform.a)
		self.b = T(transform.b)
		self.c = T(transform.c)
		self.d = T(transform.d)
		self.tx = T(transform.tx)
		self.ty = T(transform.ty)
	}

	public var affineTransform: CGAffineTransform {
		return CGAffineTransform(a: CGFloat(self.a), b: CGFloat(self.b), c: CGFloat(self.c), d: CGFloat(self.d), tx: CGFloat(self.tx), ty: CGFloat(self.ty))
	}

	public static func * (lhs: Self, rhs: Self) -> Self {
		return Self(lhs.affineTransform.concatenating(rhs.affineTransform))
	}

	public static func *= (lhs: inout Self, rhs: Self) {
		lhs = Self(lhs.affineTransform * rhs.affineTransform)
	}

	public func translate<T: BinaryFloatingPoint>(point: Point<T>) -> Self {
		return Self(self.affineTransform.translatedBy(x: CGFloat(point.x), y: CGFloat(point.y)))
	}

	public func scale<U: BinaryFloatingPoint>(point: Point<U>) -> Self {
		return Self(self.affineTransform.scaledBy(x: CGFloat(point.x), y: CGFloat(point.y)))
	}

	public func scale<U: BinaryFloatingPoint>(size: Size<U>) -> Self {
		return Self(self.affineTransform.scaledBy(x: CGFloat(size.width), y: CGFloat(size.height)))
	}

	public init<U: BinaryFloatingPoint>(translation: Point<U>) {
		self = Self(CGAffineTransform(translationX: CGFloat(translation.x), y: CGFloat(translation.y)))
	}
	
	public init<U: BinaryFloatingPoint>(scale: Point<U>) {
		self = Self(CGAffineTransform(scaleX: CGFloat(scale.x), y: CGFloat(scale.y)))
	}

	public init<U: BinaryFloatingPoint>(scale: Size<U>) {
		self = Self(CGAffineTransform(scaleX: CGFloat(scale.width), y: CGFloat(scale.height)))
	}

	public var description: String {
		return String("{AffineTransform: a=\(self.a), b=\(self.b), c=\(self.c), d=\(self.d), tx=\(self.tx), ty=\(self.ty)}")
	}

	public static var identity: Self {
		return Self(CGAffineTransform.identity)
	}

	public static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.affineTransform == rhs.affineTransform
	}

}

public typealias AffineTransform64 = AffineTransform<Double>
public typealias AffineTransform32 = AffineTransform<Float>
@available(iOS 14, *)
public typealias AffineTransform16 = AffineTransform<Float16>

public extension CGAffineTransform {
	init<T: BinaryFloatingPoint>(_ transform: AffineTransform<T>) {
		self = transform.affineTransform
	}
}



public extension CGPoint {

	init<T: BinaryFloatingPoint>(_ point: Point<T>) {
		self = CGPoint(x: CGFloat(point.x), y: CGFloat(point.y))
	}

}


public extension CGSize {

	init<T: BinaryFloatingPoint>(_ size: Size<T>) {
		self.init(width: CGFloat(size.width), height: CGFloat(size.height))
	}

}


public extension CGRect {

	init<T: BinaryFloatingPoint>(_ rect: Rect<T>) {
		self.init(origin: CGPoint(rect.origin), size: CGSize(rect.size))
	}

}


public extension Point32 {

	init<X: BinaryFloatingPoint, Y: BinaryFloatingPoint>(x: X, y: Y) {
		self.x = Float(x)
		self.y = Float(y)
	}

	init<T: BinaryFloatingPoint>(_ point: Point<T>) {
		self = Point32(x: Float(point.x), y: Float(point.y))
	}

}


public extension Size32 {

	init<T: BinaryFloatingPoint>(width: T, height: T) {
		self.width = Float(width)
		self.height = Float(height)
	}

	init<T: BinaryFloatingPoint>(_ size: Size<T>) {
		self = Size32(width: Float(size.width), height: Float(size.height))
	}

}


public extension Rect32 {

	init<T: BinaryFloatingPoint>(origin: Point<T>, size: Size<T>) {
		self = Rect32(origin: Point32(origin), size: Size32(size))
	}

	init<T: BinaryFloatingPoint>(_ rect: Rect<T>) {
		self = Rect32(origin: Point32(rect.origin), size: Size32(rect.size))
	}

}


public extension float4x4 {

	static let identity = matrix_identity_float4x4

	init<T: BinaryFloatingPoint>(_ transform: AffineTransform<T>) {
		self = float4x4(transform.affineTransform)
	}

}

// MARK: -

public extension CGPath {

	private class Info<T: BinaryFloatingPoint & Codable> {
		var pathElements = [BezierPathElement<T>]()
	}
	
	func makePathElements<T: BinaryFloatingPoint & Codable>() -> [BezierPathElement<T>] {
		typealias Element = BezierPathElement
		let elements: [BezierPathElement<T>] = self.pathElements.map {
			switch $0 {
			case .moveTo(let p0): return Element.moveTo(Point(p0))
			case .lineTo(let p1): return Element.lineTo(Point(p1))
			case .quadCurveTo(let p1, let p2): return Element.quadCurveTo(Point(p1), Point(p2))
			case .curveTo(let p1, let p2, let p3): return Element.curveTo(Point(p3), Point(p1), Point(p2))
			case .closeSubpath: return Element.closeSubpath
			}
		}
		return elements
	}

	static func makePath<T: BinaryFloatingPoint & Codable>(elements: [BezierPathElement<T>]) -> CGPath {
		let bezierPath = CGMutablePath()
		for element in elements {
			switch element {
			case .moveTo(let p0): bezierPath.move(to: CGPoint(p0))
			case .lineTo(let p1): bezierPath.addLine(to: CGPoint(p1))
			case .quadCurveTo(let p1, let p2): bezierPath.addQuadCurve(to: CGPoint(p2), control: CGPoint(p1))
			case .curveTo(let p1, let p2, let p3): bezierPath.addCurve(to: CGPoint(p1), control1: CGPoint(p2), control2: CGPoint(p3))
			case .closeSubpath: bezierPath.closeSubpath()
			}
		}
		return bezierPath
	}

}


public enum BezierPathElement<T: BinaryFloatingPoint & Codable>: Equatable, Codable {

	enum CodingKeys: String, CodingKey { case type, values }
	enum ElementType: Int, CodingKey { case move, line, quad, curve, close }

	case moveTo(Point<T>)
	case lineTo(Point<T>)
	case quadCurveTo(Point<T>, Point<T>)
	case curveTo(Point<T>, Point<T>, Point<T>)
	case closeSubpath
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let elemenType = try container.decode(Int.self, forKey: .type)
		switch ElementType(rawValue: elemenType) {
		case .move:
			let values = try container.decode([Point<T>].self, forKey: .values)
			self = BezierPathElement.moveTo(values[0])
		case .line:
			let values = try container.decode([Point<T>].self, forKey: .values)
			self = BezierPathElement.lineTo(values[0])
		case .quad:
			let values = try container.decode([Point<T>].self, forKey: .values)
			self = BezierPathElement.quadCurveTo(values[0], values[1])
		case .curve:
			let values = try container.decode([Point<T>].self, forKey: .values)
			self = BezierPathElement.curveTo(values[0], values[1], values[2])
		case .close:
			self = BezierPathElement.closeSubpath
		default:
			fatalError()
		}
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		switch self {
		case .moveTo(let p0):
			try container.encode(ElementType.move.rawValue, forKey: .type)
			try container.encode([p0], forKey: .values)
		case .lineTo(let p1):
			try container.encode(ElementType.line.rawValue, forKey: .type)
			try container.encode([p1], forKey: .values)
		case .quadCurveTo(let p1, let p2):
			try container.encode(ElementType.quad.rawValue, forKey: .type)
			try container.encode([p1, p2], forKey: .values)
		case .curveTo(let p1, let p2, let p3):
			try container.encode(ElementType.curve.rawValue, forKey: .type)
			try container.encode([p1, p2, p3], forKey: .values)
		case .closeSubpath:
			try container.encode(ElementType.close.rawValue, forKey: .type)
		}
	}

	public static func ==(lhs: BezierPathElement, rhs: BezierPathElement) -> Bool {
		switch (lhs, rhs) {
		case let (.moveTo(l), .moveTo(r)),
			 let (.lineTo(l), .lineTo(r)):
			return l == r
		case let (.quadCurveTo(l1, l2), .quadCurveTo(r1, r2)):
			return l1 == r1 && l2 == r2
		case let (.curveTo(l1, l2, l3), .curveTo(r1, r2, r3)):
			return l1 == r1 && l2 == r2 && l3 == r3
		case (.closeSubpath, .closeSubpath):
			return true
		default:
			return false
		}
	}

}


public class BezierPath<T: BinaryFloatingPoint & Codable>: Codable {
	private (set) public var pathElements: [BezierPathElement<T>]
	public init() {
		self.pathElements = []
	}
	public init(pathElements: [BezierPathElement<T>]) {
		self.pathElements = pathElements
	}
	public init(path: CGPath) {
		self.pathElements = path.makePathElements()
	}
	public var cgPath: CGPath {
		CGPath.makePath(elements: self.pathElements)
	}
	public func move(to point: Point<T>) {
		self.pathElements.append(BezierPathElement.moveTo(point))
	}
	public func addLine(to point: Point<T>) {
		self.pathElements.append(BezierPathElement.lineTo(point))
	}
	public func addQuadCurve(to point: Point<T>, controlPoint: Point<T>) {
		self.pathElements.append(BezierPathElement.quadCurveTo(controlPoint, point))
	}
	public func addCurve(to point: Point<T>, controlPoint1: Point<T>, controlPoint2: Point<T>) {
		self.pathElements.append(BezierPathElement.curveTo(point, controlPoint1, controlPoint2))
	}
	public func closeSubpath() {
		self.pathElements.append(BezierPathElement.closeSubpath)
	}
	public func removeAlllPoints() {
		self.pathElements.removeAll()
	}
	public static func + (lhs: BezierPath<T>, rhs: BezierPath<T>) -> BezierPath {
		return BezierPath(pathElements: lhs.pathElements + rhs.pathElements)
	}
	public static func += (lhs: inout BezierPath, rhs: BezierPath) {
		lhs.pathElements += rhs.pathElements
	}
}


@available(iOS 14, *)
public typealias BezierPath16 = BezierPath<Float16>
public typealias BezierPath32 = BezierPath<Float32>

