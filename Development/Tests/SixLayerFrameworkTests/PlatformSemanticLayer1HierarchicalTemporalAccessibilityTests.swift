import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for hierarchical and temporal data functions in PlatformSemanticLayer1.swift
/// Ensures hierarchical and temporal data presentation functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
final class PlatformSemanticLayer1HierarchicalTemporalAccessibilityTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
        await setupTestEnvironment()
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            config.resetToDefaults()
            config.enableAutoIDs = true
            config.namespace = "SixLayer"
            config.mode = .automatic
            config.enableDebugLogging = false
        }
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
        await cleanupTestEnvironment()
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            config.resetToDefaults()
        }
    }
    
    // MARK: - Test Data Models
    
    struct HierarchicalTestItem: Identifiable {
        let id = UUID()
        let title: String
        let children: [HierarchicalTestItem]
    }
    
    struct TemporalTestItem: Identifiable {
        let id = UUID()
        let title: String
        let timestamp: Date
    }
    
    // MARK: - Hierarchical Data Presentation Tests
    
    /// BUSINESS PURPOSE: Validates that platformPresentHierarchicalData_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformPresentHierarchicalDataL1GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let testData = GenericHierarchicalItem(
            title: "Root Item",
            level: 0,
            children: [
                GenericHierarchicalItem(title: "Child 1", level: 1),
                GenericHierarchicalItem(title: "Child 2", level: 1)
            ]
        )
        
        let hints = PresentationHints(
            dataType: .hierarchical,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .modal,
            customPreferences: [:]
        )
        
        let view = platformPresentHierarchicalData_L1(
            items: [testData],
            hints: hints
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.*element.*hierarchicaldata", 
                platform: .iOS,
                componentName: "platformPresentHierarchicalData_L1"
            )
        }
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentHierarchicalData_L1 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPresentHierarchicalData_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformPresentHierarchicalDataL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let testData = GenericHierarchicalItem(
            title: "Root Item",
            level: 0,
            children: [
                GenericHierarchicalItem(title: "Child 1", level: 1),
                GenericHierarchicalItem(title: "Child 2", level: 1)
            ]
        )
        
        let hints = PresentationHints(
            dataType: .hierarchical,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .modal,
            customPreferences: [:]
        )
        
        let view = platformPresentHierarchicalData_L1(
            items: [testData],
            hints: hints
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.*element.*hierarchicaldata", 
                platform: .macOS,
                componentName: "platformPresentHierarchicalData_L1"
            )
        }
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentHierarchicalData_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - Temporal Data Presentation Tests
    
    /// BUSINESS PURPOSE: Validates that platformPresentTemporalData_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformPresentTemporalDataL1GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let testData = GenericTemporalItem(
            title: "Event 1",
            date: Date(),
            duration: 3600
        )
        
        let hints = PresentationHints(
            dataType: .temporal,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .modal,
            customPreferences: [:]
        )
        
        let view = platformPresentTemporalData_L1(
            items: [testData],
            hints: hints
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.*element.*temporaldata", 
                platform: .iOS,
                componentName: "platformPresentTemporalData_L1"
            )
        }
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentTemporalData_L1 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPresentTemporalData_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformPresentTemporalDataL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let testData = GenericTemporalItem(
            title: "Event 1",
            date: Date(),
            duration: 3600
        )
        
        let hints = PresentationHints(
            dataType: .temporal,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .modal,
            customPreferences: [:]
        )
        
        let view = platformPresentTemporalData_L1(
            items: [testData],
            hints: hints
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.*element.*temporaldata", 
                platform: .macOS,
                componentName: "platformPresentTemporalData_L1"
            )
        }
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentTemporalData_L1 should generate accessibility identifiers on macOS")
    }
}
