//
//	UIView+Z.swift
//	ZKit
//
//	The MIT License (MIT)
//
//	Copyright (c) 2020 Electricwoods LLC, Kaz Yoshikawa.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

import UIKit


public extension UIView {

	func transform(to view: UIView) -> CGAffineTransform {
		let targetRect = self.convert(self.bounds, to: view)
		return view.bounds.transform(to: targetRect)
	}

	func addSubviewToFit(_ view: UIView) {
		view.frame = self.bounds
		self.addSubview(view)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
		view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
	}

	func setBorder(color: UIColor?, width: CGFloat) {
		self.layer.borderWidth = width
		self.layer.borderColor = color?.cgColor
	}

	func findViewController() -> UIViewController? {
		var responser = self.next
		while responser != nil {
			if let viewController = responser as? UIViewController {
				return viewController
			}
			responser = responser?.next
		}
		return nil
	}

	func firstResponderView() -> UIView? {
		if self.isFirstResponder { return self }
		for subview in self.subviews {
			if let firstResponder = subview.firstResponderView() {
				return firstResponder
			}
		}
		return nil
	}
}
