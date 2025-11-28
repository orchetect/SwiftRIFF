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
        .package(url: "https://github.com/orchetect/swift-extensions", from: "2.0.0"),
        .package(url: "https://github.com/orchetect/swift-radix", from: "1.4.0"),
        .package(url: "https://github.com/orchetect/swift-timecode", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "SwiftRIFF",
            dependencies: ["SwiftRIFFCore", "SwiftRIFFWAV"]
        ),
        .target(
            name: "SwiftRIFFCore",
            dependencies: [
                .product(name: "SwiftExtensions", package: "swift-extensions"),
                .product(name: "SwiftRadix", package: "swift-radix")
            ]
        ),
        .target(
            name: "SwiftRIFFWAV",
            dependencies: [
                "SwiftRIFFCore",
                .product(name: "SwiftExtensions", package: "swift-extensions"),
                .product(name: "SwiftRadix", package: "swift-radix"),
                .product(name: "SwiftTimecodeCore", package: "swift-timecode")
            ]
        ),
        .testTarget(
            name: "SwiftRIFFCoreTests",
            dependencies: [
                "SwiftRIFFCore", 
                    .product(name: "SwiftExtensions", package: "swift-extensions")
            ]
        ),
        .testTarget(
            name: "SwiftRIFFWAVTests",
            dependencies: [
                "SwiftRIFFWAV", 
                    .product(name: "SwiftExtensions", package: "swift-extensions")
            ]
        )
    ]
)
