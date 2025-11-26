// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-riff",
    platforms: [.macOS(.v11), .iOS(.v14)],
    products: [
        .library(name: "SwiftRIFF", targets: ["SwiftRIFF", "SwiftRIFFCore", "SwiftRIFFWAV"]),
        .library(name: "SwiftRIFFCore", targets: ["SwiftRIFFCore"]),
        .library(name: "SwiftRIFFWAV", targets: ["SwiftRIFFWAV"])
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/OTCore", from: "1.7.9"),
        .package(url: "https://github.com/orchetect/swift-radix", from: "1.4.0"),
        .package(url: "https://github.com/orchetect/TimecodeKit", from: "2.3.4")
    ],
    targets: [
        .target(
            name: "SwiftRIFF",
            dependencies: ["SwiftRIFFCore", "SwiftRIFFWAV"]
        ),
        .target(
            name: "SwiftRIFFCore",
            dependencies: [
                "OTCore",
                .product(name: "SwiftRadix", package: "swift-radix")
            ]
        ),
        .target(
            name: "SwiftRIFFWAV",
            dependencies: [
                "SwiftRIFFCore",
                "OTCore",
                .product(name: "SwiftRadix", package: "swift-radix"),
                .product(name: "TimecodeKitCore", package: "TimecodeKit")
            ]
        ),
        .testTarget(
            name: "SwiftRIFFCoreTests",
            dependencies: ["SwiftRIFFCore", "OTCore"]
        ),
        .testTarget(
            name: "SwiftRIFFWAVTests",
            dependencies: ["SwiftRIFFWAV", "OTCore"]
        )
    ]
)
