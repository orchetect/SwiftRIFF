//
//  RIFFFile INFOChunk.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-17.
//

import Foundation
import OTCore

extension RIFFFile {
    /// The optional INFO chunk.
    ///
    /// > Wikipedia:
    /// >
    /// > The INFO chunk allows RIFF files to be "tagged" with information falling into
    /// > a number of predefined categories, such as copyright ("ICOP"), comments ("ICMT"),
    /// > artist ("IART"), in a standardized way. These details can be read from a RIFF file even
    /// > if the rest of the file format is unrecognized.
    /// >
    /// > The standard also allows the use of user-defined fields. Programmers intending to use
    /// > non-standard fields should bear in mind that the same non-standard subchunk ID may be
    /// > used by different applications in different (and potentially incompatible) ways.
    /// >
    /// > For cataloguing purposes, the optimal position for the INFO chunk is near the beginning
    /// > of the file. However, since the INFO chunk is optional, it is often omitted from the
    /// > detailed specifications of individual file formats, leading to some confusion over the
    /// > correct position for this chunk within a file.
    /// >
    /// > [See Article](https://en.wikipedia.org/wiki/Resource_Interchange_File_Format#Use_of_the_INFO_chunk)
    public struct INFOChunk: RIFFFileChunk {
        public let id: RIFFFileChunkID = .info
        public var range: ClosedRange<UInt64>
        public var dataRange: ClosedRange<UInt64>?
        
        public init(range: ClosedRange<UInt64>, dataRange: ClosedRange<UInt64>?) {
            self.range = range
            self.dataRange = dataRange
        }
    }
}

extension RIFFFile.INFOChunk {
    public init(
        handle: FileHandle,
        endianness: NumberEndianness,
        additionalChunkDefinitions: RIFFFileChunkDefinitions
    ) throws(RIFFFileReadError) {
        let descriptor = try handle.parseRIFFChunkDescriptor(endianness: endianness)
        
        guard descriptor.id == id else {
            throw .invalidChunkTypeIdentifier(chunkID: descriptor.id.id)
        }
        
        range = descriptor.chunkRange
        
        dataRange = descriptor.dataRange
    }
}
