import XCTest
import SwiftUI
@testable import ViewInspector

final class NavigationLinkTests: XCTestCase {
    
    func testEnclosedView() throws {
        let view = NavigationLink(
            destination: Text("Screen 1")) { Text("GoTo 1") }
        let text = try view.inspect().text().string()
        XCTAssertEqual(text, "Screen 1")
    }
    
    func testLabelView() throws {
        let view = NavigationLink(
            destination: Text("Screen 1")) { Text("GoTo 1") }
        let text = try view.inspect().label().text().string()
        XCTAssertEqual(text, "GoTo 1")
    }
    
    func testExtractionFromSingleViewContainer() throws {
        let view = AnyView(NavigationLink(
            destination: Text("Screen 1")) { Text("GoTo 1") })
        XCTAssertNoThrow(try view.inspect().navigationLink())
    }
    
    func testExtractionFromMultipleViewContainer() throws {
        let view = NavigationView {
            NavigationLink(
                destination: Text("Screen 1")) { Text("GoTo 1") }
            NavigationLink(
                destination: Text("Screen 2")) { Text("GoTo 2") }
        }
        XCTAssertNoThrow(try view.inspect().navigationLink(0))
        XCTAssertNoThrow(try view.inspect().navigationLink(1))
    }
    
    func testNavigationWithoutBinding() throws {
        let view = NavigationView {
            NavigationLink(
                destination: Text("Screen 1")) { Text("GoTo 1") }
        }
        let isActive = try view.inspect().navigationLink(0).isActive()
        XCTAssertFalse(isActive)
        XCTAssertThrowsError(try view.inspect().navigationLink(0).activate())
    }
    
    func testNavigationWithBindingActivation() throws {
        let view = TestView()
        XCTAssertNil(view.state.selection)
        let isActive1 = try view.inspect().navigationView().navigationLink(0).isActive()
        let isActive2 = try view.inspect().navigationView().navigationLink(1).isActive()
        XCTAssertFalse(isActive1)
        XCTAssertFalse(isActive2)
        try view.inspect().navigationView().navigationLink(0).activate()
        XCTAssertEqual(view.state.selection, view.tag1)
        let isActiveAfter1 = try view.inspect().navigationView().navigationLink(0).isActive()
        let isActiveAfter2 = try view.inspect().navigationView().navigationLink(1).isActive()
        XCTAssertTrue(isActiveAfter1)
        XCTAssertFalse(isActiveAfter2)
    }
    
    func testNavigationWithBindingDeactivation() throws {
        let view = TestView()
        view.state.selection = view.tag2
        let isActive1 = try view.inspect().navigationView().navigationLink(0).isActive()
        let isActive2 = try view.inspect().navigationView().navigationLink(1).isActive()
        XCTAssertFalse(isActive1)
        XCTAssertTrue(isActive2)
        try view.inspect().navigationView().navigationLink(1).deactivate()
        XCTAssertNil(view.state.selection)
        let isActiveAfter1 = try view.inspect().navigationView().navigationLink(0).isActive()
        let isActiveAfter2 = try view.inspect().navigationView().navigationLink(1).isActive()
        XCTAssertFalse(isActiveAfter1)
        XCTAssertFalse(isActiveAfter2)
    }
    
    func testNavigationWithBindingReactivation() throws {
        let view = TestView()
        try view.inspect().navigationView().navigationLink(1).activate()
        XCTAssertEqual(view.state.selection, view.tag2)
        try view.inspect().navigationView().navigationLink(0).activate()
        XCTAssertEqual(view.state.selection, view.tag1)
        let isActiveAfter1 = try view.inspect().navigationView().navigationLink(0).isActive()
        let isActiveAfter2 = try view.inspect().navigationView().navigationLink(1).isActive()
        XCTAssertTrue(isActiveAfter1)
        XCTAssertFalse(isActiveAfter2)
    }
}

private struct TestView: View, Inspectable {
    @ObservedObject var state = NavigationState()
    
    var tag1: String { "tag1" }
    var tag2: String { "tag2" }
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: Text("Screen 1"), tag: tag1,
                           selection: self.$state.selection) { Text("GoTo 1") }
            NavigationLink(destination: Text("Screen 2"), tag: tag2,
                           selection: self.$state.selection) { Text("GoTo 2") }
        }
    }
}

extension TestView {
    class NavigationState: ObservableObject {
        @Published var selection: String?
    }
}
