// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "SwiftRIFF",
    platforms: [.macOS(.v11), .iOS(.v14)],
    products: [
        .library(name: "SwiftRIFF", targets: ["SwiftRIFF", "SwiftRIFFCore", "SwiftRIFFWAV"]),
        .library(name: "SwiftRIFFCore", targets: ["SwiftRIFFCore"]),
        .library(name: "SwiftRIFFWAV", targets: ["SwiftRIFFWAV"])
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/OTCore", from: "1.7.6"),
        .package(url: "https://github.com/orchetect/SwiftRadix", from: "1.3.2"),
        .package(url: "https://github.com/orchetect/TimecodeKit", from: "2.3.3")
    ],
    targets: [
        .target(
            name: "SwiftRIFF",
            dependencies: ["SwiftRIFFCore", "SwiftRIFFWAV"]
        ),
        .target(
            name: "SwiftRIFFCore",
            dependencies: ["OTCore", "SwiftRadix"]
        ),
        .target(
            name: "SwiftRIFFWAV",
            dependencies: [
                "SwiftRIFFCore",
                "OTCore",
                "SwiftRadix",
                .product(name: "TimecodeKitCore", package: "TimecodeKit")
            ]
        ),
        .testTarget(
            name: "SwiftRIFFCoreTests",
            dependencies: ["SwiftRIFFCore", "OTCore"]
        )
    ]
)
