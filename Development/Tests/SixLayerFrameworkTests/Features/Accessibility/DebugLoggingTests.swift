//
//  DebugLoggingTDDTests.swift
//  SixLayerFrameworkTests
//
//  TDD Tests for Debug Logging Functionality
//  Tests written FIRST, implementation will follow
//

import Testing
import Foundation
@testable import SixLayerFramework

/// TDD Tests for Debug Logging Functionality
/// Following Red-Green-Refactor cycle: Write failing tests first, then implement
@MainActor
@Suite("Debug Logging T D D")
open class DebugLoggingTDDTests: BaseTestClass {
    
    // MARK: - Test Setup// MARK: - AccessibilityIdentifierGenerator Tests
    
    /// TEST: AccessibilityIdentifierGenerator should exist and be instantiable
    @Test func testAccessibilityIdentifierGeneratorExists() async {
        // Given: We need an AccessibilityIdentifierGenerator
        // When: Creating an instance
        let generator = AccessibilityIdentifierGenerator()
        
        // Then: It should be created successfully
        #expect(generator != nil, "AccessibilityIdentifierGenerator should be instantiable")
    }
    
    /// TEST: generateID method should exist and return a string
    @Test func testGenerateIDMethodExists() async {
        // Given: An AccessibilityIdentifierGenerator
        let generator = AccessibilityIdentifierGenerator()
        
        // When: Calling generateID
        let id = generator.generateID(for: "test", role: "button", context: "ui")
        
        // Then: It should return a non-empty string
        #expect(!id.isEmpty, "generateID should return a non-empty string")
        #expect(id.contains("test"), "Generated ID should contain the component name")
    }
    
    /// TEST: generateID should respect debug logging when enabled
    @Test func testGenerateIDRespectsDebugLoggingWhenEnabled() async {
        // Given: Debug logging is enabled
        let config = AccessibilityIdentifierConfig.shared
        config.enableDebugLogging = true
        config.clearDebugLog()
        
        let generator = AccessibilityIdentifierGenerator()
        
        // When: Generating an ID
        let id = generator.generateID(for: "testButton", role: "button", context: "ui")
        
        // Then: Debug log should contain the generation event
        let debugLog = config.getDebugLog()
        #expect(!debugLog.isEmpty, "Debug log should not be empty when debug logging is enabled")
        #expect(debugLog.contains("testButton"), "Debug log should contain component name")
        #expect(debugLog.contains("button"), "Debug log should contain role")
        #expect(debugLog.contains(id), "Debug log should contain generated ID")
    }
    
    /// TEST: generateID should not log when debug logging is disabled
    @Test func testGenerateIDDoesNotLogWhenDebugLoggingDisabled() async {
        // Given: Debug logging is disabled
        let config = AccessibilityIdentifierConfig.shared
        config.enableDebugLogging = false
        config.clearDebugLog()
        
        let generator = AccessibilityIdentifierGenerator()
        
        // When: Generating an ID
        let _ = generator.generateID(for: "testButton", role: "button", context: "ui")
        
        // Then: Debug log should be empty
        let debugLog = config.getDebugLog()
        #expect(debugLog.isEmpty, "Debug log should be empty when debug logging is disabled")
    }
    
    // MARK: - Debug Log Management Tests
    
    /// TEST: getDebugLog method should exist and return a string
    @Test func testGetDebugLogMethodExists() async {
        // Given: AccessibilityIdentifierConfig
        let config = AccessibilityIdentifierConfig.shared
        
        // When: Getting debug log
        let debugLog = config.getDebugLog()
        
        // Then: It should return a string (may be empty)
        #expect(debugLog is String, "getDebugLog should return a String")
    }
    
    /// TEST: clearDebugLog method should exist and clear the log
    @Test func testClearDebugLogMethodExists() async {
        // Given: Debug logging is enabled and we have some log entries
        let config = AccessibilityIdentifierConfig.shared
        config.enableDebugLogging = true
        
        let generator = AccessibilityIdentifierGenerator()
        let _ = generator.generateID(for: "test", role: "button", context: "ui")
        
        // Verify we have log entries
        let initialLog = config.getDebugLog()
        #expect(!initialLog.isEmpty, "Should have log entries before clearing")
        
        // When: Clearing the debug log
        config.clearDebugLog()
        
        // Then: Debug log should be empty
        let clearedLog = config.getDebugLog()
        #expect(clearedLog.isEmpty, "Debug log should be empty after clearing")
    }
    
    /// TEST: Debug log should accumulate multiple entries
    @Test func testDebugLogAccumulatesMultipleEntries() async {
        // Given: Debug logging is enabled
        let config = AccessibilityIdentifierConfig.shared
        config.enableDebugLogging = true
        config.clearDebugLog()
        
        let generator = AccessibilityIdentifierGenerator()
        
        // When: Generating multiple IDs
        let _ = generator.generateID(for: "button1", role: "button", context: "ui")
        let _ = generator.generateID(for: "button2", role: "button", context: "ui")
        let _ = generator.generateID(for: "textField", role: "textField", context: "form")
        
        // Then: Debug log should contain all entries
        let debugLog = config.getDebugLog()
        #expect(debugLog.contains("button1"), "Debug log should contain first button")
        #expect(debugLog.contains("button2"), "Debug log should contain second button")
        #expect(debugLog.contains("textField"), "Debug log should contain text field")
    }
    
