// swift-tools-version: 5.4

import PackageDescription

let package = Package(
    name: "NativeRPCServiceKit",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "NativeRPCServiceKit",
            targets: ["NativeRPCServiceKit"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "NativeRPCServiceKit"),
        .testTarget(
            name: "NativeRPCServiceKitTests",
            dependencies: ["NativeRPCServiceKit"]
        ),
    ]
)
