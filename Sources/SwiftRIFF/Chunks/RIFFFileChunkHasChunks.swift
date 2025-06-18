//
//  RIFFFileChunkHasChunks.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-17.
//

public protocol RIFFFileChunkHasChunks where Self: RIFFFileChunk {
    /// Returns subchunks contained within the chunk.
    var chunks: [AnyRIFFFileChunk] { get }
}
