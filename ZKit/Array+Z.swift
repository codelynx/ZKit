//
//	Array+Z.swift
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


public extension Array {

	mutating func rearrange(from fromIndex: Int, to toIndex: Int) {
		let item = self.remove(at: fromIndex)
		self.insert(item, at: toIndex)
	}

	func rearranged(from fromIndex: Int, to toIndex: Int) -> Array {
		var array = self
		let item = array.remove(at: fromIndex)
		array.insert(item, at: toIndex)
		return array
	}

	func appending(_ elements: [Element]) -> Array {
		var array = self
		array += elements
		return array
	}

	func appending(_ element: Element) -> Array {
		var array = self
		array += [element]
		return array
	}

}


extension Array where Element: Equatable {

	public func removingDuplicates() -> Array {
		return reduce(into: []) { result, element in
			if !result.contains(element) {
				result.append(element)
			}
		}
	}
	
	mutating public func removeDuplicates() {
		self = self.removingDuplicates()
	}

	public func removing(_ elements: [Element]) -> Array {
		return self.filter { !elements.contains($0) }
	}

	mutating public func remove(_ elements: [Element]) {
		self = self.removing(elements)
	}

	func indexes(of element: Element) -> [Int] {
		return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
	}

	mutating func removeIndexes(_ indexes: [Int]) {
		for index in Set(indexes).sorted(by: >) {
			self.remove(at: index)
		}
	}

	func removingIndexes(_ indexes: [Int]) -> Self {
		var array = Array(self)
		array.removeIndexes(indexes)
		return array
	}

}
