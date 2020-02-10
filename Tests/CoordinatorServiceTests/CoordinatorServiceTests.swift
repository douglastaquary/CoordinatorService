import XCTest
@testable import CoordinatorService

final class CoordinatorServiceTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CoordinatorService().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
