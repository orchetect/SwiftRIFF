# swift-riff

[![Platforms - macOS | iOS | tvOS | watchOS | visionOS](https://img.shields.io/badge/platforms-macOS%20|%20iOS%20|%20tvOS%20|%20watchOS%20|%20visionOS-blue.svg?style=flat)](https://developer.apple.com/swift) ![Swift 6.0](https://img.shields.io/badge/Swift-6.0-blue.svg?style=flat) [![Xcode 16](https://img.shields.io/badge/Xcode-16-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/swift-riff/blob/main/LICENSE)

Swift package for Apple platforms for performant parsing, reading, and writing of [RIFF](https://en.wikipedia.org/wiki/Resource_Interchange_File_Format) files.

## Feature Set

This package currently offers:

- a lightweight abstraction for parsing chunks in RIFF-based files, and overwriting chunks in existing files
- abstractions for some file specifications that use RIFF as their underlying file format (such as WAV files)

At present, baseline functionality is implemented and unit tested. The initial goal of this library is to offer a mechanism to read the structure of RIFF files, with very limited mechanisms for writing. In the future, a full set of methods for authoring and writing to RIFF files would be added to the library ideally.

## Library Structure

- `SwiftRIFF`: umbrella package target loads all package modules including additional file specification abstractions (ie: WAV)
- `SwiftRIFFCore`: package target offers the basic `RIFFFile` type which allows parsing any generic RIFF-based file
  - Custom RIFF chunk abstractions may be built by adopting the `RIFFFileChunk` protocol and passing these custom types into the `RIFFFile` parser so it can identify them during parsing (For an example, see the `WAVFile` type and its chunk implementation)
- `SwiftRIFFWAV`: [WAV](https://en.wikipedia.org/wiki/WAV) file specification abstraction (which uses RIFF as its underlying file structure)

## Installation

### Swift Package Manager (SPM)

To add this package to an Xcode app project, use:

 `https://github.com/orchetect/swift-riff` as the URL.

To add this package to a Swift package, add the dependency to your package and target in Package.swift:

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/orchetect/swift-riff", from: "0.2.0")
    ],
    targets: [
        .target(
            dependencies: [
                .product(name: "SwiftRIFF", package: "swift-riff")
            ]
        )
    ]
)
```

## Documentation / Examples

There is no format documentation at this time, but most types and methods in the package have inline documentation to help explain their purpose.

See the [Examples](Examples) folder for a quick way to get started with parsing RIFF files.

See the `SwiftRIFFWAV` package target for a blueprint of how to implement your own custom abstractions for RIFF-based files and chunks.

## Roadmap

These features are not yet implemented, but are planned for the future. There is no timeline for these additions, but they may be added on an as-needed basis.

- RIFF files

  - Authoring new RIFF files
  - Replacing RIFF file chunk with chunk of different byte length
  - Adding new chunks to RIFF files
  - Removing chunks from RIFF files
- [Broadcast Wave (BWAV)](https://en.wikipedia.org/wiki/Broadcast_Wave_Format): Implement abstractions for additional known chunk types
  (`iXML`, `qlty`, `mext`, `levl`, `link`, `axml`)
- Implement [RF64](https://en.wikipedia.org/wiki/RF64)
- Implement RIF2 (New 64-bit Cubase 13/Nuendo 13 file format)

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/swift-riff/blob/master/LICENSE) for details.

## Sponsoring

If you enjoy using swift-riff and want to contribute to open-source financially, GitHub sponsorship is much appreciated. Feedback and code contributions are also welcome.

## Community & Support

Please do not email maintainers for technical support. Several options are available for issues and questions:

- Questions and feature ideas can be posted to [Discussions](https://github.com/orchetect/swift-riff/discussions).
- If an issue is a verifiable bug with reproducible steps it may be posted in [Issues](https://github.com/orchetect/swift-riff/issues).

## Contributions

Contributions are welcome. Posting in [Discussions](https://github.com/orchetect/swift-riff/discussions) first prior to new submitting PRs for features or modifications is encouraged.

## Legacy

This repository was formerly known as SwiftRIFF.