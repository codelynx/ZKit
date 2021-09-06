//
//	Pointer+Z.swift
//	ZKit
//
//	Created by Kaz Yoshikawa on 9/5/21.
//

import Foundation

// UnsafeRawBufferPointer

func unsafeRawBufferPointer<T>(_ array: [T]) -> UnsafeRawBufferPointer {
	return array.withUnsafeBytes { $0 }
}
func unsafeRawPointer(_ pointer: UnsafeRawBufferPointer) -> UnsafeRawPointer {
	return pointer.baseAddress!
}
func unsafeMutableRawPointer(_ pointer: UnsafeRawBufferPointer) -> UnsafeMutableRawPointer {
	return UnsafeMutableRawPointer(mutating: pointer.baseAddress!)
}
func unsafePointer<T>(_ pointer: UnsafeRawBufferPointer) -> UnsafePointer<T> {
	return pointer.baseAddress!.assumingMemoryBound(to: T.self)
}
func unsafeMutableRawBufferPointer(_ pointer: UnsafeRawBufferPointer) -> UnsafeMutableRawBufferPointer {
	return UnsafeMutableRawBufferPointer(mutating: pointer)
}
func opaquePointer(_ pointer: UnsafeRawBufferPointer) -> OpaquePointer {
	return OpaquePointer(pointer.baseAddress!)
}

// UnsafeMutableRawBufferPointer

func unsafeMutableRawBufferPointer<T>(_ array: inout [T]) -> UnsafeMutableRawBufferPointer {
	return array.withUnsafeMutableBytes { $0 }
}
func unsafeRawPointer(_ pointer: UnsafeMutableRawBufferPointer) -> UnsafeRawPointer {
	return UnsafeRawPointer( pointer.baseAddress! )
}
func unsafeMutableRawPointer(_ pointer: UnsafeMutableRawBufferPointer) -> UnsafeMutableRawPointer {
	return pointer.baseAddress!
}
func unsafePointer<T>(_ pointer: UnsafeMutableRawBufferPointer) -> UnsafePointer<T> {
	return UnsafePointer(pointer.baseAddress!.assumingMemoryBound(to: T.self))
}
func unsafeMutablePointer<T>(_ pointer: UnsafeMutableRawBufferPointer) -> UnsafeMutablePointer<T> {
	return pointer.baseAddress!.assumingMemoryBound(to: T.self)
}
func unsafeRawBufferPointer(_ pointer: UnsafeMutableRawBufferPointer) -> UnsafeRawBufferPointer {
	return UnsafeRawBufferPointer(pointer)
}
func opaquePointer(_ pointer: UnsafeMutableRawBufferPointer) -> OpaquePointer {
	return OpaquePointer(pointer.baseAddress!)
}

// UnsafeBufferPointer<T>

func unsafeBufferPointer<T>(_ array: Array<T>) -> UnsafeBufferPointer<T> {
	return array.withUnsafeBufferPointer { $0 }
}
func unsafeRawPointer<T>(_ pointer: UnsafeBufferPointer<T>) -> UnsafeRawPointer {
	return UnsafeRawPointer(pointer.baseAddress!)
}
func unsafeMutableRawPointer<T>(_ pointer: UnsafeBufferPointer<T>) -> UnsafeMutableRawPointer {
	return UnsafeMutableRawPointer(mutating: pointer.baseAddress!)
}
func unsafePointer<T>(_ pointer: UnsafeBufferPointer<T>) -> UnsafePointer<T> {
	return UnsafePointer(pointer.baseAddress!)
}
func unsafeMutablePointer<T>(_ pointer: UnsafeBufferPointer<T>) -> UnsafeMutablePointer<T>  {
	return UnsafeMutablePointer(mutating: pointer.baseAddress!)
}
func unsafeRawBufferPointer<T>(_ pointer: UnsafeBufferPointer<T>) -> UnsafeRawBufferPointer {
	return UnsafeRawBufferPointer(pointer)
}
func unsafeMutableRawBufferPointer<T>(_ pointer: UnsafeBufferPointer<T>) -> UnsafeMutableRawBufferPointer {
	return UnsafeMutableRawBufferPointer(mutating: UnsafeRawBufferPointer(pointer))
}
func unsafeMutableBufferPointer<T>(_ pointer: UnsafeBufferPointer<T>) -> UnsafeMutableBufferPointer<T> {
	return UnsafeMutableBufferPointer(mutating: pointer)
}
func array<T>(_ pointer: UnsafeBufferPointer<T>) -> Array<T> {
	return Array(pointer)
}
func arraySlice<T>(_ pointer: UnsafeBufferPointer<T>) -> ArraySlice<T> {
	return ArraySlice(pointer)
}
func opaquePointer<T>(_ pointer: UnsafeBufferPointer<T>) -> OpaquePointer {
	return OpaquePointer(pointer.baseAddress!)
}

