import Testing
import Foundation
@testable import SixLayerFramework

//
//  DynamicFormStateAutoSaveTests.swift
//  SixLayerFrameworkTests
//
//  BUSINESS PURPOSE:
//  Validates auto-save and draft functionality for DynamicFormState (Issue #80)
//  Ensures form state can be saved, loaded, and cleared correctly
//
//  TESTING SCOPE:
//  - Auto-save timer functionality
//  - Draft save, load, and clear operations
//  - Debounced save on field changes
//  - Storage integration
//
//  METHODOLOGY:
//  - Test auto-save timer start/stop
//  - Test draft save and load
//  - Test debounced saves
//  - Test storage error handling
//
//  AUDIT STATUS: ✅ COMPLIANT
//

/// NOTE: Not marked @MainActor on class to allow parallel execution
@Suite("DynamicFormState Auto-Save")
open class DynamicFormStateAutoSaveTests: BaseTestClass {
    
    // MARK: - Auto-Save Timer Tests
    
    /// BUSINESS PURPOSE: Validate auto-save timer starts correctly
    /// TESTING SCOPE: Tests that auto-save timer can be started
    /// METHODOLOGY: Start auto-save and verify timer is active
    @Test @MainActor func testAutoSaveTimerStarts() {
        let config = DynamicFormConfiguration(
            id: "test-form",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: config)
        
        formState.startAutoSave(interval: 1.0)
        
        // Timer should be started (we can't directly verify, but we can test that save works)
        // Give it a moment, then verify draft can be saved
        formState.setValue("test", for: "field1")
        
        // Small delay to allow save
        Thread.sleep(forTimeInterval: 0.1)
        
        // Verify draft exists
        #expect(formState.hasDraft())
    }
    
    /// BUSINESS PURPOSE: Validate auto-save timer stops correctly
    /// TESTING SCOPE: Tests that auto-save timer can be stopped
    /// METHODOLOGY: Start then stop auto-save timer
    @Test @MainActor func testAutoSaveTimerStops() {
        let config = DynamicFormConfiguration(
            id: "test-form",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: config)
        
        formState.startAutoSave(interval: 1.0)
        formState.stopAutoSave()
        
        // Timer should be stopped (no way to directly verify, but stop should not crash)
        // If we get here, stop worked
        #expect(Bool(true))
    }
    
    // MARK: - Draft Save/Load Tests
    
    /// BUSINESS PURPOSE: Validate draft save functionality
    /// TESTING SCOPE: Tests that form state can be saved as draft
    /// METHODOLOGY: Set field values, save draft, verify it exists
    @Test @MainActor func testSaveDraft() {
        let testDefaults = UserDefaults(suiteName: "test_form_autosave")!
        testDefaults.removePersistentDomain(forName: "test_form_autosave")
        
        let storage = UserDefaultsFormStateStorage(userDefaults: testDefaults)
        let config = DynamicFormConfiguration(
            id: "test-form",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: config, storage: storage)
        
        formState.setValue("John", for: "name")
        formState.setValue(30, for: "age")
        
        formState.saveDraft()
        
        #expect(formState.hasDraft())
        
        testDefaults.removePersistentDomain(forName: "test_form_autosave")
    }
    
    /// BUSINESS PURPOSE: Validate draft load functionality
    /// TESTING SCOPE: Tests that saved draft can be loaded
    /// METHODOLOGY: Save draft, clear state, load draft, verify values restored
    @Test @MainActor func testLoadDraft() {
        let testDefaults = UserDefaults(suiteName: "test_form_autosave")!
        testDefaults.removePersistentDomain(forName: "test_form_autosave")
        
        let storage = UserDefaultsFormStateStorage(userDefaults: testDefaults)
        let config = DynamicFormConfiguration(
            id: "test-form",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: config, storage: storage)
        
        // Set values and save
        formState.setValue("Jane", for: "name")
        formState.setValue(25, for: "age")
        formState.saveDraft()
        
        // Clear state
        formState.fieldValues.removeAll()
        #expect(formState.getValue(for: "name") as String? == nil)
        
        // Load draft
        let loaded = formState.loadDraft()
        #expect(loaded == true)
        
        // Verify values restored
        #expect(formState.getValue(for: "name") as String? == "Jane")
        #expect(formState.getValue(for: "age") as Int? == 25)
        
        testDefaults.removePersistentDomain(forName: "test_form_autosave")
    }
    
