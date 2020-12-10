//
//	Float16.swift
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
import Accelerate
import CoreGraphics


public struct Float16: CustomStringConvertible, Hashable, Codable {
	
	var rawValue: UInt16
	
	public static func float_to_float16(value: Float) -> Float16 {
		var input: [Float] = [value]
		var output: [UInt16] = [0]
		var sourceBuffer = input.withUnsafeMutableBufferPointer { (buffer) -> vImage_Buffer in
			vImage_Buffer(data: buffer.baseAddress!, height: 1, width: 1, rowBytes: MemoryLayout<Float>.size)
		}
		var destinationBuffer = output.withUnsafeMutableBufferPointer { (buffer) -> vImage_Buffer in
			vImage_Buffer(data: buffer.baseAddress!, height: 1, width: 1, rowBytes: MemoryLayout<UInt16>.size)
		}
		vImageConvert_PlanarFtoPlanar16F(&sourceBuffer, &destinationBuffer, 0)
		return Float16(rawValue: output[0])
	}
	
	public static func float16_to_float(value: Float16) -> Float {
		var input: [UInt16] = [value.rawValue]
		var output: [Float] = [0]
		var sourceBuffer = input.withUnsafeMutableBufferPointer { (buffer) -> vImage_Buffer in
			vImage_Buffer(data: buffer.baseAddress!, height: 1, width: 1, rowBytes: MemoryLayout<Float>.size)
		}
		var destinationBuffer = output.withUnsafeMutableBufferPointer { (buffer) -> vImage_Buffer in
			vImage_Buffer(data: buffer.baseAddress!, height: 1, width: 1, rowBytes: MemoryLayout<UInt16>.size)
		}
		vImageConvert_Planar16FtoPlanarF(&sourceBuffer, &destinationBuffer, 0)
		return output[0]
	}
	
	public static func floats_to_float16s(values: [Float]) -> [Float16] {
		var inputs = values
		var outputs = Array<UInt16>(repeating: 0, count: values.count)
		let width = vImagePixelCount(values.count)
		var sourceBuffer = inputs.withUnsafeMutableBufferPointer { (buffer) -> vImage_Buffer in
			vImage_Buffer(data: buffer.baseAddress!, height: 1, width: width, rowBytes: MemoryLayout<Float>.size)
		}
		var destinationBuffer = outputs.withUnsafeMutableBufferPointer { (buffer) -> vImage_Buffer in
			vImage_Buffer(data: buffer.baseAddress!, height: 1, width: width, rowBytes: MemoryLayout<UInt16>.size)
		}
		vImageConvert_PlanarFtoPlanar16F(&sourceBuffer, &destinationBuffer, 0)
		return outputs.map { Float16(rawValue: $0) }
	}
	
	public static func float16s_to_floats(values: [Float16]) -> [Float] {
		var inputs: [UInt16] = values.map { $0.rawValue }
		var outputs: [Float] = Array<Float>(repeating: 0, count: values.count)
		let width = vImagePixelCount(values.count)
		var sourceBuffer = inputs.withUnsafeMutableBufferPointer { (buffer) -> vImage_Buffer in
			vImage_Buffer(data: buffer.baseAddress!, height: 1, width: width, rowBytes: MemoryLayout<Float>.size)
		}
		var destinationBuffer = outputs.withUnsafeMutableBufferPointer { (buffer) -> vImage_Buffer in
			vImage_Buffer(data: buffer.baseAddress!, height: 1, width: width, rowBytes: MemoryLayout<UInt16>.size)
		}
		vImageConvert_Planar16FtoPlanarF(&sourceBuffer, &destinationBuffer, 0)
		return outputs
	}

	public static let zero: Float16 = Float16(Float(0))
	public static let one: Float16 = Float16(Float(1))

	public init(_ value: Float) {
		self = Float16.float_to_float16(value: value)
	}
	
	public init(rawValue: UInt16) {
		self.rawValue = rawValue
	}

	public init(_ value: Double) {
		self = Float16.float_to_float16(value: Float(value))
	}

	public init(_ value: CGFloat) {
		self = Float16.float_to_float16(value: Float(value))
	}

	public var description: String {
		return self.floatValue.description
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.floatValue)
	}

	public static func + (lhs: Float16, rhs: Float16) -> Float16 {
		return Float16(lhs.floatValue + rhs.floatValue)
	}
	
	public static func - (lhs: Float16, rhs: Float16) -> Float16 {
		return Float16(lhs.floatValue - rhs.floatValue)
	}
	
	public static func * (lhs: Float16, rhs: Float16) -> Float16 {
		return Float16(lhs.floatValue * rhs.floatValue)
	}
	
	public static func / (lhs: Float16, rhs: Float16) -> Float16 {
		return Float16(lhs.floatValue / rhs.floatValue)
	}

	public static func == (lhs: Float16, rhs: Float16) -> Bool {
		return lhs.rawValue == rhs.rawValue
	}

}


public extension CGFloat {

	init(_ value: Float16) {
		self = CGFloat(value.floatValue)
	}

}


public extension Double {

	init(_ value: Float16) {
		self = Double(value.floatValue)
	}

}


public extension Float {

	init(_ value: Float16) {
		self = Float(value.floatValue)
	}

}
