// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SixLayerFramework",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        // Main framework product
        .library(
            name: "SixLayerFramework",
            targets: ["SixLayerFramework"]
        ),
        
        // Platform-specific optimization libraries
        .library(
            name: "SixLayerIOS",
            targets: ["SixLayerIOS"]
        ),
        .library(
            name: "SixLayerMacOS",
            targets: ["SixLayerMacOS"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", from: "0.9.0"),
        .package(url: "https://github.com/nalexn/ViewInspector.git", from: "0.9.0")
    ],
    targets: [
        // Main shared framework target
        .target(
            name: "SixLayerFramework",
            dependencies: ["ZIPFoundation"],
            path: "Sources/Shared",
            exclude: ["ProjectHelpers"],
            sources: [
                "Models",
                "Views",
                "Views/Extensions"
            ]
        ),
        
        // iOS-specific optimizations
        .target(
            name: "SixLayerIOS",
            dependencies: ["SixLayerFramework"],
            path: "Sources/iOS",
            sources: [
                "Views",
                "Views/Extensions",
                "ProjectHelpers"
            ]
        ),
        
        // macOS-specific optimizations
        .target(
            name: "SixLayerMacOS",
            dependencies: ["SixLayerFramework"],
            path: "Sources/macOS",
            sources: [
                "Views",
                "Views/Extensions",
                "ProjectHelpers"
            ]
        ),
        
        // iOS tests
        .testTarget(
            name: "SixLayerFrameworkTests",
            dependencies: [
                "SixLayerFramework",
                "SixLayerIOS",
                "ViewInspector"
            ],
            path: "Tests/SixLayerFrameworkTests"
        ),
        
        // macOS tests
        .testTarget(
            name: "SixLayerMacOSTests",
            dependencies: [
                "SixLayerFramework",
                "SixLayerMacOS",
                "ViewInspector"
            ],
            path: "Tests/SixLayerMacOSTests"
        )
    ]
)
