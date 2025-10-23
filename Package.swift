// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
// SixLayerFramework v4.5.0 - CardDisplayHelper Hint System + Dependency Injection + Compilation Fixes

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
            .package(url: "https://github.com/nalexn/ViewInspector", from: "0.9.7")
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
                "Extensions"
            ]
        ),
        
        // Test targets - organized into logical structure
        .testTarget(
            name: "SixLayerFrameworkTests",
            dependencies: [
                "SixLayerFramework",
                "ViewInspector"
            ],
            path: "Development/Tests/SixLayerFrameworkTests",
            exclude: [
                // Function index moved to docs directory
            ],
            sources: [
                "Core",
                "Layers", 
                "Features",
                "Integration",
                "Utilities"
            ]
        ),
        
    ]
)
