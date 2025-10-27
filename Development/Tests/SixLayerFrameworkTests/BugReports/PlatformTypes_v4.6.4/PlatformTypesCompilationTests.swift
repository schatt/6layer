//
//  PlatformTypesCompilationTests.swift
//  SixLayerFrameworkTests
//
//  Bug Report: SixLayerFramework 4.6.4 PlatformTypes Compilation Bug
//  Created: January 24, 2025
//

import Testing
import SixLayerFramework
import Foundation
import CoreGraphics

/// BUSINESS PURPOSE: Verify that PlatformTypes.swift compiles correctly and all types are accessible
/// TESTING SCOPE: PlatformTypes compilation, type accessibility, cross-platform compatibility
/// METHODOLOGY: Direct compilation tests and type instantiation verification
@MainActor
struct PlatformTypesCompilationTests {
    
    // MARK: - Core Platform Types Tests
    
    @Test func testSixLayerPlatformCompilation() {
        // Verify SixLayerPlatform enum compiles and is accessible
        let platform = SixLayerPlatform.current
        // Platform is non-optional, so just verify it exists
        let _ = platform
        
        // Verify all cases are accessible
        let allPlatforms = SixLayerPlatform.allCases
        #expect(!allPlatforms.isEmpty)
        #expect(allPlatforms.contains(.iOS))
        #expect(allPlatforms.contains(.macOS))
        #expect(allPlatforms.contains(.watchOS))
        #expect(allPlatforms.contains(.tvOS))
        #expect(allPlatforms.contains(.visionOS))
    }
    
    @Test func testDeviceTypeCompilation() {
        // Verify DeviceType enum compiles and is accessible
        let deviceType = DeviceType.current
        // DeviceType is non-optional, so just verify it exists
        let _ = deviceType
        
        // Verify all cases are accessible
        let allDeviceTypes = DeviceType.allCases
        #expect(!allDeviceTypes.isEmpty)
        #expect(allDeviceTypes.contains(.phone))
        #expect(allDeviceTypes.contains(.pad))
        #expect(allDeviceTypes.contains(.mac))
        #expect(allDeviceTypes.contains(.tv))
        #expect(allDeviceTypes.contains(.watch))
        #expect(allDeviceTypes.contains(.car))
        #expect(allDeviceTypes.contains(.vision))
    }
    
    @Test func testDeviceContextCompilation() {
        // Verify DeviceContext enum compiles and is accessible
        let deviceContext = DeviceContext.current
        // DeviceContext is non-optional, so just verify it exists
        let _ = deviceContext
        
        // Verify all cases are accessible
        let allContexts = DeviceContext.allCases
        #expect(!allContexts.isEmpty)
        #expect(allContexts.contains(.standard))
        #expect(allContexts.contains(.carPlay))
        #expect(allContexts.contains(.externalDisplay))
        #expect(allContexts.contains(.splitView))
        #expect(allContexts.contains(.stageManager))
    }
    
    // MARK: - CarPlay Types Tests
    
    @Test func testCarPlayCapabilityDetectionCompilation() {
        // Verify CarPlayCapabilityDetection compiles and is accessible
        let isCarPlayActive = CarPlayCapabilityDetection.isCarPlayActive
        #expect(!isCarPlayActive) // Should be false in test environment
        
        let supportsCarPlay = CarPlayCapabilityDetection.supportsCarPlay
        // Bool is non-optional, so just verify it exists
        let _ = supportsCarPlay
        
        let carPlayDeviceType = CarPlayCapabilityDetection.carPlayDeviceType
        #expect(carPlayDeviceType == .car)
        
        let layoutPreferences = CarPlayCapabilityDetection.carPlayLayoutPreferences
        #expect(layoutPreferences.prefersLargeText)
        #expect(layoutPreferences.prefersHighContrast)
        #expect(layoutPreferences.prefersMinimalUI)
    }
    
