import XCTest
@testable import ZKit

@available(iOS 14.0, macOS 11.0, *)
final class HalfTests: XCTestCase {
	
	// MARK: - Basic Value Comparisons
	
	func testBasicValues() {
		let testValues: [Float] = [
			0.0, -0.0, 1.0, -1.0, 2.0, -2.0, 0.5, -0.5,
			0.25, -0.25, 0.125, -0.125, 3.0, -3.0, 4.0, -4.0,
			0.1, -0.1, 0.01, -0.01, 0.001, -0.001,
			10.0, -10.0, 100.0, -100.0, 1000.0, -1000.0,
			3.14159, -3.14159, 2.71828, -2.71828
		]
		
		for value in testValues {
			let half = Half(value)
			let float16 = Float16(value)
			
			// Compare raw bit patterns
			XCTAssertEqual(half.rawValue, float16.bitPattern,
						   "Bit pattern mismatch for \(value)")
			
			// Compare converted back to Float
			XCTAssertEqual(Float(half), Float(float16), accuracy: 0.0001,
						   "Float conversion mismatch for \(value)")
		}
	}
	
	// MARK: - Special Values
	
	func testSpecialValues() {
		// Positive infinity
		XCTAssertEqual(Half.infinity.rawValue, Float16.infinity.bitPattern)
		XCTAssertTrue(Half.infinity.isInfinite)
		XCTAssertEqual(Float(Half.infinity), Float.infinity)
		
		// Negative infinity
		let negInf = Half(rawValue: 0xFC00)
		let negInf16 = -Float16.infinity
		XCTAssertEqual(negInf.rawValue, negInf16.bitPattern)
		XCTAssertTrue(negInf.isInfinite)
		
		// NaN
		XCTAssertEqual(Half.nan.rawValue, Float16.nan.bitPattern)
		XCTAssertTrue(Half.nan.isNaN)
		
		// Signaling NaN
		XCTAssertEqual(Half.signalingNaN.rawValue, Float16.signalingNaN.bitPattern)
		XCTAssertTrue(Half.signalingNaN.isSignalingNaN)
		
		// Zero
		let zero = Half(0.0)
		let zero16 = Float16(0.0)
		XCTAssertEqual(zero.rawValue, zero16.bitPattern)
		XCTAssertTrue(zero.isZero)
		
		// Negative zero
		let negZero = Half(rawValue: 0x8000)
		let negZero16 = -Float16(0.0)
		XCTAssertEqual(negZero.rawValue, negZero16.bitPattern)
		XCTAssertTrue(negZero.isZero)
	}
	
	// MARK: - Limits
	
	func testLimits() {
		// Greatest finite magnitude
		XCTAssertEqual(Half.greatestFiniteMagnitude.rawValue,
					   Float16.greatestFiniteMagnitude.bitPattern)
		
		// Least normal magnitude
		XCTAssertEqual(Half.leastNormalMagnitude.rawValue,
					   Float16.leastNormalMagnitude.bitPattern)
		
		// Least nonzero magnitude
		XCTAssertEqual(Half.leastNonzeroMagnitude.rawValue,
					   Float16.leastNonzeroMagnitude.bitPattern)
		
		// Pi
		XCTAssertEqual(Half.pi.rawValue, Float16.pi.bitPattern)
	}
	
	// MARK: - Arithmetic Operations
	
	func testArithmetic() {
		let pairs: [(Float, Float)] = [
			(1.0, 2.0), (0.5, 0.25), (3.0, 4.0),
			(10.0, 5.0), (100.0, 50.0), (-1.0, 2.0),
			(0.1, 0.2), (0.01, 0.03)
		]
		
		for (a, b) in pairs {
			let halfA = Half(a)
			let halfB = Half(b)
			let float16A = Float16(a)
			let float16B = Float16(b)
			
			// Addition
			let halfSum = halfA + halfB
			let float16Sum = float16A + float16B
			XCTAssertEqual(halfSum.rawValue, float16Sum.bitPattern,
						   "Addition mismatch for \(a) + \(b)")
			
			// Subtraction
			let halfDiff = halfA - halfB
			let float16Diff = float16A - float16B
			XCTAssertEqual(halfDiff.rawValue, float16Diff.bitPattern,
						   "Subtraction mismatch for \(a) - \(b)")
			
			// Multiplication
			let halfProd = halfA * halfB
			let float16Prod = float16A * float16B
			XCTAssertEqual(halfProd.rawValue, float16Prod.bitPattern,
						   "Multiplication mismatch for \(a) * \(b)")
			
			// Division (skip if b is zero)
			if b != 0 {
				let halfQuot = halfA / halfB
				let float16Quot = float16A / float16B
				XCTAssertEqual(halfQuot.rawValue, float16Quot.bitPattern,
							   "Division mismatch for \(a) / \(b)")
			}
		}
	}
	
