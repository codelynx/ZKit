//
//	URL+Z.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 3/11/19.
//	Copyright © 2019 Electricwoods. All rights reserved.
//

import Foundation


extension URL {
	var isDirectory: Bool {
		let values = try? resourceValues(forKeys: [.isDirectoryKey])
		return values?.isDirectory ?? false
	}
}

