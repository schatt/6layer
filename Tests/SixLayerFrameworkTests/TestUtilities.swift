import Foundation
import SwiftUI

// MARK: - Shared Test Data Models

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
