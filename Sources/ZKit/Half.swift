//
//	Float16.swift
//	ZKit
//
//	The MIT License (MIT)
//
//	Copyright (c) 2021 Electricwoods LLC, Kaz Yoshikawa.
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
import Accelerate
import CoreGraphics


public struct Half: FloatingPoint, CustomStringConvertible, Codable, Hashable, Sendable {
	public typealias Exponent = Int
	public typealias Stride = Half
	public typealias Magnitude = Half
	public typealias IntegerLiteralType = Int
	
	var rawValue: UInt16
	
	static public func float_to_half(value: Float) -> Half {
		var input: [Float] = [value]
		var output: [UInt16] = [0]
		var sourceBuffer = input.withUnsafeMutableBytes { (bufferPointer) -> vImage_Buffer in
			return vImage_Buffer(data: bufferPointer.baseAddress, height: 1, width: 1, rowBytes: MemoryLayout<Float>.size)
		}
		var destinationBuffer = output.withUnsafeMutableBytes { (bufferPointer) -> vImage_Buffer in
			return vImage_Buffer(data: bufferPointer.baseAddress, height: 1, width: 1, rowBytes: MemoryLayout<UInt16>.size)
		}
		vImageConvert_PlanarFtoPlanar16F(&sourceBuffer, &destinationBuffer, 0)
		return Half(rawValue: output[0])
	}
	
	static public func half_to_float(value: Half) -> Float {
		var input: [UInt16] = [value.rawValue]
		var output: [Float] = [0]
		var sourceBuffer = input.withUnsafeMutableBytes { (bufferPointer) -> vImage_Buffer in
			return vImage_Buffer(data: bufferPointer.baseAddress, height: 1, width: 1, rowBytes: MemoryLayout<UInt16>.size)
		}
		var destinationBuffer = output.withUnsafeMutableBytes { (bufferPointer) -> vImage_Buffer in
			return vImage_Buffer(data: bufferPointer.baseAddress, height: 1, width: 1, rowBytes: MemoryLayout<Float>.size)
		}
		vImageConvert_Planar16FtoPlanarF(&sourceBuffer, &destinationBuffer, 0)
		return output[0]
	}
	
	static public func floats_to_halves(values: [Float]) -> [Half] {
		var inputs = values
		var outputs = Array<UInt16>(repeating: 0, count: values.count)
		let width = vImagePixelCount(values.count)
		var sourceBuffer = inputs.withUnsafeMutableBytes { (bufferPointer) -> vImage_Buffer in
			return vImage_Buffer(data: bufferPointer.baseAddress, height: 1, width: width, rowBytes: MemoryLayout<Float>.size)
		}
		var destinationBuffer = outputs.withUnsafeMutableBytes { (bufferPointer) -> vImage_Buffer in
			return vImage_Buffer(data: bufferPointer.baseAddress, height: 1, width: width, rowBytes: MemoryLayout<UInt16>.size)
		}
		vImageConvert_PlanarFtoPlanar16F(&sourceBuffer, &destinationBuffer, 0)
		return outputs.map { Half(rawValue: $0) }
	}
	
	static public func halves_to_floats(values: [Half]) -> [Float] {
		var inputs: [UInt16] = values.map { $0.rawValue }
		var outputs: [Float] = Array<Float>(repeating: 0, count: values.count)
		let width = vImagePixelCount(values.count)
		var sourceBuffer = inputs.withUnsafeMutableBytes { (bufferPointer) -> vImage_Buffer in
			return vImage_Buffer(data: bufferPointer.baseAddress, height: 1, width: width, rowBytes: MemoryLayout<UInt16>.size)
		}
		var destinationBuffer = outputs.withUnsafeMutableBytes { (bufferPointer) -> vImage_Buffer in
			return vImage_Buffer(data: bufferPointer.baseAddress, height: 1, width: width, rowBytes: MemoryLayout<Float>.size)
		}
		vImageConvert_Planar16FtoPlanarF(&sourceBuffer, &destinationBuffer, 0)
		return outputs
	}
	
	public init(integerLiteral value: Int) {
		self.init(Float(value))
	}
	
	public init(rawValue: UInt16) {
		self.rawValue = rawValue
	}
	
	public init(_ value: Float) {
		self = Half.float_to_half(value: value)
	}
	
	public init(_ value: Double) {
		self = Half(Float(value))
	}
	
	public init(_ value: CGFloat) {
		self = Half(Float(value))
	}
	
	public init(sign: FloatingPointSign, exponent: Int, significand: Half) {
		self = Half(Float(sign: sign, exponent: exponent, significand: Float(significand)))
	}
	
	public init(signOf: Half, magnitudeOf: Half) {
		self = Half(Float(signOf: Float(signOf), magnitudeOf: Float(magnitudeOf)))
	}
	
	public init(_ value: Int) {
		self = Half(Float(value))
	}
	
