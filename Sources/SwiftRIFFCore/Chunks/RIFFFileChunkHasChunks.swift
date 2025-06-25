//
//  RIFFFileChunkHasChunks.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

public protocol RIFFFileChunkHasChunks where Self: RIFFFileChunk {
    /// Returns subchunks contained within the chunk.
    var chunks: [AnyRIFFFileChunk] { get }
}
