//
//  PlatformTypes.swift
//  SixLayerFramework
//
//  Core platform and device type definitions for the 6-layer architecture
//

import Foundation
import SwiftUI

// MARK: - Platform Enumeration

/// Represents the target platform for optimization and adaptation
public enum SixLayerPlatform: String, CaseIterable {
    case iOS = "iOS"
    case macOS = "macOS"
    case watchOS = "watchOS"
    case tvOS = "tvOS"
    case visionOS = "visionOS"
    
    /// Current platform detection (compile-time only)
    public static var current: SixLayerPlatform {
        #if os(iOS)
        return .iOS
        #elseif os(macOS)
        return .macOS
        #elseif os(watchOS)
        return .watchOS
        #elseif os(tvOS)
        return .tvOS
        #elseif os(visionOS)
        return .visionOS
        #else
        return .iOS // Default fallback
        #endif
    }
    
    /// Current platform detection (runtime-aware for testing)
    public static var currentPlatform: SixLayerPlatform {
        // Check if test platform is set in RuntimeCapabilityDetection
        if let testPlatform = RuntimeCapabilityDetection.testPlatform {
            return testPlatform
        }
        
        // Otherwise fall back to compile-time platform detection
        return current
    }
    
    /// Current device type detection (runtime-aware for testing)
    @MainActor
    public static var deviceType: DeviceType {
        // If test platform is set, derive device type from test platform
        if let testPlatform = RuntimeCapabilityDetection.testPlatform {
            return deriveDeviceTypeFromPlatform(testPlatform)
        }
        
        // Otherwise fall back to compile-time device type detection
        return DeviceType.current
    }
    
    /// Derive device type from platform for testing purposes
    private static func deriveDeviceTypeFromPlatform(_ platform: SixLayerPlatform) -> DeviceType {
        switch platform {
        case .iOS:
            // For iOS testing, default to phone unless specifically testing iPad
            // This could be enhanced with a specific test device type override
            return .phone
        case .macOS:
            return .mac
        case .watchOS:
            return .watch
        case .tvOS:
            return .tv
        case .visionOS:
            // visionOS doesn't have a specific DeviceType, use tv as placeholder
            return .tv
        }
    }
}

// MARK: - Device Type Enumeration

/// Represents the device type for responsive design and optimization
public enum DeviceType: String, CaseIterable {
    case phone = "phone"
    case pad = "pad"
    case mac = "mac"
    case tv = "tv"
    case watch = "watch"
    case car = "car"
    case vision = "vision"
    
    /// Current device type detection
    @MainActor
    public static var current: DeviceType {
        #if os(iOS)
        // Check for CarPlay first
        if CarPlayCapabilityDetection.isCarPlayActive {
            return .car
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .pad
        } else {
            return .phone
        }
        #elseif os(macOS)
        return .mac
        #elseif os(watchOS)
        return .watch
        #elseif os(tvOS)
        return .tv
        #else
        return .phone // Default fallback
        #endif
    }
    
    /// Detect device type from screen size
    public static func from(screenSize: CGSize) -> DeviceType {
        let width = screenSize.width
        let height = screenSize.height
        let minDimension = min(width, height)
        let maxDimension = max(width, height)
        
        #if os(iOS)
        // iOS device detection based on screen dimensions
        if minDimension >= 768 {
            return .pad
        } else {
            return .phone
        }
        #elseif os(macOS)
        return .mac
        #elseif os(watchOS)
        return .watch
        #elseif os(tvOS)
        return .tv
        #else
        // Fallback based on screen size
        if minDimension >= 768 {
            return .pad
        } else if minDimension >= 162 && maxDimension >= 197 {
            return .watch
        } else if minDimension >= 1920 {
            return .tv
        } else {
            return .phone
        }
        #endif
    }
}

// MARK: - Device Context Enumeration

/// Represents the context in which the app is running for specialized optimizations
public enum DeviceContext: String, CaseIterable {
    case standard = "standard"
    case carPlay = "carPlay"
    case externalDisplay = "externalDisplay"
    case splitView = "splitView"
    case stageManager = "stageManager"
    
