// swift-tools-version:5.5

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/01/2022.
//  All code (c) 2022 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import PackageDescription

let package = Package(
    name: "SkyrimFileFormat",
    platforms: [
        .macOS(.v12), .iOS(.v15), .tvOS(.v15), .watchOS(.v8)
    ],
    products: [
        .library(
            name: "SkyrimFileFormat",
            targets: ["SkyrimFileFormat"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/elegantchaos/XCTestExtensions.git", from: "1.4.2"),
        .package(url: "https://github.com/mochidev/AsyncSequenceReader.git", from: "0.1.0"),
        .package(url: "https://github.com/mochidev/Bytes.git", from: "0.2.2")
    ],
    targets: [
        .target(
            name: "SkyrimFileFormat",
            dependencies: [
                "AsyncSequenceReader",
                "Bytes"
            ],
            resources: [
                .copy("Resources/Fields")
            ]
        ),
        
        .testTarget(
            name: "SkyrimFileFormatTests",
            dependencies: ["SkyrimFileFormat", "XCTestExtensions"],
            resources: [
                .copy("Resources/Example")
                       ]
        ),
    ]
)
