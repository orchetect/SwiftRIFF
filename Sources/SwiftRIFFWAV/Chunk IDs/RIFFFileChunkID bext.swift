//
//  RIFFFileChunkID bext.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import SwiftRIFFCore

extension RIFFFileChunkID {
    /// Broadcast Extension Chunk ID ("bext").
    ///
    /// - See: https://en.wikipedia.org/wiki/Broadcast_Wave_Format
    public static var wavFile_bext: Self { Self(id: "bext") }
}
