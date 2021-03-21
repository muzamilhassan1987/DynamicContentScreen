import XCTest
@testable import UICommon

final class UICommonTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(UICommon().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