	// MARK: - Comparison Operations
	
	func testComparisons() {
		let values: [Float] = [0.0, 1.0, -1.0, 2.0, -2.0, Float.infinity, -Float.infinity, Float.nan]
		
		for i in 0..<values.count {
			for j in 0..<values.count {
				let halfA = Half(values[i])
				let halfB = Half(values[j])
				let float16A = Float16(values[i])
				let float16B = Float16(values[j])
				
				// isEqual
				XCTAssertEqual(halfA.isEqual(to: halfB),
							   float16A.isEqual(to: float16B),
							   "isEqual mismatch for \(values[i]) == \(values[j])")
				
				// isLess
				XCTAssertEqual(halfA.isLess(than: halfB),
							   float16A.isLess(than: float16B),
							   "isLess mismatch for \(values[i]) < \(values[j])")
				
				// isLessThanOrEqualTo
				XCTAssertEqual(halfA.isLessThanOrEqualTo(halfB),
							   float16A.isLessThanOrEqualTo(float16B),
							   "isLessThanOrEqualTo mismatch for \(values[i]) <= \(values[j])")
			}
		}
	}
	
	// MARK: - Properties
	
	func testProperties() {
		let testCases: [(Float, String)] = [
			(0.0, "zero"),
			(-0.0, "negative zero"),
			(1.0, "one"),
			(0.5, "half"),
			(0.000061, "smallest subnormal"),
			(Float.infinity, "infinity"),
			(-Float.infinity, "negative infinity"),
			(Float.nan, "NaN"),
			(65504.0, "max finite")
		]
		
		for (value, description) in testCases {
			let half = Half(value)
			let float16 = Float16(value)
			
			XCTAssertEqual(half.isNormal, float16.isNormal,
						   "isNormal mismatch for \(description)")
			XCTAssertEqual(half.isFinite, float16.isFinite,
						   "isFinite mismatch for \(description)")
			XCTAssertEqual(half.isZero, float16.isZero,
						   "isZero mismatch for \(description)")
			XCTAssertEqual(half.isSubnormal, float16.isSubnormal,
						   "isSubnormal mismatch for \(description)")
			XCTAssertEqual(half.isInfinite, float16.isInfinite,
						   "isInfinite mismatch for \(description)")
			XCTAssertEqual(half.isNaN, float16.isNaN,
						   "isNaN mismatch for \(description)")
			XCTAssertEqual(half.isSignalingNaN, float16.isSignalingNaN,
						   "isSignalingNaN mismatch for \(description)")
			XCTAssertEqual(half.isCanonical, float16.isCanonical,
						   "isCanonical mismatch for \(description)")
		}
	}
	
	// MARK: - Exponent and Significand
	
	func testExponentAndSignificand() {
		let values: [Float] = [
			1.0, 2.0, 0.5, 0.25, 3.0, 1.5,
			0.000061035, // smallest positive subnormal
			0.00006104, // largest subnormal
			0.00006103515625, // smallest normal
			65504.0, // largest finite
			Float.infinity,
			0.0
		]
		
		for value in values {
			let half = Half(value)
			let float16 = Float16(value)
			
			XCTAssertEqual(half.exponent, float16.exponent,
						   "Exponent mismatch for \(value)")
			
			// For significand, we need to compare the bit patterns since
			// the significand is also a Half/Float16
			let halfSig = half.significand
			let float16Sig = float16.significand
			XCTAssertEqual(halfSig.rawValue, float16Sig.bitPattern,
						   "Significand mismatch for \(value)")
		}
	}
	
	// MARK: - Sign
	
	func testSign() {
		let testCases: [(Float, FloatingPointSign)] = [
			(1.0, .plus),
			(-1.0, .minus),
			(0.0, .plus),
			(-0.0, .minus),
			(Float.infinity, .plus),
			(-Float.infinity, .minus)
		]
		
		for (value, expectedSign) in testCases {
			let half = Half(value)
			let float16 = Float16(value)
			
			XCTAssertEqual(half.sign, float16.sign,
						   "Sign mismatch for \(value)")
			XCTAssertEqual(half.sign, expectedSign,
						   "Unexpected sign for \(value)")
		}
	}
	
