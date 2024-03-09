//
//	UIView+name.swift
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

#if os(iOS) || os(visionOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif


fileprivate var viewNameMap = NSMapTable<XView, NSString>.weakToStrongObjects()
fileprivate var viewDictionaryMap = NSMapTable<XView, NSDictionary>.weakToStrongObjects()


public extension XView {
	
	@IBInspectable dynamic var name: String? {
		get {
			return viewNameMap.object(forKey: self) as String?
		}
		set {
			if let name = newValue {
				viewNameMap.setObject(name as NSString, forKey: self)
			}
			else {
				viewNameMap.removeObject(forKey: self)
			}
		}
	}

	func view(named name: String) -> XView? {
		if self.name == name {
			return self
		}
		for subview in self.subviews {
			if let view = subview.view(named: name) {
				return view
			}
		}
		return nil
	}

	var configuration: NSDictionary? {
		get {
			return viewDictionaryMap.object(forKey: self)
		}
		set {
			if let newValue = newValue {
				viewDictionaryMap.setObject(newValue, forKey: self)
			}
			else {
				viewDictionaryMap.removeObject(forKey: self)
			}
		}
		
	}


}

