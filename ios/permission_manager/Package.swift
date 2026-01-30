// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "permission_manager",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "permission-manager",
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
