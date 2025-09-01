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
public enum Platform: String, CaseIterable {
    case iOS = "iOS"
    case macOS = "macOS"
    case watchOS = "watchOS"
    case tvOS = "tvOS"
    
    /// Current platform detection
    public static var current: Platform {
        #if os(iOS)
        return .iOS
        #elseif os(macOS)
        return .macOS
        #elseif os(watchOS)
        return .watchOS
        #elseif os(tvOS)
        return .tvOS
        #else
        return .iOS // Default fallback
        #endif
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
    
    /// Current device type detection
    @MainActor
    public static var current: DeviceType {
        #if os(iOS)
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
    public static func platformDecimalKeyboardType() -> KeyboardType {
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

// MARK: - Content Complexity

/// Represents the complexity level of content for layout decisions
public enum ContentComplexity: String, CaseIterable, Sendable {
    case simple = "simple"
    case moderate = "moderate"
    case complex = "complex"
    case veryComplex = "veryComplex"
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
public struct PlatformImage {
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
    
    #if os(iOS)
    public var uiImage: UIImage { return _uiImage }
    #elseif os(macOS)
    public var nsImage: NSImage { return _nsImage }
    #endif
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
