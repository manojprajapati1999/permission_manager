// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "permission_manager",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .library(
            name: "permission_manager",
            targets: ["permission_manager"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "permission_manager",
            dependencies: [],
            path: "Sources/permission_manager",
            publicHeadersPath: "."
        )
    ]
)
