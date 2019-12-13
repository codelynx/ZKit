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
}
