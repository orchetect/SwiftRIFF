//
//  RIFFFileChunkHasSubID.swift
//  swift-riff • https://github.com/orchetect/swift-riff
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

/// Protocol trait for a `RIFFFileChunk` to describe a RIFF file chunk that contains a 4-byte ASCII identifier
/// string as its first four data bytes (after the chunk's name and length bytes).
///
/// For example, the `RIFF` chunk contains this sub-identifier that serves to identify the expected contents of the file.
/// When this sub-ID is `WAVE` this indicates the RIFF file is formatted according to the WAV file specification.
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
