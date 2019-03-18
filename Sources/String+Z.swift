//
//	String+Z.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 12/4/15.
//	Copyright © 2015 Electricwoods LLC. All rights reserved.
//

import Foundation

//
//	String
//

extension String {
	
	func appendingPathExtension(_ str: String) -> String? {
		return (self as NSString).appendingPathExtension(str)
	}
	
	func appendingPathComponent(_ str: String) -> String {
		return (self as NSString).appendingPathComponent(str)
	}
	
	var deletingPathExtension: String {
		return (self as NSString).deletingPathExtension
	}
	
	var deletingLastPathComponent: String {
		return (self as NSString).deletingLastPathComponent
	}
	
	var abbreviatingWithTildeInPath: String {
		return (self as NSString).abbreviatingWithTildeInPath;
	}
	
	var expandingTildeInPath: String {
		return (self as NSString).expandingTildeInPath;
	}
	
	var fileSystemRepresentation: UnsafePointer<Int8> {
		return (self as NSString).fileSystemRepresentation
	}
	
	var lastPathComponent: String {
		return (self as NSString).lastPathComponent
	}
	
	var pathExtension: String {
		return (self as NSString).pathExtension
	}
	
	var pathComponents: [String] {
		return (self as NSString).pathComponents
	}
	
	func pathsForResourcesOfType(_ type: String) -> [String] {
		let enumerator = FileManager.default.enumerator(atPath: self)
		var filePaths = [String]()
		while let filePath = enumerator?.nextObject() as? String {
			if filePath.pathExtension == type {
				filePaths.append(filePath)
			}
		}
		return filePaths
	}
	
	var lines: [String] {
		var lines = [String]()
		self.enumerateLines { (line, stop) -> () in
			lines.append(line)
		}
		return lines
	}
	
	func indent() -> String {
		return self.lines.map{"  " + $0}.joined(separator: "\r")
	}
	
	init(`class`: AnyClass) {
		self = String(describing: `class`)
	}

	func trimmingWhitespaces() -> String {
		return self.trimmingCharacters(in: CharacterSet.whitespaces)
	}

	func trimmingWhitespacesAndNewlines() -> String {
		return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
	}

	var stringByDecodingNonLossyASCII: String {
		return String(cString: self.cString(using: .utf8)!, encoding: .nonLossyASCII)!
	}

}


extension CustomStringConvertible {
	var xdescription: String { return self.description.stringByDecodingNonLossyASCII }
}
