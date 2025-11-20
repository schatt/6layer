//
//  PlatformNavigationDecisionLayer2.swift
//  SixLayerFramework
//
//  Layer 2: Navigation Decision Engine
//  Content-aware navigation decision making (NOT platform-aware)
//

import SwiftUI
import Foundation

// MARK: - Layer 2: Navigation Decision Engine
// This layer analyzes content and makes navigation decisions based on content characteristics
// It is CONTENT-AWARE but NOT platform-aware (platform decisions happen in Layer 3)

// MARK: - Navigation Decision Data Structure

/// Navigation decision result from Layer 2 analysis
public struct NavigationStackDecision: Sendable {
    public let strategy: NavigationStrategy?
    public let reasoning: String?
    
    public init(
        strategy: NavigationStrategy?,
        reasoning: String?
    ) {
        self.strategy = strategy
        self.reasoning = reasoning
    }
}

// MARK: - Navigation Decision Functions

/// Determine optimal navigation strategy based on content analysis
/// Analyzes content characteristics and makes navigation decisions
/// This is CONTENT-AWARE but NOT platform-aware
///
/// - Parameters:
///   - items: Collection of items to navigate
///   - hints: Presentation hints that guide navigation decisions
/// - Returns: Navigation decision with recommended strategy and reasoning
@MainActor
public func determineNavigationStackStrategy_L2<Item: Identifiable>(
    items: [Item],
    hints: PresentationHints
) -> NavigationStackDecision {
    
    // Analyze content characteristics
    let analysis = DataIntrospectionEngine.analyzeCollection(items)
    
    // Check hints first for explicit preferences
    if hints.presentationPreference == .navigation {
        return NavigationStackDecision(
            strategy: .navigationStack,
            reasoning: "Navigation strategy selected based on explicit hints preference"
        )
    } else if hints.presentationPreference == .detail {
        return NavigationStackDecision(
            strategy: .splitView,
            reasoning: "Split view strategy selected based on detail preference in hints"
        )
    } else if hints.presentationPreference == .modal {
        return NavigationStackDecision(
            strategy: .modal,
            reasoning: "Modal strategy selected based on modal preference in hints"
        )
    }
    
    // Analyze data characteristics to determine optimal strategy
    // This is content-aware analysis, not platform-aware
    let strategy: NavigationStrategy
    let reasoning: String
    
    switch (analysis.collectionType, analysis.itemComplexity) {
    case (.empty, _):
        strategy = .navigationStack
        reasoning = "Empty collection: NavigationStack provides clean empty state handling"
        
    case (.single, _):
        strategy = .navigationStack
        reasoning = "Single item: NavigationStack provides simple navigation pattern"
        
    case (.small, .simple):
        strategy = .navigationStack
        reasoning = "Small simple collection: NavigationStack provides efficient navigation"
        
    case (.small, .moderate):
        strategy = .navigationStack
        reasoning = "Small moderate collection: NavigationStack handles moderate complexity well"
        
    case (.medium, .simple):
        strategy = .navigationStack
        reasoning = "Medium simple collection: NavigationStack scales well for simple content"
        
    case (.medium, .moderate):
        // For medium moderate, could go either way - prefer NavigationStack for consistency
        strategy = .navigationStack
        reasoning = "Medium moderate collection: NavigationStack provides consistent navigation"
        
    case (.medium, .complex):
        // Complex content might benefit from split view, but NavigationStack can handle it
        strategy = .adaptive
        reasoning = "Medium complex collection: Adaptive strategy allows platform-specific optimization"
        
    case (.large, .simple):
        strategy = .adaptive
        reasoning = "Large simple collection: Adaptive strategy optimizes for platform capabilities"
        
    case (.large, .moderate):
        strategy = .adaptive
        reasoning = "Large moderate collection: Adaptive strategy balances navigation and detail views"
        
    case (.large, .complex):
        strategy = .adaptive
        reasoning = "Large complex collection: Adaptive strategy handles complex navigation needs"
        
    case (.veryLarge, _):
        strategy = .adaptive
        reasoning = "Very large collection: Adaptive strategy optimizes for performance and usability"
        
    default:
        strategy = .adaptive
        reasoning = "Default: Adaptive strategy provides best platform-specific experience"
    }
    
    return NavigationStackDecision(
        strategy: strategy,
        reasoning: reasoning
    )
}

