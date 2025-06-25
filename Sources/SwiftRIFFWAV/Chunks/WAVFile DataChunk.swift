//
//  WAVFile DataChunk.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OTCore
import SwiftRIFFCore

extension WAVFile {
    public struct DataChunk: RIFFFileChunk {
        public let id: RIFFFileChunkID = .wavFile_data
        public var range: ClosedRange<UInt64>
        public var dataRange: ClosedRange<UInt64>?
        
        public init(
            handle: FileHandle,
            endianness: NumberEndianness,
            additionalChunkTypes: RIFFFileChunkTypes
        ) throws(RIFFFileReadError) {
            let descriptor = try handle.parseRIFFChunkDescriptor(endianness: endianness)
            
            guard descriptor.id == id else {
                throw .invalidChunkTypeIdentifier(chunkID: descriptor.id.id)
            }
            
            range = descriptor.chunkRange
            
            dataRange = descriptor.dataRange
        }
    }
}

extension WAVFile.DataChunk: Equatable { }

extension WAVFile.DataChunk: Hashable { }

extension WAVFile.DataChunk: Sendable { }

extension WAVFile.DataChunk: CustomStringConvertible {
    public var description: String {
        "data: \(dataRange?.count ?? 0) bytes"
    }
}
