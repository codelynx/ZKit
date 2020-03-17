//	WeakObjectSet.swift
//
//	The MIT License (MIT)
//
//	Copyright (c) 2019 Electricwoods LLC, Kaz Yoshikawa.
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

fileprivate class WeakObject<T: AnyObject>: Equatable, Hashable {
	weak var object: T?
	private let hashKey: Int
	init(_ object: T) {
		self.object = object
		self.hashKey = ObjectIdentifier(object).hashValue
	}
	static func == (lhs: WeakObject<T>, rhs: WeakObject<T>) -> Bool {
		if lhs.object == nil || rhs.object == nil { return false }
		return lhs.object === rhs.object
	}
	func hash(into hasher: inout Hasher) {
		hasher.combine(hashKey)
	}
}

class WeakObjectSet<T: AnyObject> {
	private var _objects: Set<WeakObject<T>>
	init() {
		self._objects = Set<WeakObject<T>>([])
	}
	init(_ objects: [T]) {
		self._objects = Set<WeakObject<T>>(objects.map { WeakObject($0) })
	}
	var objects: [T] {
		return self._objects.compactMap { $0.object }
	}
	func contains(_ object: T) -> Bool {
		return self._objects.contains(WeakObject(object))
	}
	func addObject(_ object: T) {
		self._objects.insert(WeakObject(object))
	}
	func addingObject(_ object: T) -> WeakObjectSet<T> {
		return WeakObjectSet( self.objects + [object])
	}
	func addObjects(_ objects: [T]) {
		self._objects.formUnion(objects.map { WeakObject($0) })
	}
	func addingObjects(_ objects: [T]) -> WeakObjectSet<T> {
		return WeakObjectSet( self.objects + objects)
	}
	func removeObject(_ object: T) {
		self._objects.remove(WeakObject(object))
	}
	func removingObject(_ object: T) -> WeakObjectSet<T> {
		var temporaryObjects = self._objects
		temporaryObjects.remove(WeakObject(object))
		return WeakObjectSet(temporaryObjects.compactMap { $0.object })
	}
	func removeObjects(_ objects: [T]) {
		self._objects.subtract(objects.map { WeakObject($0) })
	}
	func removingObjects(_ objects: [T]) -> WeakObjectSet<T> {
		let temporaryObjects = self._objects.subtracting(objects.map { WeakObject($0) })
		return WeakObjectSet(temporaryObjects.compactMap { $0.object })
	}
}