    @Test func testCarPlayLayoutPreferencesCompilation() {
        // Verify CarPlayLayoutPreferences compiles and can be instantiated
        let preferences = CarPlayLayoutPreferences()
        #expect(preferences.prefersLargeText)
        #expect(preferences.prefersHighContrast)
        #expect(preferences.prefersMinimalUI)
        #expect(preferences.supportsVoiceControl)
        #expect(preferences.supportsTouch)
        #expect(preferences.supportsKnobControl)
        
        // Test custom initialization
        let customPreferences = CarPlayLayoutPreferences(
            prefersLargeText: false,
            prefersHighContrast: false,
            prefersMinimalUI: false,
            supportsVoiceControl: false,
            supportsTouch: false,
            supportsKnobControl: false
        )
        #expect(!customPreferences.prefersLargeText)
        #expect(!customPreferences.prefersHighContrast)
        #expect(!customPreferences.prefersMinimalUI)
        #expect(!customPreferences.supportsVoiceControl)
        #expect(!customPreferences.supportsTouch)
        #expect(!customPreferences.supportsKnobControl)
    }
    
    @Test func testCarPlayFeatureCompilation() {
        // Verify CarPlayFeature enum compiles and is accessible
        let allFeatures = CarPlayFeature.allCases
        #expect(!allFeatures.isEmpty)
        #expect(allFeatures.contains(.navigation))
        #expect(allFeatures.contains(.music))
        #expect(allFeatures.contains(.phone))
        #expect(allFeatures.contains(.messages))
        #expect(allFeatures.contains(.voiceControl))
        #expect(allFeatures.contains(.knobControl))
        #expect(allFeatures.contains(.touchControl))
    }
    
    // MARK: - Keyboard Types Tests
    
    @Test func testKeyboardTypeCompilation() {
        // Verify KeyboardType enum compiles and is accessible
        let allKeyboardTypes = KeyboardType.allCases
        #expect(!allKeyboardTypes.isEmpty)
        #expect(allKeyboardTypes.contains(.default))
        #expect(allKeyboardTypes.contains(.asciiCapable))
        #expect(allKeyboardTypes.contains(.numbersAndPunctuation))
        #expect(allKeyboardTypes.contains(.URL))
        #expect(allKeyboardTypes.contains(.numberPad))
        #expect(allKeyboardTypes.contains(.phonePad))
        #expect(allKeyboardTypes.contains(.namePhonePad))
        #expect(allKeyboardTypes.contains(.emailAddress))
        #expect(allKeyboardTypes.contains(.decimalPad))
        #expect(allKeyboardTypes.contains(.twitter))
        #expect(allKeyboardTypes.contains(.webSearch))
        
        // Note: platformDecimalKeyboardType() is internal, so we can't test it directly
    }
    
    // MARK: - Form Types Tests
    
    @Test func testFormContentMetricsCompilation() {
        // Verify FormContentMetrics compiles and can be instantiated
        let metrics = FormContentMetrics(
            fieldCount: 5,
            estimatedComplexity: .moderate,
            preferredLayout: .adaptive,
            sectionCount: 2,
            hasComplexContent: true
        )
        #expect(metrics.fieldCount == 5)
        #expect(metrics.estimatedComplexity == .moderate)
        #expect(metrics.preferredLayout == .adaptive)
        #expect(metrics.sectionCount == 2)
        #expect(metrics.hasComplexContent)
        
        // Test default initialization
        let defaultMetrics = FormContentMetrics(fieldCount: 3)
        #expect(defaultMetrics.fieldCount == 3)
        #expect(defaultMetrics.estimatedComplexity == .simple)
        #expect(defaultMetrics.preferredLayout == .adaptive)
        #expect(defaultMetrics.sectionCount == 1)
        #expect(!defaultMetrics.hasComplexContent)
    }
    
