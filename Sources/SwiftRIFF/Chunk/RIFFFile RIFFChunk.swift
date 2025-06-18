//
//  RIFFFile RIFFChunk.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-16.
//

import Foundation
import OTCore

extension RIFFFile {
    /// RIFF chunk.
    ///
    /// A RIFF chunk has a sub-ID and contains one or more subchunks.
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

extension RIFFFile.RIFFChunk {
    public init(
        handle: FileHandle,
        endianness: NumberEndianness,
        additionalChunkDefinitions: RIFFFileChunkDefinitions
    ) throws(RIFFFileReadError) {
        let descriptor = try handle.parseRIFFChunkDescriptor(endianness: endianness)
        
        guard descriptor.id == id else {
            throw .invalidChunkTypeIdentifier(chunkID: descriptor.id.id)
        }
        
        // contain a 4-byte ASCII string as the first four bytes of its data block
        guard let subID = descriptor.subID else {
            throw .missingChunkSubtypeIdentifier(chunkID: id.id)
        }
        self.subID = subID
        
        range = descriptor.chunkRange
        
        dataRange = descriptor.dataRange
        
        // recursively parse child subchunks
        chunks = try handle.parseRIFFSubchunks(
            in: descriptor,
            endianness: endianness,
            additionalChunkDefinitions: additionalChunkDefinitions
        )
        .asAnyRIFFFileChunks()
    }
}