    /// Current device context detection
    @MainActor
    public static var current: DeviceContext {
        #if os(iOS)
        // Check for CarPlay
        if CarPlayCapabilityDetection.isCarPlayActive {
            return .carPlay
        }
        
        // Check for external display
        if UIScreen.screens.count > 1 {
            return .externalDisplay
        }
        
        // Check for split view (iPad only)
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if windowScene.traitCollection.horizontalSizeClass == .regular &&
                   windowScene.traitCollection.verticalSizeClass == .regular {
                    return .splitView
                }
            }
        }
        
        return .standard
        #else
        return .standard
        #endif
    }
}

// MARK: - CarPlay Capability Detection

/// CarPlay-specific capability detection and optimization
public struct CarPlayCapabilityDetection {
    
    /// Whether CarPlay is currently active
    @MainActor
    public static var isCarPlayActive: Bool {
        #if os(iOS)
        if #available(iOS 14.0, *) {
            // Check if we're in a CarPlay context
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return windowScene.traitCollection.userInterfaceIdiom == .carPlay
            }
        }
        return false
        #else
        return false
        #endif
    }
    
    /// Whether the app supports CarPlay
    public static var supportsCarPlay: Bool {
        #if os(iOS)
        if #available(iOS 14.0, *) {
            return true
        }
        return false
        #else
        return false
        #endif
    }
    
    /// Get CarPlay-specific device type
    @MainActor
    public static var carPlayDeviceType: DeviceType {
        return .car
    }
    
    /// Get CarPlay-optimized layout preferences
    public static var carPlayLayoutPreferences: CarPlayLayoutPreferences {
        return CarPlayLayoutPreferences(
            prefersLargeText: true,
            prefersHighContrast: true,
            prefersMinimalUI: true,
            supportsVoiceControl: true,
            supportsTouch: true,
            supportsKnobControl: true
        )
    }
    
    /// Check if specific CarPlay features are available
    @MainActor
    public static func isFeatureAvailable(_ feature: CarPlayFeature) -> Bool {
        guard isCarPlayActive else { return false }
        
        switch feature {
        case .navigation:
            return true
        case .music:
            return true
        case .phone:
            return true
        case .messages:
            return true
        case .voiceControl:
            return true
        case .knobControl:
            return true
        case .touchControl:
            return true
        }
    }
}

// MARK: - CarPlay Layout Preferences

/// CarPlay-specific layout and interaction preferences
public struct CarPlayLayoutPreferences {
    public let prefersLargeText: Bool
    public let prefersHighContrast: Bool
    public let prefersMinimalUI: Bool
    public let supportsVoiceControl: Bool
    public let supportsTouch: Bool
    public let supportsKnobControl: Bool
    
    public init(
        prefersLargeText: Bool = true,
        prefersHighContrast: Bool = true,
        prefersMinimalUI: Bool = true,
        supportsVoiceControl: Bool = true,
        supportsTouch: Bool = true,
        supportsKnobControl: Bool = true
    ) {
        self.prefersLargeText = prefersLargeText
        self.prefersHighContrast = prefersHighContrast
        self.prefersMinimalUI = prefersMinimalUI
        self.supportsVoiceControl = supportsVoiceControl
        self.supportsTouch = supportsTouch
        self.supportsKnobControl = supportsKnobControl
    }
}

// MARK: - CarPlay Features

/// Available CarPlay features for capability detection
public enum CarPlayFeature: String, CaseIterable {
    case navigation = "navigation"
    case music = "music"
    case phone = "phone"
    case messages = "messages"
    case voiceControl = "voiceControl"
    case knobControl = "knobControl"
    case touchControl = "touchControl"
}

// MARK: - Keyboard Type Enumeration

