// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "SwiftRIFF",
    platforms: [.macOS(.v11), .iOS(.v14)],
    products: [
        .library(
            name: "SwiftRIFF",
            targets: ["SwiftRIFF"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/OTCore", from: "1.7.6"),
        .package(url: "https://github.com/orchetect/SwiftRadix", from: "1.3.2")
    ],
    targets: [
        .target(
            name: "SwiftRIFF",
            dependencies: ["OTCore", "SwiftRadix"]
        ),
        .testTarget(
            name: "SwiftRIFFTests",
            dependencies: ["SwiftRIFF", "OTCore"]
        )
    ]
)
