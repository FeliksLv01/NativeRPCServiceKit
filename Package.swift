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
    dependencies: [
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", from: "3.8.0"),
    ],
    targets: [
        .target(
            name: "NativeRPCServiceKit",
            dependencies: [.product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack")]
        ),
        .testTarget(
            name: "NativeRPCServiceKitTests",
            dependencies: ["NativeRPCServiceKit"]
        ),
    ]
)
