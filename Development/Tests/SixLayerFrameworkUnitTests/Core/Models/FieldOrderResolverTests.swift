import Testing
@testable import SixLayerFramework

/// TDD: Core ordering behavior for field display
@Suite("Field Order Resolver")
struct FieldOrderResolverTests {
    
    // MARK: - Helpers
    private func makeRules(
        list: [String]? = nil,
        weights: [String: Int] = [:],
        groups: [FieldGroup] = [],
        traitOverrides: [FieldTrait: FieldOrderRules] = [:]
    ) -> FieldOrderRules {
        return FieldOrderRules(
            explicitOrder: list,
            perFieldWeights: weights,
            groups: groups,
            traitOverrides: traitOverrides
        )
    }
    
    // MARK: - Tests
    @Test func ordersByExplicitListThenAppendsRemaining() async throws {
        let fields = ["title","status","priority","notes"]
        let rules = makeRules(list: ["title","status","priority"]) // notes should append
        let ordered = FieldOrderResolver.resolve(fields: fields, rules: rules)
        #expect(ordered == ["title","status","priority","notes"]) 
    }
    
    @Test func ordersByWeightsWhenNoListProvided() async throws {
        let fields = ["title","status","priority","notes"]
        let rules = makeRules(weights: ["title": 10, "status": 20, "priority": 30])
        // Highest weight first; unspecified (notes) goes last, stable name tie-break
        let ordered = FieldOrderResolver.resolve(fields: fields, rules: rules)
        #expect(ordered == ["priority","status","title","notes"]) 
    }
    
    @Test func listWinsOverWeightsForSpecifiedFields() async throws {
        let fields = ["a","b","c","d"]
        let rules = makeRules(list: ["c","a"], weights: ["a": 100, "b": 50, "d": 75])
        // c,a from list first (in that order), then remaining by weights: d(75), b(50)
        let ordered = FieldOrderResolver.resolve(fields: fields, rules: rules)
        #expect(ordered == ["c","a","d","b"]) 
    }
    
    @Test func ignoresUnknownKeysAndKeepsDeterministicOrder() async throws {
        let fields = ["x","y"]
        let rules = makeRules(list: ["z","x"]) // z unknown, skip; x known
        let ordered = FieldOrderResolver.resolve(fields: fields, rules: rules)
        #expect(ordered == ["x","y"]) 
    }
    
    @Test func respectsGroupsThenOrdersWithinGroups() async throws {
        let fields = ["title","status","priority","notes","sizeUnit"]
        let groups = [
            FieldGroup(id: "meta", title: "Overview", fields: ["title","status","priority"]),
            FieldGroup(id: "sizing", title: "Sizing", fields: ["sizeUnit"])
        ]
        let rules = makeRules(weights: ["status": 20, "title": 10, "priority": 30], groups: groups)
        // Groups order as declared; within group use weights: priority(30), status(20), title(10)
        // Remaining field (notes) appends at end
        let ordered = FieldOrderResolver.resolve(fields: fields, rules: rules)
        #expect(ordered == ["priority","status","title","sizeUnit","notes"]) 
    }
    
    @Test func appliesTraitOverrideForCompact() async throws {
        let fields = ["title","status","priority","notes"]
        let base = makeRules(list: ["title","status","priority"]) // default
        let compactOverride = makeRules(list: ["title","priority"]) // compact should prioritize title,priority then others
        let rules = FieldOrderRules(
            explicitOrder: base.explicitOrder,
            perFieldWeights: base.perFieldWeights,
            groups: base.groups,
            traitOverrides: [.compact: compactOverride]
        )
        let ordered = FieldOrderResolver.resolve(fields: fields, rules: rules, activeTrait: .compact)
        #expect(ordered == ["title","priority","status","notes"]) 
    }
}


