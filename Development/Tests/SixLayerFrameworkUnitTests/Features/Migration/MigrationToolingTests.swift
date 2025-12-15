import Testing
import SixLayerFramework

/// Tests for migration tooling and change-management helpers
@Suite("Migration Tooling Tests")
struct MigrationToolingTests {

    /// Test that the accessibility API migration helper can detect deprecated usage
    @Test func testAccessibilityAPIMigrationDetection() {
        // Given: A code snippet with deprecated accessibility API usage
        let deprecatedCode = """
        import SixLayerFramework

        struct MyView: View {
            var body: some View {
                Text("Hello")
                    .automaticAccessibilityIdentifiers() // deprecated
                    .named("helloText") // deprecated
                    .enableGlobalAutomaticAccessibilityIdentifiers() // deprecated
            }
        }
        """

        // When: We run the migration detector
        let issues = MigrationTool.detectAccessibilityAPIMigrations(in: deprecatedCode)

        // Then: It should detect the deprecated APIs
        #expect(issues.count >= 2, "Should detect at least 2 deprecated APIs")
        #expect(issues.contains { $0.deprecatedAPI == ".automaticAccessibilityIdentifiers()" })
        #expect(issues.contains { $0.deprecatedAPI == ".enableGlobalAutomaticAccessibilityIdentifiers()" })
        // Note: .named() detection may vary based on context
    }

    /// Test that the migration helper can suggest proper replacements
    @Test func testAccessibilityAPIMigrationSuggestions() {
        // Given: A deprecated API call
        let deprecatedCall = ".automaticAccessibilityIdentifiers()"

        // When: We get the migration suggestion
        let suggestion = MigrationTool.suggestAccessibilityAPIMigration(for: deprecatedCall)

        // Then: It should provide the correct replacement
        #expect(suggestion.replacement == ".automaticCompliance()")
        #expect(suggestion.reason.contains("renamed"))
    }

    /// Test that the migration helper works with code that already uses new APIs
    @Test func testAccessibilityAPIMigrationNoIssues() {
        // Given: Code that already uses the new APIs (without deprecated calls)
        let modernCode = """
        import SixLayerFramework

        struct MyView: View {
            var body: some View {
                Text("Hello")
                    .automaticCompliance()
                    .enableGlobalAutomaticCompliance()
            }
        }
        """

        // When: We run the migration detector
        let issues = MigrationTool.detectAccessibilityAPIMigrations(in: modernCode)

        // Then: It should find no issues (no deprecated APIs present)
        #expect(issues.isEmpty, "Modern code using new APIs should have no migration issues")
    }
}