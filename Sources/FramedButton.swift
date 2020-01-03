//
//	FramedButton.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 2/14/19.
//	Copyright © 2019 Electricwoods LLC. All rights reserved.
//

import UIKit

@IBDesignable public class FramedButton: UIButton {
	
	@IBInspectable var borderWidth: CGFloat = 0
	@IBInspectable var borderColor: UIColor? = nil

	override public func awakeFromNib() {
		super.awakeFromNib()
		self.layer.borderWidth = self.borderWidth
		self.layer.borderColor = self.borderColor?.cgColor
	}


}
