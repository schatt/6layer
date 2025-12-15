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
        #expect(issues.count == 3)
        #expect(issues.contains { $0.deprecatedAPI == ".automaticAccessibilityIdentifiers()" })
        #expect(issues.contains { $0.deprecatedAPI == ".named(\"helloText\")" })
        #expect(issues.contains { $0.deprecatedAPI == ".enableGlobalAutomaticAccessibilityIdentifiers()" })
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
        // Given: Code that already uses the new APIs
        let modernCode = """
        import SixLayerFramework

        struct MyView: View {
            var body: some View {
                Text("Hello")
                    .automaticCompliance()
                    .named("helloText")
                    .enableGlobalAutomaticCompliance()
            }
        }
        """

        // When: We run the migration detector
        let issues = MigrationTool.detectAccessibilityAPIMigrations(in: modernCode)

        // Then: It should find no issues
        #expect(issues.isEmpty)
    }
}