// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "RIFFFileLib",
    products: [
        .library(
            name: "RIFFFileLib",
            targets: ["RIFFFileLib"]
        )
    ],
    targets: [
        .target(
            name: "RIFFFileLib"
        ),
        .testTarget(
            name: "RIFFFileLibTests",
            dependencies: ["RIFFFileLib"]
        )
    ]
)
