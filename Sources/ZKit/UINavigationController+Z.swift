//
//	UINavigationController+Leaf.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 3/3/18.
//	Copyright © 2018 Electricwoods LLC. All rights reserved.
//

import Foundation
import UIKit

public extension UINavigationController {
	
	override var shouldAutorotate: Bool {
		guard let viewController = self.visibleViewController else { return true }
		return viewController.shouldAutorotate
	}
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		guard let viewController = self.visibleViewController else { return .all }
		return viewController.supportedInterfaceOrientations
	}
	
}

