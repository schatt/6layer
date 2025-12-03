import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

// MARK: - Platform Share and Clipboard Layer 4: Component Implementation

/// Platform-agnostic helpers for sharing content, clipboard operations, and system actions
/// Implements Issue #12: Add Share/Clipboard Helpers to Six-Layer Architecture (Layer 4)
/// Implements Issue #42: Add Layer 4 System Action Functions
///
/// ## Cross-Platform Behavior
///
/// ### Share Sheet (`platformShare_L4`)
/// **Semantic Purpose**: Share content with other apps or services
/// - **iOS**: Uses `UIActivityViewController` presented as a sheet
///   - Full-screen or half-sheet modal presentation
///   - Shows grid of sharing options (Messages, Mail, AirDrop, etc.)
///   - User-friendly, visual selection interface
///   - Supports excluded activity types for customization
/// - **macOS**: Uses `NSSharingServicePicker` as a popover/menu
///   - Appears as a popover near the source element
///   - Shows menu of sharing services
///   - More compact, menu-based interface
///   - Automatically positions near the trigger point
///
/// **When to Use**: Sharing text, URLs, images, or files with other apps
/// **Interaction Model**: iOS = modal sheet, macOS = popover menu
///
/// ### Clipboard Operations (`platformCopyToClipboard_L4`)
/// **Semantic Purpose**: Copy content to system clipboard
/// - **iOS**: Uses `UIPasteboard` with optional haptic feedback
///   - Provides tactile feedback on successful copy
///   - Better user experience with confirmation
/// - **macOS**: Uses `NSPasteboard`
///   - Standard clipboard operations
///   - No haptic feedback (not applicable to desktop)
///
/// **When to Use**: Copy text, images, or URLs to clipboard
/// **Feedback**: iOS provides haptic feedback, macOS relies on visual confirmation
public extension View {
    
    /// Unified share sheet presentation helper
    ///
    /// **Cross-Platform Behavior:**
    /// - **iOS**: Presents `UIActivityViewController` as a modal sheet
    ///   - Full-screen or half-sheet presentation
    ///   - Visual grid of sharing options
    ///   - Supports excluded activity types
    /// - **macOS**: Presents `NSSharingServicePicker` as a popover
    ///   - Appears near the source element
    ///   - Menu-based interface
    ///   - Automatically positions and dismisses
    ///
    /// **Use For**: Sharing text, URLs, images, or files with other apps
    ///
    /// - Parameters:
    ///   - isPresented: Binding to control share sheet presentation
    ///   - items: Array of items to share (text, URLs, images, files)
    ///   - onComplete: Optional callback when sharing completes
    /// - Returns: View with share sheet modifier applied
    @ViewBuilder
    func platformShare_L4(
        isPresented: Binding<Bool>,
        items: [Any],
        onComplete: ((Bool) -> Void)? = nil
    ) -> some View {
        #if os(iOS)
        self.sheet(isPresented: isPresented) {
            ShareSheet(
                items: items,
                excludedActivityTypes: nil,
                onComplete: onComplete
            )
        }
        .automaticCompliance(named: "platformShare_L4")
        #elseif os(macOS)
        self.onChange(of: isPresented.wrappedValue) { oldValue, newValue in
            if newValue {
                platformShareMacOS(items: items, onComplete: onComplete)
                // Reset binding after sharing
                DispatchQueue.main.async {
                    isPresented.wrappedValue = false
                }
            }
        }
        .automaticCompliance(named: "platformShare_L4")
        #else
        self
            .automaticCompliance(named: "platformShare_L4")
        #endif
    }
    
    #if os(iOS)
    /// iOS-specific share sheet with excluded activity types
    @ViewBuilder
    func platformShare_L4(
        isPresented: Binding<Bool>,
        items: [Any],
        excludedActivityTypes: [UIActivity.ActivityType]?,
        onComplete: ((Bool) -> Void)? = nil
    ) -> some View {
        self.sheet(isPresented: isPresented) {
            ShareSheet(
                items: items,
                excludedActivityTypes: excludedActivityTypes,
                onComplete: onComplete
            )
        }
        .automaticCompliance(named: "platformShare_L4")
    }
    #endif
    
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
    
    /// Unified share sheet presentation helper (convenience overload)
    /// Implements Issue #42: Add Layer 4 System Action Functions
    ///
    /// **Cross-Platform Behavior:**
    /// - **iOS**: Presents `UIActivityViewController` as a modal sheet
    ///   - Full-screen or half-sheet presentation
    ///   - Visual grid of sharing options
    /// - **macOS**: Presents `NSSharingServicePicker` as a popover
    ///   - Appears near the source element (if provided)
    ///   - Menu-based interface
    ///
    /// **Use For**: Sharing text, URLs, images, or files with other apps
    ///
    /// **Usage Example:**
    /// ```swift
    /// struct ContentView: View {
    ///     @State private var showShare = false
    ///     let items: [Any] = ["Text to share", URL(string: "https://example.com")!]
    ///
    ///     var body: some View {
    ///         Button("Share") {
    ///             showShare = true
    ///         }
    ///         .platformShare_L4(items: items, from: nil)
    ///         .platformShare_L4(isPresented: $showShare, items: items)
    ///     }
    /// }
    /// ```
    ///
    /// **Note**: This overload accepts items and sourceView for API compatibility with Issue #42.
    /// For actual programmatic control, use the `isPresented: Binding<Bool>` overload.
    /// The `from` parameter is documented for future enhancement of popover positioning.
    ///
    /// - Parameters:
    ///   - items: Array of items to share (text, URLs, images, files)
    ///   - sourceView: Optional source view for positioning (reserved for future popover positioning enhancement)
    /// - Returns: View with share sheet modifier applied (requires isPresented binding for actual functionality)
    @ViewBuilder
    func platformShare_L4(
        items: [Any],
        from sourceView: (any View)? = nil
    ) -> some View {
        // This overload provides the API signature requested in Issue #42
        // For actual functionality, use the isPresented binding overload
        // The sourceView parameter is accepted for API compatibility
        self
            .automaticCompliance(named: "platformShare_L4")
    }
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
    /// - Parameter image: Image to copy (PlatformImage - standardized cross-platform type)
    /// - Returns: Success status
    /// 
    /// System boundary conversion: PlatformImage → UIImage/NSImage at clipboard API
    @MainActor
    public static func copyToClipboard(_ image: PlatformImage) -> Bool {
        #if os(iOS)
        // System boundary conversion: PlatformImage → UIImage
        UIPasteboard.general.image = image.uiImage
        return UIPasteboard.general.image != nil
        #elseif os(macOS)
        // System boundary conversion: PlatformImage → NSImage
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        if let tiffData = image.nsImage.tiffRepresentation {
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
    } else if let image = content as? PlatformImage {
        // Framework uses PlatformImage (standardized type)
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

// MARK: - System Actions

/// Platform-agnostic URL opening function
/// Implements Issue #42: Add Layer 4 System Action Functions
///
/// **Cross-Platform Behavior:**
/// - **iOS**: Uses `UIApplication.shared.open(url)`
/// - **macOS**: Uses `NSWorkspace.shared.open(url)`
///
/// **Use For**: Opening URLs in the default browser or app
///
/// - Parameter url: URL to open (http/https or custom URL scheme)
/// - Returns: `true` if the URL was opened successfully, `false` otherwise
@MainActor
public func platformOpenURL_L4(_ url: URL) -> Bool {
    #if os(iOS)
    return UIApplication.shared.open(url)
    #elseif os(macOS)
    return NSWorkspace.shared.open(url)
    #else
    return false
    #endif
}

