//
//  WAVFile FMTChunk.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OTCore
import SwiftRIFFCore

extension WAVFile {
    public struct FMTChunk: RIFFFileChunk {
        public let id: RIFFFileChunkID = .wavFile_fmt
        public var range: ClosedRange<UInt64>
        public var dataRange: ClosedRange<UInt64>?
        
        public let metadata: Metadata
        
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
            
            dataRange = descriptor.dataRange?.usableRange
            
            guard let dataRange = descriptor.dataRange?.usableRange else {
                throw .chunkLengthInvalid(forChunkID: descriptor.id.id)
            }
            
            do {
                try handle.seek(toOffset: dataRange.lowerBound)
                guard let data = try handle.read(upToCount: dataRange.count) else {
                    throw RIFFFileReadError.chunkLengthInvalid(forChunkID: descriptor.id.id)
                }
                metadata = try Metadata(data: data, endianness: endianness)
            } catch let error as RIFFFileReadError { throw error }
            catch { throw .fileReadError(subError: error) }
        }
    }
}

extension WAVFile.FMTChunk: Equatable { }

extension WAVFile.FMTChunk: Hashable { }

extension WAVFile.FMTChunk: Sendable { }

extension WAVFile.FMTChunk: CustomStringConvertible {
    public var description: String {
        "fmt: \(metadata)"
    }
}