/// Represents different keyboard types for text input optimization
public enum KeyboardType: String, CaseIterable {
    case `default` = "default"
    case asciiCapable = "asciiCapable"
    case numbersAndPunctuation = "numbersAndPunctuation"
    case URL = "URL"
    case numberPad = "numberPad"
    case phonePad = "phonePad"
    case namePhonePad = "namePhonePad"
    case emailAddress = "emailAddress"
    case decimalPad = "decimalPad"
    case twitter = "twitter"
    case webSearch = "webSearch"
    
    /// Platform-specific decimal keyboard type
        static func platformDecimalKeyboardType() -> KeyboardType {
        #if os(iOS)
        return .decimalPad
        #else
        return .default
        #endif
    }
}

// MARK: - Form Content Metrics

/// Metrics for analyzing form content and determining optimal layout
public struct FormContentMetrics: Equatable, Sendable {
    public let fieldCount: Int
    public let estimatedComplexity: ContentComplexity
    public let preferredLayout: LayoutPreference
    public let sectionCount: Int
    public let hasComplexContent: Bool
    
    public init(
        fieldCount: Int,
        estimatedComplexity: ContentComplexity = .simple,
        preferredLayout: LayoutPreference = .adaptive,
        sectionCount: Int = 1,
        hasComplexContent: Bool = false
    ) {
        self.fieldCount = fieldCount
        self.estimatedComplexity = estimatedComplexity
        self.preferredLayout = preferredLayout
        self.sectionCount = sectionCount
        self.hasComplexContent = hasComplexContent
    }
}

// MARK: - Form Content Key

/// Preference key for form content metrics
public struct FormContentKey: PreferenceKey {
    public static let defaultValue: FormContentMetrics = FormContentMetrics(
        fieldCount: 0,
        estimatedComplexity: .simple,
        preferredLayout: .adaptive,
        sectionCount: 1,
        hasComplexContent: false
    )
    
        public static func reduce(value: inout FormContentMetrics, nextValue: () -> FormContentMetrics) {
        value = nextValue()
    }
}


// MARK: - Layout Preference

/// Represents the preferred layout approach for content
public enum LayoutPreference: String, CaseIterable, Sendable {
    case compact = "compact"
    case adaptive = "adaptive"
    case spacious = "spacious"
    case custom = "custom"
    case grid = "grid"
    case list = "list"
}

// MARK: - Platform Device Capabilities

/// Provides information about device capabilities for optimization
public struct PlatformDeviceCapabilities {
    /// Current device type
    @MainActor
    public static var deviceType: DeviceType {
        return DeviceType.current
    }
    
    /// Whether the device supports haptic feedback
    public static var supportsHapticFeedback: Bool {
        #if os(iOS)
        return true
        #else
        return false
        #endif
    }
    
    /// Whether the device supports keyboard shortcuts
    public static var supportsKeyboardShortcuts: Bool {
        #if os(macOS)
        return true
        #else
        return false
        #endif
    }
    
    /// Whether the device supports context menus
    public static var supportsContextMenus: Bool {
        #if os(macOS) || os(iOS)
        return true
        #else
        return false
        #endif
    }
    
    /// Whether the device supports CarPlay
    public static var supportsCarPlay: Bool {
        return CarPlayCapabilityDetection.supportsCarPlay
    }
    
    /// Whether CarPlay is currently active
    @MainActor
    public static var isCarPlayActive: Bool {
        return CarPlayCapabilityDetection.isCarPlayActive
    }
    
    /// Current device context
    @MainActor
    public static var deviceContext: DeviceContext {
        return DeviceContext.current
    }
}

// MARK: - Modal Platform Types

/// Represents the platform for modal presentations
public enum ModalPlatform: String, CaseIterable {
    case iOS = "iOS"
    case macOS = "macOS"
}

/// Represents different modal presentation types
public enum ModalPresentationType: String, CaseIterable {
    case sheet = "sheet"
    case popover = "popover"
    case fullScreen = "fullScreen"
    case custom = "custom"
}

/// Represents modal sizing options
public enum ModalSizing: String, CaseIterable {
    case small = "small"
    case medium = "medium"
    case large = "large"
    case custom = "custom"
}

