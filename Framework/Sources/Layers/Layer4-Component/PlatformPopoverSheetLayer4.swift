import SwiftUI

// MARK: - Platform Popover and Sheet Layer 4: Component Implementation

/// Platform-agnostic helpers for popover and sheet presentation
/// Implements Issue #11: Add Popover/Sheet Helpers to Six-Layer Architecture (Layer 4)
public extension View {
    
    /// Unified popover presentation helper
    /// iOS: Uses `.popover()` modifier
    /// macOS: Uses `.popover()` modifier with platform-specific positioning
    /// - Parameters:
    ///   - isPresented: Binding to control popover presentation
    ///   - attachmentAnchor: Point where popover attaches (default: .point(.center))
    ///   - arrowEdge: Edge where arrow appears (default: .top)
    ///   - content: View builder for popover content
    /// - Returns: View with popover modifier applied
    @ViewBuilder
    func platformPopover_L4<Content: View>(
        isPresented: Binding<Bool>,
        attachmentAnchor: PopoverAttachmentAnchor = .point(.center),
        arrowEdge: Edge = .top,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        #if os(iOS)
        self.popover(
            isPresented: isPresented,
            attachmentAnchor: attachmentAnchor,
            arrowEdge: arrowEdge,
            content: content
        )
        .automaticAccessibilityIdentifiers(named: "platformPopover_L4")
        #elseif os(macOS)
        self.popover(
            isPresented: isPresented,
            attachmentAnchor: attachmentAnchor,
            arrowEdge: arrowEdge,
            content: content
        )
        .automaticAccessibilityIdentifiers(named: "platformPopover_L4")
        #else
        self.popover(
            isPresented: isPresented,
            attachmentAnchor: attachmentAnchor,
            arrowEdge: arrowEdge,
            content: content
        )
        .automaticAccessibilityIdentifiers(named: "platformPopover_L4")
        #endif
    }
    
    /// Unified sheet presentation helper
    /// iOS: Uses `.sheet()` with full-screen or half-sheet based on content
    /// macOS: Uses `.sheet()` with appropriate sizing
    /// - Parameters:
    ///   - isPresented: Binding to control sheet presentation
    ///   - onDismiss: Optional callback when sheet is dismissed
    ///   - detents: Presentation detents for iOS (default: [.large])
    ///   - dragIndicator: Whether to show drag indicator (iOS only)
    ///   - content: View builder for sheet content
    /// - Returns: View with sheet modifier applied
    @ViewBuilder
    func platformSheet_L4<Content: View>(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        detents: Set<PresentationDetent> = [.large],
        dragIndicator: Visibility = .automatic,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        #if os(iOS)
        if #available(iOS 16.0, *) {
            self.sheet(isPresented: isPresented, onDismiss: onDismiss) {
                content()
                    .presentationDetents(detents)
                    .presentationDragIndicator(dragIndicator)
            }
            .automaticAccessibilityIdentifiers(named: "platformSheet_L4")
        } else {
            self.sheet(isPresented: isPresented, onDismiss: onDismiss, content: content)
                .automaticAccessibilityIdentifiers(named: "platformSheet_L4")
        }
        #elseif os(macOS)
        self.sheet(isPresented: isPresented, onDismiss: onDismiss) {
            content()
                .frame(minWidth: 400, minHeight: 300)
        }
        .automaticAccessibilityIdentifiers(named: "platformSheet_L4")
        #else
        self.sheet(isPresented: isPresented, onDismiss: onDismiss, content: content)
            .automaticAccessibilityIdentifiers(named: "platformSheet_L4")
        #endif
    }
    
    /// Unified sheet presentation with item-based binding
    /// - Parameters:
    ///   - item: Optional item binding for sheet presentation
    ///   - onDismiss: Optional callback when sheet is dismissed
    ///   - detents: Presentation detents for iOS (default: [.large])
    ///   - dragIndicator: Whether to show drag indicator (iOS only)
    ///   - content: View builder for sheet content
    /// - Returns: View with sheet modifier applied
    @ViewBuilder
    func platformSheet_L4<Item: Identifiable, Content: View>(
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        detents: Set<PresentationDetent> = [.large],
        dragIndicator: Visibility = .automatic,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        #if os(iOS)
        if #available(iOS 16.0, *) {
            self.sheet(item: item, onDismiss: onDismiss) { item in
                content(item)
                    .presentationDetents(detents)
                    .presentationDragIndicator(dragIndicator)
            }
            .automaticAccessibilityIdentifiers(named: "platformSheet_L4")
        } else {
            self.sheet(item: item, onDismiss: onDismiss, content: content)
                .automaticAccessibilityIdentifiers(named: "platformSheet_L4")
        }
        #elseif os(macOS)
        self.sheet(item: item, onDismiss: onDismiss) { item in
            content(item)
                .frame(minWidth: 400, minHeight: 300)
        }
        .automaticAccessibilityIdentifiers(named: "platformSheet_L4")
        #else
        self.sheet(item: item, onDismiss: onDismiss, content: content)
            .automaticAccessibilityIdentifiers(named: "platformSheet_L4")
        #endif
    }
}

