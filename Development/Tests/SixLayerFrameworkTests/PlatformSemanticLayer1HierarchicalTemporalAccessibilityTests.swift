import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for hierarchical and temporal data functions in PlatformSemanticLayer1.swift
/// Ensures hierarchical and temporal data presentation functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
@MainActor
final class PlatformSemanticLayer1HierarchicalTemporalAccessibilityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    override func tearDown() {
        super.tearDown()
        cleanupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
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
        let testData = HierarchicalTestItem(
            title: "Root Item",
            children: [
                HierarchicalTestItem(title: "Child 1", children: []),
                HierarchicalTestItem(title: "Child 2", children: [])
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
            data: testData,
            hints: hints,
            onItemSelected: { _ in },
            onItemExpanded: { _ in },
            onItemCollapsed: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*hierarchicaldata", 
            platform: .iOS,
            componentName: "platformPresentHierarchicalData_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentHierarchicalData_L1 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPresentHierarchicalData_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformPresentHierarchicalDataL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let testData = HierarchicalTestItem(
            title: "Root Item",
            children: [
                HierarchicalTestItem(title: "Child 1", children: []),
                HierarchicalTestItem(title: "Child 2", children: [])
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
            data: testData,
            hints: hints,
            onItemSelected: { _ in },
            onItemExpanded: { _ in },
            onItemCollapsed: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*hierarchicaldata", 
            platform: .macOS,
            componentName: "platformPresentHierarchicalData_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentHierarchicalData_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - Temporal Data Presentation Tests
    
    /// BUSINESS PURPOSE: Validates that platformPresentTemporalData_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformPresentTemporalDataL1GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let testData = TemporalTestItem(
            title: "Event 1",
            timestamp: Date()
        )
        
        let hints = PresentationHints(
            dataType: .temporal,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .modal,
            customPreferences: [:]
        )
        
        let view = platformPresentTemporalData_L1(
            data: testData,
            hints: hints,
            onItemSelected: { _ in },
            onTimeRangeChanged: { _, _ in }
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*temporaldata", 
            platform: .iOS,
            componentName: "platformPresentTemporalData_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentTemporalData_L1 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPresentTemporalData_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformPresentTemporalDataL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let testData = TemporalTestItem(
            title: "Event 1",
            timestamp: Date()
        )
        
        let hints = PresentationHints(
            dataType: .temporal,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .modal,
            customPreferences: [:]
        )
        
        let view = platformPresentTemporalData_L1(
            data: testData,
            hints: hints,
            onItemSelected: { _ in },
            onTimeRangeChanged: { _, _ in }
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*temporaldata", 
            platform: .macOS,
            componentName: "platformPresentTemporalData_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentTemporalData_L1 should generate accessibility identifiers on macOS")
    }
}

