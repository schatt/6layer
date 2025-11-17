import Foundation
import SwiftUI

#if os(macOS)
import AppKit

/// macOS-specific window detection - Convenience wrapper
/// Provides macOS-specific enhancements over the base UnifiedWindowDetection
@MainActor
public class macOSWindowDetection: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published public var windowSize: CGSize = CGSize(width: 1024, height: 768)
    @Published public var screenSize: CGSize = CGSize(width: 1024, height: 768)
    @Published public var windowFrame: CGRect = CGRect(x: 0, y: 0, width: 1024, height: 768)
    @Published public var screenSizeClass: ScreenSizeClass = .large
    @Published public var windowState: UnifiedWindowDetection.WindowState = .standard
    @Published public var deviceContext: DeviceContext = .standard
    @Published public var isResizing: Bool = false
    @Published public var safeAreaInsets: EdgeInsets = EdgeInsets()
    @Published public var orientation: DeviceOrientation = .landscape
    
    // MARK: - Initialization
    
    public init() {
        // Lightweight initialization - use default values
        // Don't access NSApplication.shared in init() to avoid blocking
        // Call updateWindowInfo() explicitly when you need actual window data
    }
    
    // MARK: - Convenience Methods
    
    public func startMonitoring() {
        // macOS-specific: Could add NSWindow notifications here if needed
        // For now, just update from current window
        updateFromCurrentWindow()
    }
    
    public func stopMonitoring() {
        // macOS-specific: Could remove NSWindow notifications here if added
    }
    
    public func updateWindowInfo() {
        updateFromCurrentWindow()
    }
    
    // MARK: - Private Methods
    
    private func updateFromCurrentWindow() {
        // macOS-specific: Get current window info
        // This is where we could enhance with platform-specific features later
        if let window = NSApplication.shared.keyWindow {
            windowFrame = window.frame
            windowSize = window.frame.size
            screenSize = NSScreen.main?.frame.size ?? CGSize(width: 1024, height: 768)
            screenSizeClass = convertToSizeClass(windowSize)
            windowState = determineWindowState(window)
        }
    }
    
    private func convertToSizeClass(_ size: CGSize) -> ScreenSizeClass {
        if size.width >= 1024 {
            return .large
        } else if size.width >= 768 {
            return .regular
        } else {
            return .compact
        }
    }
    
    private func determineWindowState(_ window: NSWindow) -> UnifiedWindowDetection.WindowState {
        if window.isMiniaturized {
            return .minimized
        } else if window.styleMask.contains(.fullScreen) {
            return .fullscreen
        } else {
            return .standard
        }
    }
}

#endif