// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
// SixLayerFramework v4.3.1 - Metal Rendering Crash Fix + Performance Layer Removal + Swift Testing Migration

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
        .package(url: "https://github.com/nalexn/ViewInspector", from: "0.9.7"),
        .package(url: "https://github.com/apple/swift-testing", exact: "0.99.0")
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
            dependencies: [
                "SixLayerFramework",
                "ViewInspector",
                .product(name: "Testing", package: "swift-testing")
            ],
            path: "Development/Tests/SixLayerFrameworkTests",
            exclude: [
                // Function index moved to docs directory
            ]
        ),
        
    ]
)
