import XCTest
@testable import ZKit

final class HalfTests: XCTestCase {
    
    func testInitialization() {
        let half = Half(sign: .plus, exponentBitPattern: 0x1F, significandBitPattern: 0x3FF)
        XCTAssertEqual(half.exponentBitPattern, 0x1F)
        XCTAssertEqual(half.significandBitPattern, 0x3FF)
        XCTAssertEqual(half.sign, .plus)
    }
    
    func testNegativeInitialization() {
        let half = Half(sign: .minus, exponentBitPattern: 0x1F, significandBitPattern: 0x3FF)
        XCTAssertEqual(half.exponentBitPattern, 0x1F)
        XCTAssertEqual(half.significandBitPattern, 0x3FF)
        XCTAssertEqual(half.sign, .minus)
    }
    
    func testExponentBitPattern() {
        let half = Half(sign: .plus, exponentBitPattern: 0x0A, significandBitPattern: 0x3FF)
        XCTAssertEqual(half.exponentBitPattern, 0x0A)
    }
    
    func testSignificandBitPattern() {
        let half = Half(sign: .plus, exponentBitPattern: 0x1F, significandBitPattern: 0x1AA)
        XCTAssertEqual(half.significandBitPattern, 0x1AA)
    }
    
    func testBinade() {
        let half = Half(sign: .plus, exponentBitPattern: 0x1F, significandBitPattern: 0x3FF)
        let binade = half.binade
        XCTAssertEqual(binade.exponentBitPattern, 0x1F)
        XCTAssertEqual(binade.significandBitPattern, 0x000)
    }
    
    func testSignificandWidth() {
        let half = Half(sign: .plus, exponentBitPattern: 0x0A, significandBitPattern: 0x3FF)
        XCTAssertEqual(half.significandWidth, 11) // 10 bits + 1 implicit bit
    }
}

