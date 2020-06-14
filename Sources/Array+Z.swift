//
//	Array+Z.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 1/9/19.
//	Copyright © 2019 Electricwoods LLC. All rights reserved.
//

import Foundation

extension Array {

	mutating public func rearrange(from fromIndex: Int, to toIndex: Int) {
		let item = self.remove(at: fromIndex)
		self.insert(item, at: toIndex)
	}

	public func rearranged(from fromIndex: Int, to toIndex: Int) -> Array {
		var array = self
		let item = array.remove(at: fromIndex)
		array.insert(item, at: toIndex)
		return array
	}

	public func appending(_ elements: [Element]) -> Array {
		var array = self
		array += elements
		return array
	}

	public func appending(_ element: Element) -> Array {
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