// UnsafeMutableBufferPointer<T>

func unsafeMutableBufferPointer<T>(_ array: inout [T]) -> UnsafeMutableBufferPointer<T> {
	return array.withUnsafeMutableBufferPointer { $0 }
}
func unsafeRawPointer<T>(_ pointer: UnsafeMutableBufferPointer<T>) -> UnsafeRawPointer {
	return UnsafeRawPointer(pointer.baseAddress!)
}
func unsafeMutableRawPointer<T>(_ pointer: UnsafeMutableBufferPointer<T>) -> UnsafeMutableRawPointer {
	return UnsafeMutableRawPointer(pointer.baseAddress!)
}
func unsafePointer<T>(_ pointer: UnsafeMutableBufferPointer<T>) -> UnsafePointer<T> {
	return UnsafePointer<T>(pointer.baseAddress!)
}
func unsafeMutablePointer<T>(_ pointer: UnsafeMutableBufferPointer<T>)  -> UnsafeMutablePointer<T> {
	return UnsafeMutablePointer(pointer.baseAddress!)
}
func unsafeRawBufferPointer<T>(_ pointer: UnsafeMutableBufferPointer<T>) -> UnsafeRawBufferPointer {
	return UnsafeRawBufferPointer(pointer)
}
func unsafeMutableRawBufferPointer<T>(_ pointer: UnsafeMutableBufferPointer<T>) -> UnsafeMutableRawBufferPointer {
	return UnsafeMutableRawBufferPointer(pointer)
}
func unsafeBufferPointer<T>(_ pointer: UnsafeMutableBufferPointer<T>) -> UnsafeBufferPointer<T> {
	return UnsafeBufferPointer(pointer)
}
func array<T>(_ pointer: UnsafeMutableBufferPointer<T>) -> [T] {
	return Array(pointer)
}
func arraySlice<T>(_ pointer: UnsafeMutableBufferPointer<T>) -> ArraySlice<T> {
	return ArraySlice(pointer)
}
func opaquePointer<T>(_ pointer: UnsafeMutableBufferPointer<T>) -> OpaquePointer {
	return OpaquePointer(pointer.baseAddress!)
}

// OpaquePointer

func opaquePointer<T>(_ array: [T]) -> OpaquePointer {
	return OpaquePointer(array)
}
func unsafeRawPointer(_ pointer: OpaquePointer) -> UnsafeRawPointer {
	return UnsafeRawPointer(pointer)
}
func unsafeMutableRawPointer(_ pointer: OpaquePointer) -> UnsafeMutableRawPointer {
	return UnsafeMutableRawPointer(pointer)
}
func unsafePointer<T>(_ pointer: OpaquePointer) -> UnsafePointer<T> {
	return UnsafePointer(pointer)
}
func unsafeMutablePointer<T>(_ pointer: OpaquePointer) -> UnsafeMutablePointer<T> {
	return UnsafeMutablePointer(pointer)
}




