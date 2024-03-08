//
//	NSTextField+Blurred.swift
//	ZKit
//
//	The MIT License (MIT)
//
//	Copyright (c) 2024 Electricwoods LLC, Kaz Yoshikawa.
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
//
//
//	Overview:
//
//	Since NSSecureTextField will not arrowed to turn on and off its text's visibility.
//	Often we place both NSTextField and NSSecureTextField and switch or show / hide
//	its control to manage as if there is one text field.
//
//	NSTextField+Burred coule be the alternative for that solution.  You may turn of
//	and off to blur or unblur to achive similar task.
//
//	Usage:
//
//	class MyViewController: NSViewController {
//		@IBOutlet weak var apiKeyTextField: NSTextField!
//		override func viewDidLoad() {
//			super.viewDidLoad()
//			self.apiKeyTextField.isBlurred = true
//		}
//		@IBAction func toggle(sender: Any) {
//			self.apiKeyTextField.toggleBlurred()
//		}
//	}
//

#if os(macOS)
import AppKit

extension NSTextField {
	var isBlurred: Bool {
		get { return self.getBlurred() }
		set { self.setBlurred(newValue) }
	}
	private func getBlurred() -> Bool {
		return self.contentFilters.filter { $0.name == "CIGaussianBlur" }.count > 0
	}
	func setBlurred(_ burred: Bool) {
		if self.getBlurred() {
			self.contentFilters = self.contentFilters.filter { $0.name != "CIGaussianBlur" }
		}
		else {
			guard let blurFilter = CIFilter(name: "CIGaussianBlur") else { fatalError() }
			blurFilter.setDefaults()
			blurFilter.setValue(4.0, forKey: kCIInputRadiusKey)
			self.contentFilters.append(blurFilter)
		}
	}
	func toggleBlurred() {
		self.setBlurred(!self.isBlurred)
	}
}
#endif

