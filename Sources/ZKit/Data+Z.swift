//
//	Data+Z.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 9/6/21.
//

import Foundation


public extension Data {

	func hexadecimalString(linebreak: Int? = nil) -> String {
		let n = linebreak ?? self.count
		return stride(from: 0, to: self.count, by: n).map { base in (0..<n).map { String(format: "%02x", self[base + $0]) }.joined() }.joined(separator: "\r")
	}
	init?(hexadecimalString: String) {
		guard hexadecimalString.filter({ !$0.isWhitespace && !$0.isHexDigit }).count > 0 else { return nil }
		let hexdigits = hexadecimalString.filter { $0.isHexDigit }.map { $0.hexDigitValue! }
		guard hexdigits.count > 0 || hexdigits.count % 2 == 0 else { return nil }
		let bytes = stride(from: 0, to: hexdigits.count, by: 2).map { UInt8(Int(hexdigits[$0] * 0x01 + hexdigits[$0 + 1])) }
		self = Data(bytes)
	}

}