    @Test func testFormContentKeyCompilation() {
        // Verify FormContentKey compiles and has proper PreferenceKey conformance
        let defaultValue = FormContentKey.defaultValue
        #expect(defaultValue.fieldCount == 0)
        #expect(defaultValue.estimatedComplexity == .simple)
        #expect(defaultValue.preferredLayout == .adaptive)
        #expect(defaultValue.sectionCount == 1)
        #expect(!defaultValue.hasComplexContent)
        
        // Test reduce function
        var value = FormContentKey.defaultValue
        let newValue = FormContentMetrics(fieldCount: 10, estimatedComplexity: .complex)
        FormContentKey.reduce(value: &value, nextValue: { newValue })
        #expect(value.fieldCount == 10)
        #expect(value.estimatedComplexity == .complex)
    }
    
    @Test func testLayoutPreferenceCompilation() {
        // Verify LayoutPreference enum compiles and is accessible
        let allLayoutPreferences = LayoutPreference.allCases
        #expect(!allLayoutPreferences.isEmpty)
        #expect(allLayoutPreferences.contains(.compact))
        #expect(allLayoutPreferences.contains(.adaptive))
        #expect(allLayoutPreferences.contains(.spacious))
        #expect(allLayoutPreferences.contains(.custom))
        #expect(allLayoutPreferences.contains(.grid))
        #expect(allLayoutPreferences.contains(.list))
    }
    
    // MARK: - Platform Device Capabilities Tests
    
    @Test func testPlatformDeviceCapabilitiesCompilation() {
        // Verify PlatformDeviceCapabilities compiles and is accessible
        let deviceType = PlatformDeviceCapabilities.deviceType
        let _ = deviceType
        
        let supportsHapticFeedback = PlatformDeviceCapabilities.supportsHapticFeedback
        let _ = supportsHapticFeedback
        
        let supportsKeyboardShortcuts = PlatformDeviceCapabilities.supportsKeyboardShortcuts
        let _ = supportsKeyboardShortcuts
        
        let supportsContextMenus = PlatformDeviceCapabilities.supportsContextMenus
        let _ = supportsContextMenus
        
        let supportsCarPlay = PlatformDeviceCapabilities.supportsCarPlay
        let _ = supportsCarPlay
        
        let isCarPlayActive = PlatformDeviceCapabilities.isCarPlayActive
        #expect(!isCarPlayActive) // Should be false in test environment
        
        let deviceContext = PlatformDeviceCapabilities.deviceContext
        let _ = deviceContext
    }
    
    // MARK: - Modal Types Tests
    
    @Test func testModalPlatformCompilation() {
        // Verify ModalPlatform enum compiles and is accessible
        let allModalPlatforms = ModalPlatform.allCases
        #expect(!allModalPlatforms.isEmpty)
        #expect(allModalPlatforms.contains(.iOS))
        #expect(allModalPlatforms.contains(.macOS))
    }
    
    @Test func testModalPresentationTypeCompilation() {
        // Verify ModalPresentationType enum compiles and is accessible
        let allPresentationTypes = ModalPresentationType.allCases
        #expect(!allPresentationTypes.isEmpty)
        #expect(allPresentationTypes.contains(.sheet))
        #expect(allPresentationTypes.contains(.popover))
        #expect(allPresentationTypes.contains(.fullScreen))
        #expect(allPresentationTypes.contains(.custom))
    }
    
    @Test func testModalSizingCompilation() {
        // Verify ModalSizing enum compiles and is accessible
        let allSizingOptions = ModalSizing.allCases
        #expect(!allSizingOptions.isEmpty)
        #expect(allSizingOptions.contains(.small))
        #expect(allSizingOptions.contains(.medium))
        #expect(allSizingOptions.contains(.large))
        #expect(allSizingOptions.contains(.custom))
    }
    
