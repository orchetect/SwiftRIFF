//
//  RIFFFile LISTChunk.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-17.
//

extension RIFFFile {
    /// LIST chunk.
    public struct LISTChunk: RIFFFileChunk, RIFFFileChunkHasSubID, RIFFFileChunkHasChunks {
        public let id: RIFFFileChunkID = .list
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
