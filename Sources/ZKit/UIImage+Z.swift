//
//	UIImage+Z.swift
//	ZKit
//
//	Copyright (c) 2020 Kaz Yoshikawa
//
//	Permission is hereby granted, free of charge, to any person
//	obtaining a copy of this software and associated documentation
//	files (the "Software"), to deal in the Software without
//	restriction, including without limitation the rights to use,
//	copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following
//	conditions:
//
//	The above copyright notice and this permission notice shall be
//	included in all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//	OTHER DEALINGS IN THE SOFTWARE.

#if os(iOS)
import UIKit

public extension UIImage {
	
	func invertingAlpha() -> UIImage? {
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		let (width, height) = (Int(self.size.width * self.scale), Int(self.size.height * self.scale))
		let bytesPerPixel = 4
		let bytesPerRow = bytesPerPixel * width
		let byteOffsetToAlpha = 3 // [r][g][b][a]
		if let context = CGContext(
				data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow,
				space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo.rawValue),
			let cgImage = self.cgImage {
			context.setFillColor(UIColor.clear.cgColor)
			context.fill(CGRect(origin: CGPoint.zero, size: self.size))
			context.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: self.size * self.scale))
			if let memory: UnsafeMutableRawPointer = context.data {
				for y in 0..<height {
					let pointer = memory.advanced(by: bytesPerRow * y)
					let buffer = pointer.bindMemory(to: UInt8.self, capacity: bytesPerRow)
					for x in 0..<width {
						let rowOffset = x * bytesPerPixel + byteOffsetToAlpha
						buffer[rowOffset] = 0xff - buffer[rowOffset]
					}
				}
				if let cgImage =  context.makeImage() {
					let image = UIImage(cgImage: cgImage, scale: self.scale, orientation: .up)
					return image
				}
			}
		}
		return nil
	}

	func resizing(to _size: CGSize) -> UIImage? {
		let widthRatio = _size.width / size.width
		let heightRatio = _size.height / size.height
		let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
		let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)
		UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
		draw(in: CGRect(origin: .zero, size: resizedSize))
		let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return resizedImage
	}

}

#endif
