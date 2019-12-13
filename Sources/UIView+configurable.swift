//
//  UIView+name.swift
//  SSI-ios
//
//  Created by Kaz Yoshikawa on 8/17/19.
//  Copyright © 2019 Electricwoods LLC. All rights reserved.
//

import UIKit


fileprivate var viewNameMap = NSMapTable<UIView, NSString>.weakToStrongObjects()
fileprivate var viewDictionaryMap = NSMapTable<UIView, NSDictionary>.weakToStrongObjects()


extension UIView {
	
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

	func view(named name: String) -> UIView? {
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

