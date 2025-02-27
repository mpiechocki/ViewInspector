import SwiftUI

#if os(macOS)

public extension ViewType {
    
    struct VSplitView: KnownViewType {
        public static let typePrefix: String = "VSplitView"
    }
}

public extension VSplitView {
    
    func inspect() throws -> InspectableView<ViewType.VSplitView> {
        return try InspectableView<ViewType.VSplitView>(self)
    }
}

// MARK: - Content Extraction

extension ViewType.VSplitView: MultipleViewContent {
    
    public static func content(view: Any, envObject: Any) throws -> LazyGroup<Any> {
        return try ViewType.HSplitView.content(view: view, envObject: envObject)
    }
}

// MARK: - Extraction from SingleViewContent parent

public extension InspectableView where View: SingleViewContent {
    
    func vSplitView() throws -> InspectableView<ViewType.VSplitView> {
        let content = try View.content(view: view, envObject: envObject)
        return try InspectableView<ViewType.VSplitView>(content)
    }
}

// MARK: - Extraction from MultipleViewContent parent

public extension InspectableView where View: MultipleViewContent {
    
    func vSplitView(_ index: Int) throws -> InspectableView<ViewType.VSplitView> {
        let content = try contentView(at: index)
        return try InspectableView<ViewType.VSplitView>(content)
    }
}

#endif
