import Foundation
import SwiftUI

/// Unified window size detection across all platforms
/// Provides consistent API for iOS, macOS, and other platforms
@MainActor
public class UnifiedWindowDetection: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Current window size (actual window, not device screen)
    @Published public var windowSize: CGSize = CGSize(width: 375, height: 667)
    
    /// Current screen size (device screen)
    @Published public var screenSize: CGSize = CGSize(width: 375, height: 667)
    
    /// Current window frame
    @Published public var windowFrame: CGRect = CGRect(x: 0, y: 0, width: 375, height: 667)
    
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
    
    /// Platform-specific window detection
    @Published public var platformDetection: (any PlatformWindowDetection)?
    
    /// Layout change callback - called when window properties change
    public var onLayoutChange: (() -> Void)?
    
    /// Previous window size for change detection
    private var previousWindowSize: CGSize = CGSize(width: 375, height: 667)
    
    /// Previous screen size class for change detection
    private var previousScreenSizeClass: ScreenSizeClass = .compact
    
    /// Previous orientation for change detection
    private var previousOrientation: DeviceOrientation = .portrait
    
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
    
    // MARK: - Platform Window Detection Protocol
    
    @MainActor
    public protocol PlatformWindowDetection: ObservableObject {
        var windowSize: CGSize { get }
        var screenSize: CGSize { get }
        var windowFrame: CGRect { get }
        var screenSizeClass: ScreenSizeClass { get }
        var windowState: WindowState { get }
        var deviceContext: DeviceContext { get }
        var isResizing: Bool { get }
        var safeAreaInsets: EdgeInsets { get }
        var orientation: DeviceOrientation { get }
        
        func startMonitoring()
        func stopMonitoring()
        func updateWindowInfo()
    }
    
    // MARK: - Private Properties
    
    private var platformDetectionTimer: Timer?
    
    // MARK: - Initialization
    
    public init() {
        setupPlatformDetection()
    }
    
    deinit {
        // Use a weak reference to avoid capture issues
        weak var weakSelf = self
        Task { @MainActor in
            weakSelf?.platformDetectionTimer?.invalidate()
        }
    }
    
    // MARK: - Public Methods
    
    /// Start monitoring window size changes
    public func startMonitoring() {
        platformDetection?.startMonitoring()
        startPeriodicUpdates()
    }
    
    /// Stop monitoring window size changes
    public func stopMonitoring() {
        platformDetection?.stopMonitoring()
        platformDetectionTimer?.invalidate()
        platformDetectionTimer = nil
    }
    
    /// Force update window information
    public func updateWindowInfo() {
        platformDetection?.updateWindowInfo()
        syncFromPlatformDetection()
    }
    
    // MARK: - Private Methods
    
    private func setupPlatformDetection() {
        #if os(iOS)
        platformDetection = iOSWindowDetection()
        #elseif os(macOS)
        platformDetection = macOSWindowDetection()
        #else
        // Fallback for other platforms
        platformDetection = nil
        #endif
        
        // Start monitoring immediately
        startMonitoring()
    }
    
    private func startPeriodicUpdates() {
        platformDetectionTimer?.invalidate()
        platformDetectionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.syncFromPlatformDetection()
            }
        }
    }
    
    private func syncFromPlatformDetection() {
        guard let platformDetection = platformDetection else { return }
        
        // Check for significant changes that should trigger layout updates
        let newWindowSize = platformDetection.windowSize
        let newScreenSizeClass = platformDetection.screenSizeClass
        let newOrientation = platformDetection.orientation
        
        // Detect if any significant layout-affecting properties have changed
        let windowSizeChanged = abs(newWindowSize.width - previousWindowSize.width) > 1 || 
                               abs(newWindowSize.height - previousWindowSize.height) > 1
        let screenSizeClassChanged = newScreenSizeClass != previousScreenSizeClass
        let orientationChanged = newOrientation != previousOrientation
        
        let layoutAffectingChange = windowSizeChanged || screenSizeClassChanged || orientationChanged
        
        // Sync all properties from platform-specific detection
        self.windowSize = newWindowSize
        self.screenSize = platformDetection.screenSize
        self.windowFrame = platformDetection.windowFrame
        self.screenSizeClass = newScreenSizeClass
        self.windowState = platformDetection.windowState
        self.deviceContext = platformDetection.deviceContext
        self.isResizing = platformDetection.isResizing
        self.safeAreaInsets = platformDetection.safeAreaInsets
        self.orientation = newOrientation
        
        // Update previous values
        self.previousWindowSize = newWindowSize
        self.previousScreenSizeClass = newScreenSizeClass
        self.previousOrientation = newOrientation
        
        // Trigger layout change callback if significant changes occurred
        if layoutAffectingChange {
            onLayoutChange?()
        }
    }
}

// MARK: - SwiftUI Integration

/// SwiftUI view modifier for unified window size detection
public struct UnifiedWindowSizeModifier: ViewModifier {
    @StateObject private var windowDetection = UnifiedWindowDetection()
    
    public func body(content: Content) -> some View {
        content
            .environmentObject(windowDetection)
            .onAppear {
                windowDetection.startMonitoring()
            }
            .onDisappear {
                windowDetection.stopMonitoring()
            }
    }
}

/// SwiftUI view extension for easy window size detection
public extension View {
    /// Enable unified window size detection for responsive layouts
    /// Works across iOS, macOS, and other platforms
    /// Handles multiple windows, Stage Manager, Split View, and Slide Over
    func detectWindowSize() -> some View {
        self.modifier(UnifiedWindowSizeModifier())
    }
}

// MARK: - Platform-Specific Imports

#if os(iOS)
import UIKit
#endif

#if os(macOS)
import AppKit
#endif