    @Test func testModalConstraintCompilation() {
        // Verify ModalConstraint compiles and can be instantiated
        let constraint = ModalConstraint(
            maxWidth: 300,
            maxHeight: 400,
            preferredSize: CGSize(width: 250, height: 350)
        )
        #expect(constraint.maxWidth == 300)
        #expect(constraint.maxHeight == 400)
        #expect(constraint.preferredSize?.width == 250)
        #expect(constraint.preferredSize?.height == 350)
        
        // Test default initialization
        let defaultConstraint = ModalConstraint()
        #expect(defaultConstraint.maxWidth == nil)
        #expect(defaultConstraint.maxHeight == nil)
        #expect(defaultConstraint.preferredSize == nil)
    }
    
    @Test func testPlatformAdaptationCompilation() {
        // Verify PlatformAdaptation enum compiles and is accessible
        let allAdaptations = PlatformAdaptation.allCases
        #expect(!allAdaptations.isEmpty)
        #expect(allAdaptations.contains(.largeFields))
        #expect(allAdaptations.contains(.standardFields))
        #expect(allAdaptations.contains(.compactFields))
    }
    
    // MARK: - Form Layout Types Tests
    
    @Test func testFormLayoutDecisionCompilation() {
        // Verify FormLayoutDecision compiles and can be instantiated
        let decision = FormLayoutDecision(
            containerType: .form,
            fieldLayout: .standard,
            spacing: .comfortable,
            validation: .realTime
        )
        #expect(decision.containerType == .form)
        #expect(decision.fieldLayout == .standard)
        #expect(decision.spacing == .comfortable)
        #expect(decision.validation == .realTime)
    }
    
    @Test func testFormContainerTypeCompilation() {
        // Verify FormContainerType enum compiles and is accessible
        let allContainerTypes = FormContainerType.allCases
        #expect(!allContainerTypes.isEmpty)
        #expect(allContainerTypes.contains(.form))
        #expect(allContainerTypes.contains(.scrollView))
        #expect(allContainerTypes.contains(.custom))
        #expect(allContainerTypes.contains(.adaptive))
        #expect(allContainerTypes.contains(.standard))
    }
    
    @Test func testValidationStrategyCompilation() {
        // Verify ValidationStrategy enum compiles and is accessible
        let allStrategies = ValidationStrategy.allCases
        #expect(!allStrategies.isEmpty)
        #expect(allStrategies.contains(.none))
        #expect(allStrategies.contains(.realTime))
        #expect(allStrategies.contains(.onSubmit))
        #expect(allStrategies.contains(.custom))
        #expect(allStrategies.contains(.immediate))
        #expect(allStrategies.contains(.deferred))
    }
    
    @Test func testSpacingPreferenceCompilation() {
        // Verify SpacingPreference enum compiles and is accessible
        let allSpacingPreferences = SpacingPreference.allCases
        #expect(!allSpacingPreferences.isEmpty)
        #expect(allSpacingPreferences.contains(.compact))
        #expect(allSpacingPreferences.contains(.comfortable))
        #expect(allSpacingPreferences.contains(.generous))
        #expect(allSpacingPreferences.contains(.standard))
        #expect(allSpacingPreferences.contains(.spacious))
    }
    
    @Test func testFieldLayoutCompilation() {
        // Verify FieldLayout enum compiles and is accessible
        let allFieldLayouts = FieldLayout.allCases
        #expect(!allFieldLayouts.isEmpty)
        #expect(allFieldLayouts.contains(.standard))
        #expect(allFieldLayouts.contains(.compact))
        #expect(allFieldLayouts.contains(.spacious))
        #expect(allFieldLayouts.contains(.adaptive))
        #expect(allFieldLayouts.contains(.vertical))
        #expect(allFieldLayouts.contains(.horizontal))
        #expect(allFieldLayouts.contains(.grid))
    }
    
    // MARK: - Modal Layout Types Tests
    
    @Test func testModalLayoutDecisionCompilation() {
        // Verify ModalLayoutDecision compiles and can be instantiated
        let decision = ModalLayoutDecision(
            presentationType: .sheet,
            sizing: .medium,
            detents: [.small, .medium, .large],
            platformConstraints: [:]
        )
        #expect(decision.presentationType == .sheet)
        #expect(decision.sizing == .medium)
        #expect(decision.detents.count == 3)
        // Note: SheetDetent doesn't conform to Equatable, so we can't use contains
        #expect(decision.platformConstraints.isEmpty)
    }
    
