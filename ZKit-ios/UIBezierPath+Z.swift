//
//  UIBezierPath+Z.swift
//  ZKit
//
//  Created by Kaz Yoshikawa on 9/2/21.
//

import UIKit

public extension UIBezierPath {

	convenience init?(points: [CGPoint]) {
		var iterator = points.makeIterator()
		guard let point1 = iterator.next() else { return nil }
		guard let point2 = iterator.next() else { return nil }
		let bezierPath = UIBezierPath()
		bezierPath.move(to: point1)
		bezierPath.addLine(to: point2)
		while let point = iterator.next() {
			bezierPath.addLine(to: point)
		}
		self.init(cgPath: bezierPath.cgPath)
	}

	func with(lineWidth: CGFloat) -> UIBezierPath {
		self.lineWidth = lineWidth
		return self
	}

}
