import XCTest
import SwiftUI
@testable import ViewInspector

final class EquatableViewTests: XCTestCase {
    
    func testEnclosedView() throws {
        let sampleView = Text("Test")
        let view = EquatableView(content: sampleView)
        let sut = try view.inspect().text().view as? Text
        XCTAssertEqual(sut, sampleView)
    }
    
    func testExtractionFromSingleViewContainer() throws {
        let view = AnyView(EquatableView(content: Text("")))
        XCTAssertNoThrow(try view.inspect().equatableView())
    }
    
    func testExtractionFromMultipleViewContainer() throws {
        let view = HStack {
            EquatableView(content: Text(""))
            EquatableView(content: Text(""))
        }
        XCTAssertNoThrow(try view.inspect().equatableView(0))
        XCTAssertNoThrow(try view.inspect().equatableView(1))
    }
}
