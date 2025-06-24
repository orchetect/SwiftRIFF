//
//  RIFFFile GenericChunk.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OTCore

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

extension RIFFFile.GenericChunk {
    public init(
        handle: FileHandle,
        endianness: NumberEndianness,
        additionalChunkTypes: RIFFFileChunkTypes
    ) throws(RIFFFileReadError) {
        let descriptor = try handle.parseRIFFChunkDescriptor(endianness: endianness)
        
        id = descriptor.id
        range = descriptor.chunkRange
        dataRange = descriptor.dataRange
    }
}
