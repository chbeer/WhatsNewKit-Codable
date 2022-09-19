// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "WhatsNewKit-Codable",
    platforms: [
        .iOS(.v13),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "WhatsNewKit-Codable",
            targets: ["WhatsNewKit-Codable"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SvenTiigi/WhatsNewKit.git", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "WhatsNewKit-Codable",
            dependencies: [
                "WhatsNewKit"
            ]),
        .testTarget(
            name: "WhatsNewKit-CodableTests",
            dependencies: [
                "WhatsNewKit",
                "WhatsNewKit-Codable"
            ]),
    ]
)
