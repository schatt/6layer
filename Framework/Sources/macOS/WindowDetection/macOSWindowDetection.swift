import Foundation
import SwiftUI

#if os(macOS)
import AppKit

/// macOS-specific window size detection and monitoring
/// Provides real-time window size detection for responsive layouts
@MainActor
public class macOSWindowDetection: ObservableObject, UnifiedWindowDetection.PlatformWindowDetection {
    
    // MARK: - Published Properties
    
    /// Current window size (actual window, not device screen)
    @Published public var windowSize: CGSize = CGSize(width: 1024, height: 768)
    
    /// Current screen size (primary display)
    @Published public var screenSize: CGSize = CGSize(width: 1024, height: 768)
    
    /// Current window frame
    @Published public var windowFrame: CGRect = CGRect(x: 0, y: 0, width: 1024, height: 768)
    
    /// Screen size class based on current window size
    @Published public var screenSizeClass: ScreenSizeClass = .large
    
    /// Current window state
    @Published public var windowState: UnifiedWindowDetection.WindowState = .standard
    
    /// Current device context
    @Published public var deviceContext: DeviceContext = .standard
    
    /// Whether window is currently resizing
    @Published public var isResizing: Bool = false
    
    /// Safe area insets for current window
    @Published public var safeAreaInsets: EdgeInsets = EdgeInsets()
    
    /// Current orientation
    @Published public var orientation: DeviceOrientation = .landscape
    
    // MARK: - Private Properties
    
    private var window: NSWindow?
    private var resizeTimer: Timer?
    private var notificationObservers: [NSObjectProtocol] = []
    private var updateTimer: Timer?
    
    // MARK: - Initialization
    
    public init() {
        setupWindowDetection()
    }
    
    deinit {
        // Clean up synchronously to avoid retain cycles
        resizeTimer?.invalidate()
        resizeTimer = nil
        
        updateTimer?.invalidate()
        updateTimer = nil
        
        notificationObservers.forEach { observer in
            NotificationCenter.default.removeObserver(observer)
        }
        notificationObservers.removeAll()
        
        window = nil
    }
    
    // MARK: - Public Methods
    
    /// Start monitoring window size changes
    public func startMonitoring() {
        guard window == nil else { return }
        
        // Find the current key window
        if let keyWindow = NSApplication.shared.keyWindow {
            self.window = keyWindow
            updateWindowInfo()
            setupWindowObservers()
        } else {
            // If no key window, try to find any window
            if let firstWindow = NSApplication.shared.windows.first {
                self.window = firstWindow
                updateWindowInfo()
                setupWindowObservers()
            }
        }
    }
    
    /// Stop monitoring window size changes
    public func stopMonitoring() {
        cleanup()
    }
    
    /// Force update window information
    public func updateWindowInfo() {
        guard let window = window else { return }
        
        let newWindowSize = window.frame.size
        let newWindowFrame = window.frame
        let newScreenSize = window.screen?.frame.size ?? CGSize(width: 1024, height: 768)
        
        // Update published properties
        self.windowSize = newWindowSize
        self.windowFrame = newWindowFrame
        self.screenSize = newScreenSize
        self.screenSizeClass = ScreenSizeClass.from(screenSize: newWindowSize)
        self.windowState = determineWindowState(window)
        self.deviceContext = .standard // macOS doesn't have split view, stage manager, etc.
        
        // Debug logging
        #if DEBUG
        print("macOS Window Detection - Size: \(newWindowSize), Screen: \(newScreenSize), State: \(windowState)")
        #endif
    }
    
    // MARK: - Private Methods
    
    private func setupWindowDetection() {
        // Start monitoring immediately
        startMonitoring()
        
        // Set up periodic updates in case we miss notifications
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateWindowInfo()
            }
        }
    }
    
    private func setupWindowObservers() {
        guard let window = window else { return }
        
        // Clear existing observers
        cleanup()
        
        // Window frame change notification
        let frameObserver = NotificationCenter.default.addObserver(
            forName: NSWindow.didResizeNotification,
            object: window,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.handleWindowResize()
            }
        }
        notificationObservers.append(frameObserver)
        
        // Window move notification
        let moveObserver = NotificationCenter.default.addObserver(
            forName: NSWindow.didMoveNotification,
            object: window,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.updateWindowInfo()
            }
        }
        notificationObservers.append(moveObserver)
        
        // Window state change notifications
        let minimizeObserver = NotificationCenter.default.addObserver(
            forName: NSWindow.didMiniaturizeNotification,
            object: window,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.updateWindowInfo()
            }
        }
        notificationObservers.append(minimizeObserver)
        
        let deminimizeObserver = NotificationCenter.default.addObserver(
            forName: NSWindow.didDeminiaturizeNotification,
            object: window,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.updateWindowInfo()
            }
        }
        notificationObservers.append(deminimizeObserver)
        
        // Fullscreen notifications
        let fullscreenObserver = NotificationCenter.default.addObserver(
            forName: NSWindow.didEnterFullScreenNotification,
            object: window,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.updateWindowInfo()
            }
        }
        notificationObservers.append(fullscreenObserver)
        
        let exitFullscreenObserver = NotificationCenter.default.addObserver(
            forName: NSWindow.didExitFullScreenNotification,
            object: window,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.updateWindowInfo()
            }
        }
        notificationObservers.append(exitFullscreenObserver)
        
        // Window close notification
        let closeObserver = NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: window,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.handleWindowClose()
            }
        }
        notificationObservers.append(closeObserver)
    }
    
    private func handleWindowResize() {
        isResizing = true
        
        // Cancel previous timer
        resizeTimer?.invalidate()
        
        // Set new timer to detect end of resize
        resizeTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.isResizing = false
                self?.updateWindowInfo()
            }
        }
        
        // Update immediately for responsive behavior
        updateWindowInfo()
    }
    
    private func handleWindowClose() {
        // Window is closing, find a new window to monitor
        if let newWindow = NSApplication.shared.windows.first(where: { $0 != window }) {
            self.window = newWindow
            setupWindowObservers()
            updateWindowInfo()
        } else {
            // No other windows, stop monitoring
            cleanup()
        }
    }
    
    private func determineWindowState(_ window: NSWindow) -> UnifiedWindowDetection.WindowState {
        if window.isMiniaturized {
            return .minimized
        } else if window.styleMask.contains(.fullScreen) {
            return .fullscreen
        } else if window.isZoomed {
            return .standard // macOS doesn't have "maximized" state
        } else if !window.isVisible {
            return .hidden
        } else {
            return .standard
        }
    }
    
    private func cleanup() {
        resizeTimer?.invalidate()
        resizeTimer = nil
        
        updateTimer?.invalidate()
        updateTimer = nil
        
        notificationObservers.forEach { observer in
            NotificationCenter.default.removeObserver(observer)
        }
        notificationObservers.removeAll()
        
        window = nil
    }
}

// MARK: - Screen Size Class Extension

extension ScreenSizeClass {
    /// Detect screen size class from macOS window size
    static func from(macOSWindowSize: CGSize) -> ScreenSizeClass {
        let width = macOSWindowSize.width
        let height = macOSWindowSize.height
        let minDimension = min(width, height)
        
        // macOS-specific breakpoints
        if minDimension < 800 {
            return .compact
        } else if minDimension < 1000 {
            return .regular
        } else {
            return .large
        }
    }
}

#endif
