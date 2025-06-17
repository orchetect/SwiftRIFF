//
//  RIFFFile+Parsing.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-17.
//

import Foundation
import OTCore

extension FileHandle {
    func parseRIFF() throws(RIFFFileReadError) -> (
        riffFormat: RIFFFile.Format,
        chunks: [RIFFFile.Chunk]
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
        let riffDescriptor = try handle.readChunkDescriptor(endianness: endianness)
        let riffChunk = try handle.readChunk(for: riffDescriptor, endianness: endianness)
        
        return (
            riffFormat: riffFormat,
            chunks: [riffChunk]
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
    
    struct ChunkDescriptor {
        let id: RIFFFile.ChunkID
        let subID: String? // applicable to RIFF or LIST chunks only
        let length: UInt32
        let chunkRange: ClosedRange<UInt64>
        let encodedDataRange: ClosedRange<UInt64>?
        let dataRange: ClosedRange<UInt64>?
    }
    
    func readChunkDescriptor(
        endianness: NumberEndianness
    ) throws(RIFFFileReadError) -> ChunkDescriptor {
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
        
        guard let id = RIFFFile.ChunkID(rawValue: idString)
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
            
        case .info, .generic:
            subID = nil
        }
        
        // move handle pointer to first byte after this chunk
        do { try handle.seek(toOffset: chunkRange.upperBound + 1) }
        catch { throw .fileReadError(subError: error) }
        
        return ChunkDescriptor(
            id: id,
            subID: subID,
            length: dataLength,
            chunkRange: chunkRange,
            encodedDataRange: encodedDataRange,
            dataRange: dataRange
        )
    }
    
    func readChunk(
        for descriptor: ChunkDescriptor,
        endianness: NumberEndianness
    ) throws(RIFFFileReadError) -> RIFFFile.Chunk {
        let chunk: RIFFFile.Chunk
        
        guard let dataRange = descriptor.dataRange else {
            throw .chunkLengthInvalid(forChunkID: descriptor.id.rawValue)
        }
        let postSubIDOffset = descriptor.subID != nil ? dataRange.lowerBound + 4 : dataRange.lowerBound
        do {
            try seek(toOffset: postSubIDOffset)
        }
        catch { throw .chunkLengthInvalid(forChunkID: descriptor.id.rawValue) }
        
        switch descriptor.id {
        case .riff:
            // contains a 4-byte ASCII string as the first four bytes of its data block
            guard let subID = descriptor.subID
            else {
                throw .missingChunkSubtypeIdentifier(chunkID: descriptor.id.rawValue)
            }
            
            // RIFF chunk can contain subchunks
            // recursively parse child subchunks
            let subchunks = try self.readSubchunks(in: descriptor, endianness: endianness)
            chunk = .riff(
                subID: subID,
                chunks: subchunks,
                range: descriptor.chunkRange,
                dataRange: postSubIDOffset ... dataRange.upperBound
            )
            
        case .list:
            // contains a 4-byte ASCII string as the first four bytes of its data block
            guard let subID = descriptor.subID
            else {
                throw .missingChunkSubtypeIdentifier(chunkID: descriptor.id.rawValue)
            }
            
            // LIST chunk can contain subchunks
            // recursively parse child subchunks
            let subchunks = try self.readSubchunks(in: descriptor, endianness: endianness)
            chunk = .list(
                subID: subID,
                chunks: subchunks,
                range: descriptor.chunkRange,
                dataRange: postSubIDOffset ... dataRange.upperBound
            )
            
        case .info:
            chunk = .info(
                range: descriptor.chunkRange,
                dataRange: descriptor.dataRange
            )
            
        case .generic(identifier: _):
            chunk = .generic(
                id: descriptor.id,
                range: descriptor.chunkRange,
                dataRange: descriptor.dataRange
            )
        }
        
        // set file handle pointer to byte past end of chunk
        do { try seek(toOffset: descriptor.chunkRange.upperBound + 1) }
        catch { throw .chunkLengthInvalid(forChunkID: descriptor.id.rawValue) }
        
        return chunk
    }
    
    func readSubchunks(
        in descriptor: ChunkDescriptor,
        endianness: NumberEndianness
    ) throws(RIFFFileReadError) -> [RIFFFile.Chunk] {
        var chunks: [RIFFFile.Chunk] = []
        
        guard let dataRange = descriptor.dataRange else {
            throw .chunkLengthInvalid(forChunkID: descriptor.id.rawValue)
        }
        let postSubIDOffset = descriptor.subID != nil ? dataRange.lowerBound + 4 : dataRange.lowerBound
        do {
            try seek(toOffset: postSubIDOffset)
        }
        catch { throw .chunkLengthInvalid(forChunkID: descriptor.id.rawValue) }
        
        while try getOffset() < descriptor.chunkRange.upperBound {
            let subchunkDescriptor = try readChunkDescriptor(endianness: endianness)
            
            let chunk = try readChunk(for: subchunkDescriptor, endianness: endianness)
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
    
    func getEndOffset() throws(RIFFFileReadError) -> UInt64 {
        let endOffset: uint64
        do {
            let currentOffset = try offset()
            try seekToEnd()
            endOffset = try offset()
            try seek(toOffset: currentOffset) // restore offset
        } catch { throw .fileReadError(subError: error) }
        return endOffset
    }
}
