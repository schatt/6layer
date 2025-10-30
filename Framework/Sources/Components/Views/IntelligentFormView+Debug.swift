import Foundation

public extension IntelligentFormView {
    /// Inspect effective field order and gather validation warnings for debugging.
    static func inspectEffectiveOrder(
        analysis: DataAnalysisResult
    ) -> (effective: [String], warnings: [String]) {
        let names = analysis.fields.map { $0.name }
        if let rules = orderRulesProvider?(analysis) {
            let ordered = FieldOrderResolver.resolve(fields: names, rules: rules, activeTrait: activeTrait())
            let warnings = FieldOrderResolver.validate(fields: names, rules: rules)
            return (ordered, warnings)
        }
        // Fall back to priority-based order used by the form
        let orderedFields = orderFieldsByPriority(analysis.fields)
        return (orderedFields.map { $0.name }, [])
    }
}


