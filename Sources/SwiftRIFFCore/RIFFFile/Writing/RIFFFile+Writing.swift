//
//  RIFFFile+Writing.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftExtensions

extension RIFFFile {
    /// Replaces the chunk in the file on disk with the new chunk supplied.
    ///
    /// The total byte size of the existing chunk must match the byte size of the new chunk replacing it.
    ///
    /// Note that the `data` portion is the range not including the chunk ID, chunk length,
    /// and chunk sub-ID (if present).
    public func write(chunk: some RIFFFileChunk, data: Data) throws(RIFFFileWriteError) {
        guard let url else { throw .noFileURL }
        
        let h: FileHandle
        do {
            h = try FileHandle(forUpdating: url)
        } catch { throw .fileWriteError(subError: error) }
        
        try h.writeRIFF(chunk: chunk, data: data, endianness: riffFormat.endianness)
    }
}

extension FileHandle {
    // TODO: this needs rethinking, since RIFFFileChunk can contain subchunks but we're also asking for a Data parameter -- these two conflict with each other. Currently we're just ignoring subchunks that may be present in the `chunk`.
    
    /// Replaces the chunk in the file on disk with the new chunk supplied.
    ///
    /// The total byte size of the existing chunk must match the byte size of the new chunk replacing it.
    ///
    /// Note that the `data` portion is the range not including the chunk ID, chunk length,
    /// and chunk sub-ID (if present).
    func writeRIFF(chunk: some RIFFFileChunk, data: Data, endianness: NumberEndianness) throws(RIFFFileWriteError) {
        let existingChunkDescriptor: RIFFChunkDescriptor
        
        do {
            try seek(toOffset: chunk.range.lowerBound)
            existingChunkDescriptor = try parseRIFFChunkDescriptor(endianness: endianness)
        } catch { throw .fileWriteError(subError: error) }
        
        guard existingChunkDescriptor.chunkRange.count == chunk.range.count else {
            throw .newChunkDoesNotMatchExistingChunkSize
        }
        
        let dataRangeExcludingSubID = chunk.dataRangeExcludingSubID
        
        guard data.count == dataRangeExcludingSubID?.count ?? 0 else {
            throw .newChunkDoesNotMatchExistingChunkSize
        }
        
        // note: we've already guaranteed that there is enough room in the file to write our data
        // by reading the existing chunk descriptor above. so we don't need further validation.
        
        // prepare bytes ahead of time before writing
        
        guard let chunkIDData = chunk.id.id.data(using: .ascii),
              chunkIDData.count == 4
        else { throw .invalidChunkID }
        
        let subID = chunk.getSubID?.data(using: .ascii)
        if let subID { guard subID.count == 4 else { throw .invalidChunkSubID } }
        
        let chunkLengthData = UInt32(chunk.dataRange?.count ?? 0).toData(endianness)
        guard chunkLengthData.count == 4 else { throw .invalidChunkLength }
        
        do {
            try seek(toOffset: chunk.range.lowerBound)
        } catch { throw .fileReadError(subError: error) }
        
        do {
            try write(contentsOf: chunkIDData)
            try write(contentsOf: chunkLengthData)
            if let subID { try write(contentsOf: subID) }
            try write(contentsOf: data)
        } catch { throw .fileWriteError(subError: error) }
    }
}
