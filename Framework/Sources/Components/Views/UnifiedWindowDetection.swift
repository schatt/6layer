import Foundation
import SwiftUI

/// Protocol for providing geometry information - enables testability
public protocol GeometryProvider {
    func getSize(from geometry: GeometryProxy) -> CGSize
    func getSafeAreaInsets(from geometry: GeometryProxy) -> EdgeInsets
}

/// Default implementation that uses the actual geometry values
public struct DefaultGeometryProvider: GeometryProvider {
    public init() {}
    
    public func getSize(from geometry: GeometryProxy) -> CGSize {
        return geometry.size
    }
    
    public func getSafeAreaInsets(from geometry: GeometryProxy) -> EdgeInsets {
        return geometry.safeAreaInsets
    }
}

/// Unified Window Detection - Convenience wrapper around SwiftUI's native responsive system
/// 
/// Provides cross-platform abstraction over SwiftUI's GeometryReader and environment system.
/// Lightweight convenience utility that can be enhanced with platform-specific features as needed.
@MainActor
public class UnifiedWindowDetection: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Current window size (from GeometryReader)
    @Published public var windowSize: CGSize = CGSize(width: 375, height: 667)
    
    /// Current screen size (device screen)
    @Published public var screenSize: CGSize = CGSize(width: 375, height: 667)
    
    /// Screen size class based on current window size
    @Published public var screenSizeClass: ScreenSizeClass = .compact
    
    /// Current window state
    @Published public var windowState: WindowState = .standard
    
    /// Current device context
    @Published public var deviceContext: DeviceContext = .standard
    
    /// Whether window is currently resizing
    @Published public var isResizing: Bool = false
    
    /// Safe area insets for current window
    @Published public var safeAreaInsets: EdgeInsets = EdgeInsets()
    
    /// Current orientation
    @Published public var orientation: DeviceOrientation = .portrait
    
    /// Layout change callback - called when window properties change
    public var onLayoutChange: (() -> Void)?
    
    /// Geometry provider for testability
    internal let geometryProvider: GeometryProvider
    
    // MARK: - Window State Enum
    
    public enum WindowState: String, CaseIterable {
        case standard = "standard"
        case splitView = "splitView"
        case slideOver = "slideOver"
        case stageManager = "stageManager"
        case fullscreen = "fullscreen"
        case minimized = "minimized"
        case hidden = "hidden"
    }
    
    // MARK: - Initialization
    
    public init(geometryProvider: GeometryProvider = DefaultGeometryProvider()) {
        self.geometryProvider = geometryProvider
        // Lightweight initialization - no polling, no timers
    }
    
    // MARK: - Convenience Methods
    
    /// Update from SwiftUI GeometryReader - main convenience method
    public func updateFromGeometry(_ geometry: GeometryProxy) {
        let newSize = geometryProvider.getSize(from: geometry)
        
        // Only update if size actually changed (avoid unnecessary SwiftUI updates)
        if abs(newSize.width - windowSize.width) > 0.5 || 
           abs(newSize.height - windowSize.height) > 0.5 {
            
            windowSize = newSize
            screenSizeClass = convertToSizeClass(newSize)
            
            // Call layout change callback if registered
            onLayoutChange?()
        }
    }
    
    /// Update from SwiftUI environment values
    public func updateFromEnvironment(
        horizontalSizeClass: UserInterfaceSizeClass?,
        verticalSizeClass: UserInterfaceSizeClass?,
        safeAreaInsets: EdgeInsets
    ) {
        self.safeAreaInsets = safeAreaInsets
        
        // Convert SwiftUI size classes to our unified types
        if let horizontal = horizontalSizeClass {
            screenSizeClass = convertFromSwiftUISizeClass(horizontal, verticalSizeClass)
        }
    }
    
    /// Update size class based on current window size - for testing
    internal func updateSizeClass() {
        screenSizeClass = convertToSizeClass(windowSize)
    }
    
    /// Update window information - stub implementation for compatibility
    public func updateWindowInfo() {
        // UnifiedWindowDetection doesn't actively monitor - it relies on SwiftUI updates
        // This is a stub for compatibility with platform-specific implementations
    }
    
    // MARK: - Private Helper Methods
    
    private func convertToSizeClass(_ size: CGSize) -> ScreenSizeClass {
        // Simple size class conversion - can be enhanced later
        if size.width >= 1024 {
            return .large
        } else if size.width >= 768 {
            return .regular
        } else {
            return .compact
        }
    }
    
    private func convertFromSwiftUISizeClass(
        _ horizontal: UserInterfaceSizeClass,
        _ vertical: UserInterfaceSizeClass?
    ) -> ScreenSizeClass {
        // Convert SwiftUI's size classes to our unified type
        switch horizontal {
        case .compact:
            return .compact
        case .regular:
            return .large
        @unknown default:
            return .compact
        }
    }
}

// MARK: - SwiftUI View Modifier

/// SwiftUI view modifier for unified window size detection
/// Convenience wrapper around GeometryReader
public struct UnifiedWindowSizeModifier: ViewModifier {
    @StateObject private var windowDetection = UnifiedWindowDetection()
    
    public func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .onAppear {
                    windowDetection.updateFromGeometry(geometry)
                }
                .onChange(of: geometry.size) { _ in
                    windowDetection.updateFromGeometry(geometry)
                }
                .environmentObject(windowDetection)
        }
    }
}

// MARK: - View Extension

public extension View {
    /// Apply unified window size detection
    func unifiedWindowDetection() -> some View {
        modifier(UnifiedWindowSizeModifier())
    }
    
    /// Detect window size - convenience method for compatibility
    func detectWindowSize() -> some View {
        unifiedWindowDetection()
    }
}