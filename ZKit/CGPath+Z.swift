//
//	CGPath+Z.swift
//	ZKit
//
//	The MIT License (MIT)
//
//	Copyright (c) 2016 Electricwoods LLC, Kaz Yoshikawa.
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


public enum CGPathElement: Equatable {
	case moveTo(CGPoint)
	case lineTo(CGPoint)
	case quadCurveTo(CGPoint, CGPoint)
	case curveTo(CGPoint, CGPoint, CGPoint)
	case closeSubpath
	
	static public func ==(lhs: CGPathElement, rhs: CGPathElement) -> Bool {
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


public extension CGPath {
	
	private class Elements {
		var pathElements = [CGPathElement]()
	}
	
	var pathElements: [CGPathElement] {
		var elements = Elements()
		
		self.apply(info: &elements) { (info, element) -> () in
			guard let infoPointer = UnsafeMutablePointer<Elements>(OpaquePointer(info)) else { return }
			switch element.pointee.type {
			case .moveToPoint:
				let pt = element.pointee.points[0]
				infoPointer.pointee.pathElements.append(.moveTo(pt))
			case .addLineToPoint:
				let pt = element.pointee.points[0]
				infoPointer.pointee.pathElements.append(.lineTo(pt))
			case .addQuadCurveToPoint:
				let pt1 = element.pointee.points[0]
				let pt2 = element.pointee.points[1]
				infoPointer.pointee.pathElements.append(.quadCurveTo(pt1, pt2))
			case .addCurveToPoint:
				let pt1 = element.pointee.points[0]
				let pt2 = element.pointee.points[1]
				let pt3 = element.pointee.points[2]
				infoPointer.pointee.pathElements.append(.curveTo(pt1, pt2, pt3))
			case .closeSubpath:
				infoPointer.pointee.pathElements.append(.closeSubpath)
			@unknown default:
				break
			}
		}
		
		let pathelements = elements.pathElements
		return pathelements
	}
}


public extension CGPath {
	
	static func quadraticCurveLength(_ p0: CGPoint, _ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
		
		// cf. http://www.malczak.linuxpl.com/blog/quadratic-bezier-curve-length/
		
		let a = CGPoint(x: p0.x - 2 * p1.x + p2.x, y: p0.y - 2 * p1.y + p2.y)
		let b = CGPoint(x: 2 * p1.x - 2 * p0.x, y: 2 * p1.y - 2 * p0.y)
		let A = 4 * (a.x * a.x + a.y * a.y)
		let B = 4 * (a.x * b.x + a.y * b.y)
		let C = b.x * b.x + b.y * b.y
		let Sabc = 2 * sqrt(A + B + C)
		let A_2 = sqrt(A)
		let A_32 = 2 * A * A_2
		let C_2 = 2 * sqrt(C)
		let BA = B / A_2
		let L = (A_32 * Sabc + A_2 * B * (Sabc - C_2) + (4 * C * A - B * B) * log((2 * A_2 + BA + Sabc) / (BA + C_2))) / (4 * A_32)
		return L.isNaN ? 0 : L
	}
	
	static func approximateCubicCurveLength(_ p0: CGPoint, _ p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint) -> CGFloat {
		let n = 16
		var length: CGFloat = 0
		var point: CGPoint? = nil
		for i in 0 ..< n {
			let t = CGFloat(i) / CGFloat(n)
			
			let q1 = p0 + (p1 - p0) * t
			let q2 = p1 + (p2 - p1) * t
			let q3 = p2 + (p3 - p2) * t
			
			let r1 = q1 + (q2 - q1) * t
			let r2 = q2 + (q3 - q2) * t
			
			let s = r1 + (r2 - r1) * t
			
			if let point = point {
				length += (point - s).length
			}
			point = s
		}
		return length
	}
	
}


public extension CGPoint {
	static let nan = CGPoint(x: CGFloat.nan, y: CGFloat.nan)
}


public enum PathElement<T: BinaryFloatingPoint & Codable>: Equatable {

	case moveTo(Point<T>)
	case lineTo(Point<T>)
	case quadCurveTo(Point<T>, Point<T>)
	case curveTo(Point<T>, Point<T>, Point<T>)
	case closeSubpath
	
	static public func ==(lhs: PathElement, rhs: PathElement) -> Bool {
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


public extension CGPath {

	private class Info<T: BinaryFloatingPoint & Codable> {
		var pathElements = [PathElement<T>]()
	}
	
	func makePathElements<T: BinaryFloatingPoint & Codable>() -> [PathElement<T>] {
		let elements: [PathElement<T>] = self.pathElements.map {
			switch $0 {
			case .moveTo(let p0): return PathElement.moveTo(Point(p0))
			case .lineTo(let p1): return PathElement.lineTo(Point(p1))
			case .quadCurveTo(let p1, let p2): return PathElement.quadCurveTo(Point(p1), Point(p2))
			case .curveTo(let p1, let p2, let p3): return PathElement.curveTo(Point(p1), Point(p2), Point(p3))
			case .closeSubpath: return PathElement.closeSubpath
			}
		}
		return elements
	}

	static func makePath<T: BinaryFloatingPoint & Codable>(elements: [PathElement<T>]) -> CGPath {
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
