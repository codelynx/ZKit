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
		var isDirectory: ObjCBool = false
		return FileManager.default.fileExists(atPath: self.path, isDirectory: &isDirectory) && isDirectory.boolValue
	}

}

