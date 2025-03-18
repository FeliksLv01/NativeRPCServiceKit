// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "NativeRPCServiceKit",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .macCatalyst(.v13),
    ],
    products: [
        .library(
            name: "NativeRPCServiceKit",
            targets: ["NativeRPCServiceKit"]
        )
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
