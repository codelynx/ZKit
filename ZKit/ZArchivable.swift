//
//	ZArchivable.swift
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
//
//	[DESCRIPTION]
//
//	ZArchivable is a protocol for archive / unarchive struct item into swift `Data`, and the other way around.
//	It is designed for save and load large number of vertex data or fixed structued data without tagging
//	for each member element.  Since this utility code simply import or export binary data without
//	any checkings, so it is your responsible to load and save the same data.
//
//	[USAGE]
//
//	struct RGBA8: ZArchivable {
//		var r: UInt8
//		var g: UInt8
//		var b: UInt8
//		var a: UInt8
//	}
//
//	struct RGBA16: ZArchivable {
//		var r: Float16
//		var g: Float16
//		var b: Float16
//		var a: Float16
//	}
//
//	let color1s = RGBA8(r: 255, g: 128, b: 80, a: 255)
//	let color2s = RGBA16(r: 0.25, g: 0.5, b: 0.75, a: 1.0)
//	let data1 = color1s.archive()
//	let data2 = color2s.archive()
//
//	let color1d = data1.unarchive(as: RGBA8.self) // OK
//	let color2d = data2.unarchive(as: RGBA16.self) // OK
//	let color2f = data1.unarchive(as: RGBA16.self) // NG


import Foundation


public protocol ZArchivable {

	func archive() -> Data
}

public extension ZArchivable {

	func archive() -> Data {
		var value: Self = self
		return Data(bytes: &value, count: MemoryLayout<Self>.size)
	}

}

public extension Data {

	func unarchive<T: ZArchivable>(as type: T.Type) -> T? {
		guard self.count >= MemoryLayout<T>.size else { print("too small to unarchive `\(T.self)`"); return nil }
		let unsafeRawPointer = (self as NSData).bytes
		let unsafePointer = UnsafePointer<T>(OpaquePointer(unsafeRawPointer))
		return unsafePointer.pointee
	}

}
