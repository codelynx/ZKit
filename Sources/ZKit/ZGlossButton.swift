//
//	ZGlossButton.swift
//	SSI-ios
//
//	Created by Kaz Yoshikawa on 3/2/18.
//	Copyright © 2018 Electricwoods LLC. All rights reserved.
//

import UIKit

@IBDesignable public class ZGlossButton: UIButton {
	
	@IBInspectable var buttonColor: UIColor = UIColor.blue
	@IBInspectable var gloss: CGFloat = 0.5
	
	override public var isHighlighted: Bool {
		didSet {
			self.setNeedsDisplay()
		}
	}
	
	override public func draw(_ rect: CGRect) {
		super.draw(rect)
		
		guard let context = UIGraphicsGetCurrentContext() else { return }
		
		context.saveGState()
		UIColor.clear.setFill()
		UIRectFill(self.bounds)
		
		/*
		+-------- radius1
		| +------ radius2
		| |
		| |		+
		*/
		
		let inset1: CGFloat = 1.0
		let bounds1 = self.bounds
		let bounds2 = bounds1.insetBy(dx: inset1, dy: inset1)
		let radius1 = bounds1.size.height * 0.25
		let radius2 = radius1 - inset1
		
		let baseColor = self.buttonColor
		let (h, s, v, a) = baseColor.hsba
		let z: CGFloat = (v > 0.5 && self.isHighlighted) ? 0.2 : 0.0
		let v1: CGFloat = ((v > 0.5) ? v - 0.3 : v) - z
		let v2: CGFloat = ((v > 0.5) ? v : v + 0.3) - z
		
		let c1 = UIColor(h: h, s: s, b: v1, a: a)
		let c2 = UIColor(h: h, s: s, b: v2, a: a)
		let c3 = UIColor(h: h, s: s * 0.25, b: v * 0.3, a: a)
		let (r1, g1, b1, _) = c1.rgba
		let (r2, g2, b2, _) = c2.rgba
		
		// inner fill
		context.setFillColor(c3.cgColor)
		context.addPath(bounds1.cgPath(cornerRadius: radius1))
		context.fillPath()
		context.restoreGState()
		
		// garient inner fill button
		let glossiness: CGFloat = 0.25 * (1.0 - min(max(self.gloss, 0.0), 1.0)) + 0.01
		let components: [CGFloat] = [
			r1, g1, b1, a,
			r1, g1, b1, a,
			r2, g2, b2, a,
			r2, g2, b2, a
		]
		
		let locationsN: [CGFloat] = [
			0.000,
			0.500 - glossiness,
			0.500 + glossiness,
			1.000
		]
		
		let locationsH: [CGFloat] = [
			1.000,
			0.500 + glossiness,
			0.500 - glossiness,
			0.000
		]
		
		context.saveGState()
		let locations = self.isHighlighted ? locationsN : locationsH
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let gradient = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: locations, count: locations.count)
		let startPt = bounds1.midXminY
		let endPt = bounds2.midXmaxY
		
		context.addPath(bounds2.cgPath(cornerRadius: radius2))
		
		context.clip()
		context.drawLinearGradient(gradient!, start: startPt, end: endPt, options: [])
		context.restoreGState()
		
		//		// outer stroke
		//		let lineWidth: CGFloat = 3.0
		//		context.saveGState()
		//		context.setStrokeColor(UIColor.orange.cgColor)
		//		context.setLineWidth(3.0)
		//		context.addPath(bounds1.cgPath(cornerRadius: radius1 + lineWidth))
		//		context.strokePath()
		//		context.restoreGState()
	}
	
	private lazy var setup: ()->() = {
		self.contentEdgeInsets = UIEdgeInsets(top: 3, left: 16, bottom: 3, right: 16)
		return {}
	}()
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		self.contentMode = .redraw
		self.setup()
	}
	
	override public func setTitle(_ title: String?, for state: UIControl.State) {
		super.setTitle(title, for: state)
	}
	
	override public var intrinsicContentSize: CGSize {
		return super.intrinsicContentSize + CGSize(width: 100, height: 4)
	}
}
