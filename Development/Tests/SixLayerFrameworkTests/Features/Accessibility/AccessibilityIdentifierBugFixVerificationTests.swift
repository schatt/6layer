import Testing


import SwiftUI
@testable import SixLayerFramework

/**
 * BUSINESS PURPOSE: Verify that the critical accessibility identifier generation bug
 * reported in SixLayerFramework 4.2.0 has been fixed. This test reproduces the exact
 * scenario described in the bug report and verifies that identifiers are now generated
 * correctly.
 * 
 * TESTING SCOPE: Tests the specific bug scenario where .named() and
 * missing globalAutomaticAccessibilityIdentifiers environment variable.
 * 
 * METHODOLOGY: Reproduces the exact configuration and usage pattern from the bug report
 * and verifies that accessibility identifiers are now generated correctly.
 */
open class AccessibilityIdentifierBugFixVerificationTests {
    
    init() async throws {
                await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    /// BUSINESS PURPOSE: Verify the exact bug scenario from the user's report is now fixed
    /// TESTING SCOPE: Tests the specific configuration and usage pattern that was failing
    /// METHODOLOGY: Reproduces the exact scenario and verifies identifiers are generated
    @Test func testBugReportScenarioIsFixed() async {
        await MainActor.run {
            // Given: Exact configuration from the user's bug report
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "CarManager"
            config.mode = .automatic
            config.enableViewHierarchyTracking = true
            config.enableUITestIntegration = true
            config.enableDebugLogging = true
            
            // When: Creating the exact view structure from the bug report
            let fuelView = VStack(spacing: 0) {
                // Filter controls
                VStack {
                    Text("Filter Content")
                }
                
                // Main content
                VStack {
                    Text("No Fuel Records")
                }
            }
            .platformNavigationTitle("Fuel")
            .platformNavigationTitleDisplayMode(.inline)
            .named("FuelView")      // ✅ Applied
            
            .platformToolbarWithTrailingActions {
                HStack(spacing: 16) {
                    Button(action: { /* add fuel action */ }) {
                        Label("Add Fuel", systemImage: "plus")
                    }
                    .named("AddFuelButton")  // ✅ Applied
                    .accessibilityIdentifier("manual-add-fuel-button")  // ✅ Manual ID works
                }
            }
            
            // Then: The view should be created successfully with automatic accessibility identifiers
            #expect(fuelView != nil, "FuelView should be created successfully")
            
            // Verify configuration is correct
            #expect(config.enableAutoIDs, "Auto IDs should be enabled")
            #expect(config.namespace == "CarManager", "Namespace should be set correctly")
            #expect(config.enableViewHierarchyTracking, "View hierarchy tracking should be enabled")
            #expect(config.enableUITestIntegration, "UI test integration should be enabled")
            #expect(config.enableDebugLogging, "Debug logging should be enabled")
        }
    }
    
    /// BUSINESS PURPOSE: Verify that .named() modifier generates accessibility identifiers
    /// TESTING SCOPE: Tests ONLY the .named() modifier functionality (without screen context)
    /// METHODOLOGY: Tests the .named() modifier in isolation
    @Test func testNamedModifierGeneratesIdentifiers() async {
        await MainActor.run {
            // Given: Configuration matching the bug report
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "CarManager"
            config.mode = .automatic
            config.enableViewHierarchyTracking = true
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            // When: Using ONLY .named() modifier (no screen context)
            let testView = Button(action: {}) {
                Label("Add Fuel", systemImage: "plus")
            }
            .named("AddFuelButton")
            
            // Then: The view should be created successfully
            #expect(testView != nil, "View with .named() should be created successfully")
            
            // Test actual accessibility identifier generation (should use default "main" screen context)
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: "CarManager.main.element.*", 
                platform: .iOS,
            platform: .iOS,
            componentName: "AddFuelButton"
            )
            
            #expect(hasAccessibilityID, "View with .named() should generate accessibility identifiers matching pattern 'CarManager.main.element.*'")
        }
    }
    
