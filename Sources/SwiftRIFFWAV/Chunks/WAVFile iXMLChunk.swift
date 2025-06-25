//
//  WAVFile iXMLChunk.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OTCore
import SwiftRIFFCore

extension WAVFile {
    /// XML metadata chunk used in the Broadcast Wave file standard.
    ///
    /// - See: https://en.wikipedia.org/wiki/IXML
    /// - See: https://en.wikipedia.org/wiki/Broadcast_Wave_Format
    public struct iXMLChunk: RIFFFileChunk {
        public let id: RIFFFileChunkID = .wavFile_iXML
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

extension WAVFile.iXMLChunk: Equatable { }

extension WAVFile.iXMLChunk: Hashable { }

extension WAVFile.iXMLChunk: Sendable { }

extension WAVFile.iXMLChunk: CustomStringConvertible {
    public var description: String {
        "iXML: \(dataRange?.count ?? 0) bytes"
    }
}
