//
//	XView.swift
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

import Foundation

#if os(iOS) || os(visionOS)
import UIKit
public typealias XView = UIView
#elseif os(macOS)
import AppKit
public typealias XView = NSView
#endif


public extension XView {

	#if os(macOS)
	@objc func setNeedsLayout() {
		self.layout()
	}
	#endif
	
	#if os(macOS)
	@objc func setNeedsDisplay() {
		self.setNeedsDisplay(self.bounds)
	}
	#endif
	
	#if os(macOS)
	@objc func sendSubview(toBack: NSView) {
		var subviews = self.subviews
		if let index = subviews.firstIndex(of: toBack) {
			subviews.remove(at: index)
			subviews.insert(toBack, at: 0)
			self.subviews = subviews
		}
	}
	#endif

	#if os(macOS)
	@objc func bringSubview(toFront: NSView) {
		var subviews = self.subviews
		if let index = subviews.firstIndex(of: toFront) {
			subviews.remove(at: index)
			subviews.append(toFront)
			self.subviews = subviews
		}
	}
	#endif

	#if os(macOS)
	@objc func replaceSubview(subview: NSView, with other: NSView) {
		var subviews = self.subviews
		if let index = subviews.firstIndex(of: subview) {
			subviews.remove(at: index)
			subviews.insert(other, at: index)
			self.subviews = subviews
		}
	}
	#endif

	#if os(macOS)
	var backgroundColor: XColor {
		get {
			if let backgroundColor = self.layer?.backgroundColor, let color = XColor(cgColor: backgroundColor) {
				return color
			}
			return .clear
		}
		set {
			self.wantsLayer = true
			self.layer?.backgroundColor = newValue.cgColor
		}
	}
	#endif

}