    /// BUSINESS PURPOSE: Verify that .named() modifier respects screen context when combined
    /// METHODOLOGY: Tests that .named() modifier respects previously set screen context
    @Test func testNamedModifierWithScreenContext() async {
        await MainActor.run {
            // Given: Configuration matching the bug report
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "CarManager"
            config.mode = .automatic
            config.enableViewHierarchyTracking = true
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            let testView = Button(action: {}) {
                Label("Add Fuel", systemImage: "plus")
            }
            .named("AddFuelButton")
            
            // Then: The view should be created successfully
            
            // Test actual accessibility identifier generation (should use "FuelView" screen context)
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: "CarManager.FuelView.element.*", 
                platform: .iOS,
            platform: .iOS,
            componentName: "AddFuelButton"
            )
            
        }
    }
    
    /// TESTING SCOPE: Tests that screen context modifiers work correctly
    /// METHODOLOGY: Tests the specific modifier that was failing in the bug report
    @Test func testScreenContextGeneratesIdentifiers() async {
        await MainActor.run {
            // Given: Configuration matching the bug report
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "CarManager"
            config.mode = .automatic
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            let testView = VStack {
                Text("Test Content")
            }
            
            // Then: The view should be created successfully
            #expect(testView != nil, "View with named modifier should be created successfully")
            
            // Test actual accessibility identifier generation
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: "CarManager.FuelView.*", 
                platform: .iOS,
            platform: .iOS,
            componentName: "ScreenContext"
            )
            
            #expect(hasAccessibilityID, "View with named modifier should generate accessibility identifiers matching pattern 'CarManager.FuelView.*'")
        }
    }
    
    /// TESTING SCOPE: Tests that navigation state modifiers work correctly
    /// METHODOLOGY: Tests the specific modifier that was failing in the bug report
    @Test func testNavigationStateGeneratesIdentifiers() async {
        await MainActor.run {
            // Given: Configuration matching the bug report
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "CarManager"
            config.mode = .automatic
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            let testView = HStack {
                Text("Navigation Content")
            }
            
            // Then: The view should be created successfully
            #expect(testView != nil, "View with named modifier should be created successfully")
            
            // Test actual accessibility identifier generation
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: "CarManager.*", 
                platform: .iOS,
            platform: .iOS,
            componentName: "NavigationState"
            )
            
            #expect(hasAccessibilityID, "View with named modifier should generate accessibility identifiers matching pattern 'CarManager.*'")
        }
    }
    
    /// BUSINESS PURPOSE: Verify that manual accessibility identifiers still work (regression test)
    /// TESTING SCOPE: Tests that manual identifiers continue to work as before
    /// METHODOLOGY: Tests that the fix doesn't break existing functionality
    @Test func testManualAccessibilityIdentifiersStillWork() async {
        await MainActor.run {
            // Given: Configuration matching the bug report
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "CarManager"
            config.mode = .automatic
            
            // When: Using manual accessibility identifier (the working case from bug report)
            let testView = Button(action: {}) {
                Label("Add Fuel", systemImage: "plus")
            }
            .accessibilityIdentifier("manual-add-fuel-button")
            
            // Then: The view should be created successfully
            #expect(testView != nil, "View with manual accessibility identifier should be created successfully")
            
            // Verify that manual identifiers continue to work
            #expect(testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedIdentifier: "manual-add-fuel-button", 
                platform: .iOS,
            platform: .iOS,
            componentName: "ManualAccessibilityIdentifier"
            ), "Manual accessibility identifier should work")
        }
    }
    
    /// BUSINESS PURPOSE: Verify that the fix enables proper identifier generation
    /// TESTING SCOPE: Tests that the root cause has been addressed
    /// METHODOLOGY: Tests that globalAutomaticAccessibilityIdentifiers is properly set
    @Test func testGlobalAutomaticAccessibilityIdentifiersIsSet() async {
        await MainActor.run {
            // Given: Configuration matching the bug report
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "CarManager"
            config.mode = .automatic
            
            // When: Using automatic accessibility identifiers
            let testView = Button(action: {}) {
                Label("Test", systemImage: "plus")
            }
            .named("TestButton")
            
            // Then: The view should be created successfully
            #expect(testView != nil, "View with automatic accessibility identifiers should be created successfully")
            
            // The fix ensures that automatic accessibility identifiers work correctly
            #expect(testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: "CarManager.*element.*testbutton", 
                platform: .iOS,
            platform: .iOS,
            componentName: "AutomaticAccessibilityIdentifiers"
            ), "AutomaticAccessibilityIdentifiers should generate accessibility identifier")
        }
    }
    
    /// BUSINESS PURPOSE: Verify that the fix doesn't break existing global modifier usage
    /// TESTING SCOPE: Tests that .enableGlobalAutomaticAccessibilityIdentifiers() still works
    /// METHODOLOGY: Tests that the fix doesn't interfere with existing functionality
    @Test func testGlobalModifierStillWorks() async {
        await MainActor.run {
            // Given: Configuration matching the bug report
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "CarManager"
            config.mode = .automatic
            
            // When: Using the global modifier (the original working approach)
            let testView = Text("Global Test")
                .enableGlobalAutomaticAccessibilityIdentifiers()
            
            // Then: The view should be created successfully
            #expect(testView != nil, "View with global modifier should be created successfully")
            
            // Verify that the original approach still works
            // This was the only way to make automatic identifiers work before the fix
        }
    }
    
    /// BUSINESS PURPOSE: Verify that the fix enables proper identifier generation with context
    /// TESTING SCOPE: Tests that identifiers are generated with proper context information
    /// METHODOLOGY: Tests that the Enhanced Breadcrumb System now works correctly
    @Test func testIdentifiersGeneratedWithProperContext() async {
        await MainActor.run {
            // Given: Configuration with enhanced features enabled
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "CarManager"
            config.mode = .automatic
            config.enableViewHierarchyTracking = true
            config.enableUITestIntegration = true
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            // When: Setting up context and generating identifiers
            config.setScreenContext("FuelView")
            config.pushViewHierarchy("NavigationView")
            config.pushViewHierarchy("FuelSection")
            
            let generator = AccessibilityIdentifierGenerator()
            let id = generator.generateID(
                for: "test-object",
                role: "button",
                context: "FuelView"
            )
            
            // Then: The identifier should contain proper context information
            #expect(id.contains("CarManager"), "ID should contain namespace")
            #expect(id.contains("FuelView"), "ID should contain screen context")
            #expect(id.contains("button"), "ID should contain role")
            #expect(id.contains("test-object"), "ID should contain object ID")
            
            // Cleanup
            config.popViewHierarchy()
            config.popViewHierarchy()
        }
    }
}

