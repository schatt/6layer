import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

// MARK: - Platform Share and Clipboard Layer 4: Component Implementation

/// Platform-agnostic helpers for sharing content and clipboard operations
/// Implements Issue #12: Add Share/Clipboard Helpers to Six-Layer Architecture (Layer 4)
public extension View {
    
    /// Unified share sheet presentation helper
    /// iOS: Uses UIActivityViewController via .sheet()
    /// macOS: Uses NSSharingServicePicker or native share sheet
    /// - Parameters:
    ///   - isPresented: Binding to control share sheet presentation
    ///   - items: Array of items to share (text, URLs, images, files)
    ///   - excludedActivityTypes: Activity types to exclude (iOS only)
    ///   - onComplete: Optional callback when sharing completes
    /// - Returns: View with share sheet modifier applied
    @ViewBuilder
    func platformShare_L4(
        isPresented: Binding<Bool>,
        items: [Any],
        #if os(iOS)
        excludedActivityTypes: [UIActivity.ActivityType]? = nil,
        #else
        excludedActivityTypes: [String]? = nil,
        #endif
        onComplete: ((Bool) -> Void)? = nil
    ) -> some View {
        #if os(iOS)
        self.sheet(isPresented: isPresented) {
            ShareSheet(
                items: items,
                excludedActivityTypes: excludedActivityTypes,
                onComplete: onComplete
            )
        }
        .automaticAccessibilityIdentifiers(named: "platformShare_L4")
        #elseif os(macOS)
        self.onChange(of: isPresented.wrappedValue) { newValue in
            if newValue {
                platformShareMacOS(items: items, onComplete: onComplete)
                // Reset binding after sharing
                DispatchQueue.main.async {
                    isPresented.wrappedValue = false
                }
            }
        }
        .automaticAccessibilityIdentifiers(named: "platformShare_L4")
        #else
        self
            .automaticAccessibilityIdentifiers(named: "platformShare_L4")
        #endif
    }
    
    #if os(macOS)
    /// macOS-specific share implementation
    private func platformShareMacOS(items: [Any], onComplete: ((Bool) -> Void)?) {
        guard let window = NSApplication.shared.keyWindow,
              let contentView = window.contentView else {
            onComplete?(false)
            return
        }
        
        let sharingServicePicker = NSSharingServicePicker(items: items)
        let rect = NSRect(x: contentView.bounds.midX, y: contentView.bounds.midY, width: 0, height: 0)
        sharingServicePicker.show(relativeTo: rect, of: contentView, preferredEdge: .minY)
        onComplete?(true)
    }
    #endif
}

// MARK: - Share Sheet (iOS)

#if os(iOS)
/// iOS share sheet wrapper
private struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    let excludedActivityTypes: [UIActivity.ActivityType]?
    let onComplete: ((Bool) -> Void)?
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        if let excludedActivityTypes = excludedActivityTypes {
            controller.excludedActivityTypes = excludedActivityTypes
        }
        controller.completionWithItemsHandler = { _, completed, _, _ in
            onComplete?(completed)
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No updates needed
    }
}
#endif

// MARK: - Clipboard Helpers

/// Platform-agnostic clipboard operations
public enum PlatformClipboard {
    
    /// Copy text to clipboard
    /// - Parameter text: Text to copy
    /// - Returns: Success status
    @MainActor
    public static func copyToClipboard(_ text: String) -> Bool {
        #if os(iOS)
        UIPasteboard.general.string = text
        return UIPasteboard.general.string == text
        #elseif os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        return pasteboard.setString(text, forType: .string)
        #else
        return false
        #endif
    }
    
    /// Copy image to clipboard
    /// - Parameter image: Image to copy
    /// - Returns: Success status
    @MainActor
    public static func copyToClipboard(_ image: ClipboardImage) -> Bool {
        #if os(iOS)
        UIPasteboard.general.image = image
        return UIPasteboard.general.image != nil
        #elseif os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        if let tiffData = image.tiffRepresentation {
            return pasteboard.setData(tiffData, forType: .tiff)
        }
        return false
        #else
        return false
        #endif
    }
    
    /// Copy URL to clipboard
    /// - Parameter url: URL to copy
    /// - Returns: Success status
    @MainActor
    public static func copyToClipboard(_ url: URL) -> Bool {
        return copyToClipboard(url.absoluteString)
    }
    
    /// Get text from clipboard
    /// - Returns: Text from clipboard, or nil if unavailable
    @MainActor
    public static func getTextFromClipboard() -> String? {
        #if os(iOS)
        return UIPasteboard.general.string
        #elseif os(macOS)
        return NSPasteboard.general.string(forType: .string)
        #else
        return nil
        #endif
    }
}

#if os(iOS)
public typealias ClipboardImage = UIImage
#elseif os(macOS)
public typealias ClipboardImage = NSImage
#else
public typealias ClipboardImage = Any
#endif

/// Unified clipboard copy operation helper
/// - Parameters:
///   - content: Content to copy (text, image, or URL)
///   - provideFeedback: Whether to provide haptic/visual feedback (default: true)
/// - Returns: Success status
@MainActor
public func platformCopyToClipboard_L4(
    content: Any,
    provideFeedback: Bool = true
) -> Bool {
    let success: Bool
    
    if let text = content as? String {
        success = PlatformClipboard.copyToClipboard(text)
    } else if let url = content as? URL {
        success = PlatformClipboard.copyToClipboard(url)
    } else if let image = content as? ClipboardImage {
        success = PlatformClipboard.copyToClipboard(image)
    } else {
        // Try to convert to string
        success = PlatformClipboard.copyToClipboard(String(describing: content))
    }
    
    #if os(iOS)
    if success && provideFeedback {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    #endif
    
    return success
}

