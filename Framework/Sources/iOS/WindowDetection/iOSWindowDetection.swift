import Foundation
import SwiftUI

#if os(iOS)
import UIKit

/// iOS/iPadOS-specific window size detection and monitoring
/// Handles multiple windows, Stage Manager, Split View, and Slide Over
@MainActor
public class iOSWindowDetection: ObservableObject, UnifiedWindowDetection.PlatformWindowDetection {
    
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
    @Published public var windowState: UnifiedWindowDetection.WindowState = .standard
    
    /// Current device context
    @Published public var deviceContext: DeviceContext = .standard
    
    /// Whether window is currently resizing
    @Published public var isResizing: Bool = false
    
    /// Safe area insets for current window
    @Published public var safeAreaInsets: EdgeInsets = EdgeInsets()
    
    /// Current orientation
    @Published public var orientation: DeviceOrientation = .portrait
    
    // MARK: - Private Properties
    
    private var windowScene: UIWindowScene?
    private var window: UIWindow?
    private var resizeTimer: Timer?
    private var notificationObservers: [NSObjectProtocol] = []
    
    // MARK: - Initialization
    
    public init() {
        setupWindowDetection()
    }
    
    deinit {
        cleanup()
    }
    
    // MARK: - Public Methods
    
    /// Start monitoring window size changes
    public func startMonitoring() {
        guard windowScene == nil else { return }
        
        // Find the current window scene
        if let currentScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) {
            
            self.windowScene = currentScene
            self.window = currentScene.windows.first
            updateWindowInfo()
            setupWindowObservers()
        }
    }
    
    /// Stop monitoring window size changes
    public func stopMonitoring() {
        cleanup()
    }
    
    /// Force update window information
    public func updateWindowInfo() {
        guard let windowScene = windowScene,
              let window = window else { return }
        
        let newWindowSize = window.bounds.size
        let newWindowFrame = window.frame
        let newScreenSize = windowScene.screen.bounds.size
        let newSafeAreaInsets = window.safeAreaInsets
        let newOrientation = DeviceOrientation.fromUIDeviceOrientation(UIDevice.current.orientation)
        
        // Update published properties
        self.windowSize = newWindowSize
        self.windowFrame = newWindowFrame
        self.screenSize = newScreenSize
        self.safeAreaInsets = EdgeInsets(
            top: newSafeAreaInsets.top,
            leading: newSafeAreaInsets.left,
            bottom: newSafeAreaInsets.bottom,
            trailing: newSafeAreaInsets.right
        )
        self.orientation = newOrientation
        self.screenSizeClass = ScreenSizeClass.from(screenSize: newWindowSize)
        self.windowState = determineWindowState(windowScene, window)
        self.deviceContext = determineDeviceContext(windowScene, window)
        
        // Debug logging
        #if DEBUG
        print("iOS Window Detection - Window: \(newWindowSize), Screen: \(newScreenSize), State: \(windowState), Context: \(deviceContext)")
        #endif
    }
    
    // MARK: - Private Methods
    
    private func setupWindowDetection() {
        // Start monitoring immediately
        startMonitoring()
        
        // Set up periodic updates in case we miss notifications
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateWindowInfo()
        }
    }
    
    private func setupWindowObservers() {
        guard let windowScene = windowScene else { return }
        
        // Clear existing observers
        cleanup()
        
        // Window scene activation state changes
        let activationObserver = NotificationCenter.default.addObserver(
            forName: UIScene.didActivateNotification,
            object: windowScene,
            queue: .main
        ) { [weak self] _ in
            self?.updateWindowInfo()
        }
        notificationObservers.append(activationObserver)
        
        // Window scene deactivation
        let deactivationObserver = NotificationCenter.default.addObserver(
            forName: UIScene.didDeactivateNotification,
            object: windowScene,
            queue: .main
        ) { [weak self] _ in
            self?.updateWindowInfo()
        }
        notificationObservers.append(deactivationObserver)
        
        // Device orientation changes
        let orientationObserver = NotificationCenter.default.addObserver(
            forName: UIDevice.orientationDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateWindowInfo()
        }
        notificationObservers.append(orientationObserver)
        
        // Window frame changes (for resizing)
        let frameObserver = NotificationCenter.default.addObserver(
            forName: UIScene.didEnterBackgroundNotification,
            object: windowScene,
            queue: .main
        ) { [weak self] _ in
            self?.updateWindowInfo()
        }
        notificationObservers.append(frameObserver)
        
        // Screen changes (external displays, etc.)
        let screenObserver = NotificationCenter.default.addObserver(
            forName: UIScreen.didConnectNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateWindowInfo()
        }
        notificationObservers.append(screenObserver)
        
        let screenDisconnectObserver = NotificationCenter.default.addObserver(
            forName: UIScreen.didDisconnectNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateWindowInfo()
        }
        notificationObservers.append(screenDisconnectObserver)
    }
    
    private func determineWindowState(_ windowScene: UIWindowScene, _ window: UIWindow) -> UnifiedWindowDetection.WindowState {
        // Check for Stage Manager (iPadOS 16+)
        if #available(iOS 16.0, *) {
            if windowScene.traitCollection.userInterfaceIdiom == .pad {
                // Check if we're in Stage Manager
                if windowScene.traitCollection.horizontalSizeClass == .regular &&
                   windowScene.traitCollection.verticalSizeClass == .regular {
                    // Check if window is in a multi-window environment
                    let allScenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
                    if allScenes.count > 1 {
                        return .stageManager
                    }
                }
            }
        }
        
        // Check for Split View
        if windowScene.traitCollection.userInterfaceIdiom == .pad {
            let horizontalSizeClass = windowScene.traitCollection.horizontalSizeClass
            let verticalSizeClass = windowScene.traitCollection.verticalSizeClass
            
            // In Split View, one dimension is typically compact
            if (horizontalSizeClass == .compact && verticalSizeClass == .regular) ||
               (horizontalSizeClass == .regular && verticalSizeClass == .compact) {
                return .splitView
            }
        }
        
        // Check for Slide Over (smaller window)
        if windowScene.traitCollection.userInterfaceIdiom == .pad {
            let windowWidth = window.bounds.width
            let screenWidth = windowScene.screen.bounds.width
            
            // Slide Over windows are typically much smaller than screen width
            if windowWidth < screenWidth * 0.4 {
                return .slideOver
            }
        }
        
        // Check for fullscreen
        if window.bounds.size == windowScene.screen.bounds.size {
            return .fullscreen
        }
        
        return .standard
    }
    
    private func determineDeviceContext(_ windowScene: UIWindowScene, _ window: UIWindow) -> DeviceContext {
        // Check for external display
        if UIScreen.screens.count > 1 {
            return .externalDisplay
        }
        
        // Check for CarPlay
        if CarPlayCapabilityDetection.isCarPlayActive {
            return .carPlay
        }
        
        // Check for Split View
        if windowState == .splitView {
            return .splitView
        }
        
        // Check for Stage Manager
        if windowState == .stageManager {
            return .stageManager
        }
        
        return .standard
    }
    
    private func cleanup() {
        resizeTimer?.invalidate()
        resizeTimer = nil
        
        notificationObservers.forEach { observer in
            NotificationCenter.default.removeObserver(observer)
        }
        notificationObservers.removeAll()
        
        windowScene = nil
        window = nil
    }
}

// MARK: - Screen Size Class Extension

extension ScreenSizeClass {
    /// Detect screen size class from iOS window size (not device screen)
    static func from(iOSWindowSize: CGSize) -> ScreenSizeClass {
        let width = iOSWindowSize.width
        let height = iOSWindowSize.height
        let minDimension = min(width, height)
        
        // iOS-specific breakpoints based on actual window size
        if minDimension < 400 {
            return .compact
        } else if minDimension < 800 {
            return .regular
        } else {
            return .large
        }
    }
}

#endif