/// Represents modal constraints for different platforms
public struct ModalConstraint {
    public let maxWidth: CGFloat?
    public let maxHeight: CGFloat?
    public let preferredSize: CGSize?
    
    public init(
        maxWidth: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        preferredSize: CGSize? = nil
    ) {
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        self.preferredSize = preferredSize
    }
}

/// Represents platform adaptations for different devices
public enum PlatformAdaptation: String, CaseIterable {
    case largeFields = "largeFields"
    case standardFields = "standardFields"
    case compactFields = "compactFields"
}

// MARK: - Form Layout Types

/// Represents form layout decisions for different platforms
public struct FormLayoutDecision {
    public let containerType: FormContainerType
    public let fieldLayout: FieldLayout
    public let spacing: SpacingPreference
    public let validation: ValidationStrategy
    
    public init(
        containerType: FormContainerType,
        fieldLayout: FieldLayout,
        spacing: SpacingPreference,
        validation: ValidationStrategy
    ) {
        self.containerType = containerType
        self.fieldLayout = fieldLayout
        self.spacing = spacing
        self.validation = validation
    }
}

/// Represents form container types
public enum FormContainerType: String, CaseIterable {
    case form = "form"
    case scrollView = "scrollView"
    case custom = "custom"
    case adaptive = "adaptive"
    case standard = "standard"
}

/// Represents validation strategies
public enum ValidationStrategy: String, CaseIterable {
    case none = "none"
    case realTime = "realTime"
    case onSubmit = "onSubmit"
    case custom = "custom"
    case immediate = "immediate"
    case deferred = "deferred"
}

/// Represents spacing preferences
public enum SpacingPreference: String, CaseIterable {
    case compact = "compact"
    case comfortable = "comfortable"
    case generous = "generous"
    case standard = "standard"
    case spacious = "spacious"
}

/// Represents field layout strategies
public enum FieldLayout: String, CaseIterable {
    case standard = "standard"
    case compact = "compact"
    case spacious = "spacious"
    case adaptive = "adaptive"
    case vertical = "vertical"
    case horizontal = "horizontal"
    case grid = "grid"
}

/// Represents modal layout decisions
public struct ModalLayoutDecision {
    public let presentationType: ModalPresentationType
    public let sizing: ModalSizing
    public let detents: [SheetDetent]
    public let platformConstraints: [ModalPlatform: ModalConstraint]
    
    public init(
        presentationType: ModalPresentationType,
        sizing: ModalSizing,
        detents: [SheetDetent] = [],
        platformConstraints: [ModalPlatform: ModalConstraint] = [:]
    ) {
        self.presentationType = presentationType
        self.sizing = sizing
        self.detents = detents
        self.platformConstraints = platformConstraints
    }
}

/// Represents sheet detents for modal presentations
public enum SheetDetent: CaseIterable {
    case small
    case medium
    case large
    case custom(height: CGFloat)
    
    public static var allCases: [SheetDetent] {
        return [.small, .medium, .large, .custom(height: 300)] // Default height for custom
    }
}

/// Represents form strategy for different platforms
public struct FormStrategy {
    public let containerType: FormContainerType
    public let fieldLayout: FieldLayout
    public let validation: ValidationStrategy
    public let platformAdaptations: [ModalPlatform: PlatformAdaptation]
    
    public init(
        containerType: FormContainerType,
        fieldLayout: FieldLayout,
        validation: ValidationStrategy,
        platformAdaptations: [ModalPlatform: PlatformAdaptation] = [:]
    ) {
        self.containerType = containerType
        self.fieldLayout = fieldLayout
        self.validation = validation
        self.platformAdaptations = platformAdaptations
    }
}

// MARK: - Card Layout Types

/// Represents card layout decisions for different platforms
public struct CardLayoutDecision {
    public let layout: CardLayoutType
    public let sizing: CardSizing
    public let interaction: CardInteraction
    public let responsive: ResponsiveBehavior
    public let spacing: CGFloat
    public let columns: Int
    
