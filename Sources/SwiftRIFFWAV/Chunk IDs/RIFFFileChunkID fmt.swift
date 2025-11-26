//
//  RIFFFileChunkID fmt.swift
//  swift-riff • https://github.com/orchetect/swift-riff
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftExtensions
import SwiftRIFFCore

extension RIFFFileChunkID {
    /// WAV file fmt chunk ID ("fmt ").
    public static var wavFile_fmt: Self { Self(id: "fmt ") }
}
