// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MetalBirdRenderer",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .macCatalyst(.v16),
        .watchOS(.v9),
        .tvOS(.v16)
    ],
    products: [
        .library(
            name: "MetalBirdRenderer",
            targets: ["MetalBirdRenderer"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "MetalBirdRenderer",
            dependencies: [],
            resources: [.process("Resources")],
            publicHeadersPath: "./Public",
            cSettings: [
                .headerSearchPath("./Internal"),
//                .unsafeFlags(["-fno-objc-arc", "-fno-objc-weak"])
            ]
        )
    ]
)
