//
//  RIFFFile.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftExtensions

/// A view into a RIFF-based file (RIFF, RIFX, RF64, RIF2).
///
/// Parses an existing RIFF-based file, and supports a limited set of write operations.
///
/// Resource Interchange File Format (RIFF) is a generic file container format for storing data in tagged chunks.
/// It is historically used primarily for audio and video but can be used for nearly any content.
///
/// The 'directory entries' are defined by chunks. Every chunk contains either data or a list of chunks.
///
/// The first chunk is the root entry and must have a ID of "RIFF" or "RIFX", the former being the most
/// common version. "RIFF" specifies little-endian byte ordering, whereas the less common "RIFX" specifies
/// big-endian byte order.
///
/// See [Wikipedia Article](https://en.wikipedia.org/wiki/Resource_Interchange_File_Format).
public struct RIFFFile {
    public let url: URL?
    
    /// 4-Byte ASCII identifier describing the RIFF file type.
    ///
    /// This format determines the byte endianness of data stored within the file.
    public let riffFormat: Format
    
    /// Chunks contained in the file.
    public let chunks: [AnyRIFFFileChunk]
}

extension RIFFFile: Equatable { }

extension RIFFFile: Hashable { }

extension RIFFFile: Sendable { }

extension RIFFFile {
    /// Initialize by parsing a RIFF file on disk.
    ///
    /// - Parameters:
    ///   - url: File URL to the RIFF file on disk.
    ///   - additionalChunkTypes: Optionally supply custom chunk types to the parser.
    public init(
        url: URL,
        additionalChunkTypes: RIFFFileChunkTypes = [:]
    ) throws(RIFFFileReadError) {
        let h: FileHandle
        do {
            h = try FileHandle(forReadingFrom: url)
        } catch { throw .fileReadError(subError: error) }
        
        try self.init(handle: h, url: url, additionalChunkTypes: additionalChunkTypes)
    }
    
    // TODO: add parser that can parse `Data` in memory without requiring a FileHandle
    // public init(data: Data) throws {
    //
    // }
    
    /// Initialize by parsing a RIFF file on disk.
    ///
    /// - Parameters:
    ///   - handle: File handle pointing to a RIFF file on disk. Ensure the file handle was created for reading from a file URL.
    ///   - url: File URL to the RIFF file on disk. This must be the same file URL used to open the file handle.
    ///   - additionalChunkTypes: Optionally supply custom chunk types to the parser.
    public init(
        handle: FileHandle,
        url: URL? = nil,
        additionalChunkTypes: RIFFFileChunkTypes = [:]
    ) throws(RIFFFileReadError) {
        self.url = url
        (riffFormat, chunks) = try handle.parseRIFF(additionalChunkTypes: additionalChunkTypes)
    }
}

extension RIFFFile {
    /// Returns a hierarchical info string describing the RIFF file's basic structure, suitable for debugging.
    public var info: String {
        chunks.map(\.base).map(\.info).joined(separator: "\n")
    }
}
