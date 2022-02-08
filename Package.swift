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
        .package(url: "https://github.com/elegantchaos/Coercion.git", from: "1.1.3"),
        .package(url: "https://github.com/elegantchaos/AsyncSequenceReader.git", from: "0.1.0"),
        .package(url: "https://github.com/elegantchaos/Bytes.git", from: "0.2.2"),
        .package(url: "https://github.com/elegantchaos/XCTestExtensions.git", from: "1.4.2"),
    ],
    targets: [
        .target(
            name: "SkyrimFileFormat",
            dependencies: [
                "AsyncSequenceReader",
                "Bytes",
                "Coercion"
            ],
            resources: [
                .copy("Resources/Records")
            ]
        ),
        
        .testTarget(
            name: "SkyrimFileFormatTests",
            dependencies: ["SkyrimFileFormat", "XCTestExtensions"],
            resources: [
                .copy("Resources/Example"),
                    .copy("Resources/DialogueExample")
                       ]
        ),
    ]
)