    @Test func testSheetDetentCompilation() {
        // Verify SheetDetent enum compiles and is accessible
        let allDetents = SheetDetent.allCases
        #expect(!allDetents.isEmpty)
        // Note: SheetDetent doesn't conform to Equatable, so we can't use contains
        // We can verify the count and that it's not empty
        
        // Test custom detent
        let customDetent = SheetDetent.custom(height: 200)
        if case .custom(let height) = customDetent {
            #expect(height == 200)
        } else {
            Issue.record("Custom detent should have height 200")
        }
    }
    
    @Test func testFormStrategyCompilation() {
        // Verify FormStrategy compiles and can be instantiated
        let strategy = FormStrategy(
            containerType: .form,
            fieldLayout: .standard,
            validation: .realTime,
            platformAdaptations: [:]
        )
        #expect(strategy.containerType == .form)
        #expect(strategy.fieldLayout == .standard)
        #expect(strategy.validation == .realTime)
        #expect(strategy.platformAdaptations.isEmpty)
    }
    
    // MARK: - Card Layout Types Tests
    
    @Test func testCardLayoutDecisionCompilation() {
        // Verify CardLayoutDecision compiles and can be instantiated
        let decision = CardLayoutDecision(
            layout: .uniform,
            sizing: .fixed,
            interaction: .tap,
            responsive: ResponsiveBehavior(type: .adaptive),
            spacing: 16.0,
            columns: 2
        )
        #expect(decision.layout == .uniform)
        #expect(decision.sizing == .fixed)
        #expect(decision.interaction == .tap)
        #expect(decision.responsive.type == .adaptive)
        #expect(decision.spacing == 16.0)
        #expect(decision.columns == 2)
    }
    
    @Test func testCardLayoutTypeCompilation() {
        // Verify CardLayoutType enum compiles and is accessible
        let allLayoutTypes = CardLayoutType.allCases
        #expect(!allLayoutTypes.isEmpty)
        #expect(allLayoutTypes.contains(.uniform))
        #expect(allLayoutTypes.contains(.contentAware))
        #expect(allLayoutTypes.contains(.aspectRatio))
        #expect(allLayoutTypes.contains(.dynamic))
    }
    
    @Test func testCardSizingCompilation() {
        // Verify CardSizing enum compiles and is accessible
        let allSizingTypes = CardSizing.allCases
        #expect(!allSizingTypes.isEmpty)
        #expect(allSizingTypes.contains(.fixed))
        #expect(allSizingTypes.contains(.flexible))
        #expect(allSizingTypes.contains(.adaptive))
        #expect(allSizingTypes.contains(.contentBased))
    }
    
    @Test func testCardInteractionCompilation() {
        // Verify CardInteraction enum compiles and is accessible
        let allInteractionTypes = CardInteraction.allCases
        #expect(!allInteractionTypes.isEmpty)
        #expect(allInteractionTypes.contains(.tap))
        #expect(allInteractionTypes.contains(.longPress))
        #expect(allInteractionTypes.contains(.drag))
        #expect(allInteractionTypes.contains(.hover))
        #expect(allInteractionTypes.contains(.none))
    }
    
    @Test func testResponsiveBehaviorCompilation() {
        // Verify ResponsiveBehavior compiles and can be instantiated
        let behavior = ResponsiveBehavior(
            type: .adaptive,
            breakpoints: [768, 1024, 1200],
            adaptive: true
        )
        #expect(behavior.type == .adaptive)
        #expect(behavior.breakpoints.count == 3)
        #expect(behavior.breakpoints[0] == 768)
        #expect(behavior.breakpoints[1] == 1024)
        #expect(behavior.breakpoints[2] == 1200)
        #expect(behavior.adaptive)
        
        // Test default initialization
        let defaultBehavior = ResponsiveBehavior(type: .fixed)
        #expect(defaultBehavior.type == .fixed)
        #expect(defaultBehavior.breakpoints.isEmpty)
        #expect(!defaultBehavior.adaptive)
    }
    
