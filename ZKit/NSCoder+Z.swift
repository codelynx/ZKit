//
//	NSCoder+Z.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 9/5/21.
//

import Foundation


public extension NSCoder {

	func decodeString(forKey key: String) -> String? {
		return self.decodeObject(forKey: key) as? String
	}
	func encodeString(_ value: String, forKey key: String) {
		self.encode(value as NSString, forKey: key)
	}
	func decodeData(forKey key: String) -> Data? {
		return self.decodeObject(forKey: key) as? Data
	}
	func encodeData(_ value: Data, forKey key: String) {
		self.encode(value as NSData, forKey: key)
	}

}

public extension NSCoder {

	func encode<T: Codable>(_ value: T?, forKey key: CodingKey, as: T.Type) {
		let encoder = PropertyListEncoder()
		encoder.outputFormat = .binary
		if let value = value, let data = try? encoder.encode(value) {
			self.encode(data as NSData, forKey: key.stringValue)
		}
	}

	func decode<T: Codable>(forKey key: CodingKey, as: T.Type) -> T? {
		let decoder = PropertyListDecoder()
		if let data = self.decodeObject(forKey: key.stringValue) as? Data {
			return try? decoder.decode(T.self, from: data)
		}
		return nil
	}

}

public extension NSCoder {

	/*
	func archive<T: ZArchivable>(_ value: T?, forKey key: CodingKey, as: T.Type) {
		if let data = value?.archive() {
			self.encode(data as NSData, forKey: key.stringValue)
		}
	}

	func unarchive<T: ZArchivable>(forKey key: CodingKey, as: T.Type) -> T? {
		if let data = self.decodeObject(forKey: key.stringValue) as? Data {
			return data.unarchive(as: T.self)
		}
		return nil
	}
	*/

	func serialize<T>(_ value: T, forKey key: CodingKey, of: T.Type) {
		var value = value
		Swift.withUnsafePointer(to: &value) { valuePointer in
			let rawPointer = UnsafeRawPointer(valuePointer)
			let bytesPointer = rawPointer.assumingMemoryBound(to: UInt8.self)
			let data = Data(bytes: bytesPointer, count: MemoryLayout<T>.size)
			self.encode(data, forKey: key.stringValue)
		}
	}

	func unserialize<T>(forKey key: CodingKey, of: T.Type) -> T? {
		let length = MemoryLayout<T>.size
		if let data = self.decodeData(forKey: key.stringValue), data.count >= length {
			return data.withUnsafeBytes { $0.load(as: T.self) }
		}
		return nil
	}
	

}
