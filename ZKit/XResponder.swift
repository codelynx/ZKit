//
//	UIResponder+Z.swift
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

#if os(iOS)
import UIKit
public typealias XResponder = UIResponder
#elseif os(macOS)
import AppKit
public typealias XResponder = NSResponder
#endif


public extension XResponder {
	
	func findResponder<T>(of: T.Type) -> T? {
		for responder in self {
			if let responder = responder as? T {
				return responder
			}
		}
		return nil
	}

	#if os(macOS)
	var next: XResponder? {
		return self.nextResponder
	}
	#endif

	var responders: [XResponder] {
		return self.map { $0 }
	}
}

extension XResponder: Sequence {

	public func makeIterator() -> Iterator {
		return Iterator(responder: self)
	}

	public struct Iterator: IteratorProtocol {

		public typealias Element = XResponder
		private var responder: XResponder?

		init(responder: XResponder) {
			self.responder = responder
		}

		public mutating func next() -> XResponder? {
			let next = self.responder?.next
			self.responder = next
			return next
		}
		
	}

}

