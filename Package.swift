// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "SwiftRIFF",
    platforms: [.macOS(.v10_15), .iOS(.v12)],
    products: [
        .library(
            name: "SwiftRIFF",
            targets: ["SwiftRIFF"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/OTCore", from: "1.7.6")
    ],
    targets: [
        .target(
            name: "SwiftRIFF",
            dependencies: ["OTCore"]
        ),
        .testTarget(
            name: "SwiftRIFFTests",
            dependencies: ["SwiftRIFF", "OTCore"]
        )
    ]
)
