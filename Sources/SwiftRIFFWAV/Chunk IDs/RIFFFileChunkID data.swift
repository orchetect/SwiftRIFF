//
//  RIFFFileChunkID data.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import SwiftRIFFCore

extension RIFFFileChunkID {
    /// WAV file data chunk ID ("data").
    public static var wavFile_data: Self { Self(id: "data") }
}
