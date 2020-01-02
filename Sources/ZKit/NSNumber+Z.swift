//
//	NSNumber+Z.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 3/16/18.
//	Copyright © 2018 Electricwoods LLC. All rights reserved.
//

import Foundation


public extension NSNumber {
	
	convenience init?(_ value: Int?) {
		guard let value = value else { return nil }
		self.init(value: value)
	}
	
	convenience init?(_ value: Bool?) {
		guard let value = value else { return nil }
		self.init(value: value)
	}
	
}


public extension NSDecimalNumber {
	
	var isNotANumber: Bool {
		return self.isEqual(NSDecimalNumber.notANumber)
	}
	
}
