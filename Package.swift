// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
// SixLayerFramework v5.0.0 - Major Testing and Accessibility Release

import PackageDescription

let package = Package(
    name: "SixLayerFramework",
    platforms: [
        .iOS(.v17),
        .macOS(.v15)
    ],
    products: [
        // Main framework product - single library for all platforms
        .library(
            name: "SixLayerFramework",
            targets: ["SixLayerFramework"]
        )
    ],
        dependencies: [
            .package(url: "https://github.com/nalexn/ViewInspector", from: "0.9.0")
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
                "Services"
            ],
            swiftSettings: [
                // Enable previews only when building in Xcode (where PreviewsMacros plugin is available)
                // Command-line builds (swift test, swift build) don't have PreviewsMacros plugin
                // Uncomment this line when building in Xcode to enable #Preview macros:
                // .define("ENABLE_PREVIEWS")
            ]
        ),
        
        // Unit tests - non-UI tests without ViewInspector dependency
        .testTarget(
            name: "SixLayerFrameworkUnitTests",
            dependencies: [
                "SixLayerFramework"
            ],
            path: "Development/Tests/SixLayerFrameworkUnitTests",
            exclude: [
                // Function index moved to docs directory
                "BugReports/README.md",
                "BugReports/PlatformImage_v4.6.2/README.md",
                "BugReports/ButtonStyle_v4.6.3/README.md",
                "BugReports/PlatformTypes_v4.6.4/README.md",
                "BugReports/PlatformPhotoPicker_v4.6.5/README.md",
                "BugReports/PlatformTypes_v4.6.6/README.md",
                // Documentation files
                "Utilities/TestHelpers/CoreDataTestingGuide.md"
            ]
        ),
        
        // UI tests - ViewInspector-dependent tests for UI/view inspection
        .testTarget(
            name: "SixLayerFrameworkUITests",
            dependencies: [
                "SixLayerFramework",
                // ✅ ViewInspector macOS support verified - builds successfully on macOS SDK 26.2
                // All types (VideoPlayer, SignInWithAppleButton, MapAnnotation, etc.) compile on macOS
                .product(name: "ViewInspector", package: "ViewInspector")
            ],
            path: "Development/Tests/SixLayerFrameworkUITests",
            swiftSettings: [
                // ✅ VERIFIED: ViewInspector builds successfully on macOS SDK 26.2
                // Investigation confirmed all types compile on macOS - issue was incorrect
                // This flag enables ViewInspector-dependent tests on macOS
                .define("VIEW_INSPECTOR_MAC_FIXED")
            ]
        ),
        
        // External integration tests - uses normal import (no @testable)
        // Tests the framework from external module perspective
        .testTarget(
            name: "SixLayerFrameworkExternalIntegrationTests",
            dependencies: [
                "SixLayerFramework"
            ],
            path: "Development/Tests/SixLayerFrameworkExternalIntegrationTests",
            exclude: [
                // Documentation files
                "README.md"
            ]
        ),
        
    ]
)
