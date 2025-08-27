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
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", from: "0.9.0"),
        .package(url: "https://github.com/nalexn/ViewInspector.git", from: "0.9.0")
    ],
    targets: [
        // Main framework target - includes all platform-specific code
        .target(
            name: "SixLayerFramework",
            dependencies: ["ZIPFoundation"],
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
                "SixLayerFramework",
                "ViewInspector"
            ],
            path: "Tests/SixLayerFrameworkTests"
        ),
        
        // macOS-specific tests
        .testTarget(
            name: "SixLayerMacOSTests",
            dependencies: [
                "SixLayerFramework",
                "ViewInspector"
            ],
            path: "Tests/SixLayerMacOSTests"
        )
    ]
)
