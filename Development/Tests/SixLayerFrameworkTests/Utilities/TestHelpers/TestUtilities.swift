import Foundation
import SwiftUI
@testable import SixLayerFramework

// MARK: - Shared Test Data Models

struct TestItem: Identifiable, CardDisplayable, Hashable, @unchecked Sendable {
    let id: AnyHashable
    let title: String
    let subtitle: String?
    let description: String?
    let icon: String?
    let color: Color?
    let value: Any?
    
    // Constructor with auto-generated UUID ID
    init(title: String, subtitle: String? = nil, description: String? = nil, icon: String? = nil, color: Color? = nil, value: Any? = nil) {
        self.id = UUID()
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.icon = icon
        self.color = color
        self.value = value
    }
    
    // Constructor with explicit ID (String or UUID)
    init(id: AnyHashable, title: String, subtitle: String? = nil, description: String? = nil, icon: String? = nil, color: Color? = nil, value: Any? = nil) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.icon = icon
        self.color = color
        self.value = value
    }
    
    var cardTitle: String { title }
    var cardSubtitle: String? { subtitle }
    var cardDescription: String? { description }
    var cardIcon: String? { icon }
    var cardColor: Color? { color }
    
    // MARK: - Hashable Conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(subtitle)
        hasher.combine(description)
        hasher.combine(icon)
    }
    
    static func == (lhs: TestItem, rhs: TestItem) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.subtitle == rhs.subtitle &&
               lhs.description == rhs.description &&
               lhs.icon == rhs.icon
    }
}

struct MockItem: Identifiable {
    let id: Int
}

struct MockNavigationItem: Identifiable, Hashable {
    let id: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MockNavigationItem, rhs: MockNavigationItem) -> Bool {
        return lhs.id == rhs.id
    }
}

struct MockHierarchicalData {
    let id = UUID()
    let name = "Root"
    let children: [MockHierarchicalData] = []
}

// MARK: - Test Helper Functions

func createTestHints(
    dataType: DataTypeHint = .collection,
    presentationPreference: PresentationPreference = .automatic,
    complexity: ContentComplexity = .moderate,
    context: PresentationContext = .dashboard,
    customPreferences: [String: String] = [:]
) -> PresentationHints {
    return PresentationHints(
        dataType: dataType,
        presentationPreference: presentationPreference,
        complexity: complexity,
        context: context,
        customPreferences: customPreferences
    )
}
