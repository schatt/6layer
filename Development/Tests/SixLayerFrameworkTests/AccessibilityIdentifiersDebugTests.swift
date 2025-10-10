import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// Debug Test: Check if .automaticAccessibilityIdentifiers() works at all
@MainActor
final class AccessibilityIdentifiersDebugTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
