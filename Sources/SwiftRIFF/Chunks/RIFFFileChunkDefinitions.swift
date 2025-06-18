//
//  RIFFFileChunkDefinitions.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-17.
//

public typealias RIFFFileChunkDefinitions = [RIFFFileChunkID: any RIFFFileChunk.Type]

extension RIFFFileChunkDefinitions {
    /// Standard RIFF file chunk definitions: RIFF, LIST, and INFO.
    /// All other chunk types will be considered generic chunks.
    public static var standard: Self {
        [
            .riff: RIFFFile.RIFFChunk.self,
            .list: RIFFFile.LISTChunk.self,
            .info: RIFFFile.INFOChunk.self
        ]
    }
    
    /// Merge custom RIFF file chunk definitions into the standard set.
    public static func standard(merging other: Self) -> Self {
        Self.standard.merging(other) { old, new in new }
    }
}
