//
//  RIFFFile GenericChunk.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-17.
//

extension RIFFFile {
    /// A generic chunk.
    public struct GenericChunk: RIFFFileChunk {
        public var id: RIFFFileChunkID
        public var range: ClosedRange<UInt64>
        public var dataRange: ClosedRange<UInt64>?
        
        public init(id: String, range: ClosedRange<UInt64>, dataRange: ClosedRange<UInt64>?) {
            self.id = RIFFFileChunkID(id: id)
            self.range = range
            self.dataRange = dataRange
        }
        
        public init(id: RIFFFileChunkID, range: ClosedRange<UInt64>, dataRange: ClosedRange<UInt64>?) {
            self.id = id
            self.range = range
            self.dataRange = dataRange
        }
    }
}
