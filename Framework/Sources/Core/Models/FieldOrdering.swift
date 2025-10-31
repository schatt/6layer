//
//  FieldOrdering.swift
//  SixLayerFramework
//
//  Deterministic field ordering support for IntelligentFormView and hints.
//

import Foundation

// MARK: - Ordering Types

/// UI trait for ordering overrides (keep minimal and cross-platform)
public enum FieldTrait: Hashable, Sendable {
    case compact
    case regular
}

/// Group of fields with an identifier and optional title for rendering
public struct FieldGroup: Equatable, Sendable {
    public let id: String
    public let title: String?
    public let fields: [String]
    
    public init(id: String, title: String? = nil, fields: [String]) {
        self.id = id
        self.title = title
        self.fields = fields
    }
}

/// Rules for field ordering and grouping
public struct FieldOrderRules: Equatable, Sendable {
    /// Explicit overall order; unknown keys are ignored
    public let explicitOrder: [String]?
    /// Per-field weights; higher values sort earlier
    public let perFieldWeights: [String: Int]
    /// Groups in declaration order
    public let groups: [FieldGroup]
    /// Trait-specific overrides (e.g., compact)
    public let traitOverrides: [FieldTrait: FieldOrderRules]
    
    public init(
        explicitOrder: [String]? = nil,
        perFieldWeights: [String: Int] = [:],
        groups: [FieldGroup] = [],
        traitOverrides: [FieldTrait: FieldOrderRules] = [:]
    ) {
        self.explicitOrder = explicitOrder
        self.perFieldWeights = perFieldWeights
        self.groups = groups
        self.traitOverrides = traitOverrides
    }
}

// MARK: - Resolver

public enum FieldOrderResolver {
    /// Resolve deterministic field order from rules
    public static func resolve(
        fields: [String],
        rules: FieldOrderRules,
        activeTrait: FieldTrait? = nil
    ) -> [String] {
        // Apply trait override if present
        if let trait = activeTrait, let override = rules.traitOverrides[trait] {
            return resolve(fields: fields, rules: override, activeTrait: nil)
        }
        
        // If groups provided: flatten groups in declaration order, ordering within by list/weights
        if !rules.groups.isEmpty {
            var ordered: [String] = []
            var consumed = Set<String>()
            
            for group in rules.groups {
                let intersect = group.fields.filter { fields.contains($0) }
                if intersect.isEmpty { continue }
                let within = orderWithin(fields: intersect, rules: rules)
                for f in within where !consumed.contains(f) {
                    ordered.append(f)
                    consumed.insert(f)
                }
            }
            
            // Append any remaining fields not covered by groups using standard ordering
            let remaining = fields.filter { !consumed.contains($0) }
            let tail = orderWithin(fields: remaining, rules: rules)
            return ordered + tail
        }
        
        // No groups: simple ordering
        return orderWithin(fields: fields, rules: rules)
    }
    
    private static func orderWithin(fields: [String], rules: FieldOrderRules) -> [String] {
        // 1) Explicit list precedence (relative order preserved)
        if let list = rules.explicitOrder {
            var result: [String] = []
            var used = Set<String>()
            for key in list where fields.contains(key) {
                result.append(key)
                used.insert(key)
            }
            // 2) Remaining by weights desc; if no weights, preserve original relative order; else name asc for determinism
            let remaining = fields.filter { !used.contains($0) }
            let hasAnyWeights = remaining.contains { rules.perFieldWeights[$0] != nil }
            let sortedRemaining: [String]
            if hasAnyWeights {
                sortedRemaining = remaining.sorted { lhs, rhs in
                    let wl = rules.perFieldWeights[lhs] ?? Int.min
                    let wr = rules.perFieldWeights[rhs] ?? Int.min
                    if wl != wr { return wl > wr }
                    return lhs < rhs
                }
            } else {
                // Preserve original relative order when no weights specified
                sortedRemaining = remaining
            }
            return result + sortedRemaining
        }
        
        // Only weights/name
        return fields.sorted { lhs, rhs in
            let wl = rules.perFieldWeights[lhs] ?? Int.min
            let wr = rules.perFieldWeights[rhs] ?? Int.min
            if wl != wr { return wl > wr }
            return lhs < rhs
        }
    }
    
    /// Validate rules against available fields and return warnings (strings) for diagnostics
    public static func validate(
        fields: [String],
        rules: FieldOrderRules
    ) -> [String] {
        var warnings: [String] = []
        let fieldSet = Set(fields)
        
        // Unknown keys in explicit list
        if let list = rules.explicitOrder {
            let unknown = list.filter { !fieldSet.contains($0) }
            if !unknown.isEmpty {
                warnings.append("Unknown field ids in explicitOrder: \(unknown.joined(separator: ", "))")
            }
        }
        
        // Unknown keys in weights
        let unknownWeights = rules.perFieldWeights.keys.filter { !fieldSet.contains($0) }
        if !unknownWeights.isEmpty {
            warnings.append("Unknown field ids in perFieldWeights: \(unknownWeights.joined(separator: ", "))")
        }
        
        // Unknown keys in groups
        for group in rules.groups {
            let unknown = group.fields.filter { !fieldSet.contains($0) }
            if !unknown.isEmpty {
                warnings.append("Unknown field ids in group \(group.id): \(unknown.joined(separator: ", "))")
            }
        }
        
        return warnings
    }
}


