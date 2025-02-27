import SwiftUI

public extension ViewType {
    
    struct VStack: KnownViewType {
        public static let typePrefix: String = "VStack"
    }
}

public extension VStack {
    
    func inspect() throws -> InspectableView<ViewType.VStack> {
        return try InspectableView<ViewType.VStack>(self)
    }
}

// MARK: - Content Extraction

extension ViewType.VStack: MultipleViewContent {
    
    public static func content(view: Any, envObject: Any) throws -> LazyGroup<Any> {
        return try ViewType.HStack.content(view: view, envObject: envObject)
    }
}

// MARK: - Extraction from SingleViewContent parent

public extension InspectableView where View: SingleViewContent {
    
    func vStack() throws -> InspectableView<ViewType.VStack> {
        let content = try View.content(view: view, envObject: envObject)
        return try InspectableView<ViewType.VStack>(content)
    }
}

// MARK: - Extraction from MultipleViewContent parent

public extension InspectableView where View: MultipleViewContent {
    
    func vStack(_ index: Int) throws -> InspectableView<ViewType.VStack> {
        let content = try contentView(at: index)
        return try InspectableView<ViewType.VStack>(content)
    }
}
