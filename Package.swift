// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "SwiftRIFF",
    platforms: [.macOS(.v11), .iOS(.v14)],
    products: [
        .library(name: "SwiftRIFFCore", targets: ["SwiftRIFFCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/OTCore", from: "1.7.6"),
        .package(url: "https://github.com/orchetect/SwiftRadix", from: "1.3.2")
    ],
    targets: [
        .target(
            name: "SwiftRIFFCore",
            dependencies: ["OTCore", "SwiftRadix"]
        ),
        .testTarget(
            name: "SwiftRIFFCoreTests",
            dependencies: ["SwiftRIFFCore", "OTCore"]
        )
    ]
)
