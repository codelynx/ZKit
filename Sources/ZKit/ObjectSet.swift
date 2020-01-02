//	ObjectSet.swift
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
//	* Motivation *
//	You can use `Set` features for your class objects without conforming `Hashable`
//	protocol.
//

import Foundation

fileprivate class ObjectWrapper<T: AnyObject>: Equatable, Hashable {
	let object: T
	init(_ object: T) {
		self.object = object
	}
	static func == (lhs: ObjectWrapper<T>, rhs: ObjectWrapper<T>) -> Bool {
		return lhs.object === rhs.object
	}
	func hash(into hasher: inout Hasher) {
		hasher.combine(ObjectIdentifier(self.object))
	}
}

class ObjectSet<T: AnyObject> {
	private var _objects: Set<ObjectWrapper<T>>
	init() {
		self._objects = Set<ObjectWrapper<T>>([])
	}
	init(_ objects: [T]) {
		self._objects = Set<ObjectWrapper<T>>(objects.map { ObjectWrapper($0) })
	}
	var objects: [T] {
		return self._objects.compactMap { $0.object }
	}
	func contains(_ object: T) -> Bool {
		return self._objects.contains(ObjectWrapper(object))
	}
	func addObject(_ object: T) {
		self._objects.insert(ObjectWrapper(object))
	}
	func addingObject(_ object: T) -> ObjectSet<T> {
		return ObjectSet( self.objects + [object])
	}
	func addObjects(_ objects: [T]) {
		self._objects.formUnion(objects.map { ObjectWrapper($0) })
	}
	func addingObjects(_ objects: [T]) -> ObjectSet<T> {
		return ObjectSet( self.objects + objects)
	}
	func removeObject(_ object: T) {
		self._objects.remove(ObjectWrapper(object))
	}
	func removingObject(_ object: T) -> ObjectSet<T> {
		var temporaryObjects = self._objects
		temporaryObjects.remove(ObjectWrapper(object))
		return ObjectSet(temporaryObjects.compactMap { $0.object })
	}
	func removeObjects(_ objects: [T]) {
		self._objects.subtract(objects.map { ObjectWrapper($0) })
	}
	func removingObjects(_ objects: [T]) -> ObjectSet<T> {
		let temporaryObjects = self._objects.subtracting(objects.map { ObjectWrapper($0) })
		return ObjectSet(temporaryObjects.compactMap { $0.object })
	}
}
