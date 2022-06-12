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
	
	/// Exchange two items specified by index
	/// - Parameters:
	///   - fromIndex: index to the first item
	///   - toIndex: index to the second item
	mutating func rearrange(from fromIndex: Int, to toIndex: Int) {
		let item = self.remove(at: fromIndex)
		self.insert(item, at: toIndex)
	}
	
	/// Create a new array by exchanging two items specified by index
	/// - Parameters:
	///   - fromIndex: index to the first item
	///   - toIndex: index to the second item
	/// - Returns: an array two items are exchanged
	func rearranged(from fromIndex: Int, to toIndex: Int) -> Array {
		var array = self
		let item = array.remove(at: fromIndex)
		array.insert(item, at: toIndex)
		return array
	}
	
	/// Create an array by appending another array
	/// - Parameter elements: another array
	/// - Returns: an array appending another array
	func appending(_ elements: [Element]) -> Array {
		var array = self
		array += elements
		return array
	}
	
	/// Create an array by append an item
	/// - Parameter element: an item to append
	/// - Returns: an array appending by an item
	func appending(_ element: Element) -> Array {
		var array = self
		array += [element]
		return array
	}
	
}


public extension Array where Element: Equatable {
	
	/// Remove duplicated items fomr the array
	/// - Returns: an array by removing duplicated items
	func removingDuplicates() -> Self {
		return reduce(into: []) { result, element in
			if !result.contains(element) {
				result.append(element)
			}
		}
	}
	
	/// remove duplicated items form the array
	mutating func removeDuplicates() {
		self = self.removingDuplicates()
	}
	
	/// returning an array by removing items from another array
	func removing(_ elements: [Element]) -> Self {
		return self.filter { !elements.contains($0) }
	}

	/// removing some items from the array
	mutating func remove(_ elements: [Element]) {
		self = self.removing(elements)
	}
	
	/// returning an array by removing some items from the array
	func removing(_ element: Element) -> Self {
		return self.removing([element])
	}
	
	/// remove a single item from the array
	mutating func remove(_ element: Element) {
		self = self.removing(element)
	}
	
	/// returning an array of indexes of a specified item
	func indexes(of element: Element) -> [Int] {
		return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
	}
	
	/// remove some items specified by indexes
	mutating func removeIndexes(_ indexes: [Int]) {
		for index in Set(indexes).sorted(by: >) {
			self.remove(at: index)
		}
	}
	
	/// returning an array by removing items specified by indexes
	func removingIndexes(_ indexes: [Int]) -> Self {
		var array = Array(self)
		array.removeIndexes(indexes)
		return array
	}
	
}
