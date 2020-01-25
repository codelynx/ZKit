//
//  ZError.swift
//  SSI-ios
//
//  Created by Kaz Yoshikawa on 1/24/20.
//  Copyright © 2020 Electricwoods LLC. All rights reserved.
//

import Foundation

public class ZError: Error, CustomStringConvertible {
	public let messgae: String
	public let file: String
	public let line: UInt
	public init(_ messgae: String, _ file: String = #file, _ line: UInt = #line) {
		self.messgae = messgae
		self.file = file.lastPathComponent
		self.line = line
	}
	public var description: String {
		return messgae
	}
	public var debugDescription: String {
		return "\(self.messgae), at: \(self.file):\(self.line)"
	}
}
