import SwiftUI
import SixLayerFramework

// Example demonstrating deterministic field ordering via orderRulesProvider
struct FieldOrderingExample: View {
    struct TaskForm {
        let title: String
        let status: String
        let priority: Int
        let sizeUnit: String
        let estimatedHours: Double
        let notes: String
    }
    
    init() {
        // Install a global provider once (e.g., at app launch)
        IntelligentFormView.orderRulesProvider = { analysis in
            // Prefer explicit order for Task-like models (by convention: fields present)
            let names = Set(analysis.fields.map { $0.name })
            let isTask = ["title","status","priority","sizeUnit","estimatedHours","notes"].allSatisfy { names.contains($0) }
            if isTask {
                let base = FieldOrderRules(
                    explicitOrder: [
                        "title", "status", "priority", "sizeUnit", "estimatedHours", "notes"
                    ]
                )
                // Example compact override: emphasize title and priority on small screens
                let compact = FieldOrderRules(explicitOrder: ["title","priority","status"])
                return FieldOrderRules(
                    explicitOrder: base.explicitOrder,
                    perFieldWeights: base.perFieldWeights,
                    groups: base.groups,
                    traitOverrides: [.compact: compact]
                )
            }
            // No special rules – fall back to IntelligentFormView defaults (title/name first)
            return nil
        }
    }
    
    var body: some View {
        // Simple demonstration form
        let task = TaskForm(
            title: "Upgrade infra",
            status: "In Progress",
            priority: 2,
            sizeUnit: "points",
            estimatedHours: 8.0,
            notes: "Roll out gradually."
        )
        
        IntelligentFormView.generateForm(for: task)
            .padding()
    }
}


