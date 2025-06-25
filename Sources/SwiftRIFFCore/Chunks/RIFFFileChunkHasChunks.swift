//
//  RIFFFileChunkHasChunks.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

/// Protocol trait for a `RIFFFileChunk` to describe a RIFF file chunk that is capable of
/// containing subchunks.
public protocol RIFFFileChunkHasChunks where Self: RIFFFileChunk {
    /// Returns subchunks contained within the chunk.
    var chunks: [AnyRIFFFileChunk] { get }
}
