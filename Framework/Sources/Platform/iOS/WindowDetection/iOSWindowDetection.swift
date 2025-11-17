import Foundation
import SwiftUI

#if os(iOS)
import UIKit

/// iOS-specific window detection - Convenience wrapper
/// Provides iOS-specific enhancements over the base UnifiedWindowDetection
@MainActor
public class iOSWindowDetection: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published public var windowSize: CGSize = CGSize(width: 375, height: 667)
    @Published public var screenSize: CGSize = CGSize(width: 375, height: 667)
    @Published public var windowFrame: CGRect = CGRect(x: 0, y: 0, width: 375, height: 667)
    @Published public var screenSizeClass: ScreenSizeClass = .compact
    @Published public var windowState: UnifiedWindowDetection.WindowState = .standard
    @Published public var deviceContext: DeviceContext = .standard
    @Published public var isResizing: Bool = false
    @Published public var safeAreaInsets: EdgeInsets = EdgeInsets()
    @Published public var orientation: DeviceOrientation = .portrait
    
    // MARK: - Initialization
    
    public init() {
        // Lightweight initialization - use default values
        // Don't access UIApplication.shared in init() to avoid blocking
        // Call updateWindowInfo() explicitly when you need actual window data
    }
    
    // MARK: - Convenience Methods
    
    public func startMonitoring() {
        // iOS-specific: Could add UIWindow notifications here if needed
        // For now, just update from current window
        updateFromCurrentWindow()
    }
    
    public func stopMonitoring() {
        // iOS-specific: Could remove UIWindow notifications here if added
    }
    
    public func updateWindowInfo() {
        updateFromCurrentWindow()
    }
    
    // MARK: - Private Methods
    
    private func updateFromCurrentWindow() {
        // iOS-specific: Get current window info
        // This is where we could enhance with Stage Manager, Split View, etc. later
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            
            windowFrame = window.frame
            windowSize = window.frame.size
            screenSize = windowScene.screen.bounds.size
            screenSizeClass = convertToSizeClass(windowSize)
            windowState = determineWindowState(windowScene, window)
            safeAreaInsets = EdgeInsets(
                top: window.safeAreaInsets.top,
                leading: window.safeAreaInsets.left,
                bottom: window.safeAreaInsets.bottom,
                trailing: window.safeAreaInsets.right
            )
            orientation = determineOrientation(windowScene)
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
    
    private func determineWindowState(_ windowScene: UIWindowScene, _ window: UIWindow) -> UnifiedWindowDetection.WindowState {
        // iOS-specific: Could detect Stage Manager, Split View, Slide Over here
        // For now, just return standard
        return .standard
    }
    
    private func determineOrientation(_ windowScene: UIWindowScene) -> DeviceOrientation {
        // Use size of largest window to determine orientation
        let windowSize = windowScene.windows.first?.bounds.size ?? windowScene.screen.bounds.size
        let isLandscape = windowSize.width > windowSize.height
        
        if isLandscape {
            return .landscape
        } else {
            return .portrait
        }
    }
}

#endif
