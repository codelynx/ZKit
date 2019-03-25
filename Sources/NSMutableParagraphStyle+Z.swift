//
//	NSMutableParagraphStyle+Z.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 8/18/18.
//	Copyright © 2018 Electricwoods LLC. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableParagraphStyle {

	convenience init(alignment: NSTextAlignment) {
		self.init()
		self.alignment = alignment
	}

}
