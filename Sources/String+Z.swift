//
//	String+Z.swift
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
import UIKit

//
//	String
//

public extension String {
	
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
		return self.cString(using: .utf8).flatMap({ String(cString: $0, encoding: .nonLossyASCII) }) ?? "???"
	}

	// MARK: -
	
	func draw(at point: CGPoint, withAttributes: [NSAttributedString.Key : Any]? = nil) {
		(self as NSString).draw(at: point, withAttributes: withAttributes)
	}
	
	func draw(in rect: CGRect, withAttributes: [NSAttributedString.Key : Any]? = nil) {
		(self as NSString).draw(in: rect, withAttributes: withAttributes)
	}
	
	func draw(with rect: CGRect, options: NSStringDrawingOptions = [], attributes: [NSAttributedString.Key : Any]? = nil, context: NSStringDrawingContext?) {
		(self as NSString).draw(with: rect, options: options, attributes: attributes, context: context)
	}
	
	func boundingRect(with size: CGSize, options: NSStringDrawingOptions = [], attributes: [NSAttributedString.Key : Any]? = nil, context: NSStringDrawingContext?) -> CGRect {
		return (self as NSString).boundingRect(with: size, options: options, attributes: attributes, context: context)
	}
	
	func size(withAttributes: [NSAttributedString.Key : Any]? = nil) -> CGSize {
		return (self as NSString).size(withAttributes: withAttributes)
	}

	// MARK: -

	subscript (i: Int) -> Character {
		return self[index(startIndex, offsetBy: i)]
	}

	func range(from range: NSRange) -> Range<String.Index>? {
		return Range(range, in: self)
	}

	func range(from range: Range<String.Index>) -> NSRange {
		return NSRange(range, in: self)
	}

	var wholeRange: NSRange {
		return NSMakeRange(0, (self as NSString).length) // don't use NSRangeFromString()
	}

	var length: Int {
		return (self as NSString).length
	}

	subscript(_ range: CountableRange<Int>) -> String {
		let start = index(startIndex, offsetBy: max(0, range.lowerBound))
		let end = index(startIndex, offsetBy: min(self.count, range.upperBound))
		return String(self[start..<end])
	}

	subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
		let start = index(startIndex, offsetBy: max(0, range.lowerBound))
		 return String(self[start...])
	}

}


public extension CustomStringConvertible {
	var xdescription: String { return self.description.stringByDecodingNonLossyASCII }
}
