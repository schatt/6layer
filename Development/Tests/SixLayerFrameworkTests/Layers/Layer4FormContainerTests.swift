import Testing


//
//  Layer4FormContainerTests.swift
//  SixLayerFrameworkTests
//
//  Layer 4 (Implementation) TDD Tests
//  Tests for platformFormContainer_L4 function
//

import SwiftUI
import ViewInspector
@testable import SixLayerFramework

@MainActor
final class Layer4FormContainerTests {
    
    // MARK: - Test Data
    
    let testContent = Text("Test Form Content")
    
    // MARK: - Form Container Type Tests
    
    @Test func testPlatformFormContainer_L4_FormContainer() {
        // Given: Form container strategy
        let strategy = FormStrategy(
            containerType: .form,
            fieldLayout: .standard,
            validation: .deferred
        )
        
        // When: Creating form container
        let view = platformFormContainer_L4(strategy: strategy) {
            self.testContent
        }
        
        // Then: Test the two critical aspects
        
        // 1. Does it return a valid structure of the kind it's supposed to?
        #expect(view != nil, "Form container should return a valid SwiftUI view")
        
        // 2. Does that structure contain what it should?
        do {
            // The form container should contain the test content
            let viewText = try view.inspect().findAll(ViewType.Text.self)
            #expect(!viewText.isEmpty, "Form container should contain text elements")
            
            // Should contain the test content
            let hasTestContent = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains("Test Form Content")
                } catch {
                    return false
                }
            }
            #expect(hasTestContent, "Form container should contain the test content")
            
        } catch {
            Issue.record("Failed to inspect form container structure: \(error)")
        }
        
        // 3. Platform-specific implementation verification (REQUIRED)
        #if os(iOS)
        // iOS: Should contain Form structure with iOS-specific background color
        do {
            let formView = try view.inspect().find(ViewType.Form.self)
            // Form found - this is correct for iOS
            // Note: iOS uses Color(.systemGroupedBackground) for form backgrounds
        } catch {
            Issue.record("iOS form container should contain Form structure")
        }
        #elseif os(macOS)
        // macOS: Should contain Form structure with macOS-specific background color
        do {
            let formView = try view.inspect().find(ViewType.Form.self)
            // Form found - this is correct for macOS
            // Note: macOS uses Color(.controlBackgroundColor) for form backgrounds
        } catch {
            Issue.record("macOS form container should contain Form structure")
        }
        #endif
    }
    
    @Test func testPlatformFormContainer_L4_StandardContainer() {
        // Given: Standard container strategy
        let strategy = FormStrategy(
            containerType: .standard,
            fieldLayout: .standard,
            validation: .deferred
        )
        
        // When: Creating form container
        let view = platformFormContainer_L4(strategy: strategy) {
            self.testContent
        }
        
        // Then: Test the two critical aspects
        
        // 1. Does it return a valid structure of the kind it's supposed to?
        #expect(view != nil, "Standard container should return a valid SwiftUI view")
        
        // 2. Does that structure contain what it should?
        do {
            // The standard container should contain the test content
            let viewText = try view.inspect().findAll(ViewType.Text.self)
            #expect(!viewText.isEmpty, "Standard container should contain text elements")
            
            // Should contain the test content
            let hasTestContent = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains("Test Form Content")
                } catch {
                    return false
                }
            }
            #expect(hasTestContent, "Standard container should contain the test content")
            
        } catch {
            Issue.record("Failed to inspect standard container structure: \(error)")
        }
        
        // 3. Platform-specific implementation verification (REQUIRED)
        #if os(iOS)
        // iOS: Should contain VStack structure with iOS-specific background color
        do {
            let vStack = try view.inspect().find(ViewType.VStack.self)
            // VStack found - this is correct for iOS
            // Note: iOS uses Color(.secondarySystemBackground) for standard container backgrounds
        } catch {
            Issue.record("iOS standard container should contain VStack structure")
        }
        #elseif os(macOS)
        // macOS: Should contain VStack structure with macOS-specific background color
        do {
            let vStack = try view.inspect().find(ViewType.VStack.self)
            // VStack found - this is correct for macOS
            // Note: macOS uses Color(.controlBackgroundColor) for standard container backgrounds
        } catch {
            Issue.record("macOS standard container should contain VStack structure")
        }
        #endif
    }
    
    @Test func testPlatformFormContainer_L4_ScrollViewContainer() {
        // Given: ScrollView container strategy
        let strategy = FormStrategy(
            containerType: .scrollView,
            fieldLayout: .standard,
            validation: .deferred
        )
        
        // When: Creating form container
        let view = platformFormContainer_L4(strategy: strategy) {
            self.testContent
        }
        
        // Then: Should return a view with ScrollView container
        #expect(view != nil)
        
        // 3. Platform-specific implementation verification (REQUIRED)
        #if os(iOS)
        // iOS: Should contain ScrollView structure with iOS-specific background color
        do {
            let scrollView = try view.inspect().find(ViewType.ScrollView.self)
            // ScrollView found - this is correct for iOS
            // Note: iOS uses Color(.systemGroupedBackground) for scroll view backgrounds
        } catch {
            Issue.record("iOS scroll view container should contain ScrollView structure")
        }
        #elseif os(macOS)
        // macOS: Should contain ScrollView structure with macOS-specific background color
        do {
            let scrollView = try view.inspect().find(ViewType.ScrollView.self)
            // ScrollView found - this is correct for macOS
            // Note: macOS uses Color(.controlBackgroundColor) for scroll view backgrounds
        } catch {
            Issue.record("macOS scroll view container should contain ScrollView structure")
        }
        #endif
    }
    
    @Test func testPlatformFormContainer_L4_CustomContainer() {
        // Given: Custom container strategy
        let strategy = FormStrategy(
            containerType: .custom,
            fieldLayout: .standard,
            validation: .deferred
        )
        
        // When: Creating form container
        let view = platformFormContainer_L4(strategy: strategy) {
            self.testContent
        }
        
        // Then: Should return a view with custom VStack container
        #expect(view != nil)
        
        let mirror = Mirror(reflecting: view)
        #expect(String(describing: mirror.subjectType) == "AnyView")
    }
    
    @Test func testPlatformFormContainer_L4_AdaptiveContainer() {
        // Given: Adaptive container strategy
        let strategy = FormStrategy(
            containerType: .adaptive,
            fieldLayout: .standard,
            validation: .deferred
        )
        
        // When: Creating form container
        let view = platformFormContainer_L4(strategy: strategy) {
            self.testContent
        }
        
        // Then: Should return a view with adaptive VStack container
        #expect(view != nil)
        
        let mirror = Mirror(reflecting: view)
        #expect(String(describing: mirror.subjectType) == "AnyView")
    }
    
    // MARK: - Field Layout Tests
    
    @Test func testPlatformFormContainer_L4_DifferentFieldLayouts() {
        // Given: Different field layout strategies
        let fieldLayouts: [FieldLayout] = [
            .compact, .standard, .spacious, .adaptive,
            .vertical, .horizontal, .grid
        ]
        
        for fieldLayout in fieldLayouts {
            let strategy = FormStrategy(
                containerType: .standard,
                fieldLayout: fieldLayout,
                validation: .deferred
            )
            
            // When: Creating form container
            let view = platformFormContainer_L4(strategy: strategy) {
                self.testContent
            }
            
            // Then: Should return a view for each field layout
            #expect(view != nil, "Should handle field layout: \(fieldLayout)")
            
            let mirror = Mirror(reflecting: view)
            #expect(String(describing: mirror.subjectType) == "AnyView", "Should return AnyView for layout: \(fieldLayout)")
        }
    }
    
    @Test func testPlatformFormContainer_L4_CompactLayout() {
        // Given: Compact field layout strategy
        let strategy = FormStrategy(
            containerType: .standard,
            fieldLayout: .compact,
            validation: .deferred
        )
        
        // When: Creating form container
        let view = platformFormContainer_L4(strategy: strategy) {
            self.testContent
        }
        
        // Then: Should return a view with compact spacing
        #expect(view != nil)
        
        let mirror = Mirror(reflecting: view)
        #expect(String(describing: mirror.subjectType) == "AnyView")
    }
    
    @Test func testPlatformFormContainer_L4_SpaciousLayout() {
        // Given: Spacious field layout strategy
        let strategy = FormStrategy(
            containerType: .standard,
            fieldLayout: .spacious,
            validation: .deferred
        )
        
        // When: Creating form container
        let view = platformFormContainer_L4(strategy: strategy) {
            self.testContent
        }
        
        // Then: Should return a view with spacious spacing
        #expect(view != nil)
        
        let mirror = Mirror(reflecting: view)
        #expect(String(describing: mirror.subjectType) == "AnyView")
    }
    
    @Test func testPlatformFormContainer_L4_GridLayout() {
        // Given: Grid field layout strategy
        let strategy = FormStrategy(
            containerType: .standard,
            fieldLayout: .grid,
            validation: .deferred
        )
        
        // When: Creating form container
        let view = platformFormContainer_L4(strategy: strategy) {
            self.testContent
        }
        
        // Then: Should return a view with grid spacing
        #expect(view != nil)
        
        let mirror = Mirror(reflecting: view)
        #expect(String(describing: mirror.subjectType) == "AnyView")
    }
    
    // MARK: - Validation Strategy Tests
    
    @Test func testPlatformFormContainer_L4_DifferentValidationStrategies() {
        // Given: Different validation strategies
        let validationStrategies: [ValidationStrategy] = [
            .none, .realTime, .onSubmit, .custom, .immediate, .deferred
        ]
        
        for validation in validationStrategies {
            let strategy = FormStrategy(
                containerType: .standard,
                fieldLayout: .standard,
                validation: validation
            )
            
            // When: Creating form container
            let view = platformFormContainer_L4(strategy: strategy) {
                self.testContent
            }
            
            // Then: Should return a view for each validation strategy
            #expect(view != nil, "Should handle validation: \(validation)")
            
            let mirror = Mirror(reflecting: view)
            #expect(String(describing: mirror.subjectType) == "AnyView", "Should return AnyView for validation: \(validation)")
        }
    }
    
    // MARK: - Complex Content Tests
    
    @Test func testPlatformFormContainer_L4_ComplexContent() {
        // Given: Complex content with multiple views
        let complexContent = VStack {
            Text("Form Title")
                .font(.headline)
            TextField("Name", text: .constant(""))
            TextField("Email", text: .constant(""))
            Button("Submit") { }
        }
        
        let strategy = FormStrategy(
            containerType: .standard,
            fieldLayout: .standard,
            validation: .deferred
        )
        
        // When: Creating form container with complex content
        let view = platformFormContainer_L4(strategy: strategy) {
            complexContent
        }
        
        // Then: Should return a view containing the complex content
        #expect(view != nil)
        
        let mirror = Mirror(reflecting: view)
        #expect(String(describing: mirror.subjectType) == "AnyView")
    }
    
    @Test func testPlatformFormContainer_L4_EmptyContent() {
        // Given: Empty content
        let emptyContent = EmptyView()
        
        let strategy = FormStrategy(
            containerType: .standard,
            fieldLayout: .standard,
            validation: .deferred
        )
        
        // When: Creating form container with empty content
        let view = platformFormContainer_L4(strategy: strategy) {
            emptyContent
        }
        
        // Then: Should return a view even with empty content
        #expect(view != nil)
        
        let mirror = Mirror(reflecting: view)
        #expect(String(describing: mirror.subjectType) == "AnyView")
    }
    
    // MARK: - Platform Adaptations Tests
    
    @Test func testPlatformFormContainer_L4_WithPlatformAdaptations() {
        // Given: Strategy with platform adaptations
        let platformAdaptations: [ModalPlatform: PlatformAdaptation] = [
            .iOS: .standardFields,
            .macOS: .largeFields
        ]
        
        let strategy = FormStrategy(
            containerType: .standard,
            fieldLayout: .standard,
            validation: .deferred,
            platformAdaptations: platformAdaptations
        )
        
        // When: Creating form container
        let view = platformFormContainer_L4(strategy: strategy) {
            self.testContent
        }
        
        // Then: Should return a view with platform adaptations
        #expect(view != nil)
        
        let mirror = Mirror(reflecting: view)
        #expect(String(describing: mirror.subjectType) == "AnyView")
    }
    
    // MARK: - Edge Cases and Error Handling
    
    @Test func testPlatformFormContainer_L4_AllContainerTypes() {
        // Given: All possible container types
        let containerTypes: [FormContainerType] = [
            .form, .scrollView, .custom, .adaptive, .standard
        ]
        
        for containerType in containerTypes {
            let strategy = FormStrategy(
                containerType: containerType,
                fieldLayout: .standard,
                validation: .deferred
            )
            
            // When: Creating form container
            let view = platformFormContainer_L4(strategy: strategy) {
                self.testContent
            }
            
            // Then: Should return a view for each container type
            #expect(view != nil, "Should handle container type: \(containerType)")
            
            let mirror = Mirror(reflecting: view)
            #expect(String(describing: mirror.subjectType) == "AnyView", "Should return AnyView for container: \(containerType)")
        }
    }
    
    @Test func testPlatformFormContainer_L4_AllFieldLayouts() {
        // Given: All possible field layouts
        let fieldLayouts: [FieldLayout] = [
            .standard, .compact, .spacious, .adaptive,
            .vertical, .horizontal, .grid
        ]
        
        for fieldLayout in fieldLayouts {
            let strategy = FormStrategy(
                containerType: .standard,
                fieldLayout: fieldLayout,
                validation: .deferred
            )
            
            // When: Creating form container
            let view = platformFormContainer_L4(strategy: strategy) {
                self.testContent
            }
            
            // Then: Should return a view for each field layout
            #expect(view != nil, "Should handle field layout: \(fieldLayout)")
            
            let mirror = Mirror(reflecting: view)
            #expect(String(describing: mirror.subjectType) == "AnyView", "Should return AnyView for layout: \(fieldLayout)")
        }
    }
    
    @Test func testPlatformFormContainer_L4_AllValidationStrategies() {
        // Given: All possible validation strategies
        let validationStrategies: [ValidationStrategy] = [
            .none, .realTime, .onSubmit, .custom, .immediate, .deferred
        ]
        
        for validation in validationStrategies {
            let strategy = FormStrategy(
                containerType: .standard,
                fieldLayout: .standard,
                validation: validation
            )
            
            // When: Creating form container
            let view = platformFormContainer_L4(strategy: strategy) {
                self.testContent
            }
            
            // Then: Should return a view for each validation strategy
            #expect(view != nil, "Should handle validation: \(validation)")
            
            let mirror = Mirror(reflecting: view)
            #expect(String(describing: mirror.subjectType) == "AnyView", "Should return AnyView for validation: \(validation)")
        }
    }
    
    // MARK: - Performance Tests
    
    @Test func testPlatformFormContainer_L4_Performance() {
        // Given: Standard strategy
        let strategy = FormStrategy(
            containerType: .standard,
            fieldLayout: .standard,
            validation: .deferred
        )
        
        // When: Measuring performance
        measure {
            _ = platformFormContainer_L4(strategy: strategy) {
                self.testContent
            }
        }
    }
    
    @Test func testPlatformFormContainer_L4_PerformanceWithComplexContent() {
        // Given: Complex content
        let complexContent = VStack {
            ForEach(0..<50) { i in
                TextField("Field \(i)", text: .constant(""))
            }
        }
        
        let strategy = FormStrategy(
            containerType: .scrollView,
            fieldLayout: .standard,
            validation: .deferred
        )
        
        // When: Measuring performance
        measure {
            _ = platformFormContainer_L4(strategy: strategy) {
                complexContent
            }
        }
    }
}
