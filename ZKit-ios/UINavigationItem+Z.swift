//
//	UINavigationItem+Z.swift
//	ZKit-ios
//
//	Created by Kaz Yoshikawa on 10/15/21.
//

import UIKit

public extension UINavigationItem {

	func setNavigationBarAppearance(_ appearance: UINavigationBarAppearance) {
		self.standardAppearance = appearance
		self.scrollEdgeAppearance = appearance
		self.compactAppearance = appearance
	}

}
