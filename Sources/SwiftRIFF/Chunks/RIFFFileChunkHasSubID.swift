//
//  RIFFFileChunkHasSubID.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

public protocol RIFFFileChunkHasSubID where Self: RIFFFileChunk {
    /// Chunk Sub-ID.
    ///
    /// 4-Byte ASCII identifier, padded with ASCII 32 (space) if less than 4 characters.
    ///
    /// This identifier determines the specification outlining the structure and format of this chunk.
    ///
    /// This property should only be non-nil for RIFF and LIST chunks.
    var subID: String { get }
}
