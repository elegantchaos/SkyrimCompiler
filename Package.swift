// swift-tools-version:5.5

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/01/2022.
//  All code (c) 2022 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import PackageDescription

let package = Package(
    name: "SkyrimFileFormat",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "skyc",
            targets: ["SkyC"]
        ),
        
            .library(
                name: "SkyrimFileFormat",
                targets: ["SkyrimFileFormat"]
            ),
    ],
    dependencies: [
        .package(url: "https://github.com/elegantchaos/AsyncSequenceReader.git", from: "0.1.0"),
        .package(url: "https://github.com/elegantchaos/BinaryCoding.git", .branch("main")),
        .package(url: "https://github.com/elegantchaos/Bytes.git", .branch("float-support")),
        .package(url: "https://github.com/elegantchaos/Coercion.git", from: "1.1.3"),
        .package(url: "https://github.com/elegantchaos/ElegantStrings.git", from: "1.1.1"),
        .package(url: "https://github.com/elegantchaos/Expressions.git", from: "1.1.1"),
        .package(url: "https://github.com/elegantchaos/Files.git", from: "1.2.2"),
        .package(url: "https://github.com/elegantchaos/Logger.git", from: "1.7.3"),
        .package(url: "https://github.com/tsolomko/SWCompression.git", .upToNextMajor(from: "4.7.0")),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.5.0"),
        .package(url: "https://github.com/elegantchaos/XCTestExtensions.git", from: "1.4.5"),
    ],
    
    targets: [
        .executableTarget(
            name: "SkyC",
            dependencies: [
                "Files",
                "SkyrimFileFormat",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        
        .target(
            name: "SkyrimFileFormat",
            dependencies: [
                "AsyncSequenceReader",
                "BinaryCoding",
                "Bytes",
                "Coercion",
                "ElegantStrings",
                "Expressions",
                "Logger",
                .product(name: "SWCompression", package: "SWCompression"),
            ],
            resources: [
            ]
        ),
    
        .testTarget(
            name: "SkyrimFileFormatTests",
            dependencies: ["SkyrimFileFormat", "XCTestExtensions"],
            resources: [
                .process("Resources/Examples/"),
                .copy("Resources/Unpacked"),
            ]
        ),
    ]
)
