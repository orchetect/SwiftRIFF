//
//  RIFFFile+Parsing.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-17.
//

import Foundation
import OTCore

extension FileHandle {
    func parseRIFF(
        additionalChunkTypes: RIFFFileChunkTypes = [:]
    ) throws(RIFFFileReadError) -> (
        riffFormat: RIFFFile.Format,
        chunks: [AnyRIFFFileChunk]
    ) {
        let handle = self
        
        // determine container format
        let riffFormat = try parseRIFFFormat()
        
        // reject RIF2 until parsing it is implemented
        switch riffFormat {
        case .riff, .rifx, .rf64: break
        case .rif2: throw .unsupportedRIF2Type
        }
        
        let endianness: NumberEndianness = riffFormat.endianness
        
        // rewind file handle position to file start
        do {
            try handle.seek(toOffset: 0)
        } catch { throw .fileReadError(subError: error) }
        
        // advances 8 bytes
        let riffDescriptor = try handle.parseRIFFChunkDescriptor(endianness: endianness)
        let riffChunk = try handle.parseRIFFChunk(
            in: riffDescriptor,
            endianness: endianness,
            additionalChunkTypes: additionalChunkTypes
        )
        
        return (
            riffFormat: riffFormat,
            chunks: [riffChunk.asAnyRIFFFileChunk()]
        )
    }
    
    func parseRIFFFormat() throws(RIFFFileReadError) -> RIFFFile.Format {
        do {
            try seek(toOffset: 0)
        } catch { throw .fileReadError(subError: error) }
        
        guard let riffID = try? read(upToCount: 4)?.toString(using: .ascii),
              let riffFormat = RIFFFile.Format(rawValue: riffID)
        else {
            throw .missingRIFFHeader
        }
        
        return riffFormat
    }
    
    /// Parses a RIFF chunk starting at the file handle's current offset.
    /// Returns a descriptor with its details.
    public func parseRIFFChunkDescriptor(
        endianness: NumberEndianness
    ) throws(RIFFFileReadError) -> RIFFChunkDescriptor {
        let handle = self
        
        let startOffset: UInt64
        do { startOffset = try handle.offset() }
        catch { throw .fileReadError(subError: error) }
        
        let idBytes: Data?
        do {
            idBytes = try handle.read(upToCount: 4)
        } catch { throw .fileReadError(subError: error) }
        
        guard let idBytes,
              idBytes.count == 4,
              let idString = idBytes.toString(using: .ascii)
        else {
            throw .invalidChunkTypeIdentifier(chunkID: nil)
        }
        
        let id = RIFFFileChunkID(id: idString)
        guard id.isValid
        else {
            throw .invalidChunkTypeIdentifier(chunkID: idString)
        }
        
        let lengthBytes: Data?
        do {
            lengthBytes = try handle.read(upToCount: 4)
        } catch { throw .fileReadError(subError: error) }
        
        guard let lengthBytes,
              lengthBytes.count == 4,
              let dataLength = lengthBytes.toUInt32(from: endianness)
        else {
            throw .chunkLengthInvalid(forChunkID: idString)
        }
        
        let chunkRange = startOffset ... startOffset + 8 + UInt64(dataLength) - 1 // add ID & data-length byte size
        
        let dataOffset: UInt64
        do { dataOffset = try handle.offset() }
        catch { throw .fileReadError(subError: error) }
        
        let dataRange: ClosedRange<UInt64>? = dataLength == 0
        ? nil
        : dataOffset ... dataOffset + UInt64(dataLength) - 1
        
        // pad if data count is odd
        let encodedDataRange: ClosedRange<UInt64>? = if let dataRange {
            dataRange.lowerBound ... dataRange.upperBound + (dataLength % 2 == 1 ? 1 : 0)
        } else {
            nil
        }
        
        let subID: String?
        switch id {
        case .riff, .list:
            // RIFF/LIST contain a 4-byte ASCII string as the first four bytes of its data block
            let subIDBytes: Data?
            do {
                subIDBytes = try read(upToCount: 4)
            } catch { throw .fileReadError(subError: error) }
            
            guard let subIDBytes,
                  subIDBytes.count == 4,
                  let subIDString = subIDBytes.toString(using: .ascii)
            else {
                throw .missingChunkSubtypeIdentifier(chunkID: idString)
            }
            subID = subIDString
            
        case .info:
            subID = nil
        default:
            subID = nil
        }
        
        // move handle pointer to first byte after this chunk
        do { try handle.seek(toOffset: chunkRange.upperBound + 1) }
        catch { throw .fileReadError(subError: error) }
        
        return RIFFChunkDescriptor(
            id: id,
            subID: subID,
            length: dataLength,
            chunkRange: chunkRange,
            encodedDataRange: encodedDataRange,
            dataRange: dataRange
        )
    }
    
    func parseRIFFChunk(
        in descriptor: RIFFChunkDescriptor,
        endianness: NumberEndianness,
        additionalChunkTypes: RIFFFileChunkTypes
    ) throws(RIFFFileReadError) -> any RIFFFileChunk {
        do { try seek(toOffset: descriptor.chunkRange.lowerBound) }
        catch { throw .chunkLengthInvalid(forChunkID: descriptor.id.id) }
        
        let chunkTypes: RIFFFileChunkTypes = .standard(merging: additionalChunkTypes)
        let concreteType = chunkTypes[descriptor.id] ?? RIFFFile.GenericChunk.self
        let chunk: any RIFFFileChunk = try concreteType.init(
            handle: self,
            endianness: endianness,
            additionalChunkTypes: additionalChunkTypes
        )
        
        // set file handle pointer to byte past end of chunk
        do { try seek(toOffset: descriptor.chunkRange.upperBound + 1) }
        catch { throw .chunkLengthInvalid(forChunkID: descriptor.id.id) }
        
        return chunk
    }
    
    public func parseRIFFSubchunks(
        in descriptor: RIFFChunkDescriptor,
        endianness: NumberEndianness,
        additionalChunkTypes: RIFFFileChunkTypes
    ) throws(RIFFFileReadError) -> [any RIFFFileChunk] {
        var chunks: [any RIFFFileChunk] = []
        
        guard let dataRange = descriptor.dataRange else {
            throw .chunkLengthInvalid(forChunkID: descriptor.id.id)
        }
        let postSubIDOffset = descriptor.subID != nil ? dataRange.lowerBound + 4 : dataRange.lowerBound
        do {
            try seek(toOffset: postSubIDOffset)
        }
        catch { throw .chunkLengthInvalid(forChunkID: descriptor.id.id) }
        
        while try getOffset() < descriptor.chunkRange.upperBound {
            let subchunkDescriptor = try parseRIFFChunkDescriptor(endianness: endianness)
            
            let chunk = try parseRIFFChunk(
                in: subchunkDescriptor,
                endianness: endianness,
                additionalChunkTypes: additionalChunkTypes
            )
            chunks.append(chunk)
        }
        
        return chunks
    }
    
    // MARK: - Utilities
    
    /// Wrapper for `offset()` to throw our own error.
    func getOffset() throws(RIFFFileReadError) -> UInt64 {
        let offset: UInt64
        do { offset = try self.offset() }
        catch { throw .fileReadError(subError: error) }
        return offset
    }
    
    func getEndOffset() throws -> UInt64 {
        let currentOffset = try offset()
        try seekToEnd()
        let endOffset = try offset()
        try seek(toOffset: currentOffset) // restore offset
        return endOffset
    }
}
