// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "permission_manager",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .library(
            name: "permission_manager",
            targets: ["PermissionManager"]
        )
    ],
    targets: [
        .target(
            name: "PermissionManager",
            path: "Classes"
        )
    ]
)
