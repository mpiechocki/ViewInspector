import XCTest
import SwiftUI
@testable import ViewInspector

final class ToggleTests: XCTestCase {
    
    @State var isOn1 = false
    @State var isOn2 = false
    
    override func setUp() {
        isOn1 = false
        isOn2 = false
    }
    
    func testEnclosedView() throws {
        let view = Toggle(isOn: $isOn1) { Text("Test") }
        let text = try view.inspect().text().string()
        XCTAssertEqual(text, "Test")
    }
    
    func testExtractionFromSingleViewContainer() throws {
        let view = AnyView(Toggle(isOn: $isOn1) { Text("Test") })
        XCTAssertNoThrow(try view.inspect().toggle())
    }
    
    func testExtractionFromMultipleViewContainer() throws {
        let view = HStack {
            Toggle(isOn: $isOn1) { Text("Test") }
            Toggle(isOn: $isOn2) { Text("Test") }
        }
        XCTAssertNoThrow(try view.inspect().toggle(0))
        XCTAssertNoThrow(try view.inspect().toggle(1))
    }
}
