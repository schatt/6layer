#!/bin/bash

# Comprehensive fix for all remaining test issues

echo "Fixing all remaining test issues..."

# Fix async warnings and main actor isolation issues
find Development/Tests/SixLayerFrameworkTests -name "*.swift" -exec sed -i '' 's/await setupTestEnvironment()/setupTestEnvironment()/g' {} \;
find Development/Tests/SixLayerFrameworkTests -name "*.swift" -exec sed -i '' 's/await cleanupTestEnvironment()/cleanupTestEnvironment()/g' {} \;

# Add @MainActor to setUp and tearDown methods that don't have it
find Development/Tests/SixLayerFrameworkTests -name "*.swift" -exec sed -i '' 's/^    override func setUp() async throws {/@MainActor\n    override func setUp() async throws {/g' {} \;
find Development/Tests/SixLayerFrameworkTests -name "*.swift" -exec sed -i '' 's/^    override func tearDown() async throws {/@MainActor\n    override func tearDown() async throws {/g' {} \;

# Fix missing override keywords in extensions
find Development/Tests/SixLayerFrameworkTests -name "*.swift" -exec sed -i '' 's/    func setupTestEnvironment() {/    override func setupTestEnvironment() {/g' {} \;
find Development/Tests/SixLayerFrameworkTests -name "*.swift" -exec sed -i '' 's/    func cleanupTestEnvironment() {/    override func cleanupTestEnvironment() {/g' {} \;

# Fix hasAccessibilityIdentifier calls by wrapping in MainActor.run
find Development/Tests/SixLayerFrameworkTests -name "*.swift" -exec sed -i '' 's/let hasAccessibilityID = hasAccessibilityIdentifier(/let hasAccessibilityID = await MainActor.run { hasAccessibilityIdentifier(/g' {} \;

# Add closing brace for MainActor.run blocks
find Development/Tests/SixLayerFrameworkTests -name "*.swift" -exec sed -i '' 's/XCTAssertTrue(hasAccessibilityID, ".*should generate accessibility identifiers.*")/XCTAssertTrue(hasAccessibilityID, "Component should generate accessibility identifiers")\n        }/g' {} \;

echo "All test files have been fixed!"
