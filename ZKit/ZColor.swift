//
//  ZColor.swift
//  ZKit
//
//  Created by Kaz Yoshikawa on 9/29/21.
//

import UIKit


public struct ZRGBA<T: BinaryFloatingPoint>: ZDataRepresentable, ZArchivable {
	var r: T
	var g: T
	var b: T
	var a: T
	public init<R: BinaryFloatingPoint, G: BinaryFloatingPoint, B: BinaryFloatingPoint, A: BinaryFloatingPoint>(r: R, g: G, b: B, a: A) {
		(self.r, self.g, self.b, self.a) = (T(r), T(g), T(b), T(a))
	}
	public init(color: UIColor) {
		var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
		color.getRed(&r, green: &g, blue: &b, alpha: &a)
		(self.r, self.g, self.b, self.a) = (T(r), T(g), T(b), T(a))
	}
	public var color: UIColor {
		return UIColor(red: CGFloat(self.r), green: CGFloat(self.g), blue: CGFloat(self.b), alpha: CGFloat(self.a))
	}
	public init?(data: Data) {
		guard let rgba = data.unarchive(as: ZRGBA<T>.self) else { return nil }
		self = rgba
	}
	public var dataRepresentation: Data {
		return self.archive()
	}
	public var red: T { return self.r }
	public var green: T { return self.g }
	public var blue: T { return self.b }
	public var alpha: T { return self.a }
}

public struct ZRGB<T: BinaryFloatingPoint>: ZDataRepresentable, ZArchivable {
	var r: T
	var g: T
	var b: T
	public init<R: BinaryFloatingPoint, G: BinaryFloatingPoint, B: BinaryFloatingPoint>(r: R, g: G, b: B) {
		(self.r, self.g, self.b) = (T(r), T(g), T(b))
	}
	public init(color: UIColor) {
		var (r, g, b): (CGFloat, CGFloat, CGFloat) = (0, 0, 0)
		color.getRed(&r, green: &g, blue: &b, alpha: nil)
		(self.r, self.g, self.b) = (T(r), T(g), T(b))
	}
	public var color: UIColor {
		return UIColor(red: CGFloat(self.r), green: CGFloat(self.g), blue: CGFloat(self.b), alpha: 1.0)
	}
	public init?(data: Data) {
		guard let rgb = data.unarchive(as: ZRGB<T>.self) else { return nil }
		self = rgb
	}
	public var dataRepresentation: Data {
		return self.archive()
	}
	public var red: T { return self.r }
	public var green: T { return self.g }
	public var blue: T { return self.b }
}


public struct ZHSBA<T: BinaryFloatingPoint>: ZDataRepresentable, ZArchivable {
	var h: T
	var s: T
	var b: T
	var a: T
	public init<H: BinaryFloatingPoint, S: BinaryFloatingPoint, B: BinaryFloatingPoint, A: BinaryFloatingPoint>(h: H, s: S, b: B, a: A) {
		(self.h, self.s, self.b, self.a) = (T(h), T(s), T(b), T(a))
	}
	public init(color: UIColor) {
		var (h, s, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
		color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
		(self.h, self.s, self.b, self.a) = (T(h), T(s), T(b), T(a))
	}
	public var color: UIColor {
		return UIColor(hue: CGFloat(self.h), saturation: CGFloat(self.s), brightness: CGFloat(self.b), alpha: CGFloat(self.a))
	}
	public init?(data: Data) {
		guard let hsba = data.unarchive(as: ZHSBA<T>.self) else { return nil }
		self = hsba
	}
	public var dataRepresentation: Data {
		return self.archive()
	}
	var hue: T { return self.h }
	var saturation: T { return self.s }
	var brightness: T { return self.b }
	var alpha: T { return self.a }
}


public struct ZHSB<T: BinaryFloatingPoint>: ZDataRepresentable, ZArchivable {
	var h: T
	var s: T
	var b: T
	public init<H: BinaryFloatingPoint, S: BinaryFloatingPoint, B: BinaryFloatingPoint>(h: H, s: S, b: B) {
		(self.h, self.s, self.b) = (T(h), T(s), T(b))
	}
	public init(color: UIColor) {
		var (h, s, b): (CGFloat, CGFloat, CGFloat) = (0, 0, 0)
		color.getHue(&h, saturation: &s, brightness: &b, alpha: nil)
		(self.h, self.s, self.b) = (T(h), T(s), T(b))
	}
	public var color: UIColor {
		return UIColor(hue: CGFloat(self.h), saturation: CGFloat(self.s), brightness: CGFloat(self.b), alpha: 1.0)
	}
	public init?(data: Data) {
		guard let hsb = data.unarchive(as: ZHSB<T>.self) else { return nil }
		self = hsb
	}
	public var dataRepresentation: Data {
		return self.archive()
	}
	var hue: T { return self.h }
	var saturation: T { return self.s }
	var brightness: T { return self.b }
}


public struct ZColor<T: BinaryFloatingPoint>: Codable {
	enum CodingError: Error {
		case unexpectedFormat
	}
	enum ColorModel {
		case rgba(ZRGBA<T>)
		case hsba(ZHSBA<T>)
	}
	var value: ColorModel
	init(rgba: ZRGBA<T>) {
		self.value = ColorModel.rgba(rgba)
	}
	init(hsba: ZHSBA<T>) {
		self.value = ColorModel.hsba(hsba)
	}
	var color: UIColor {
		switch value {
		case .rgba(let rgba): return rgba.color
		case .hsba(let hsba): return hsba.color
		}
	}
	enum TypeKeys: String { case rgba, hsba }
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		guard let type = TypeKeys(rawValue: try container.decode(String.self)) else { throw ZError("unexpected format") }
		let data = try container.decode(Data.self)
		switch type {
		case .rgba:
			guard let rgba = data.unarchive(as: ZRGBA<T>.self) else { throw ZError("unexpected format") }
			self = ZColor(rgba: rgba)
		case .hsba:
			guard let hsba = data.unarchive(as: ZHSBA<T>.self) else { throw ZError("unexpected format") }
			self = ZColor(hsba: hsba)
		}
	}
	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		switch value {
		case .rgba(let rgba):
			try container.encode(TypeKeys.rgba.rawValue)
			try container.encode(rgba.archive())
		case .hsba(let hsba):
			try container.encode(TypeKeys.hsba.rawValue)
			try container.encode(hsba.archive())
		}
	}
}
