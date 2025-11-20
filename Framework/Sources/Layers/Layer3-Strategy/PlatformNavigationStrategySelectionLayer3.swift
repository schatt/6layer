//
//  PlatformNavigationStrategySelectionLayer3.swift
//  SixLayerFramework
//
//  Layer 3: Navigation Strategy Selection
//  Platform-aware strategy selection for NavigationStack implementation
//

import SwiftUI
import Foundation

// MARK: - Layer 3: Navigation Strategy Selection
// This layer selects optimal implementation strategies based on Layer 2 decisions and platform capabilities
// It is PLATFORM-AWARE (unlike Layer 2 which is content-aware)

// MARK: - Navigation Implementation Strategy

/// Navigation implementation strategy for Layer 4
public enum NavigationImplementationStrategy: String, CaseIterable, Sendable {
    case navigationStack = "navigationStack"  // iOS 16+ NavigationStack
    case navigationView = "navigationView"     // iOS 15 and earlier, macOS
    case splitView = "splitView"               // NavigationSplitView
    case modal = "modal"                       // Modal presentation
}

// MARK: - Navigation Strategy Result

/// Navigation strategy result from Layer 3 selection
public struct NavigationStackStrategy: Sendable {
    public let implementation: NavigationImplementationStrategy?
    public let reasoning: String?
    
    public init(
        implementation: NavigationImplementationStrategy?,
        reasoning: String?
    ) {
        self.implementation = implementation
        self.reasoning = reasoning
    }
}

// MARK: - Strategy Selection Functions

/// Select optimal NavigationStack implementation strategy based on Layer 2 decision and platform
/// This is PLATFORM-AWARE (unlike Layer 2 which is content-aware)
///
/// - Parameters:
///   - decision: Layer 2 navigation decision
///   - platform: Target platform
///   - iosVersion: Optional iOS version (defaults to current)
/// - Returns: Navigation strategy with implementation details
@MainActor
public func selectNavigationStackStrategy_L3(
    decision: NavigationStackDecision,
    platform: SixLayerPlatform,
    iosVersion: Double? = nil
) -> NavigationStackStrategy {
    
    // Get actual iOS version if not provided
    let actualIOSVersion: Double
    if let version = iosVersion {
        actualIOSVersion = version
    } else {
        #if os(iOS)
        if #available(iOS 16.0, *) {
            actualIOSVersion = 16.0
        } else {
            actualIOSVersion = 15.0
        }
        #else
        actualIOSVersion = 15.0 // Default for non-iOS
        #endif
    }
    
    // Handle explicit Layer 2 strategy decisions
    if let l2Strategy = decision.strategy {
        switch l2Strategy {
        case .modal:
            return NavigationStackStrategy(
                implementation: .modal,
                reasoning: "Modal strategy selected based on Layer 2 decision: \(decision.reasoning ?? "modal preference")"
            )
            
        case .splitView:
            // For split view, use NavigationSplitView on supported platforms
            if platform == .iOS && actualIOSVersion >= 16.0 {
                return NavigationStackStrategy(
                    implementation: .splitView,
                    reasoning: "Split view strategy selected for iOS 16+: \(decision.reasoning ?? "split view preference")"
                )
            } else if platform == .macOS {
                return NavigationStackStrategy(
                    implementation: .splitView,
                    reasoning: "Split view strategy selected for macOS: \(decision.reasoning ?? "split view preference")"
                )
            } else {
                // Fallback to NavigationStack for older iOS
                return NavigationStackStrategy(
                    implementation: .navigationStack,
                    reasoning: "Split view requested but not available, using NavigationStack: \(decision.reasoning ?? "fallback")"
                )
            }
            
        case .navigationStack:
            // NavigationStack strategy - platform-specific implementation
            if platform == .iOS {
                if actualIOSVersion >= 16.0 {
                    return NavigationStackStrategy(
                        implementation: .navigationStack,
                        reasoning: "NavigationStack implementation for iOS 16+: \(decision.reasoning ?? "navigation stack preference")"
                    )
                } else {
                    // iOS 15 fallback
                    return NavigationStackStrategy(
                        implementation: .navigationView,
                        reasoning: "NavigationStack not available on iOS 15, using NavigationView: \(decision.reasoning ?? "fallback")"
                    )
                }
            } else if platform == .macOS {
                // macOS doesn't have NavigationStack, use NavigationView
                return NavigationStackStrategy(
                    implementation: .navigationView,
                    reasoning: "NavigationStack not available on macOS, using NavigationView: \(decision.reasoning ?? "macOS fallback")"
                )
            } else {
                // Other platforms - use NavigationView as safe fallback
                return NavigationStackStrategy(
                    implementation: .navigationView,
                    reasoning: "NavigationStack not available on \(platform), using NavigationView: \(decision.reasoning ?? "platform fallback")"
                )
            }
            
        case .adaptive:
            // Adaptive strategy - choose best for platform
            if platform == .iOS && actualIOSVersion >= 16.0 {
                return NavigationStackStrategy(
                    implementation: .navigationStack,
                    reasoning: "Adaptive strategy selected NavigationStack for iOS 16+: \(decision.reasoning ?? "adaptive selection")"
                )
            } else if platform == .macOS {
                return NavigationStackStrategy(
                    implementation: .navigationView,
                    reasoning: "Adaptive strategy selected NavigationView for macOS: \(decision.reasoning ?? "adaptive selection")"
                )
            } else {
                // Older iOS or other platforms
                return NavigationStackStrategy(
                    implementation: .navigationView,
                    reasoning: "Adaptive strategy selected NavigationView for \(platform): \(decision.reasoning ?? "adaptive selection")"
                )
            }
        }
    }
    
    // No strategy from Layer 2 - use adaptive default
    return NavigationStackStrategy(
        implementation: platform == .iOS && actualIOSVersion >= 16.0 ? .navigationStack : .navigationView,
        reasoning: "No Layer 2 strategy provided, using platform-appropriate default"
    )
}

