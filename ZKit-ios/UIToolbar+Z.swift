//
//  UIToolbar+Z.swift
//  ZKit-ios
//
//  Created by Kaz Yoshikawa on 10/15/21.
//

import UIKit


public extension UIToolbar {

	func setToolbarAppearance(_ appearance: UIToolbarAppearance) {
		self.standardAppearance = appearance
		self.compactAppearance = appearance
		if #available(iOS 15, *) {
			self.scrollEdgeAppearance = appearance
		}
	}

}
