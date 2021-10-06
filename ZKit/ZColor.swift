//
//  ZColor.swift
//  ZKit
//
//  Created by Kaz Yoshikawa on 9/29/21.
//

import UIKit


public struct ZRGBA<T: BinaryFloatingPoint>: Equatable {
	public var r: T
	public var g: T
	public var b: T
	public var a: T
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
	public var red: T { return self.r }
	public var green: T { return self.g }
	public var blue: T { return self.b }
	public var alpha: T { return self.a }
	public static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b && lhs.a == rhs.a
	}
	public static var black: Self { return Self(color: UIColor.black) }
}

@available(iOS 14, *)
public typealias ZRGBA16 = ZRGBA<Float16>
public typealias ZRGBA32 = ZRGBA<Float>
public typealias ZRGBA64 = ZRGBA<Double>


public struct ZRGB<T: BinaryFloatingPoint>: Equatable {
	public var r: T
	public var g: T
	public var b: T
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
	public var red: T { return self.r }
	public var green: T { return self.g }
	public var blue: T { return self.b }
	public static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b
	}
}

@available(iOS 14, *)
public typealias ZRGB16 = ZRGB<Float16>
public typealias ZRGB32 = ZRGB<Float>
public typealias ZRGB64 = ZRGB<Double>


public struct ZHSBA<T: BinaryFloatingPoint>: Equatable {
	public var h: T
	public var s: T
	public var b: T
	public var a: T
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
	public var hue: T { return self.h }
	public var saturation: T { return self.s }
	public var brightness: T { return self.b }
	public var alpha: T { return self.a }
	public static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.h == rhs.h && lhs.s == rhs.s && lhs.b == rhs.b && lhs.a == rhs.a
	}
}

@available(iOS 14, *)
public typealias ZHSBA16 = ZHSBA<Float16>
public typealias ZHSBA32 = ZHSBA<Float>
public typealias ZHSBA64 = ZHSBA<Double>


public struct ZHSB<T: BinaryFloatingPoint>: Equatable {
	public var h: T
	public var s: T
	public var b: T
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
	public var hue: T { return self.h }
	public var saturation: T { return self.s }
	public var brightness: T { return self.b }
	public static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.h == rhs.h && lhs.s == rhs.s && lhs.b == rhs.b
	}
}

@available(iOS 14, *)
public typealias ZHSB16 = ZHSB<Float16>
public typealias ZHSB32 = ZHSB<Float>
public typealias ZHSB64 = ZHSB<Double>


public struct ZColor<T: BinaryFloatingPoint> {
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
	/*
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
	*/
}

@available(iOS 14, *)
public typealias ZColor16 = ZColor<Float16>
public typealias ZColor32 = ZColor<Float>
public typealias ZColor64 = ZColor<Double>
