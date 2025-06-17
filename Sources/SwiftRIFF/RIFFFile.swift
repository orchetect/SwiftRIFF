//
//  RIFFFile.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-16.
//

import Foundation
import OTCore

/// A view into a RIFx File (RIFF, RIFX, RIF2).
///
/// Parses an existing RIFx file, and supports a limited set of write operations.
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
    public let chunks: [Chunk]
}

extension RIFFFile: Equatable { }

extension RIFFFile: Hashable { }

extension RIFFFile: Sendable { }

extension RIFFFile {
    public init(url: URL) throws {
        let h = try FileHandle(forReadingFrom: url)
        try self.init(handle: h, url: url)
        try h.close()
    }
    
    // TODO: add parser that can parse `Data` in memory without requiring a FileHandle
    // public init(data: Data) throws {
    //
    // }
    
    public init(handle: FileHandle, url: URL? = nil) throws(RIFFFileReadError) {
        self.url = url
        (riffFormat, chunks) = try handle.parseRIFF()
    }
}

extension RIFFFile {
    public var info: String {
        chunks.map(\.info).joined(separator: "\n")
    }
}
