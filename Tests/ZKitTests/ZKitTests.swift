import XCTest
@testable import ZKit

final class ZKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ZKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
