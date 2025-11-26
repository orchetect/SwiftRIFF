//
//  WAVFile BroadcastExtensionChunk.swift
//  swift-riff • https://github.com/orchetect/swift-riff
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftExtensions
import SwiftRIFFCore

extension WAVFile {
    /// Broadcast Extension Chunk ("bext") used in the Broadcast Wave file standard.
    ///
    /// - See: https://en.wikipedia.org/wiki/Broadcast_Wave_Format
    public struct BroadcastExtensionChunk: RIFFFileChunk {
        public let id: RIFFFileChunkID = .wavFile_bext
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

extension WAVFile.BroadcastExtensionChunk: Equatable { }

extension WAVFile.BroadcastExtensionChunk: Hashable { }

extension WAVFile.BroadcastExtensionChunk: Sendable { }

extension WAVFile.BroadcastExtensionChunk: CustomStringConvertible {
    public var description: String {
        "bext:\n\(metadata)"
    }
}
