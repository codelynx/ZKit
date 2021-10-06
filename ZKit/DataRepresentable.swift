//
//	DataRepresentable.swift
//	DataRepresentable
//
//	Created by Kaz Yoshikawa on 10/1/21.
//

import UIKit

public protocol DataRepresentable: AnyObject {
	init(data: Data) throws
	var dataRepresentation: Data { get }
}


private let markerHeader = FourCharCode("ZDR1")!
private let markerBody = FourCharCode("ZDR2")!
private let markerFooter = FourCharCode("ZDR3")!

public extension Data {

	static func serialize(dataRepresentables: [DataRepresentable]) throws -> Data {
		let typeStrings: Array<String> = Set(dataRepresentables.map { String(describing: type(of: $0)) }).map { $0 }
		let serializer = Serializer()
		try serializer.write(markerHeader) // (a)
		try serializer.write(UInt32(typeStrings.count)) // (b)
		for typeString in typeStrings {
			try serializer.write(typeString) // (c)
		}
		try serializer.write(markerBody) // (d)
		try serializer.write(Int32(dataRepresentables.count)) // (e)
		for item in dataRepresentables {
			let typeString = String(describing: type(of: item))
			guard let index = typeStrings.firstIndex(of: typeString) else { throw ZError("logical error") }
			try serializer.write(Int32(index)) // (f)
			let data = item.dataRepresentation
			try serializer.write(data) // (g)
		}
		try serializer.write(markerFooter) // (h)
		return serializer.data
	}
	
	init(dataRepresentables: [DataRepresentable]) throws {
		self = try Data.serialize(dataRepresentables: dataRepresentables)
	}

	func unserialize() throws -> [DataRepresentable] {
		let unserializer = Unserializer(data: self)
		var items = [DataRepresentable]()
		do {
			let classes = Runtime.classes(conformTo: DataRepresentable.Type.self)

			let marker1 = try unserializer.read() as UInt32 // (a)
			guard marker1 == markerHeader else { throw ZError("unexpected format") }
			let count1 = try unserializer.read() as Int32 // (b)
			var typeStrings = [String]()
			for _ in 0 ..< count1 {
				let typeString = try unserializer.read() as String // (c)
				typeStrings.append(typeString)
			}
			let marker2 = try unserializer.read() as UInt32 // (d)
			guard marker2 == markerBody else { throw ZError("unexpected format") }
			let count2 = try unserializer.read() as Int32 // (e)
			for _ in 0 ..< count2 {
				let typeIndex = try unserializer.read() as Int32 // (f)
				guard typeIndex < typeStrings.count else { throw ZError("logical error") }
				let typeString = typeStrings[Int(typeIndex)]
				let data = try unserializer.read() as Data // (g)
				if let aClass = classes.filter({ String(describing: $0) == typeString }).first {
					if let type = aClass as? DataRepresentable.Type {
						let item = try type.init(data: data)
						items.append(item)
					}
				}
			}
			let marker3 = try unserializer.read() as UInt32 // (h)
			guard marker3 == markerFooter else { throw ZError("unexpected format") }
		}
		catch { fatalError("\(error)") }
		return items
	}

}

