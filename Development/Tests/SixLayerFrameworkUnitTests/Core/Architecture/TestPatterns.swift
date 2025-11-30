import Testing
import SwiftUI
@testable import SixLayerFramework

/// DRY Test Patterns for Unit Tests
/// Provides reusable patterns for non-UI tests (no ViewInspector dependency)
@MainActor
open class TestPatterns {
    
    // MARK: - Test Data Types
    
    public struct TestDataItem: Identifiable {
        public let id = UUID()
        let title: String
        let subtitle: String?
        let description: String?
        let value: Int
        let isActive: Bool
    }
    
    // MARK: - Test Data Factory
    
    static func createTestItem(
        title: String = "Test Item",
        subtitle: String? = "Test Subtitle",
        description: String? = "Test Description",
        value: Int = 42,
        isActive: Bool = true
    ) -> TestDataItem {
        return TestDataItem(
            title: title,
            subtitle: subtitle,
            description: description,
            value: value,
            isActive: isActive
        )
    }
    
    static func createBooleanTestCases() -> [(Bool, String)] {
        return [
            (true, "enabled"),
            (false, "disabled")
        ]
    }
}

