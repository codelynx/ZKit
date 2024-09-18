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

public enum PathElement: Equatable {
	case moveTo(CGPoint)
	case lineTo(CGPoint)
	case quadCurveTo(controlPoint: CGPoint, endPoint: CGPoint)
	case curveTo(controlPoint1: CGPoint, controlPoint2: CGPoint, endPoint: CGPoint)
	case closeSubpath
	
	public static func ==(lhs: PathElement, rhs: PathElement) -> Bool {
		switch (lhs, rhs) {
		case let (.moveTo(l), .moveTo(r)),
			let (.lineTo(l), .lineTo(r)):
			return l == r
		case let (.quadCurveTo(lc, le), .quadCurveTo(rc, re)):
			return lc == rc && le == re
		case let (.curveTo(lc1, lc2, le), .curveTo(rc1, rc2, re)):
			return lc1 == rc1 && lc2 == rc2 && le == re
		case (.closeSubpath, .closeSubpath):
			return true
		default:
			return false
		}
	}
}

public extension CGPath {
	/// Returning an array of `PathElement` that represents this CGPath
	var pathElements: [PathElement] {
		var elements = [PathElement]()
		
		self.applyWithBlock { element in
			let type = element.pointee.type
			let points = element.pointee.points
			
			switch type {
			case .moveToPoint:
				let p0 = points[0]
				elements.append(.moveTo(p0))
			case .addLineToPoint:
				let p1 = points[0]
				elements.append(.lineTo(p1))
			case .addQuadCurveToPoint:
				let controlPoint = points[0]
				let endPoint = points[1]
				elements.append(.quadCurveTo(controlPoint: controlPoint, endPoint: endPoint))
			case .addCurveToPoint:
				let controlPoint1 = points[0]
				let controlPoint2 = points[1]
				let endPoint = points[2]
				elements.append(.curveTo(controlPoint1: controlPoint1, controlPoint2: controlPoint2, endPoint: endPoint))
			case .closeSubpath:
				elements.append(.closeSubpath)
			@unknown default:
				break
			}
		}
		
		return elements
	}
}

public extension CGPath {
	/// Computes the length of a quadratic Bezier curve segment.
	/// - Parameters:
	///   - p0: Start point
	///   - c1: Control point
	///   - p1: End point
	/// - Returns: The length of the quadratic Bezier curve segment.
	static func quadraticCurveLength(_ p0: CGPoint, _ c1: CGPoint, _ p1: CGPoint) -> CGFloat {
		// cf. http://www.malczak.linuxpl.com/blog/quadratic-bezier-curve-length/
		let a = CGPoint(x: p0.x - 2 * c1.x + p1.x, y: p0.y - 2 * c1.y + p1.y)
		let b = CGPoint(x: 2 * c1.x - 2 * p0.x, y: 2 * c1.y - 2 * p0.y)
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
	
	/// Computes the approximate length of a cubic Bezier curve segment.
	/// - Parameters:
	///   - p0: Start point
	///   - c1: First control point
	///   - c2: Second control point
	///   - p1: End point
	///   - subdivisions: Number of subdivisions for approximation
	/// - Returns: The approximate length of the cubic Bezier curve segment.
	static func approximateCubicCurveLength(_ p0: CGPoint, _ c1: CGPoint, _ c2: CGPoint, _ p1: CGPoint, subdivisions n: Int = 16) -> CGFloat {
		var length: CGFloat = 0
		var previousPoint: CGPoint? = nil
		for i in 0 ... n {
			let t = CGFloat(i) / CGFloat(n)
			
			let point = cubicBezierPoint(t: t, p0: p0, c1: c1, c2: c2, p1: p1)
			
			if let previousPoint = previousPoint {
				length += (point - previousPoint).length
			}
			previousPoint = point
		}
		return length
	}
	
	/// Computes a point on a cubic Bezier curve at parameter t.
	private static func cubicBezierPoint(t: CGFloat, p0: CGPoint, c1: CGPoint, c2: CGPoint, p1: CGPoint) -> CGPoint {
		let oneMinusT = 1 - t
		
		// Compute coefficients
		let coefficient1 = oneMinusT * oneMinusT * oneMinusT
		let coefficient2 = 3 * oneMinusT * oneMinusT * t
		let coefficient3 = 3 * oneMinusT * t * t
		let coefficient4 = t * t * t
		
		// Compute each term
		let term1 = p0 * coefficient1
		let term2 = c1 * coefficient2
		let term3 = c2 * coefficient3
		let term4 = p1 * coefficient4
		
		// Sum the terms to get the final point
		let point = term1 + term2 + term3 + term4
		return point
	}

}
