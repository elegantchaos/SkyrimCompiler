// swift-tools-version:5.6

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/01/2022.
//  All code (c) 2022 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import PackageDescription

let package = Package(
    name: "SkyrimCompiler",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "skyc",
            targets: ["SkyC"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/elegantchaos/Files.git", from: "1.2.2"),
        .package(url: "https://github.com/elegantchaos/SwiftESP.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-argument-parser", branch: "async"),
    ],
    
    targets: [
        .executableTarget(
            name: "SkyC",
            dependencies: [
                "Files",
                "SwiftESP",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        )
    ]
)
