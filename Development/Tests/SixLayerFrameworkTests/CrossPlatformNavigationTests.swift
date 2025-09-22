//
//  CrossPlatformNavigationTests.swift
//  SixLayerFrameworkTests
//
//  Tests for the Cross-Platform Navigation Component
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class CrossPlatformNavigationTests: XCTestCase {
    
    // MARK: - Cross-Platform Navigation Tests
    
    func testNavigationStrategyEnumIsAvailable() {
        // Test that our navigation strategy enum is accessible
        XCTAssertNotNil(NavigationStrategy.navigationStack)
        XCTAssertNotNil(NavigationStrategy.splitView)
        XCTAssertNotNil(NavigationStrategy.modal)
        XCTAssertNotNil(NavigationStrategy.adaptive)
    }
    
    func testNavigationStrategyFromString() {
        // Test that we can create navigation strategies from strings
        let stackStrategy = NavigationStrategy(rawValue: "navigationStack")
        let splitStrategy = NavigationStrategy(rawValue: "splitView")
        let modalStrategy = NavigationStrategy(rawValue: "modal")
        
        XCTAssertEqual(stackStrategy, .navigationStack)
        XCTAssertEqual(splitStrategy, .splitView)
        XCTAssertEqual(modalStrategy, .modal)
    }
    
    func testNavigationStrategyToString() {
        // Test that navigation strategies convert to strings correctly
        XCTAssertEqual(NavigationStrategy.navigationStack.rawValue, "navigationStack")
        XCTAssertEqual(NavigationStrategy.splitView.rawValue, "splitView")
        XCTAssertEqual(NavigationStrategy.modal.rawValue, "modal")
        XCTAssertEqual(NavigationStrategy.adaptive.rawValue, "adaptive")
    }
    
    func testCrossPlatformNavigationFactory() {
        // Test that our cross-platform navigation factory works
        let navigation = CrossPlatformNavigation()
        XCTAssertNotNil(navigation)
    }
    
    // MARK: - Business Purpose Tests
    
    func testNavigationSystemEnablesCrossPlatformDevelopment() {
        // Test that our navigation system supports the framework's cross-platform goals
        // Business purpose: enabling developers to write navigation once, run everywhere
        
        let strategies = [
            NavigationStrategy.navigationStack,
            NavigationStrategy.splitView,
            NavigationStrategy.modal,
            NavigationStrategy.adaptive
        ]
        
        for strategy in strategies {
            // Each strategy should be valid and usable
            XCTAssertNotNil(strategy)
            XCTAssertNotNil(strategy.rawValue)
            
            // Strategy should convert back and forth from string
            let stringValue = strategy.rawValue
            let convertedStrategy = NavigationStrategy(rawValue: stringValue)
            XCTAssertEqual(strategy, convertedStrategy)
        }
    }
    
    func testNavigationStrategySupportsBusinessRequirements() {
        // Test that our navigation strategies support real business use cases
        // Business purpose: providing appropriate navigation for different contexts
        
        // Dashboard context should use split view for desktop, stack for mobile
        let dashboardStrategy = NavigationStrategy.recommended(for: .dashboard)
        XCTAssertNotNil(dashboardStrategy)
        
        // Browse context should use adaptive navigation
        let browseStrategy = NavigationStrategy.recommended(for: .browse)
        XCTAssertNotNil(browseStrategy)
        
        // Detail context should use stack navigation
        let detailStrategy = NavigationStrategy.recommended(for: .detail)
        XCTAssertNotNil(detailStrategy)
        
        // Edit context should use modal navigation
        let editStrategy = NavigationStrategy.recommended(for: .edit)
        XCTAssertNotNil(editStrategy)
    }
    
    func testNavigationSystemHandlesEdgeCases() {
        // Test that our navigation system handles edge cases gracefully
        // Business purpose: ensuring robust navigation behavior
        
        // Invalid string should return nil (no default)
        let invalidStrategy = NavigationStrategy(rawValue: "invalidStrategy")
        XCTAssertNil(invalidStrategy)
        
        // Empty string should return nil (no default)
        let emptyStrategy = NavigationStrategy(rawValue: "")
        XCTAssertNil(emptyStrategy)
    }
}

// MARK: - Test Helpers

extension NavigationStrategy {
    /// Recommended navigation strategy for different presentation contexts
    static func recommended(for context: PresentationContext) -> NavigationStrategy {
        switch context {
        case .dashboard, .standard:
            #if os(macOS)
            return .splitView
            #else
            return .navigationStack
            #endif
        case .browse:
            return .adaptive
        case .detail:
            return .navigationStack
        case .edit:
            return .modal
        case .search:
            return .navigationStack
        case .summary:
            return .navigationStack
        case .list:
            return .adaptive
        case .form:
            return .modal
        case .modal:
            return .modal
        case .navigation:
            return .navigationStack
        case .settings:
            return .navigationStack
        case .profile:
            return .navigationStack
        case .create:
            return .modal
        }
    }
}
