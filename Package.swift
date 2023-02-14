// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AKHelpers",
    platforms: [
        .iOS(.v11),
        .tvOS(.v11)
    ],
    products: [
        .library(
            name: "AKHelpers",
            targets: ["AKHelpers"]),
    ],
    targets: [
        .target(
            name: "AKHelpers",
            dependencies: []),
        .testTarget(
            name: "AKHelpersTests",
            dependencies: ["AKHelpers"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
