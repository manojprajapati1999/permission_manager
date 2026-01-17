import PackageDescription

let package = Package(
    name: "permission_manager",
    platforms: [
        .iOS(.v11)
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
            path: "Classes" // or wherever your Swift files are
        )
    ]
)
