//
//	UIResponder+Z.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 4/14/16.
//
//

import Foundation
import UIKit


extension UIResponder {
	
	func findViewController<T: UIViewController>() -> T? {
		var responder = self.next
		repeat {
			if let viewController = responder as? T {
				return viewController
			}
			responder = responder!.next
		} while responder != nil
		return nil
	}
	
	func findResponder<T>() -> T? {
		var responder = self.next
		repeat {
			if let responder = responder as? T {
				return responder
			}
			responder = responder!.next
		} while responder != nil
		return nil
	}

}
