//
//	UIAlertController.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 3/14/19.
//	Copyright © 2019 Electricwoods. All rights reserved.
//

import UIKit


public extension UIAlertController {
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return UIInterfaceOrientationMask.all
	}
	override var shouldAutorotate: Bool {
		return false
	}
	
}

//	NOTE:
//
//	https://www.questarter.com/q/uialertcontroller-supportedinterfaceorientations-was-invoked-recursively-27_31406820.html

