#!/bin/bash

# Fix all remaining test issues systematically

echo "Fixing main actor isolation issues in all accessibility test files..."

# List of files that need fixing based on the test output
files=(
    "Development/Tests/SixLayerFrameworkTests/ImageMetadataIntelligenceAccessibilityTests.swift"
    "Development/Tests/SixLayerFrameworkTests/ImageProcessingPipelineAccessibilityTests.swift"
    "Development/Tests/SixLayerFrameworkTests/InternationalizationServiceAccessibilityTests.swift"
    "Development/Tests/SixLayerFrameworkTests/MaterialAccessibilityManagerAccessibilityTests.swift"
    "Development/Tests/SixLayerFrameworkTests/OCRServiceAccessibilityTests.swift"
    "Development/Tests/SixLayerFrameworkTests/PlatformOCRComponentsLayer4AccessibilityTests.swift"
    "Development/Tests/SixLayerFrameworkTests/PlatformOCRLayoutDecisionLayer2AccessibilityTests.swift"
    "Development/Tests/SixLayerFrameworkTests/PlatformOCRSemanticLayer1AccessibilityTests.swift"
    "Development/Tests/SixLayerFrameworkTests/PlatformOCRStrategySelectionLayer3AccessibilityTests.swift"
    "Development/Tests/SixLayerFrameworkTests/PlatformPhotoComponentsLayer4AccessibilityTests.swift"
    "Development/Tests/SixLayerFrameworkTests/PlatformPhotoLayoutDecisionLayer2AccessibilityTests.swift"
    "Development/Tests/SixLayerFrameworkTests/PlatformPhotoSemanticLayer1AccessibilityTests.swift"
    "Development/Tests/SixLayerFrameworkTests/PlatformPhotoStrategySelectionLayer3AccessibilityTests.swift"
    "Development/Tests/SixLayerFrameworkTests/PlatformSemanticLayer1HierarchicalTemporalAccessibilityTests.swift"
    "Development/Tests/SixLayerFrameworkTests/PlatformSemanticLayer1ModalFormAccessibilityTests.swift"
    "Development/Tests/SixLayerFrameworkTests/AppleHIGComplianceManagerAccessibilityTests.swift"
    "Development/Tests/SixLayerFrameworkTests/AssistiveTouchManagerAccessibilityTests.swift"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "Fixing $file..."
        
        # Fix setup/teardown methods - add @MainActor and remove await
        sed -i '' 's/override func setUp() async throws {/@MainActor\n    override func setUp() async throws {/g' "$file"
        sed -i '' 's/override func tearDown() async throws {/@MainActor\n    override func tearDown() async throws {/g' "$file"
        sed -i '' 's/await setupTestEnvironment()/setupTestEnvironment()/g' "$file"
        sed -i '' 's/await cleanupTestEnvironment()/cleanupTestEnvironment()/g' "$file"
        
        # Fix test methods - wrap config access in MainActor.run
        sed -i '' 's/let config = AccessibilityIdentifierConfig\.shared/await MainActor.run { let config = AccessibilityIdentifierConfig.shared/g' "$file"
        sed -i '' 's/XCTAssertTrue(config\.enableAutoIDs/XCTAssertTrue(config.enableAutoIDs/g' "$file"
        sed -i '' 's/XCTAssertEqual(config\.namespace/XCTAssertEqual(config.namespace/g' "$file"
        
        # Add closing brace for MainActor.run blocks
        sed -i '' 's/XCTAssertEqual(config\.namespace, "SixLayer".*$/XCTAssertEqual(config.namespace, "SixLayer", "Component should use correct namespace")\n        }/g' "$file"
        
        # Fix missing override keywords in extensions
        sed -i '' 's/    func setupTestEnvironment() {/    override func setupTestEnvironment() {/g' "$file"
        sed -i '' 's/    func cleanupTestEnvironment() {/    override func cleanupTestEnvironment() {/g' "$file"
        
        echo "Fixed $file"
    else
        echo "File not found: $file"
    fi
done

echo "All test files have been fixed!"
