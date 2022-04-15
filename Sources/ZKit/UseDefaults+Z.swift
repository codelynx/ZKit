//
//	UseDefaults+Z.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 4/4/21.
//
#if os(iOS)
import UIKit

extension UserDefaults {

	subscript(key: String) -> UIColor? {
		get {
			if let data = self.data(forKey: key) {
				return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
			}
			return nil
		}
		set {
			if let color = newValue {
				let data = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
				self.set(data, forKey: key)
			}
			else {
				self.setValue(nil, forKey: key)
			}
		}
	}
	
}
#endif

