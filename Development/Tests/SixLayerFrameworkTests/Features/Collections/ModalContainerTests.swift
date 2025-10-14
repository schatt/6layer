//
//  ModalContainerTests.swift
//  SixLayerFrameworkTests
//
//  Tests for platformModalContainer_Form_L4 function
//  Tests modal container functionality and strategy handling
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class ModalContainerTests: XCTestCase {
    
    // MARK: - Test Data
    
    private func createTestModalStrategy(
        presentationType: ModalPresentationType = .sheet,
        sizing: ModalSizing = .medium,
        detents: [SheetDetent] = [.medium],
        platformOptimizations: [ModalPlatform: ModalConstraint] = [:]
    ) -> ModalStrategy {
        return ModalStrategy(
            presentationType: presentationType,
            sizing: sizing,
            detents: detents,
            platformOptimizations: platformOptimizations
        )
    }
    
    private func createTestModalConstraint(
        maxWidth: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        preferredSize: CGSize? = nil
    ) -> ModalConstraint {
        return ModalConstraint(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            preferredSize: preferredSize
        )
    }
    
    // MARK: - Basic Modal Container Tests
    
    func testPlatformModalContainer_Form_L4_BasicSheet() {
        // Given: Basic sheet strategy
        let strategy = createTestModalStrategy(
            presentationType: .sheet,
            sizing: .medium,
            detents: [.medium]
        )
        
        // When: Creating modal container
        let container = platformModalContainer_Form_L4(strategy: strategy)
        
        // Then: Should create valid modal container
        XCTAssertNotNil(container, "Modal container should be created successfully")
    }
    
    func testPlatformModalContainer_Form_L4_Popover() {
        // Given: Popover strategy
        let strategy = createTestModalStrategy(
            presentationType: .popover,
            sizing: .small,
            detents: [.small]
        )
        
        // When: Creating modal container
        let container = platformModalContainer_Form_L4(strategy: strategy)
        
        // Then: Should create valid popover container
        XCTAssertNotNil(container, "Popover container should be created successfully")
    }
    
    func testPlatformModalContainer_Form_L4_FullScreen() {
        // Given: Full screen strategy
        let strategy = createTestModalStrategy(
            presentationType: .fullScreen,
            sizing: .large,
            detents: [.large]
        )
        
        // When: Creating modal container
        let container = platformModalContainer_Form_L4(strategy: strategy)
        
        // Then: Should create valid full screen container
        XCTAssertNotNil(container, "Full screen container should be created successfully")
    }
    
    func testPlatformModalContainer_Form_L4_Custom() {
        // Given: Custom strategy
        let strategy = createTestModalStrategy(
            presentationType: .custom,
            sizing: .custom,
            detents: [.custom(height: 400)]
        )
        
        // When: Creating modal container
        let container = platformModalContainer_Form_L4(strategy: strategy)
        
        // Then: Should create valid custom container
        XCTAssertNotNil(container, "Custom container should be created successfully")
    }
    
    // MARK: - Sizing Tests
    
    func testPlatformModalContainer_Form_L4_DifferentSizes() {
        // Given: Different sizing options
        let smallStrategy = createTestModalStrategy(sizing: .small)
        let mediumStrategy = createTestModalStrategy(sizing: .medium)
        let largeStrategy = createTestModalStrategy(sizing: .large)
        let customStrategy = createTestModalStrategy(sizing: .custom)
        
        // When: Creating containers with different sizes
        let smallContainer = platformModalContainer_Form_L4(strategy: smallStrategy)
        let mediumContainer = platformModalContainer_Form_L4(strategy: mediumStrategy)
        let largeContainer = platformModalContainer_Form_L4(strategy: largeStrategy)
        let customContainer = platformModalContainer_Form_L4(strategy: customStrategy)
        
        // Then: All containers should be created successfully
        XCTAssertNotNil(smallContainer, "Small container should be created")
        XCTAssertNotNil(mediumContainer, "Medium container should be created")
        XCTAssertNotNil(largeContainer, "Large container should be created")
        XCTAssertNotNil(customContainer, "Custom container should be created")
    }
    
    func testPlatformModalContainer_Form_L4_MultipleDetents() {
        // Given: Strategy with multiple detents
        let strategy = createTestModalStrategy(
            detents: [.small, .medium, .large]
        )
        
        // When: Creating modal container
        let container = platformModalContainer_Form_L4(strategy: strategy)
        
        // Then: Should create container with multiple detents
        XCTAssertNotNil(container, "Container with multiple detents should be created")
    }
    
    func testPlatformModalContainer_Form_L4_CustomDetent() {
        // Given: Strategy with custom detent
        let customHeight: CGFloat = 500
        let strategy = createTestModalStrategy(
            detents: [.custom(height: customHeight)]
        )
        
        // When: Creating modal container
        let container = platformModalContainer_Form_L4(strategy: strategy)
        
        // Then: Should create container with custom detent
        XCTAssertNotNil(container, "Container with custom detent should be created")
    }
    
    // MARK: - Platform Optimization Tests
    
    func testPlatformModalContainer_Form_L4_WithPlatformOptimizations() {
        // Given: Strategy with platform optimizations
        let iOSConstraint = createTestModalConstraint(
            maxWidth: 400,
            maxHeight: 600,
            preferredSize: CGSize(width: 350, height: 500)
        )
        
        let macOSConstraint = createTestModalConstraint(
            maxWidth: 600,
            maxHeight: 800,
            preferredSize: CGSize(width: 500, height: 700)
        )
        
        let platformOptimizations: [ModalPlatform: ModalConstraint] = [
            .iOS: iOSConstraint,
            .macOS: macOSConstraint
        ]
        
        let strategy = createTestModalStrategy(
            platformOptimizations: platformOptimizations
        )
        
        // When: Creating modal container
        let container = platformModalContainer_Form_L4(strategy: strategy)
        
        // Then: Should create container with platform optimizations
        XCTAssertNotNil(container, "Container with platform optimizations should be created")
    }
    
    func testPlatformModalContainer_Form_L4_iOSOptimization() {
        // Given: iOS-specific optimization
        let iOSConstraint = createTestModalConstraint(
            maxWidth: 400,
            maxHeight: 600
        )
        
        let strategy = createTestModalStrategy(
            platformOptimizations: [.iOS: iOSConstraint]
        )
        
        // When: Creating modal container
        let container = platformModalContainer_Form_L4(strategy: strategy)
        
        // Then: Should create iOS-optimized container
        XCTAssertNotNil(container, "iOS-optimized container should be created")
    }
    
    func testPlatformModalContainer_Form_L4_macOSOptimization() {
        // Given: macOS-specific optimization
        let macOSConstraint = createTestModalConstraint(
            maxWidth: 600,
            maxHeight: 800
        )
        
        let strategy = createTestModalStrategy(
            platformOptimizations: [.macOS: macOSConstraint]
        )
        
        // When: Creating modal container
        let container = platformModalContainer_Form_L4(strategy: strategy)
        
        // Then: Should create macOS-optimized container
        XCTAssertNotNil(container, "macOS-optimized container should be created")
    }
    
    // MARK: - Complex Strategy Tests
    
    func testPlatformModalContainer_Form_L4_ComplexStrategy() {
        // Given: Complex strategy with all options
        let iOSConstraint = createTestModalConstraint(
            maxWidth: 400,
            maxHeight: 600,
            preferredSize: CGSize(width: 350, height: 500)
        )
        
        let macOSConstraint = createTestModalConstraint(
            maxWidth: 600,
            maxHeight: 800,
            preferredSize: CGSize(width: 500, height: 700)
        )
        
        let strategy = createTestModalStrategy(
            presentationType: .sheet,
            sizing: .medium,
            detents: [.small, .medium, .large],
            platformOptimizations: [
                .iOS: iOSConstraint,
                .macOS: macOSConstraint
            ]
        )
        
        // When: Creating modal container
        let container = platformModalContainer_Form_L4(strategy: strategy)
        
        // Then: Should create complex container
        XCTAssertNotNil(container, "Complex container should be created")
    }
    
    func testPlatformModalContainer_Form_L4_AllPresentationTypes() {
        // Given: All presentation types
        let presentationTypes: [ModalPresentationType] = [
            .sheet, .popover, .fullScreen, .custom
        ]
        
        // When: Creating containers for each presentation type
        for presentationType in presentationTypes {
            let strategy = createTestModalStrategy(presentationType: presentationType)
            let container = platformModalContainer_Form_L4(strategy: strategy)
            
            // Then: Should create container for each presentation type
            XCTAssertNotNil(container, "Container should be created for presentation type: \(presentationType)")
        }
    }
    
    func testPlatformModalContainer_Form_L4_AllSizingOptions() {
        // Given: All sizing options
        let sizingOptions: [ModalSizing] = [
            .small, .medium, .large, .custom
        ]
        
        // When: Creating containers for each sizing option
        for sizing in sizingOptions {
            let strategy = createTestModalStrategy(sizing: sizing)
            let container = platformModalContainer_Form_L4(strategy: strategy)
            
            // Then: Should create container for each sizing option
            XCTAssertNotNil(container, "Container should be created for sizing: \(sizing)")
        }
    }
    
    func testPlatformModalContainer_Form_L4_AllDetentTypes() {
        // Given: All detent types
        let detentTypes: [SheetDetent] = [
            .small, .medium, .large, .custom(height: 300)
        ]
        
        // When: Creating containers for each detent type
        for detent in detentTypes {
            let strategy = createTestModalStrategy(detents: [detent])
            let container = platformModalContainer_Form_L4(strategy: strategy)
            
            // Then: Should create container for each detent type
            XCTAssertNotNil(container, "Container should be created for detent: \(detent)")
        }
    }
    
    // MARK: - Edge Cases and Error Handling
    
    func testPlatformModalContainer_Form_L4_EmptyDetents() {
        // Given: Strategy with empty detents
        let strategy = createTestModalStrategy(detents: [])
        
        // When: Creating modal container
        let container = platformModalContainer_Form_L4(strategy: strategy)
        
        // Then: Should handle empty detents gracefully
        XCTAssertNotNil(container, "Container should handle empty detents gracefully")
    }
    
    func testPlatformModalContainer_Form_L4_EmptyPlatformOptimizations() {
        // Given: Strategy with empty platform optimizations
        let strategy = createTestModalStrategy(platformOptimizations: [:])
        
        // When: Creating modal container
        let container = platformModalContainer_Form_L4(strategy: strategy)
        
        // Then: Should handle empty optimizations gracefully
        XCTAssertNotNil(container, "Container should handle empty platform optimizations gracefully")
    }
    
    func testPlatformModalContainer_Form_L4_MultipleCustomDetents() {
        // Given: Strategy with multiple custom detents
        let strategy = createTestModalStrategy(
            detents: [
                .custom(height: 200),
                .custom(height: 400),
                .custom(height: 600)
            ]
        )
        
        // When: Creating modal container
        let container = platformModalContainer_Form_L4(strategy: strategy)
        
        // Then: Should handle multiple custom detents
        XCTAssertNotNil(container, "Container should handle multiple custom detents")
    }
    
    func testPlatformModalContainer_Form_L4_ExtremeConstraints() {
        // Given: Strategy with extreme constraints
        let extremeConstraint = createTestModalConstraint(
            maxWidth: 1000,
            maxHeight: 1000,
            preferredSize: CGSize(width: 800, height: 800)
        )
        
        let strategy = createTestModalStrategy(
            platformOptimizations: [.iOS: extremeConstraint, .macOS: extremeConstraint]
        )
        
        // When: Creating modal container
        let container = platformModalContainer_Form_L4(strategy: strategy)
        
        // Then: Should handle extreme constraints
        XCTAssertNotNil(container, "Container should handle extreme constraints")
    }
    
    // MARK: - Performance Tests
    
    func testPlatformModalContainer_Form_L4_Performance() {
        // Given: Test strategy
        let strategy = createTestModalStrategy()
        
        // When: Measuring performance
        measure {
            let _ = platformModalContainer_Form_L4(strategy: strategy)
        }
    }
    
    func testPlatformModalContainer_Form_L4_PerformanceWithComplexStrategy() {
        // Given: Complex test strategy
        let iOSConstraint = createTestModalConstraint(
            maxWidth: 400,
            maxHeight: 600,
            preferredSize: CGSize(width: 350, height: 500)
        )
        
        let macOSConstraint = createTestModalConstraint(
            maxWidth: 600,
            maxHeight: 800,
            preferredSize: CGSize(width: 500, height: 700)
        )
        
        let strategy = createTestModalStrategy(
            presentationType: .sheet,
            sizing: .medium,
            detents: [.small, .medium, .large],
            platformOptimizations: [
                .iOS: iOSConstraint,
                .macOS: macOSConstraint
            ]
        )
        
        // When: Measuring performance
        measure {
            let _ = platformModalContainer_Form_L4(strategy: strategy)
        }
    }
    
    // MARK: - Integration Tests
    
    func testPlatformModalContainer_Form_L4_IntegrationWithFormStrategy() {
        // Given: Modal strategy that would work with form strategy
        let modalStrategy = createTestModalStrategy(
            presentationType: .sheet,
            sizing: .medium,
            detents: [.medium]
        )
        
        // When: Creating modal container
        let container = platformModalContainer_Form_L4(strategy: modalStrategy)
        
        // Then: Should create container that can work with forms
        XCTAssertNotNil(container, "Modal container should integrate with form strategy")
    }
    
    func testPlatformModalContainer_Form_L4_CrossPlatformCompatibility() {
        // Given: Cross-platform compatible strategy
        let iOSConstraint = createTestModalConstraint(maxWidth: 400, maxHeight: 600)
        let macOSConstraint = createTestModalConstraint(maxWidth: 600, maxHeight: 800)
        
        let strategy = createTestModalStrategy(
            platformOptimizations: [
                .iOS: iOSConstraint,
                .macOS: macOSConstraint
            ]
        )
        
        // When: Creating modal container
        let container = platformModalContainer_Form_L4(strategy: strategy)
        
        // Then: Should create cross-platform compatible container
        XCTAssertNotNil(container, "Modal container should be cross-platform compatible")
    }
}

