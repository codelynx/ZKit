//
//	ZDataConvertible.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 9/29/21.
//

import Foundation


protocol ZDataRepresentable {
	init?(data: Data)
	var dataRepresentation: Data { get }
}