    /// TEST: Debug log should include timestamps
    @Test func testDebugLogIncludesTimestamps() async {
        // Given: Debug logging is enabled
        let config = AccessibilityIdentifierConfig.shared
        config.enableDebugLogging = true
        config.clearDebugLog()
        
        let generator = AccessibilityIdentifierGenerator()
        
        // When: Generating an ID
        let _ = generator.generateID(for: "test", role: "button", context: "ui")
        
        // Then: Debug log should contain timestamp information
        let debugLog = config.getDebugLog()
        #expect(debugLog.contains(":"), "Debug log should contain timestamp (colon indicates time format)")
    }
    
    /// TEST: Debug log should be formatted consistently
    @Test func testDebugLogFormatIsConsistent() async {
        // Given: Debug logging is enabled
        let config = AccessibilityIdentifierConfig.shared
        config.enableDebugLogging = true
        config.clearDebugLog()
        
        let generator = AccessibilityIdentifierGenerator()
        
        // When: Generating an ID
        let id = generator.generateID(for: "testButton", role: "button", context: "ui")
        
        // Then: Debug log should have consistent format
        let debugLog = config.getDebugLog()
        #expect(debugLog.contains("Generated ID"), "Debug log should contain 'Generated ID' label")
        #expect(debugLog.contains("for:"), "Debug log should contain 'for:' label")
        #expect(debugLog.contains("role:"), "Debug log should contain 'role:' label")
        #expect(debugLog.contains("context:"), "Debug log should contain 'context:' label")
    }
    
    // MARK: - Configuration Integration Tests
    
    /// TEST: Debug logging should respect enableDebugLogging flag
    @Test func testDebugLoggingRespectsEnableFlag() async {
        // Given: AccessibilityIdentifierConfig
        let config = AccessibilityIdentifierConfig.shared
        config.clearDebugLog()
        
        let generator = AccessibilityIdentifierGenerator()
        
        // When: Debug logging is disabled
        config.enableDebugLogging = false
        let _ = generator.generateID(for: "test1", role: "button", context: "ui")
        
        // Then: No log entries should be created
        let logWhenDisabled = config.getDebugLog()
        #expect(logWhenDisabled.isEmpty, "No log entries when debug logging is disabled")
        
        // When: Debug logging is enabled
        config.enableDebugLogging = true
        let _ = generator.generateID(for: "test2", role: "button", context: "ui")
        
        // Then: Log entries should be created
        let logWhenEnabled = config.getDebugLog()
        #expect(!logWhenEnabled.isEmpty, "Log entries should be created when debug logging is enabled")
        #expect(logWhenEnabled.contains("test2"), "Log should contain the second test entry")
    }
    
    /// TEST: Debug log should persist across multiple generator instances
    @Test func testDebugLogPersistsAcrossGeneratorInstances() async {
        // Given: Debug logging is enabled
        let config = AccessibilityIdentifierConfig.shared
        config.enableDebugLogging = true
        config.clearDebugLog()
        
        // When: Using multiple generator instances
        let generator1 = AccessibilityIdentifierGenerator()
        let generator2 = AccessibilityIdentifierGenerator()
        
        let _ = generator1.generateID(for: "test1", role: "button", context: "ui")
        let _ = generator2.generateID(for: "test2", role: "button", context: "ui")
        
        // Then: All entries should be in the same log
        let debugLog = config.getDebugLog()
        #expect(debugLog.contains("test1"), "Log should contain entry from first generator")
        #expect(debugLog.contains("test2"), "Log should contain entry from second generator")
    }
    
    // MARK: - Edge Cases Tests
    
    /// TEST: Debug logging should handle empty component names
    @Test func testDebugLoggingHandlesEmptyComponentNames() async {
        // Given: Debug logging is enabled
        let config = AccessibilityIdentifierConfig.shared
        config.enableDebugLogging = true
        config.clearDebugLog()
        
        let generator = AccessibilityIdentifierGenerator()
        
        // When: Generating ID with empty component name
        let id = generator.generateID(for: "", role: "button", context: "ui")
        
        // Then: Should still generate ID and log it
        #expect(!id.isEmpty, "Should generate ID even with empty component name")
        let debugLog = config.getDebugLog()
        #expect(!debugLog.isEmpty, "Should still log even with empty component name")
    }
    
    /// TEST: Debug logging should handle special characters in component names
    @Test func testDebugLoggingHandlesSpecialCharacters() async {
        // Given: Debug logging is enabled
        let config = AccessibilityIdentifierConfig.shared
        config.enableDebugLogging = true
        config.clearDebugLog()
        
        let generator = AccessibilityIdentifierGenerator()
        
        // When: Generating ID with special characters
        let specialName = "test-button_with.special@chars"
        let id = generator.generateID(for: specialName, role: "button", context: "ui")
        
        // Then: Should handle special characters gracefully
        #expect(!id.isEmpty, "Should generate ID with special characters")
        let debugLog = config.getDebugLog()
        #expect(debugLog.contains(specialName), "Debug log should contain special characters")
    }
    
    /// TEST: Debug log should have reasonable size limits
    @Test func testDebugLogHasReasonableSizeLimits() async {
        // Given: Debug logging is enabled
        let config = AccessibilityIdentifierConfig.shared
        config.enableDebugLogging = true
        config.clearDebugLog()
        
        let generator = AccessibilityIdentifierGenerator()
        
        // When: Generating many IDs (simulate heavy usage)
        for i in 1...100 {
            let _ = generator.generateID(for: "button\(i)", role: "button", context: "ui")
        }
        
        // Then: Debug log should not grow indefinitely
        let debugLog = config.getDebugLog()
        #expect(debugLog.count < 100000, "Debug log should not grow beyond reasonable limits")
        #expect(debugLog.contains("button100"), "Should still contain recent entries")
    }
}