    public init(
        layout: CardLayoutType,
        sizing: CardSizing,
        interaction: CardInteraction,
        responsive: ResponsiveBehavior,
        spacing: CGFloat,
        columns: Int
    ) {
        self.layout = layout
        self.sizing = sizing
        self.interaction = interaction
        self.responsive = responsive
        self.spacing = spacing
        self.columns = columns
    }
}

/// Represents card layout types
public enum CardLayoutType: String, CaseIterable {
    case uniform = "uniform"
    case contentAware = "contentAware"
    case aspectRatio = "aspectRatio"
    case dynamic = "dynamic"
}

/// Represents card sizing options
public enum CardSizing: String, CaseIterable {
    case fixed = "fixed"
    case flexible = "flexible"
    case adaptive = "adaptive"
    case contentBased = "contentBased"
}

/// Represents card interaction options
public enum CardInteraction: String, CaseIterable {
    case tap = "tap"
    case longPress = "longPress"
    case drag = "drag"
    case hover = "hover"
    case none = "none"
}

/// Represents responsive behavior for cards
public struct ResponsiveBehavior {
    public let type: ResponsiveType
    public let breakpoints: [CGFloat]
    public let adaptive: Bool
    
    public init(
        type: ResponsiveType,
        breakpoints: [CGFloat] = [],
        adaptive: Bool = false
    ) {
        self.type = type
        self.breakpoints = breakpoints
        self.adaptive = adaptive
    }
}

/// Represents responsive type options
public enum ResponsiveType: String, CaseIterable {
    case fixed = "fixed"
    case adaptive = "adaptive"
    case fluid = "fluid"
    case breakpoint = "breakpoint"
    case dynamic = "dynamic"
}

// MARK: - Cross-Platform Image Types

/// Cross-platform image type for consistent image handling
public struct PlatformSize: @unchecked Sendable {
    #if os(iOS)
    public let cgSize: CGSize
    #elseif os(macOS)
    public let nsSize: NSSize
    #endif
    
    public init(width: Double, height: Double) {
        #if os(iOS)
        self.cgSize = CGSize(width: width, height: height)
        #elseif os(macOS)
        self.nsSize = NSSize(width: width, height: height)
        #endif
    }
    
    public init(_ cgSize: CGSize) {
        #if os(iOS)
        self.cgSize = cgSize
        #elseif os(macOS)
        self.nsSize = NSSize(width: cgSize.width, height: cgSize.height)
        #endif
    }
    
    public var width: Double {
        #if os(iOS)
        return Double(cgSize.width)
        #elseif os(macOS)
        return Double(nsSize.width)
        #endif
    }
    
    public var height: Double {
        #if os(iOS)
        return Double(cgSize.height)
        #elseif os(macOS)
        return Double(nsSize.height)
        #endif
    }
}

public struct PlatformImage: @unchecked Sendable {
    #if os(iOS)
    private let _uiImage: UIImage
    #elseif os(macOS)
    private let _nsImage: NSImage
    #endif
    
    public init?(data: Data) {
        #if os(iOS)
        guard let uiImage = UIImage(data: data) else { return nil }
        self._uiImage = uiImage
        #elseif os(macOS)
        guard let nsImage = NSImage(data: data) else { return nil }
        self._nsImage = nsImage
        #endif
    }
    
    public init() {
        #if os(iOS)
        self._uiImage = UIImage()
        #elseif os(macOS)
        self._nsImage = NSImage()
        #endif
    }
    
    #if os(iOS)
    public init(uiImage: UIImage) {
        self._uiImage = uiImage
    }
    #elseif os(macOS)
    public init(nsImage: NSImage) {
        self._nsImage = nsImage
    }
    #endif
    
    #if os(iOS)
    public var uiImage: UIImage { return _uiImage }
    #elseif os(macOS)
    public var nsImage: NSImage { return _nsImage }
    #endif
    
