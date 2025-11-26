//
//  RIFFFileChunkID fmt.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftExtensions
import SwiftRIFFCore

extension RIFFFileChunkID {
    /// WAV file fmt chunk ID ("fmt ").
    public static var wavFile_fmt: Self { Self(id: "fmt ") }
}
