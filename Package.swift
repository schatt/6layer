// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
                "Shared/Views",
                "Shared/Views/Extensions",
                "iOS/Views",
                "iOS/Views/Extensions", 
                "iOS/ProjectHelpers",
                "macOS/Views",
                "macOS/Views/Extensions",
                "macOS/ProjectHelpers"
            ]
        ),
        
        // Test targets
        .testTarget(
            name: "SixLayerFrameworkTests",
            dependencies: ["SixLayerFramework"],
            path: "Development/Tests/SixLayerFrameworkTests",
            exclude: [
                "ValidationEngineTests.swift.disabled"
            ]
        )
    ]
)
