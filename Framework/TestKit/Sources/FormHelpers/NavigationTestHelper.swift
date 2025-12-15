//
//  NavigationTestHelper.swift
//  SixLayerTestKit
//
//  Testing utilities for navigation flows and Layer 1 functions
//

import Foundation
import SwiftUI
import SixLayerFramework

/// Helper class for testing navigation flows and Layer 1 functions
public class NavigationTestHelper {

    // MARK: - Navigation State Tracking

    public private(set) var navigationStack: [String] = []
    public private(set) var presentedSheets: [String] = []
    public private(set) var presentedAlerts: [String] = []

    // MARK: - Navigation Simulation

    /// Simulate pushing a view onto navigation stack
    public func simulatePush(viewId: String) {
        navigationStack.append(viewId)
    }

    /// Simulate popping from navigation stack
    public func simulatePop() -> String? {
        return navigationStack.popLast()
    }

    /// Simulate presenting a sheet
    public func simulatePresentSheet(sheetId: String) {
        presentedSheets.append(sheetId)
    }

    /// Simulate dismissing a sheet
    public func simulateDismissSheet() -> String? {
        return presentedSheets.popLast()
    }

    /// Simulate presenting an alert
    public func simulatePresentAlert(alertId: String) {
        presentedAlerts.append(alertId)
    }

    /// Simulate dismissing an alert
    public func simulateDismissAlert() -> String? {
        return presentedAlerts.popLast()
    }

    /// Reset all navigation state
    public func reset() {
        navigationStack = []
        presentedSheets = []
        presentedAlerts = []
    }

    // MARK: - Layer 1 Function Testing

    /// Test Layer 1 semantic functions
    public func testSemanticFunctions() -> [String: Any] {
        return [
            "buttonTapped": simulateButtonTap(),
            "textFieldChanged": simulateTextFieldChange(),
            "toggleSwitched": simulateToggleSwitch(),
            "pickerSelected": simulatePickerSelection(),
            "sliderMoved": simulateSliderMovement()
        ]
    }

    private func simulateButtonTap() -> Bool {
        // Simulate button tap - in real app this would trigger business logic
        return true
    }

    private func simulateTextFieldChange() -> String {
        // Simulate text field change
        return TestDataGenerator.randomString(length: 10)
    }

    private func simulateToggleSwitch() -> Bool {
        // Simulate toggle switch
        return Bool.random()
    }

    private func simulatePickerSelection() -> String {
        // Simulate picker selection
        return ["Option 1", "Option 2", "Option 3"].randomElement()!
    }

    private func simulateSliderMovement() -> Double {
        // Simulate slider movement
        return Double.random(in: 0...100)
    }

    // MARK: - View State Verification

    /// Verify navigation state
    public func verifyNavigationState(expectedStack: [String], expectedSheets: [String] = [], expectedAlerts: [String] = []) -> Bool {
        return navigationStack == expectedStack &&
               presentedSheets == expectedSheets &&
               presentedAlerts == expectedAlerts
    }

    /// Get current navigation path
    public func currentNavigationPath() -> String {
        return navigationStack.joined(separator: " -> ")
    }

    // MARK: - Mock Navigation Actions

    /// Create mock navigation actions for testing
    public func createMockNavigationActions() -> [String: () -> Void] {
        return [
            "pushHome": { [weak self] in self?.simulatePush(viewId: "home") },
            "pushSettings": { [weak self] in self?.simulatePush(viewId: "settings") },
            "pushProfile": { [weak self] in self?.simulatePush(viewId: "profile") },
            "pop": { [weak self] in _ = self?.simulatePop() },
            "presentSheet": { [weak self] in self?.simulatePresentSheet(sheetId: "options") },
            "dismissSheet": { [weak self] in _ = self?.simulateDismissSheet() },
            "showAlert": { [weak self] in self?.simulatePresentAlert(alertId: "error") },
            "dismissAlert": { [weak self] in _ = self?.simulateDismissAlert() }
        ]
    }

    // MARK: - Flow Testing

    /// Test a complete user flow
    public func testUserFlow(_ actions: [() -> Void]) -> [String] {
        reset()
        var flowLog: [String] = []

        for action in actions {
            action()
            flowLog.append(currentNavigationPath())
        }

        return flowLog
    }

    /// Test navigation guard conditions
    public func testNavigationGuards(
        conditions: [String: Bool],
        guards: [String: (Bool) -> Bool]
    ) -> [String: Bool] {
        var results: [String: Bool] = [:]

        for (conditionKey, conditionValue) in conditions {
            if let guardFunc = guards[conditionKey] {
                results[conditionKey] = guardFunc(conditionValue)
            }
        }

        return results
    }

    // MARK: - Deep Link Testing

    /// Simulate deep link navigation
    public func simulateDeepLink(_ url: URL) -> [String] {
        reset()

        // Parse URL and simulate navigation
        if url.path == "/settings" {
            simulatePush(viewId: "settings")
        } else if url.path == "/profile" {
            simulatePush(viewId: "profile")
        } else if url.path.hasPrefix("/item/") {
            let itemId = String(url.path.dropFirst(6))
            simulatePush(viewId: "item-\(itemId)")
        }

        return navigationStack
    }

    /// Test deep link handling
    public func testDeepLinkHandling(urls: [URL]) -> [[String]] {
        var results: [[String]] = []

        for url in urls {
            let result = simulateDeepLink(url)
            results.append(result)
        }

        return results
    }
}