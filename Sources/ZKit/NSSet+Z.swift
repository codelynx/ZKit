//
//	NSSet+Z.swift
//	SSI-ios
//
//	Created by Kaz Yoshikawa on 3/17/18.
//	Copyright © 2018 Electricwoods LLC. All rights reserved.
//

import Foundation


public extension NSSet {
	
	static func + (lhs: NSSet, rhs: NSSet) -> NSSet {
		let objects = NSMutableSet()
		objects.addObjects(from: lhs.allObjects)
		objects.addObjects(from: rhs.allObjects)
		return objects
	}
	
	static func - (lhs: NSSet, rhs: NSSet) -> NSSet {
		let objects = NSMutableSet(set: lhs)
		if let hashables = rhs as? Set<AnyHashable> {
			objects.minus(hashables)
		}
		return objects
	}
	
	func removing(_ object: Any) -> NSSet {
		let objects = NSMutableSet(set: self)
		objects.remove(object)
		return objects
	}
	
}

