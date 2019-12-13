//
//	UIView+Z.swift
//	ZKit
//
//	The MIT License (MIT)
//
//	Copyright (c) 2016 Electricwoods LLC, Kaz Yoshikawa.
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


public extension UIViewController {

	func addViewController(viewController: UIViewController, intoView view: UIView) {
		viewController.view.frame = view.bounds
		self.addChild(viewController)
		view.addSubview(viewController.view)
		viewController.didMove(toParent: self)

		viewController.view.translatesAutoresizingMaskIntoConstraints = true
		viewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
	}

	func removeViewController(viewController: UIViewController) {
		viewController.willMove(toParent: nil)
		viewController.view.removeFromSuperview()
		viewController.removeFromParent()
	}

	func alert(title: String? = nil, message: String, actions: [UIAlertAction]) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		actions.forEach { alertController.addAction($0) }
		self.present(alertController, animated: true, completion: nil)
	}

	func alert(title: String? = nil, message: String, completion: (()->())? = nil) {
		self.alert(title: title, message: message, actions: [
			UIAlertAction(title: "OK", style: .default, handler: { action in completion?() })
		])
	}

	func presentPopover(_ viewController: UIViewController, animated flag: Bool, completion: (()->())? = nil, sourceView: UIView?, sourceRect: CGRect, preferredContentSize: CGSize? = nil) {
		viewController.modalPresentationStyle = .popover
		if let popoverController = viewController.popoverPresentationController {
			popoverController.sourceView = sourceView
			popoverController.sourceRect = sourceRect
		}
		if let preferredContentSize = preferredContentSize {
			viewController.preferredContentSize = preferredContentSize
		}
		self.present(viewController, animated: true, completion: completion)
	}

	func makeFirstResponderToResign() {
		UIApplication.shared.sendAction(#selector(UIView.resignFirstResponder), to: nil, from: nil, for: nil)
	}

}
