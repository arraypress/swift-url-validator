// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "URLValidator",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "URLValidator",
            targets: ["URLValidator"]),
    ],
    targets: [
        .target(
            name: "URLValidator"),
        .testTarget(
            name: "URLValidatorTests",
            dependencies: ["URLValidator"]
        ),
    ]
)
