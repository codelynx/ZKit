//
//	DataStream.swift
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


//
//	DataStreamError
//

enum DataStreamError: Error {
	case readError
	case writeError
}


//
//	DataReadStream
//

open class DataReadStream {

	private var inputStream: InputStream
	private let bytes: Int
	private var offset: Int = 0
	
	public init(data: Data) {
		self.inputStream = InputStream(data: data)
		self.inputStream.open()
		self.bytes = data.count
	}

	deinit {
		self.inputStream.close()
	}

	public var hasBytesAvailable: Bool {
		return self.inputStream.hasBytesAvailable
	}
	
	public var bytesAvailable: Int {
		return self.bytes - self.offset
	}
	
	public func readBytes<T>(as: T.Type) throws -> T {
		let valueSize = MemoryLayout<T>.size
		let valuePointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
		let rawPointer = UnsafeMutableRawPointer(valuePointer)
		if self.inputStream.read(rawPointer.assumingMemoryBound(to: UInt8.self), maxLength: valueSize) != valueSize {
			throw DataStreamError.readError
		}
		return valuePointer.pointee
	}

	public func read() throws -> Int8 {
		return try self.readBytes(as: Int8.self)
	}

	public func read() throws -> UInt8 {
		return try self.readBytes(as: UInt8.self)
	}

	public func read() throws -> Int16 {
		let value = try self.readBytes(as: UInt16.self)
		return Int16(bitPattern: CFSwapInt16BigToHost(value))
	}

	public func read() throws -> UInt16 {
		let value = try self.readBytes(as: UInt16.self)
		return CFSwapInt16BigToHost(value)
	}

	public func read() throws -> Int32 {
		let value = try self.readBytes(as: UInt32.self)
		return Int32(bitPattern: CFSwapInt32BigToHost(value))
	}

	public func read() throws -> UInt32 {
		let value = try self.readBytes(as: UInt32.self)
		return CFSwapInt32BigToHost(value)
	}

	public func read() throws -> Int64 {
		let value = try self.readBytes(as: UInt64.self)
		return Int64(bitPattern: CFSwapInt64BigToHost(value))
	}

	public func read() throws -> UInt64 {
		let value = try self.readBytes(as: UInt64.self)
		return CFSwapInt64BigToHost(value)
	}

	public func read() throws -> Float {
		let value = try self.readBytes(as: CFSwappedFloat32.self)
		return CFConvertFloatSwappedToHost(value)
	}

	public func read() throws -> Float64 {
		let value = try self.readBytes(as: CFSwappedFloat64.self)
		return CFConvertFloat64SwappedToHost(value)
	}

	public func read() throws -> Half  {
		let value = try self.readBytes(as: Half.self)
		return value
	}

	public func read(count: Int) throws -> Data {
		var buffer = [UInt8](repeating: 0, count: count)
		if self.inputStream.read(&buffer, maxLength: count) != count {
			throw DataStreamError.readError
		}
		offset += count
		return Data(bytes: &buffer, count: count)
	}

	public func read() throws -> Bool {
		let byte = try self.read() as UInt8
		return byte != 0
	}
	
}

//
//	DataWriteStream
//


public class DataWriteStream {

	private var outputStream: OutputStream

	public init() {
		self.outputStream = OutputStream.toMemory()
		self.outputStream.open()
	}

	deinit {
		self.outputStream.close()
	}

	public var data: Data? {
		return self.outputStream.property(forKey: .dataWrittenToMemoryStreamKey) as? Data
	}

	public func writeBytes<T>(value: T) throws {
		let valueSize = MemoryLayout<T>.size
		var value = value
		let result: Bool = withUnsafePointer(to: &value) { valuePointer in
			let rawPointer = UnsafeRawPointer(valuePointer)
			let bytesPointer = rawPointer.assumingMemoryBound(to: UInt8.self)
			return self.outputStream.write(bytesPointer, maxLength: valueSize) == valueSize
		}
		guard result else { throw DataStreamError.writeError }
	}

	public func write(_ value: Int8) throws {
		try writeBytes(value: value)
	}

	public func write(_ value: UInt8) throws {
		try writeBytes(value: value)
	}

	public func write(_ value: Int16) throws {
		try writeBytes(value: CFSwapInt16HostToBig(UInt16(bitPattern: value)))
	}

	public func write(_ value: UInt16) throws {
		try writeBytes(value: CFSwapInt16HostToBig(value))
	}

	public func write(_ value: Int32) throws {
		try writeBytes(value: CFSwapInt32HostToBig(UInt32(bitPattern: value)))
	}

	public func write(_ value: UInt32) throws {
		try writeBytes(value: CFSwapInt32HostToBig(value))
	}

	public func write(_ value: Int64) throws {
		try writeBytes(value: CFSwapInt64HostToBig(UInt64(bitPattern: value)))
	}

	public func write(_ value: UInt64) throws {
		try writeBytes(value: CFSwapInt64HostToBig(value))
	}
	
	public func write(_ value: Float) throws {
		try writeBytes(value: CFConvertFloatHostToSwapped(value))
	}

	public func write(_ value: Float64) throws {
		try writeBytes(value: CFConvertFloat64HostToSwapped(value))
	}
	
	public func write(_ value: Half) throws {
		try writeBytes(value: value)
	}

	public func write(_ data: Data) throws {
		let bytesWritten = outputStream.write(data)
		if bytesWritten != data.count { throw DataStreamError.writeError }
	}
	
	public func write(_ value: Bool) throws {
		try writeBytes(value: UInt8(value ? 0xff : 0x00))
	}

}
