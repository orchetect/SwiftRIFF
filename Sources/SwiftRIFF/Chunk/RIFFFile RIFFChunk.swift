//
//  RIFFFile RIFFChunk.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-16.
//

extension RIFFFile {
    /// RIFF chunk.
    public struct RIFFChunk: RIFFFileChunk, RIFFFileChunkHasSubID, RIFFFileChunkHasChunks {
        public let id: RIFFFileChunkID = .riff
        public var subID: String
        public var range: ClosedRange<UInt64>
        public var dataRange: ClosedRange<UInt64>?
        public var chunks: [AnyRIFFFileChunk]
        
        public init(
            subID: String,
            chunks: [AnyRIFFFileChunk],
            range: ClosedRange<UInt64>,
            dataRange: ClosedRange<UInt64>?
        ) {
            self.subID = subID
            self.chunks = chunks
            self.range = range
            self.dataRange = dataRange
        }
    }
}