	// MARK: - NextUp
	
	func testNextUp() {
		let values: [Float] = [
			0.0, -0.0, 1.0, -1.0,
			0.000061035, // smallest positive subnormal
			-0.000061035, // smallest negative subnormal
			65504.0, // largest finite
			-65504.0,
			Float.infinity,
			-Float.infinity
		]
		
		for value in values {
			let half = Half(value)
			let float16 = Float16(value)
			
			let halfNext = half.nextUp
			let float16Next = float16.nextUp
			
			XCTAssertEqual(halfNext.rawValue, float16Next.bitPattern,
						   "nextUp mismatch for \(value)")
		}
	}
	
	// MARK: - Magnitude
	
	func testMagnitude() {
		let values: [Float] = [0.0, -0.0, 1.0, -1.0, 100.0, -100.0,
							   Float.infinity, -Float.infinity]
		
		for value in values {
			let half = Half(value)
			let float16 = Float16(value)
			
			let halfMag = half.magnitude
			let float16Mag = float16.magnitude
			
			XCTAssertEqual(halfMag.rawValue, float16Mag.bitPattern,
						   "Magnitude mismatch for \(value)")
		}
	}
	
	// MARK: - ULP
	
	func testULP() {
		let values: [Float] = [1.0, 2.0, 0.5, 100.0, 0.001]
		
		for value in values {
			let half = Half(value)
			let float16 = Float16(value)
			
			let halfULP = half.ulp
			let float16ULP = float16.ulp
			
			// ULP comparison might have small differences due to rounding
			XCTAssertEqual(Float(halfULP), Float(float16ULP), accuracy: 0.0001,
						   "ULP mismatch for \(value)")
		}
	}
	
	// MARK: - Batch Conversions
	
	func testBatchConversions() {
		let floatArray: [Float] = [0.0, 1.0, -1.0, 2.0, -2.0, 0.5, -0.5,
								   Float.infinity, -Float.infinity, Float.nan]
		
		// Test floats to halves
		let halves = Half.floats_to_halves(values: floatArray)
		for (index, value) in floatArray.enumerated() {
			let expected = Float16(value)
			XCTAssertEqual(halves[index].rawValue, expected.bitPattern,
						   "Batch conversion mismatch at index \(index)")
		}
		
		// Test halves to floats
		let floatsBack = Half.halves_to_floats(values: halves)
		for (index, value) in floatsBack.enumerated() {
			let expected = Float(Float16(floatArray[index]))
			if expected.isNaN {
				XCTAssertTrue(value.isNaN, "Expected NaN at index \(index)")
			} else {
				XCTAssertEqual(value, expected, accuracy: 0.0001,
							   "Batch back-conversion mismatch at index \(index)")
			}
		}
	}
	
	// MARK: - Edge Cases
	
	func testEdgeCases() {
		// Test all bit patterns from 0x0000 to 0x0400 (covers zero, subnormals, and smallest normal)
		for bitPattern in UInt16(0x0000)...UInt16(0x0400) {
			let half = Half(rawValue: bitPattern)
			let float16 = Float16(bitPattern: bitPattern)
			
			XCTAssertEqual(Float(half), Float(float16), accuracy: 0.0000001,
						   "Conversion mismatch for bit pattern 0x\(String(bitPattern, radix: 16))")
		}
		
		// Test boundary values around infinity
		for bitPattern in UInt16(0x7BFF)...UInt16(0x7C01) {
			let half = Half(rawValue: bitPattern)
			let float16 = Float16(bitPattern: bitPattern)
			
			if float16.isNaN {
				XCTAssertTrue(half.isNaN, "Expected NaN for bit pattern 0x\(String(bitPattern, radix: 16))")
			} else if float16.isInfinite {
				XCTAssertTrue(half.isInfinite, "Expected infinity for bit pattern 0x\(String(bitPattern, radix: 16))")
			} else {
				XCTAssertEqual(Float(half), Float(float16), accuracy: 0.1,
							   "Conversion mismatch for bit pattern 0x\(String(bitPattern, radix: 16))")
			}
		}
	}
	
	// MARK: - Performance
	
	func testConversionPerformance() {
		let testArray = (0..<10000).map { Float($0) * 0.1 }
		
		measure {
			_ = Half.floats_to_halves(values: testArray)
		}
	}
}
