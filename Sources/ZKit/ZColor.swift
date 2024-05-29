//
//  ZColor.swift
//  ZKit
//
//  Created by Kaz Yoshikawa on 9/29/21.
//

#if os(iOS) || os(visionOS)
import UIKit
#endif

#if os(macOS)
import AppKit
#endif

public struct ZRGBA<T: BinaryFloatingPoint>: Equatable {
	public var r: T
	public var g: T
	public var b: T
	public var a: T
	public init<R: BinaryFloatingPoint, G: BinaryFloatingPoint, B: BinaryFloatingPoint, A: BinaryFloatingPoint>(r: R, g: G, b: B, a: A) {
		(self.r, self.g, self.b, self.a) = (T(r), T(g), T(b), T(a))
	}
	public init(_ color: XColor) {
		var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
		color.getRed(&r, green: &g, blue: &b, alpha: &a)
		(self.r, self.g, self.b, self.a) = (T(r), T(g), T(b), T(a))
	}
	public var color: XColor {
		return XColor(red: CGFloat(self.r), green: CGFloat(self.g), blue: CGFloat(self.b), alpha: CGFloat(self.a))
	}
	public var red: T { return self.r }
	public var green: T { return self.g }
	public var blue: T { return self.b }
	public var alpha: T { return self.a }
	public static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b && lhs.a == rhs.a
	}
	public static var black: Self { return Self(XColor.black) }
}

#if FLOAT16_GRAPHICS
@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, macCatalyst 14.0, visionOS 1.0, *)
public typealias ZRGBA16 = ZRGBA<Float16>
#endif
public typealias ZRGBA32 = ZRGBA<Float>
public typealias ZRGBA64 = ZRGBA<Double>


public struct ZHSBA<T: BinaryFloatingPoint>: Equatable {
	public var h: T
	public var s: T
	public var b: T
	public var a: T
	public init<H: BinaryFloatingPoint, S: BinaryFloatingPoint, B: BinaryFloatingPoint, A: BinaryFloatingPoint>(h: H, s: S, b: B, a: A) {
		(self.h, self.s, self.b, self.a) = (T(h), T(s), T(b), T(a))
	}
	public init(_ color: XColor) {
		var (h, s, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
		color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
		(self.h, self.s, self.b, self.a) = (T(h), T(s), T(b), T(a))
	}
	public var color: XColor {
		return XColor(hue: CGFloat(self.h), saturation: CGFloat(self.s), brightness: CGFloat(self.b), alpha: CGFloat(self.a))
	}
	public var hue: T { return self.h }
	public var saturation: T { return self.s }
	public var brightness: T { return self.b }
	public var alpha: T { return self.a }
	public static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.h == rhs.h && lhs.s == rhs.s && lhs.b == rhs.b && lhs.a == rhs.a
	}
}

#if FLOAT16_GRAPHICS
@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, macCatalyst 14.0, visionOS 1.0, *)
public typealias ZHSBA16 = ZHSBA<Float16>
#endif
public typealias ZHSBA32 = ZHSBA<Float>
public typealias ZHSBA64 = ZHSBA<Double>


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
	var color: XColor {
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

#if FLOAT16_GRAPHICS
@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, macCatalyst 14.0, visionOS 1.0, *)
public typealias ZColor16 = ZColor<Float16>
#endif
public typealias ZColor32 = ZColor<Float>
public typealias ZColor64 = ZColor<Double>
