//
//  ZBuffer.swift
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


//	[Description]
//	ZBuffer is designed to access random access to chunk of memory.  Using UnsafePointer, UnsafeRawPointer,
//	UnsafeBufferPointer and other pointer to fetch and store an item from a chunk of memeory is too hard to code.
//	This class should be able to make your coding life a bit easier to treat a chunk of memory as an array.
//	However, you must make sure that you should not to overwrite read-only buffer, or some other equivarent operations.
//
//	[Usage]
//	var array = [0, 1, 2, 3]
//	let buffer = ZBuffer<Int>(array: array)
//	buffer[0] = 3
//	buffer[3] = 0
//	print(array) // [3, 1, 2, 0]

class ZBuffer<T> {

	var bufferPointer: UnsafeBufferPointer<T>

	init(bufferPointer: UnsafeBufferPointer<T>) {
		self.bufferPointer = bufferPointer
	}
	init(rawPointer: UnsafeRawPointer, count: Int) {
		self.bufferPointer = UnsafeBufferPointer(start: rawPointer.assumingMemoryBound(to: T.self), count: count)
	}
	init(rawPointer: UnsafeRawPointer, bytes: Int) {
		self.bufferPointer = UnsafeBufferPointer(start: rawPointer.assumingMemoryBound(to: T.self), count: bytes / MemoryLayout<T>.stride)
	}
	init(array: Array<T>) {
		self.bufferPointer = array.withUnsafeBufferPointer { $0 }
	}
	init(opaquePointer: OpaquePointer, count: Int) {
		self.bufferPointer = UnsafeBufferPointer(start: UnsafeRawPointer(opaquePointer).assumingMemoryBound(to: T.self), count: count)
	}
	init(opaquePointer: OpaquePointer, bytes: Int) {
		self.bufferPointer = UnsafeBufferPointer(start: UnsafeRawPointer(opaquePointer).assumingMemoryBound(to: T.self), count: bytes / MemoryLayout<T>.stride)
	}
	var mutableBufferPointer: UnsafeMutableBufferPointer<T> {
		return UnsafeMutableBufferPointer(mutating: bufferPointer)
	}
	subscript(index: Int) -> T {
		get { self.bufferPointer[index] }
		set { self.mutableBufferPointer[index] = newValue }
	}

}
