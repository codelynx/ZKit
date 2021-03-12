//
//	UIGestureRecognizer+Z.swift
//	ZKit
//
//	The MIT License (MIT)
//
//	Copyright (c) 2021 Electricwoods LLC, Kaz Yoshikawa.
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

//	Sometime you like to keep some values associated to a gesture recognizer.  For example, you may want to keep the location of origin for
//	UIPanGestureRecognizer.  In this case, you can still provide a subclass of UIPanGestureRecognizer to provide a property, but this extension
//	provides a NSMutableDictionary to get or to set arbitrary value for any gesture recoginizer classes.
//
//	Usage:
/*
	extension UILongPressGestureRecognizer {
		static let previousLocationKey = "previousLocation"
		var previousLocation: CGPoint? {
			get { self.dictionary[Self.previousLocationKey] as? CGPoint }
			set { self.dictionary[Self.previousLocationKey] = newValue }
		}
	}

	class SomeViewControler: UIViewController {
		@IBAction func longPressGesture(_ gesture: UILongPressGestureRecognizer) {
			switch gesture.state {
			case .began:
				gesture.previousLocation = gesture.location(in: self.view)
			case .changed:
			let location = gesture.location(in: self.view)
				if let previousLocation = gesture.previousLocation {
					let translation = CGPoint(x: location.x - previousLocation.x, y: location.y - previousLocation.y)
					print(translation)
					// do something for the move
				}
				gesture.previousLocation = gesture.location(in: self.view)
			case .ended, .cancelled, .failed:
				gesture.previousLocation = nil
			default:
				break
			}
		}
	}
*/
//

fileprivate var gestureRecognizerDictionaryMap = NSMapTable<UIGestureRecognizer, NSMutableDictionary>.weakToStrongObjects()


public extension UIGestureRecognizer {

	var dictionary: NSMutableDictionary {
		if let dictionary = gestureRecognizerDictionaryMap.object(forKey: self) { return dictionary }
		let dictionary = NSMutableDictionary()
		gestureRecognizerDictionaryMap.setObject(dictionary, forKey: self)
		return dictionary
	}

	subscript(key: String) -> Any? {
		get { return self.dictionary[key] }
		set { self.dictionary[key] = newValue }
	}

}
