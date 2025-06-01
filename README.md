# ZKit

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%20|%20macOS%20|%20tvOS%20|%20watchOS%20|%20visionOS-blue.svg)
![Swift Package Manager](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

A comprehensive Swift utility library providing extensions and helpers for common programming tasks.

## Features

- 🚀 **High Performance**: Optimized algorithms for common operations
- 🔧 **Cross-Platform**: Unified API across all Apple platforms
- 📦 **Swift 6 Ready**: Full concurrency support with Sendable conformance
- 🧪 **Well Tested**: Comprehensive test coverage including Float16 compatibility
- 📖 **Type-Safe**: Strong typing with modern Swift features
- 🎯 **Zero Dependencies**: Pure Swift implementation

## Installation

### Swift Package Manager

Add ZKit to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/ZKit.git", from: "1.0.0")
]
```

Or in Xcode:
1. File → Add Package Dependencies...
2. Enter the repository URL
3. Click "Add Package"

## Quick Start

```swift
import ZKit

// Array extensions - Remove duplicates efficiently
let numbers = [1, 2, 3, 2, 4, 3, 5]
let unique = numbers.removingDuplicates() // [1, 2, 3, 4, 5]

// Thread-safe queue
let queue = ZQueue<String>()
queue.enqueue("Hello")
queue.enqueue("World")
print(queue.dequeue()) // Optional("Hello")

// Weak object collections
let weakSet = ZWeakObjectSet<MyViewController>()
weakSet.addObject(viewController) // Won't retain the object

// Half-precision floating point (Float16 compatible)
let half = Half(3.14159)
let float = Float(half)

// Cross-platform UI code
let color = XColor.red // UIColor on iOS, NSColor on macOS
let view = XView()     // UIView on iOS, NSView on macOS

// Error handling with context
throw ZError("Network error", "Timeout occurred")
```

## Core Components

### Collection Extensions

- **Array**: `removingDuplicates()`, `rearrange()`, `chunked()`, and more
- **Set**: Additional operators and convenience methods
- **ZQueue**: Thread-safe FIFO queue implementation
- **ZWeakObjectSet**: Collection holding weak references

### Data Types

- **Half**: IEEE 754 half-precision floating-point (Float16 compatible)
- **ZBuffer**: Efficient data buffer implementation
- **DataRepresentable**: Protocol for data serialization
- **Serializer/Unserializer**: Binary serialization utilities

### Cross-Platform UI

- **XView**, **XViewController**, **XColor**, **XFont**: Unified types across platforms
- **AutoViewUpdate**: Automatic view updates with Combine
- **Configurable Views**: Declarative view configuration

### Utilities

- **String Extensions**: Path operations, trimming, line processing
- **URL Extensions**: Enhanced file URL handling
- **Date Extensions**: Calendar date operations
- **Threading**: Modern async/await helpers

### Error Handling

- **ZError**: Enhanced error type with file/line information

## Platform Requirements

- **Swift**: 5.9+
- **iOS**: 13.0+
- **macOS**: 10.15+
- **tvOS**: 13.0+
- **watchOS**: 6.0+
- **visionOS**: 1.0+

## Migration Guide

### From Deprecated APIs

```swift
// Old (deprecated)
let path = "/Users/john".appendingPathComponent("Documents")

// New (recommended)
let path = "/Users/john".urlAppendingPathComponent("Documents")
// or
let url = URL(fileURLWithPath: "/Users/john")
    .appendingPathComponent("Documents").path
```

### Swift 6 Concurrency

```swift
// Old
OperationQueue.executeOnMain {
    updateUI()
}

// New
Task { @MainActor in
    updateUI()
}
```

## Documentation

Comprehensive documentation with examples is available through Xcode's documentation browser or can be generated using:

```bash
swift package generate-documentation
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

ZKit is available under the MIT license. See the LICENSE file for more info.

## Author

Kaz Yoshikawa - Electricwoods LLC

## Acknowledgments

This library includes utilities developed over years of iOS/macOS development, now consolidated and modernized for Swift 6 and beyond.