	public init<Source>(_ value: Source) where Source : BinaryInteger {
		self = Half(Float(value))
	}
	
	public init?<Source>(exactly value: Source) where Source : BinaryInteger {
		self = Half.float_to_half(value: Float(value))
	}
	
	public static var radix: Int {
		return Float.radix
	}
	
	public static var signalingNaN: Half {
		// Exponent all ones (0x1F), fraction with MSB=0 and next bit=1 (0x100)
		return Half(rawValue: 0x7D00)
	}
	
	public static var infinity: Half {
		// Exponent all ones (0x1F), fraction bits zero => positive infinity (0x7C00)
		return Half(rawValue: 0x7C00)
	}
	
	public static var greatestFiniteMagnitude: Half {
		// Max finite half: exponent=0x1E, fraction all ones (0x3FF) => 0x7BFF
		return Half(rawValue: 0x7BFF)
	}
	
	public static var pi: Half {
		return Half(Float.pi)
	}
	
	public var ulp: Half {
		// ULP is the difference between this value and the next representable value
		let next = self.nextUp
		return next - self
	}
	
	public static var leastNormalMagnitude: Half {
		// Smallest positive normalized half: exponent bits = 1, fraction bits = 0
		return Half(rawValue: 0x0400)
	}
	
	public static var leastNonzeroMagnitude: Half {
		// Smallest positive subnormal half: exponent bits = 0, fraction bits = 1
		return Half(rawValue: 0x0001)
	}
	
	public var sign: FloatingPointSign {
		return Float(self).sign
	}
	
	public var exponent: Int {
		let expBits = (rawValue >> 10) & 0x1F
		let fracBits = rawValue & 0x3FF
		
		// Special case: infinity
		if expBits == 0x1F && fracBits == 0 {
			return Int.max
		}
		
		// Special case: zero
		if expBits == 0 && fracBits == 0 {
			return Int.min
		}
		
		if expBits == 0 {
			// Subnormal: unbiased exponent is 1 - bias (bias = 15)
			return 1 - 15
		}
		
		// Normalized: subtract bias (15)
		return Int(expBits) - 15
	}
	
	public var significand: Half {
		let expBits = (rawValue >> 10) & 0x1F
		let fracBits = rawValue & 0x3FF
		if expBits == 0 {
			// Subnormal or zero
			if fracBits == 0 {
				// Zero
				return Half(rawValue: 0)
			}
			// Subnormal: fraction / 2^10
			let m = Float(fracBits) / 1024.0
			return Half(m)
		}
		if expBits == 0x1F {
			// Infinity or NaN
			if fracBits == 0 {
				// Infinity
				return Half.infinity
			} else {
				// NaN
				return Half.nan
			}
		}
		// Normalized: 1.fraction
		let m = 1.0 + Float(fracBits) / 1024.0
		return Half(m)
	}
	
	public static func *= (lhs: inout Half, rhs: Half) {
		lhs = Half(Float(lhs) * Float(rhs))
	}
	
	public static func /= (lhs: inout Half, rhs: Half) {
		lhs = Half(Float(lhs) / Float(rhs))
	}
	
	public mutating func formRemainder(dividingBy other: Half) {
		var value = Float(self)
		value.formRemainder(dividingBy: Float(other))
		self = Half(value)
	}
	
	public mutating func formTruncatingRemainder(dividingBy other: Half) {
		var value = Float(self)
		value.formTruncatingRemainder(dividingBy: Float(other))
		self = Half(value)
	}
	
	public mutating func formSquareRoot() {
		var value = Float(self)
		value.formSquareRoot()
		self = Half(value)
	}
	
	public mutating func addProduct(_ lhs: Half, _ rhs: Half) {
		var value = Float(self)
		value.addProduct(Float(lhs), Float(rhs))
		self = Half(value)
	}
	
	public var nextUp: Half {
		// Handle NaN: return self
		if isNaN {
			return self
		}
		// Negative zero -> smallest positive subnormal
		if rawValue == 0x8000 {
			return Half(rawValue: 0x0001)
		}
		// Extract sign bit
		let signBit = rawValue & 0x8000
		if signBit == 0 {
			// Positive or +0: increment raw bits
			if rawValue == 0x7C00 {
				// +infinity stays +infinity
				return self
			}
			return Half(rawValue: rawValue + 1)
		} else {
			// Negative: decrement raw bits towards zero
			return Half(rawValue: rawValue - 1)
		}
	}
	
	public func isEqual(to other: Half) -> Bool {
		// Standard FloatingPoint behavior: NaN is not equal to anything, including itself
		if isNaN || other.isNaN {
			return false
		}
		// Otherwise only equal if raw bits exactly match
		return rawValue == other.rawValue
	}
	
