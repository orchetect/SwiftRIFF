//
//  RIFFFileChunkHasChunks.swift
//  swift-riff • https://github.com/orchetect/swift-riff
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

/// Protocol trait for a `RIFFFileChunk` to describe a RIFF file chunk that is capable of
/// containing subchunks.
public protocol RIFFFileChunkHasChunks where Self: RIFFFileChunk {
    /// Returns subchunks contained within the chunk.
    var chunks: [AnyRIFFFileChunk] { get }
}