    @Test func testResponsiveTypeCompilation() {
        // Verify ResponsiveType enum compiles and is accessible
        let allResponsiveTypes = ResponsiveType.allCases
        #expect(!allResponsiveTypes.isEmpty)
        #expect(allResponsiveTypes.contains(.fixed))
        #expect(allResponsiveTypes.contains(.adaptive))
        #expect(allResponsiveTypes.contains(.fluid))
        #expect(allResponsiveTypes.contains(.breakpoint))
        #expect(allResponsiveTypes.contains(.dynamic))
    }
    
    // MARK: - Cross-Platform Image Types Tests
    
    @Test func testPlatformSizeCompilation() {
        // Verify PlatformSize compiles and can be instantiated
        let size = PlatformSize(width: 100, height: 200)
        #expect(size.width == 100)
        #expect(size.height == 200)
        
        // Test CGSize initialization
        let cgSize = CGSize(width: 150, height: 250)
        let platformSizeFromCG = PlatformSize(cgSize)
        #expect(platformSizeFromCG.width == 150)
        #expect(platformSizeFromCG.height == 250)
        
        // Test conversion back to CGSize/NSSize (using public property)
        // In real code, prefer using .width and .height properties instead
        #if os(iOS)
        let convertedCGSize = platformSizeFromCG.asCGSize
        #expect(convertedCGSize.width == 150)
        #expect(convertedCGSize.height == 250)
        #elseif os(macOS)
        let convertedNSSize = platformSizeFromCG.asNSSize
        #expect(convertedNSSize.width == 150)
        #expect(convertedNSSize.height == 250)
        #endif
    }
    
    @Test func testPlatformImageCompilation() {
        // Verify PlatformImage compiles and can be instantiated
        let emptyImage = PlatformImage()
        #expect(emptyImage.isEmpty)
        #expect(emptyImage.size == .zero)
        
        // Test placeholder creation
        let placeholderImage = PlatformImage.createPlaceholder()
        #expect(!placeholderImage.isEmpty)
        #expect(placeholderImage.size.width == 100)
        #expect(placeholderImage.size.height == 100)
        
        // Test data initialization (with empty data should return nil)
        let emptyData = Data()
        let imageFromEmptyData = PlatformImage(data: emptyData)
        #expect(imageFromEmptyData == nil)
    }
    
    // MARK: - Content Analysis Types Tests
    
    @Test func testContentAnalysisCompilation() {
        // Verify ContentAnalysis compiles and can be instantiated
        let analysis = ContentAnalysis(
            recommendedApproach: .adaptive,
            optimalSpacing: 16.0,
            performanceConsiderations: ["Memory usage", "Rendering performance"]
        )
        #expect(analysis.recommendedApproach == .adaptive)
        #expect(analysis.optimalSpacing == 16.0)
        #expect(analysis.performanceConsiderations.count == 2)
        #expect(analysis.performanceConsiderations.contains("Memory usage"))
        #expect(analysis.performanceConsiderations.contains("Rendering performance"))
        
        // Test default initialization
        let defaultAnalysis = ContentAnalysis(
            recommendedApproach: .compact,
            optimalSpacing: 8.0
        )
        #expect(defaultAnalysis.recommendedApproach == .compact)
        #expect(defaultAnalysis.optimalSpacing == 8.0)
        #expect(defaultAnalysis.performanceConsiderations.isEmpty)
    }
    
