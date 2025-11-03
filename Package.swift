// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
// SixLayerFramework v5.0.0 - Major Testing and Accessibility Release

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
            .package(url: "https://github.com/nalexn/ViewInspector", branch: "0.10.4")
        ],
    targets: [
        // Main framework target - organized into logical structure
        .target(
            name: "SixLayerFramework",
            dependencies: [],
            path: "Framework/Sources",
            exclude: [
                "Core/ExampleHelpers.swift",
                "Core/ExtensibleHintsExample.swift"
            ],
            sources: [
                "Core",
                "Layers",
                "Components",
                "Platform",
                "Extensions",
                "Services",
                "Shared"
            ]
        ),
        
        // Test targets - organized into logical structure
        .testTarget(
            name: "SixLayerFrameworkTests",
            dependencies: [
                "SixLayerFramework",
                // Temporarily include macOS to verify 0.10.4 branch macOS compatibility
                .product(name: "ViewInspector", package: "ViewInspector", condition: .when(platforms: [.iOS, .macOS]))
            ],
            path: "Development/Tests/SixLayerFrameworkTests",
            exclude: [
                // Function index moved to docs directory
                "BugReports/README.md",
                "BugReports/PlatformImage_v4.6.2/README.md",
                "BugReports/ButtonStyle_v4.6.3/README.md",
                "BugReports/PlatformTypes_v4.6.4/README.md",
                "BugReports/PlatformPhotoPicker_v4.6.5/README.md",
                "BugReports/PlatformTypes_v4.6.6/README.md"
            ]
        ),
        
        // External integration tests - uses normal import (no @testable)
        // Tests the framework from external module perspective
        .testTarget(
            name: "SixLayerFrameworkExternalIntegrationTests",
            dependencies: [
                "SixLayerFramework"
            ],
            path: "Development/Tests/SixLayerFrameworkExternalIntegrationTests"
        ),
        
    ]
)
