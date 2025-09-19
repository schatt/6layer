// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
// SixLayerFramework v3.0.1 - Major UI Binding Improvements with iOS Compilation Fixes

import PackageDescription

let package = Package(
    name: "SixLayerFramework",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        // Main framework product - single library for all platforms
        .library(
            name: "SixLayerFramework",
            targets: ["SixLayerFramework"]
        )
    ],
    dependencies: [
        // Removed unused dependencies: ZIPFoundation and ViewInspector
    ],
    targets: [
        // Main framework target - includes only the essential framework code
        .target(
            name: "SixLayerFramework",
            dependencies: [],
            path: "Framework/Sources",
            exclude: [
                "Shared/ProjectHelpers/ExampleHelpers.swift",
                "Shared/ProjectHelpers/ExtensibleHintsExample.swift"
            ],
            sources: [
                "Shared/Models",
                "Shared/Services",
                "Shared/Views",
                "Shared/Views/Extensions",
                "Shared/WindowDetection",
                "iOS/Views",
                "iOS/Views/Extensions", 
                "iOS/ProjectHelpers",
                "iOS/WindowDetection",
                "macOS/Views",
                "macOS/Views/Extensions",
                "macOS/ProjectHelpers",
                "macOS/WindowDetection"
            ]
        ),
        
        // Test targets
        .testTarget(
            name: "SixLayerFrameworkTests",
            dependencies: ["SixLayerFramework"],
            path: "Development/Tests/SixLayerFrameworkTests",
            exclude: [
                "ValidationEngineTests.swift.disabled",
                "OCRSemanticLayerTests.swift.disabled",
                "LiquidGlassDesignSystemTests.swift.disabled",
                "FunctionIndex_Tests_SixLayerFrameworkTests.md"
            ]
        )
    ]
)
