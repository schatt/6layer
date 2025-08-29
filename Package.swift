// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SixLayerFramework",
    platforms: [
        .iOS(.v15),
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
        // Main framework target - includes all platform-specific code
        .target(
            name: "SixLayerFramework",
            dependencies: [],
            path: "Sources",
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
        
        // Framework tests
        .testTarget(
            name: "SixLayerFrameworkTests",
            dependencies: [
                "SixLayerFramework"
            ],
            path: "Tests/SixLayerFrameworkTests"
        ),
        
        // macOS-specific tests
        .testTarget(
            name: "SixLayerMacOSTests",
            dependencies: [
                "SixLayerFramework"
            ],
            path: "Tests/SixLayerMacOSTests"
        )
    ]
)
