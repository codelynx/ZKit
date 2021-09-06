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

	func encode<T: Codable>(_ value: T?, forKey key: String, as: T.Type) {
		let encoder = PropertyListEncoder()
		encoder.outputFormat = .binary
		if let value = value, let data = try? encoder.encode(value) {
			self.encode(data as NSData, forKey: key)
		}
	}

	func decode<T: Codable>(forKey key: String, as: T.Type) -> T? {
		let decoder = PropertyListDecoder()
		if let data = self.decodeObject(forKey: key) as? Data {
			return try? decoder.decode(T.self, from: data)
		}
		return nil
	}

}

public extension NSCoder {

	func encode<T: ZArchivable>(_ value: T?, forKey key: String, as: T.Type) {
		if let data = value?.archive() {
			self.encode(data as NSData, forKey: key)
		}
	}

	func decode<T: ZArchivable>(forKey key: String, as: T.Type) -> T? {
		if let data = self.decodeObject(forKey: key) as? Data {
			return data.unarchive(as: T.self)
		}
		return nil
	}

}
