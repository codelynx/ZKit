//
//	Set+Z.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 8/12/20.
//

import Foundation


public extension Set {

	static func + (lhs: Self, rhs: Self) -> Self {
		return lhs.union(rhs)
	}
	
	static func - (lhs: Self, rhs: Self) -> Self {
		return lhs.subtracting(rhs)
	}
	
	static func * (lhs: Self, rhs: Self) -> Self {
		return lhs.intersection(rhs)
	}

}