    @Test func testLayoutApproachCompilation() {
        // Verify LayoutApproach enum compiles and is accessible
        let allApproaches = LayoutApproach.allCases
        #expect(!allApproaches.isEmpty)
        #expect(allApproaches.contains(.compact))
        #expect(allApproaches.contains(.adaptive))
        #expect(allApproaches.contains(.spacious))
        #expect(allApproaches.contains(.custom))
        #expect(allApproaches.contains(.grid))
        #expect(allApproaches.contains(.uniform))
        #expect(allApproaches.contains(.responsive))
        #expect(allApproaches.contains(.dynamic))
        #expect(allApproaches.contains(.masonry))
        #expect(allApproaches.contains(.list))
    }
    
    // MARK: - Presentation Hints Tests
    
    @Test func testDataTypeHintCompilation() {
        // Verify DataTypeHint enum compiles and is accessible
        let allDataTypeHints = DataTypeHint.allCases
        #expect(!allDataTypeHints.isEmpty)
        #expect(allDataTypeHints.contains(.generic))
        #expect(allDataTypeHints.contains(.text))
        #expect(allDataTypeHints.contains(.number))
        #expect(allDataTypeHints.contains(.date))
        #expect(allDataTypeHints.contains(.image))
        #expect(allDataTypeHints.contains(.boolean))
        #expect(allDataTypeHints.contains(.collection))
        #expect(allDataTypeHints.contains(.numeric))
        #expect(allDataTypeHints.contains(.hierarchical))
        #expect(allDataTypeHints.contains(.temporal))
        #expect(allDataTypeHints.contains(.media))
        #expect(allDataTypeHints.contains(.form))
        #expect(allDataTypeHints.contains(.list))
        #expect(allDataTypeHints.contains(.grid))
        #expect(allDataTypeHints.contains(.chart))
        #expect(allDataTypeHints.contains(.custom))
        #expect(allDataTypeHints.contains(.user))
        #expect(allDataTypeHints.contains(.transaction))
        #expect(allDataTypeHints.contains(.action))
        #expect(allDataTypeHints.contains(.product))
        #expect(allDataTypeHints.contains(.communication))
        #expect(allDataTypeHints.contains(.location))
        #expect(allDataTypeHints.contains(.navigation))
        #expect(allDataTypeHints.contains(.card))
        #expect(allDataTypeHints.contains(.detail))
        #expect(allDataTypeHints.contains(.modal))
        #expect(allDataTypeHints.contains(.sheet))
    }
    
    @Test func testPresentationPreferenceCompilation() {
        // Verify PresentationPreference enum compiles and is accessible
        let allPreferences = PresentationPreference.allCases
        #expect(!allPreferences.isEmpty)
        #expect(allPreferences.contains(.automatic))
        #expect(allPreferences.contains(.minimal))
        #expect(allPreferences.contains(.moderate))
        #expect(allPreferences.contains(.rich))
        #expect(allPreferences.contains(.custom))
        #expect(allPreferences.contains(.detail))
        #expect(allPreferences.contains(.modal))
        #expect(allPreferences.contains(.navigation))
        #expect(allPreferences.contains(.list))
        #expect(allPreferences.contains(.masonry))
        #expect(allPreferences.contains(.standard))
        #expect(allPreferences.contains(.form))
        #expect(allPreferences.contains(.card))
        #expect(allPreferences.contains(.cards))
        #expect(allPreferences.contains(.compact))
        #expect(allPreferences.contains(.grid))
        #expect(allPreferences.contains(.chart))
        #expect(allPreferences.contains(.coverFlow))
    }
    
    @Test func testPresentationContextCompilation() {
        // Verify PresentationContext enum compiles and is accessible
        let allContexts = PresentationContext.allCases
        #expect(!allContexts.isEmpty)
        #expect(allContexts.contains(.dashboard))
        #expect(allContexts.contains(.browse))
        #expect(allContexts.contains(.detail))
        #expect(allContexts.contains(.edit))
        #expect(allContexts.contains(.create))
        #expect(allContexts.contains(.search))
        #expect(allContexts.contains(.settings))
        #expect(allContexts.contains(.profile))
        #expect(allContexts.contains(.summary))
        #expect(allContexts.contains(.list))
        #expect(allContexts.contains(.standard))
        #expect(allContexts.contains(.form))
        #expect(allContexts.contains(.modal))
        #expect(allContexts.contains(.navigation))
        #expect(allContexts.contains(.gallery))
    }
    
