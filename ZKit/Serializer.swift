//
//	DataSerialization.swift
//	DataRepresentable
//
//	Created by Kaz Yoshikawa on 10/1/21.
//
//	Overview:
//
//	`Serializer` and `Unserializer` is designed to load and save large number of piece of data into binary format. For example, if you like to load
//	and save thousnads of verticies with Codabe mechanism, archived binary may be too large. Because each elements were tagged with `x` or `y`
//	`z`, `w` which may not be necessary in some cases.   This `Serializer` and `Unserializer` can load ans store such vertices like data into binary
//	format.
//
//
//	Usage:
//
//	struct Vertex {
//		var x, y, z, w: Float
//		var r, g, b, a: Float
//	}
//	let verticies: [Vertex] = [.....]
//	let serializer = Serializer()
//	let binary = serializer.

import Foundation


public enum SerializationError: Error, CustomStringConvertible {
	case runOutOfBuffer
	case tooLarge
	case failed
	case unexpectedFormat
	public var description: String {
		switch self {
		case .runOutOfBuffer: return "Serialization: run out of buffer"
		case .tooLarge: return "Serialization: too large binary data"
		case .failed: return "Serialization: unexpected failure"
		case .unexpectedFormat: return "Serialization: unexpected format"
		}
	}
}

open class Serializer {

	private (set) public var data: Data

	public init() {
		self.data = Data()
	}

	public func writeBytes<T>(_ value: T) throws {
		var value = value
		Swift.withUnsafePointer(to: &value) { valuePointer in
			let rawPointer = UnsafeRawPointer(valuePointer)
			let bytesPointer = rawPointer.assumingMemoryBound(to: UInt8.self)
			let data = Data(bytes: bytesPointer, count: MemoryLayout<T>.size)
			self.data.append(data)
		}
	}
	
	public func write(binary: Data) throws {
		guard binary.count < Int32.max else { throw SerializationError.tooLarge }
		self.data.append(binary)
	}

	public func write<T: BinaryInteger>(_ value: T) throws {
		try self.writeBytes(value)
	}

	public func write<T: BinaryFloatingPoint>(_ value: T) throws {
		try self.writeBytes(value)
	}

	public func write(_ data: Data) throws {
		guard data.count < Int32.max else { throw SerializationError.tooLarge }
		try self.writeBytes(Int32(data.count))
		self.data.append(data)
	}

	public func write(_ string: String) throws {
		try self.write(string.data(using: .utf8) ?? Data())
	}

	public func write<T: DataRepresentable>(_ value: T, of: T.Type) throws {
		let typeString = String(describing: type(of: value))
		let data = value.dataRepresentation
		guard data.count < Int32.max else { throw SerializationError.tooLarge }
		try self.write(typeString)
		try self.write(data)
	}

}


open class Unserializer {

	let data: Data
	private (set) var location: Int

	public init(data: Data) {
		self.data = data
		self.location = 0
	}

	public var isAtEnd: Bool {
		self.location < self.data.count
	}

	public func readBytes<T>(as: T.Type) throws -> T {
		let length = MemoryLayout<T>.size
		guard self.location + length <= self.data.count else { throw SerializationError.runOutOfBuffer }
		let subdata = data.subdata(in: location ..< location + length)
		defer { self.location += length }
		return subdata.withUnsafeBytes { $0.load(as: T.self) }
	}

	public func read<T: BinaryInteger>() throws -> T {
		return try self.readBytes(as: T.self)
	}

	public func read<T: BinaryFloatingPoint>() throws -> T {
		return try self.readBytes(as: T.self)
	}

	public func read() throws -> Data {
		let length = Int(try self.readBytes(as: UInt32.self))
		guard length < Int32.max else { throw SerializationError.tooLarge }
		guard self.location + length <= self.data.count else { throw SerializationError.runOutOfBuffer }
		let subdata = data.subdata(in: location ..< location + length)
		defer { self.location += length }
		return Data(subdata)
	}
	
	public func read() throws -> String {
		let data: Data = try self.read()
		guard let string = String(data: data, encoding: .utf8) else { throw SerializationError.failed }
		return string
	}

	public func read<T: DataRepresentable>(of: T.Type) throws -> T? {
		let typeString = try self.read() as String
		let subdata = try self.read() as Data
		if let type = dataRepresentableClasses.filter({ String(describing: $0) == typeString }).first as? DataRepresentable.Type {
			return type.init(data: subdata) as? T
		}
		return nil
	}

	private lazy var dataRepresentableClasses: [AnyClass] = {
		return Runtime.classes(conformTo: DataRepresentable.Type.self)
	}()

}

