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


public struct Half: FloatingPoint, CustomStringConvertible, Codable, Hashable {
	public typealias Exponent = Int
	public typealias Stride = Half
	public typealias Magnitude = Half
	public typealias IntegerLiteralType = Int
	
	var rawValue: UInt16
	
	static func float_to_half(value: Float) -> Half {
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
	
	static func half_to_float(value: Half) -> Float {
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
	
	static func floats_to_halves(values: [Float]) -> [Half] {
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
	
	static func halves_to_floats(values: [Half]) -> [Float] {
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
		return Half(Float.signalingNaN)
	}
	
	public static var infinity: Half {
		return Half(Float.infinity)
	}
	
	public static var greatestFiniteMagnitude: Half {
		return Half(Float.greatestFiniteMagnitude)
	}
	
	public static var pi: Half {
		return Half(Float.pi)
	}
	
	public var ulp: Half {
		return Half(Float(self).ulp)
	}
	
	public static var leastNormalMagnitude: Half {
		return Half(Float.leastNormalMagnitude)
	}
	
	public static var leastNonzeroMagnitude: Half {
		return Half(Float.leastNonzeroMagnitude)
	}
	
	public var sign: FloatingPointSign {
		return Float(self).sign
	}
	
	public var exponent: Int {
		return 5 // sure?
	}
	
	public var significand: Half {
		return Half(Float(self).significand) // not sure
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
		return Half(Float(self).nextUp)
	}
	
	public func isEqual(to other: Half) -> Bool {
		return Float(self).isEqual(to: Float(other))
	}
	
	public func isLess(than other: Half) -> Bool {
		return Float(self).isLess(than: Float(other))
	}
	
	public func isLessThanOrEqualTo(_ other: Half) -> Bool {
		return Float(self).isLessThanOrEqualTo(Float(other))
	}
	
	public func isTotallyOrdered(belowOrEqualTo other: Half) -> Bool {
		return Float(self).isTotallyOrdered(belowOrEqualTo: Float(other))
	}
	
	public var isNormal: Bool {
		return Float(self).isNormal
	}
	
	public var isFinite: Bool {
		return Float(self).isFinite
	}
	
	public var isZero: Bool {
		return Float(self).isZero
	}
	
	public var isSubnormal: Bool {
		return Float(self).isSubnormal
	}
	
	public var isInfinite: Bool {
		return Float(self).isInfinite
	}
	
	public var isNaN: Bool {
		return Float(self).isNaN
	}
	
	public var isSignalingNaN: Bool {
		return Float(self).isSignalingNaN
	}
	
	public var isCanonical: Bool {
		return Float(self).isCanonical
	}
	
	public func distance(to other: Half) -> Half {
		return Half(Float(self).distance(to: Float(other)))
	}
	
	public func advanced(by n: Half) -> Half {
		return Half(Float(self).advanced(by: Float(n)))
	}
	
	public var magnitude: Half {
		return Half(Float(self).magnitude)
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
	
	public static var nan: Half = Half(Float.nan)
}

extension Array where Element == Half {
	public init(_ values: [Float]) {
		self = Half.floats_to_halves(values: values)
	}
}

extension Float {
	public init(_ value: Half) {
		self = Half.half_to_float(value: value)
	}
}

extension Double {
	public init(_ value: Half) {
		self = Double(Half.half_to_float(value: value))
	}
}

extension CGFloat {
	public init(_ value: Half) {
		self = CGFloat(Half.half_to_float(value: value))
	}
}
