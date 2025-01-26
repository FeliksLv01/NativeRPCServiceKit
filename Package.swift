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
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest")
    ],
    targets: [
        .target(name: "NativeRPCServiceKit", dependencies: ["NativeRPCServiceMacrosPlugin"]),
        .macro(
            name: "NativeRPCServiceMacrosPlugin",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "NativeRPCServiceKitTests",
            dependencies: ["NativeRPCServiceKit"]
        ),
    ]
)