	public func isLess(than other: Half) -> Bool {
		// If either is NaN, return false
		if isNaN || other.isNaN {
			return false
		}
		let a = rawValue
		let b = other.rawValue
		let signA = a & 0x8000
		let signB = b & 0x8000
		// If signs differ
		if signA != signB {
			// Negative < Positive
			return signA != 0
		}
		// Same sign
		if signA == 0 {
			// Both positive: compare raw directly
			return a < b
		} else {
			// Both negative: more negative means larger raw; invert comparison
			return a > b
		}
	}
	
	public func isLessThanOrEqualTo(_ other: Half) -> Bool {
		// True if equal or less-than
		return isEqual(to: other) || isLess(than: other)
	}
	
	public func isTotallyOrdered(belowOrEqualTo other: Half) -> Bool {
		// Total ordering per IEEE 754-2019
		// -NaN < -Infinity < -finite < -0 < +0 < +finite < +Infinity < +NaN
		let a = rawValue
		let b = other.rawValue
		
		// Extract sign bits
		let signA = (a & 0x8000) != 0
		let signB = (b & 0x8000) != 0
		
		// For total ordering, we need to handle negative values specially
		if signA && !signB {
			// Negative is less than positive
			return true
		} else if !signA && signB {
			// Positive is not less than negative
			return false
		} else if signA && signB {
			// Both negative: flip comparison (larger magnitude is smaller)
			return a >= b
		} else {
			// Both positive: normal comparison
			return a <= b
		}
	}
	
	public var isNormal: Bool {
		let expBits = (rawValue >> 10) & 0x1F
		// Normal: exponent not zero or all ones
		return expBits != 0 && expBits != 0x1F
	}
	
	public var isFinite: Bool {
		let expBits = (rawValue >> 10) & 0x1F
		// Finite if exponent not all ones
		return expBits != 0x1F
	}
	
	public var isZero: Bool {
		// Zero if exponent and fraction bits are all zero (sign bit ignored)
		return (rawValue & 0x7FFF) == 0
	}
	
	public var isSubnormal: Bool {
		let expBits = (rawValue >> 10) & 0x1F
		let fracBits = rawValue & 0x3FF
		// Subnormal if exponent zero but fraction non-zero
		return expBits == 0 && fracBits != 0
	}
	
	public var isInfinite: Bool {
		let expBits = (rawValue >> 10) & 0x1F
		let fracBits = rawValue & 0x3FF
		// Infinite if exponent all ones and fraction zero
		return expBits == 0x1F && fracBits == 0
	}
	
	public var isNaN: Bool {
		let expBits = (rawValue >> 10) & 0x1F
		let fracBits = rawValue & 0x3FF
		// NaN if exponent all ones and fraction non-zero
		return expBits == 0x1F && fracBits != 0
	}
	
	public var isSignalingNaN: Bool {
		let expBits = (rawValue >> 10) & 0x1F
		let fracBits = rawValue & 0x3FF
		// Signaling NaN if exponent all ones, MSB of fraction zero, and fraction non-zero
		return expBits == 0x1F && (fracBits & 0x200) == 0 && fracBits != 0
	}
	
	public var isCanonical: Bool {
		let expBits = (rawValue >> 10) & 0x1F
		let fracBits = rawValue & 0x3FF
		// If NaN, only canonical when fraction exactly MSB=1 and other bits zero (0x200)
		if expBits == 0x1F && fracBits != 0 {
			return fracBits == 0x200
		}
		// All non-NaN values are canonical
		return true
	}
	
	public func distance(to other: Half) -> Half {
		// Distance from self to other is simply (other - self)
		return other - self
	}
	
	public func advanced(by n: Half) -> Half {
		// Advancing by n is equivalent to adding n
		return self + n
	}
	
	public var magnitude: Half {
		// Absolute value: clear the sign bit
		return Half(rawValue: rawValue & 0x7FFF)
	}
	
	public mutating func round(_ rule: FloatingPointRoundingRule) {
		var value = Float(self)
		value.round(rule)
		self = Half(value)
	}
	
	public var description: String {
		return Float(self).description
	}
	
	public static func + (lhs: Self, rhs: Self) -> Self {
		return Self(Float(lhs) + Float(rhs))
	}
	
	public static func - (lhs: Self, rhs: Self) -> Self {
		return Self(Float(lhs) - Float(rhs))
	}
	
	public static func * (lhs: Self, rhs: Self) -> Self {
		return Self(Float(lhs) * Float(rhs))
	}
	
	public static func / (lhs: Self, rhs: Self) -> Self {
		return Self(Float(lhs) / Float(rhs))
	}
	
	public static let nan: Half = Half(Float.nan)
}

public extension Array where Element == Half {
	init(_ values: [Float]) {
		self = Half.floats_to_halves(values: values)
	}
}

public extension Float {
	init(_ value: Half) {
		self = Half.half_to_float(value: value)
	}
}

public extension Double {
	init(_ value: Half) {
		self = Double(Half.half_to_float(value: value))
	}
}

public extension CGFloat {
	init(_ value: Half) {
		self = CGFloat(Half.half_to_float(value: value))
	}
}
