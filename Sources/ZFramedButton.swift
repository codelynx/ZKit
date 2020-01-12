//
//	ZFramedButton.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 10/16/19.
//	Copyright © 2019 Electricwoods LLC. All rights reserved.
//

import UIKit


public class ZFramedButton: UIButton {

	override public func layoutSubviews() {
		super.layoutSubviews()
		self.setBorder(color: self.titleColor(for: self.state), width: 1.0)
		self.layer.cornerRadius = 3.0
	}

	public override var intrinsicContentSize: CGSize {
		let size = super.intrinsicContentSize
		return CGSize(width: size.width + 8.0, height: size.height + 2.0)
	}
	
}

