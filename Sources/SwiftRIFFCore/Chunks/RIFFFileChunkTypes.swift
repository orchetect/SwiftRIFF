//
//  RIFFFileChunkTypes.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

public typealias RIFFFileChunkTypes = [RIFFFileChunkID: any RIFFFileChunk.Type]

extension RIFFFileChunkTypes {
    /// Standard RIFF file chunk types: RIFF, LIST, and INFO.
    /// All other chunk types will be considered generic chunks.
    public static var standard: Self {
        [
            .riff: RIFFFile.RIFFChunk.self,
            .list: RIFFFile.LISTChunk.self,
            .info: RIFFFile.INFOChunk.self
        ]
    }
    
    /// Merge custom RIFF file chunk types into the standard set.
    public static func standard(merging other: Self) -> Self {
        standard.merging(other) { old, new in new }
    }
}
