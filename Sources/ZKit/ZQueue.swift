//
//  ZQueue.swift
//  ZKit
//
//  Created by Kaz Yoshikawa on 2/9/24.
//

import Foundation

public class ZQueue<Element> {
	private var elements: [Element]
	
	public init(_ elements: [Element] = []) {
		self.elements = elements
	}
	
	public func enqueue(_ element: Element) {
		self.elements.append(element)
	}
	
	public func dequeue() -> Element? {
		guard !self.elements.isEmpty else { return nil }
		return self.elements.removeFirst()
	}
	
	public func peek() -> Element? {
		self.elements.first
	}
	
	public var isEmpty: Bool {
		self.elements.isEmpty
	}
}