    /// Check if the image is empty
    public var isEmpty: Bool {
        #if os(iOS)
        return uiImage.size == .zero
        #elseif os(macOS)
        return nsImage.size == .zero
        #endif
    }
    
    /// Get the size of the image
    public var size: CGSize {
        #if os(iOS)
        return uiImage.size
        #elseif os(macOS)
        return nsImage.size
        #endif
    }
}

// MARK: - Content Analysis Types

/// Represents content analysis results for layout decisions
public struct ContentAnalysis {
    public let recommendedApproach: LayoutApproach
    public let optimalSpacing: CGFloat
    public let performanceConsiderations: [String]
    
    public init(
        recommendedApproach: LayoutApproach,
        optimalSpacing: CGFloat,
        performanceConsiderations: [String] = []
    ) {
        self.recommendedApproach = recommendedApproach
        self.optimalSpacing = optimalSpacing
        self.performanceConsiderations = performanceConsiderations
    }
}

/// Represents layout approach strategies
public enum LayoutApproach: String, CaseIterable {
    case compact = "compact"
    case adaptive = "adaptive"
    case spacious = "spacious"
    case custom = "custom"
    case grid = "grid"
    case uniform = "uniform"
    case responsive = "responsive"
    case dynamic = "dynamic"
    case masonry = "masonry"
    case list = "list"
}

// MARK: - Presentation Hints

/// Data type hints for presentation
public enum DataTypeHint: String, CaseIterable, Sendable {
    case generic = "generic"
    case text = "text"
    case number = "number"
    case date = "date"
    case image = "image"
    case boolean = "boolean"
    case collection = "collection"
    case numeric = "numeric"
    case hierarchical = "hierarchical"
    case temporal = "temporal"
    case media = "media"
    case form = "form"
    case list = "list"
    case grid = "grid"
    case chart = "chart"
    case custom = "custom"
    case user = "user"
    case transaction = "transaction"
    case action = "action"
    case product = "product"
    case communication = "communication"
    case location = "location"
    case navigation = "navigation"
    case card = "card"
    case detail = "detail"
    case modal = "modal"
    case sheet = "sheet"
}

/// Presentation preference levels
public enum PresentationPreference: String, CaseIterable, Sendable {
    case automatic = "automatic"
    case minimal = "minimal"
    case moderate = "moderate"
    case rich = "rich"
    case custom = "custom"
    case detail = "detail"
    case modal = "modal"
    case navigation = "navigation"
    case list = "list"
    case masonry = "masonry"
    case standard = "standard"
    case form = "form"
    case card = "card"
    case cards = "cards"
    case compact = "compact"
    case grid = "grid"
    case chart = "chart"
    case coverFlow = "coverFlow"
}

/// Presentation context types
public enum PresentationContext: String, CaseIterable, Sendable {
    case dashboard = "dashboard"
    case browse = "browse"
    case detail = "detail"
    case edit = "edit"
    case create = "create"
    case search = "search"
    case settings = "settings"
    case profile = "profile"
    case summary = "summary"
    case list = "list"
    case standard = "standard"
    case form = "form"
    case modal = "modal"
    case navigation = "navigation"
}

/// Content complexity levels
public enum ContentComplexity: String, CaseIterable, Sendable {
    case simple = "simple"
    case moderate = "moderate"
    case complex = "complex"
    case veryComplex = "veryComplex"
    case advanced = "advanced"
}

/// Simple presentation hints for basic usage
public struct PresentationHints: Sendable {
    public let dataType: DataTypeHint
    public let presentationPreference: PresentationPreference
    public let complexity: ContentComplexity
    public let context: PresentationContext
    public var customPreferences: [String: String]
    
    public init(
        dataType: DataTypeHint = .generic,
        presentationPreference: PresentationPreference = .automatic,
        complexity: ContentComplexity = .moderate,
        context: PresentationContext = .dashboard,
        customPreferences: [String: String] = [:]
    ) {
        self.dataType = dataType
        self.presentationPreference = presentationPreference
        self.complexity = complexity
        self.context = context
        self.customPreferences = customPreferences
    }
}
