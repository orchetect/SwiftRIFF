//
//  RIFFFileChunkID bext.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-16.
//

import OTCore
import SwiftRIFFCore

extension RIFFFileChunkID {
    /// Broadcast Extension Chunk ID ("bext").
    ///
    /// - See: https://en.wikipedia.org/wiki/Broadcast_Wave_Format
    public static var wavFile_bext: Self { Self(id: "bext") }
}
