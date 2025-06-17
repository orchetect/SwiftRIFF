//
//  RIFFFileChunk.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-17.
//

public protocol RIFFFileChunk {
    /// Chunk ID.
    ///
    /// 4-Byte ASCII identifier, padded with ASCII 32 (space) if less than 4 characters.
    var id: RIFFFile.ChunkID { get }
    
    /// Chunk Sub-ID.
    ///
    /// 4-Byte ASCII identifier, padded with ASCII 32 (space) if less than 4 characters.
    ///
    /// This identifier determines the specification outlining the structure and format of this chunk.
    ///
    /// This property should only be non-nil for RIFF and LIST chunks.
    var subID: String? { get }
    
    /// The total byte offset range of the entire chunk.
    var range: ClosedRange<UInt64> { get }
    
    /// The byte offset range of the chunk's usable data portion.
    var dataRange: ClosedRange<UInt64>? { get }
    
    /// Returns subchunks contained within the chunk.
    var chunks: [RIFFFile.Chunk] { get }
}

extension RIFFFileChunk {
    /// Returns the byte offset range of the chunk's usable data portion, excluding the sub-ID if present.
    public var dataRangeExcludingSubID: ClosedRange<UInt64>? {
        guard subID != nil else { return dataRange }
        guard let dataRange else { return nil }
        
        let proposedLowerBound = dataRange.lowerBound.advanced(by: 4)
        
        guard proposedLowerBound <= dataRange.upperBound else { return nil }
        
        return proposedLowerBound ... dataRange.upperBound
    }
}
