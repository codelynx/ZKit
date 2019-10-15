//
//	UIDevice+Z.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 10/14/19.
//	Copyright © 2019 Electricwoods LLC. All rights reserved.
//

import Foundation
import UIKit


extension UIDevice {

	func setOrientation(orientation: UIDeviceOrientation) {
		// https://stackoverflow.com/questions/52176134/force-rotate-uiviewcontroller-in-portrait-status
		self.setValue(orientation.rawValue, forKey: "orientation")
	}

}

