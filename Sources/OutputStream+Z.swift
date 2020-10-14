//
//	OutputStream+Z.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 12/14/18.
//	Copyright © 2018 Electricwoods LLC. All rights reserved.
//

import Foundation


extension OutputStream {

	func write(_ data: Data) -> Int {
		let pointer = UnsafePointer<UInt8>(OpaquePointer((data as NSData).bytes))
		return self.write(pointer, maxLength: data.count)
	}

}

