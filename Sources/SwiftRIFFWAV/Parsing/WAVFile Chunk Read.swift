//
//  WAVFile Chunk Read.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftExtensions
import SwiftRIFFCore

extension WAVFile {
    /// Returns the WAV file format chunk ("fmt ").
    /// Returns `nil` if the chunk is not found.
    /// Throws an error if there was a problem reading the data or the data is malformed.
    public func format() throws -> FMTChunk? {
        guard let url = riffFile.url else { return nil }
        let h = try FileHandle(forReadingFrom: url)
        return try format(handle: h)
    }
    
    /// Returns the WAV file format chunk ("fmt ").
    /// Returns `nil` if the chunk is not found.
    /// Throws an error if there was a problem reading the data or the data is malformed.
    public func format(handle: FileHandle) throws -> FMTChunk? {
        guard let riffChunk = riffFile.chunks.first,
              let fmtChunk = riffChunk.chunks?.map(\.base).compactMap({ $0 as? FMTChunk }).first
        else {
            return nil
        }
        
        return fmtChunk
    }
}

extension WAVFile {
    /// Returns the WAV file data chunk ("data").
    /// Returns `nil` if the chunk is not found.
    /// Throws an error if there was a problem reading the data or the data is malformed.
    public func data() throws -> DataChunk? {
        guard let url = riffFile.url else { return nil }
        let h = try FileHandle(forReadingFrom: url)
        return try data(handle: h)
    }
    
    /// Returns the WAV file data chunk ("data").
    /// Returns `nil` if the chunk is not found.
    /// Throws an error if there was a problem reading the data or the data is malformed.
    public func data(handle: FileHandle) throws -> DataChunk? {
        guard let riffChunk = riffFile.chunks.first,
              let fmtChunk = riffChunk.chunks?.map(\.base).compactMap({ $0 as? DataChunk }).first
        else {
            return nil
        }
        
        return fmtChunk
    }
}

// MARK: - Broadcast Wave

extension WAVFile {
    /// Returns the WAV file Broadcast Extension chunk ("bext").
    /// Returns `nil` if the chunk is not found.
    /// Throws an error if there was a problem reading the data or the data is malformed.
    public func bext() throws -> BroadcastExtensionChunk? {
        guard let url = riffFile.url else { return nil }
        let h = try FileHandle(forReadingFrom: url)
        return try bext(handle: h)
    }
    
    /// Returns the WAV file Broadcast Extension chunk ("bext").
    /// Returns `nil` if the chunk is not found.
    /// Throws an error if there was a problem reading the data or the data is malformed.
    public func bext(handle: FileHandle) throws -> BroadcastExtensionChunk? {
        guard let riffChunk = riffFile.chunks.first,
              let fmtChunk = riffChunk.chunks?.map(\.base).compactMap({ $0 as? BroadcastExtensionChunk }).first
        else {
            return nil
        }
        
        return fmtChunk
    }
}