    @Test func testContentComplexityCompilation() {
        // Verify ContentComplexity enum compiles and is accessible
        let allComplexities = ContentComplexity.allCases
        #expect(!allComplexities.isEmpty)
        #expect(allComplexities.contains(.simple))
        #expect(allComplexities.contains(.moderate))
        #expect(allComplexities.contains(.complex))
        #expect(allComplexities.contains(.veryComplex))
        #expect(allComplexities.contains(.advanced))
    }
    
    @Test func testPresentationHintsCompilation() {
        // Verify PresentationHints compiles and can be instantiated
        let hints = PresentationHints(
            dataType: .text,
            presentationPreference: .moderate,
            complexity: .moderate,
            context: .dashboard,
            customPreferences: ["theme": "dark", "size": "large"]
        )
        #expect(hints.dataType == .text)
        #expect(hints.presentationPreference == .moderate)
        #expect(hints.complexity == .moderate)
        #expect(hints.context == .dashboard)
        #expect(hints.customPreferences.count == 2)
        #expect(hints.customPreferences["theme"] == "dark")
        #expect(hints.customPreferences["size"] == "large")
        
        // Test default initialization
        let defaultHints = PresentationHints()
        #expect(defaultHints.dataType == .generic)
        #expect(defaultHints.presentationPreference == .automatic)
        #expect(defaultHints.complexity == .moderate)
        #expect(defaultHints.context == .dashboard)
        #expect(defaultHints.customPreferences.isEmpty)
    }
    
    // MARK: - Integration Tests
    
    @Test func testPlatformTypesIntegration() {
        // Test that all types work together without compilation issues
        let platform = SixLayerPlatform.current
        let deviceType = DeviceType.current
        let deviceContext = DeviceContext.current
        
        // Create a comprehensive configuration using multiple types
        let formMetrics = FormContentMetrics(
            fieldCount: 5,
            estimatedComplexity: .moderate,
            preferredLayout: .adaptive
        )
        
        let cardDecision = CardLayoutDecision(
            layout: .uniform,
            sizing: .adaptive,
            interaction: .tap,
            responsive: ResponsiveBehavior(type: .adaptive),
            spacing: 16.0,
            columns: 2
        )
        
        let modalDecision = ModalLayoutDecision(
            presentationType: .sheet,
            sizing: .medium,
            detents: [.small, .medium],
            platformConstraints: [:]
        )
        
        let presentationHints = PresentationHints(
            dataType: .form,
            presentationPreference: .moderate,
            complexity: .moderate,
            context: .dashboard
        )
        
        // Verify all objects were created successfully
        // All these types are non-optional, so just verify they exist
        let _ = platform
        let _ = deviceType
        let _ = deviceContext
        let _ = formMetrics
        let _ = cardDecision
        let _ = modalDecision
        let _ = presentationHints
        
        // Verify cross-type relationships work
        #expect(formMetrics.preferredLayout == .adaptive)
        #expect(cardDecision.responsive.type == .adaptive)
        #expect(modalDecision.presentationType == .sheet)
        #expect(presentationHints.dataType == .form)
    }
    
    @Test func testPlatformTypesSendableCompliance() {
        // Test that Sendable types can be used in concurrent contexts
        let platform = SixLayerPlatform.current
        let deviceType = DeviceType.current
        let layoutPreference = LayoutPreference.adaptive
        let contentComplexity = ContentComplexity.moderate
        
        // These should compile without Sendable warnings
        Task {
            let _ = platform
            let _ = deviceType
            let _ = layoutPreference
            let _ = contentComplexity
        }
    }
}