//
//	AutoViewUpdate.swift
//	ZKit
//
//	The MIT License (MIT)
//
//	Copyright (c) 2024 Electricwoods LLC, Kaz Yoshikawa.
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
#if os(macOS)
import AppKit
#elseif os(iOS) || os(visionOS)
import UIKit
#endif
import Combine

public class ZSet<T: Hashable> {
	private var _set: Set<T>
	
	public init(_ items: Set<T> = Set()) {
		self._set = items
	}
	var set: Set<T> {
		get { return self._set }
		set { self._set = newValue }
	}
	func add(_ item: T) {
		self._set.insert(item)
	}
	func remove(_ item: T) {
		self._set.remove(item)
	}
}

public extension XViewController {
	static private let cancellableMapTable = NSMapTable<XViewController, ZSet<AnyCancellable>>.weakToStrongObjects()
	
	var cancellables: ZSet<AnyCancellable> {
		if let existingSet = Self.cancellableMapTable.object(forKey: self) {
			return existingSet
		} else {
			let newSet = ZSet<AnyCancellable>()
			Self.cancellableMapTable.setObject(newSet, forKey: self)
			return newSet
		}
	}
	
	func setupAutoNeedsLayout(subject: some ObservableObject) {
		subject.objectWillChange
			.receive(on: RunLoop.main)
			.sink { [weak self] _ in
				self?.view.setNeedsLayout()
				self?.view.setNeedsDisplay()
			}
			.store(in: &cancellables.set)
	}
}

public extension XView {
	static private let cancellableMapTable = NSMapTable<XView, ZSet<AnyCancellable>>.weakToStrongObjects()
	
	var cancellables: ZSet<AnyCancellable> {
		if let existingSet = Self.cancellableMapTable.object(forKey: self) {
			return existingSet
		} else {
			let newSet = ZSet<AnyCancellable>()
			Self.cancellableMapTable.setObject(newSet, forKey: self)
			return newSet
		}
	}
	
	func setupAutoNeedsLayout(subject: some ObservableObject) {
		subject.objectWillChange
			.receive(on: RunLoop.main)
			.sink { [weak self] _ in
				self?.setNeedsLayout()
				self?.setNeedsDisplay()
			}
			.store(in: &cancellables.set)
	}
}
