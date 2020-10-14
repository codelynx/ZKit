//
//	Utilities.swift
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

//	Usage:
//
//	Sometime, you need to create an object or an item. But it needs to be
//	set some properties for it, or needs to be preprocessed before it is
//	in use.  This tiny pice of code can save your small effort while coding
//	with swift.
//
//	[e.g]
//	func dictionary1() -> NSDictionary {
//		let dictionary = NSMutableDictionary()
//		dictionary["language"] = "Ja"
//		dictionary["city"] = "Tokyo"
//		return dictionary
//	}
//
//	You may write the code to do the same thing with much simpler way as follows.
//
//	[e.g]
//	func dictionary2() -> NSDictionary {
//		return with(NSMutableDictionary(), { $0["language"] = "Ja" ; $0["city"] = "Tokyo" })
//	}
//


public func with<T>(_ item: T, _ closure: (T)->()) -> T {
	closure(item)
	return item
}

public func with<T>(_ item: T?, _ closure: (T)->()) -> T? {
	if let item = item {
		closure(item)
	}
	return item
}
