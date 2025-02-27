import XCTest
import SwiftUI
@testable import ViewInspector

final class OptionalViewTests: XCTestCase {
    
    func testOptionalViewWhenExists() throws {
        let view = OptionalView(flag: true)
        let string = try view.inspect().hStack().text(0).string()
        XCTAssertEqual(string, "ABC")
    }
    
    func testOptionalViewWhenIsAbsent() throws {
        let view = OptionalView(flag: false)
        XCTAssertThrowsError(try view.inspect().hStack().text(0))
    }
    
    func testMixedOptionalViewWhenExists() throws {
        let view = MixedOptionalView(flag: true)
        let string1 = try view.inspect().hStack().text(0).string()
        XCTAssertEqual(string1, "ABC")
        let string2 = try view.inspect().hStack().text(1).string()
        XCTAssertEqual(string2, "XYZ")
    }
    
    func testMixedOptionalViewWhenIsAbsent() throws {
        let view = MixedOptionalView(flag: false)
        XCTAssertThrowsError(try view.inspect().hStack().text(0))
        let string = try view.inspect().hStack().text(1).string()
        XCTAssertEqual(string, "XYZ")
    }
}

private struct OptionalView: View, Inspectable {
    
    let flag: Bool
    var body: some View {
        HStack {
            if flag { Text("ABC") }
        }
    }
}

private struct MixedOptionalView: View, Inspectable {
    
    let flag: Bool
    var body: some View {
        HStack {
            if flag { Text("ABC") }
            Text("XYZ")
        }
    }
}