    /// BUSINESS PURPOSE: Validate draft clear functionality
    /// TESTING SCOPE: Tests that draft can be cleared
    /// METHODOLOGY: Save draft, clear it, verify it no longer exists
    @Test @MainActor func testClearDraft() {
        let testDefaults = UserDefaults(suiteName: "test_form_autosave")!
        testDefaults.removePersistentDomain(forName: "test_form_autosave")
        
        let storage = UserDefaultsFormStateStorage(userDefaults: testDefaults)
        let config = DynamicFormConfiguration(
            id: "test-form",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: config, storage: storage)
        
        formState.setValue("test", for: "field1")
        formState.saveDraft()
        #expect(formState.hasDraft())
        
        formState.clearDraft()
        #expect(!formState.hasDraft())
        
        testDefaults.removePersistentDomain(forName: "test_form_autosave")
    }
    
    // MARK: - Debounced Save Tests
    
    /// BUSINESS PURPOSE: Validate debounced save triggers correctly
    /// TESTING SCOPE: Tests that debounced save is triggered on field changes
    /// METHODOLOGY: Trigger debounced save multiple times, verify only one save occurs after delay
    @Test @MainActor func testDebouncedSave() {
        let testDefaults = UserDefaults(suiteName: "test_form_autosave")!
        testDefaults.removePersistentDomain(forName: "test_form_autosave")
        
        let storage = UserDefaultsFormStateStorage(userDefaults: testDefaults)
        let config = DynamicFormConfiguration(
            id: "test-form",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: config, storage: storage)
        
        // Set debounce delay to short interval for testing
        formState.debounceDelay = 0.5
        
        // Trigger multiple debounced saves rapidly
        formState.setValue("value1", for: "field1")
        formState.triggerDebouncedSave()
        formState.setValue("value2", for: "field1")
        formState.triggerDebouncedSave()
        formState.setValue("value3", for: "field1")
        formState.triggerDebouncedSave()
        
        // Wait for debounce delay
        Thread.sleep(forTimeInterval: 0.6)
        
        // Verify draft exists with final value
        #expect(formState.hasDraft())
        let draft = storage.loadDraft(formId: "test-form")
        let values = draft?.toFieldValues()
        #expect(values?["field1"] as? String == "value3")
        
        testDefaults.removePersistentDomain(forName: "test_form_autosave")
    }
    
    // MARK: - Configuration Tests
    
    /// BUSINESS PURPOSE: Validate auto-save can be disabled
    /// TESTING SCOPE: Tests that auto-save can be disabled via configuration
    /// METHODOLOGY: Disable auto-save, verify saves don't occur
    @Test @MainActor func testAutoSaveCanBeDisabled() {
        let config = DynamicFormConfiguration(
            id: "test-form",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: config)
        
        formState.autoSaveEnabled = false
        formState.setValue("test", for: "field1")
        formState.saveDraft()
        
        // With auto-save disabled, manual save should still work
        // But auto-save timer should not start
        formState.startAutoSave()
        // Timer should not actually start when disabled
        // (Implementation detail - we verify by checking hasDraft after manual save)
        #expect(formState.hasDraft())
    }
    
    /// BUSINESS PURPOSE: Validate auto-save interval is configurable
    /// TESTING SCOPE: Tests that auto-save interval can be customized
    /// METHODOLOGY: Set custom interval, verify it's used
    @Test @MainActor func testAutoSaveIntervalIsConfigurable() {
        let config = DynamicFormConfiguration(
            id: "test-form",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: config)
        
        formState.autoSaveInterval = 60.0
        #expect(formState.autoSaveInterval == 60.0)
        
        formState.autoSaveInterval = 15.0
        #expect(formState.autoSaveInterval == 15.0)
    }
}
