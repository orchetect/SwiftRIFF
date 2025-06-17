//
//  RIFFFile Chunk.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-16.
//

extension RIFFFile {
    public enum Chunk {
        /// RIFF chunk.
        ///
        /// - Parameters:
        ///   - subID: 4-Byte ASCII identifier, padded with ASCII 32 (space) if less than 4 characters.
        ///     This identifier determines the specification outlining the structure and format of this chunk.
        ///   - chunks: Subchunks contained within the chunk.
        ///   - range: The total byte offset range of the entire chunk.
        ///   - dataRange: The byte offset range of the chunk's usable data portion.
        case riff(subID: String, chunks: [Chunk], range: ClosedRange<UInt64>, dataRange: ClosedRange<UInt64>?)
        
        /// LIST chunk.
        ///
        /// - Parameters:
        ///   - subID: 4-Byte ASCII identifier, padded with ASCII 32 (space) if less than 4 characters.
        ///     This identifier determines the specification outlining the structure and format of this chunk.
        ///   - chunks: Subchunks contained within the chunk.
        ///   - range: The total byte offset range of the entire chunk.
        ///   - dataRange: The byte offset range of the chunk's usable data portion.
        case list(subID: String, chunks: [Chunk], range: ClosedRange<UInt64>, dataRange: ClosedRange<UInt64>?)
        
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
        ///
        /// - Parameters:
        ///   - range: The total byte offset range of the entire chunk.
        ///   - dataRange: The byte offset range of the chunk's usable data portion.
        case info(range: ClosedRange<UInt64>, dataRange: ClosedRange<UInt64>?)
        
        // TODO: add JUNK chunk
        
        /// A generic chunk.
        ///
        /// - Parameters:
        ///   - id: 4-Byte ASCII identifier, padded with ASCII 32 (space) if less than 4 characters.
        ///     This identifier determines the specification outlining the structure and format of this chunk.
        ///   - range: The total byte offset range of the entire chunk.
        ///   - dataRange: The byte offset range of the chunk's usable data portion.
        case generic(id: RIFFFile.ChunkID, range: ClosedRange<UInt64>, dataRange: ClosedRange<UInt64>?)
    }
}

extension RIFFFile.Chunk: Equatable { }

extension RIFFFile.Chunk: Hashable { }

extension RIFFFile.Chunk: Sendable { }

extension RIFFFile.Chunk: RIFFFileChunk {
    public var id: RIFFFile.ChunkID {
        switch self {
        case .riff: .riff
        case .list: .list
        case .info: .info
        case let .generic(id: id, range: _, dataRange: _): id
        }
    }
    
    public var subID: String? {
        switch self {
        case let .riff(subID: subID, chunks: _, range: _, dataRange: _): subID
        case let .list(subID: subID, chunks: _, range: _, dataRange: _): subID
        case .info: nil
        case .generic: nil
        }
    }
    
    public var range: ClosedRange<UInt64> {
        switch self {
        case let .riff(subID: _, chunks: _, range: range, dataRange: _): range
        case let .list(subID: _, chunks: _, range: range, dataRange: _): range
        case let .info(range: range, dataRange: _): range
        case let .generic(id: _, range: range, dataRange: _): range
        }
    }
    
    public var dataRange: ClosedRange<UInt64>? {
        switch self {
        case let .riff(subID: _, chunks: _, range: _, dataRange: dataRange): dataRange
        case let .list(subID: _, chunks: _, range: _, dataRange: dataRange): dataRange
        case let .info(range: _, dataRange: dataRange): dataRange
        case let .generic(id: _, range: _, dataRange: dataRange): dataRange
        }
    }
    
    public var chunks: [RIFFFile.Chunk] {
        switch self {
        case .riff(subID: _, let chunks, range: _, dataRange: _): chunks
        case .list(subID: _, let chunks, range: _, dataRange: _): chunks
        case .info(range: _, dataRange: _): []
        case .generic(id: _, range: _, dataRange: _): []
        }
    }
}

extension RIFFFile.Chunk {
    public var info: String {
        switch self {
        case let .riff(subID, chunks, range, _):
            "􀟈 \"RIFF\" \"\(subID)\" - File Byte Offset Range: \(range.lowerBound) ... \(range.upperBound)\n"
                + chunks.map(\.info)
                .joined(separator: "\n")
                .split(separator: "\n")
                .map { " 􀄵 \($0)" }
                .joined(separator: "\n")
        case let .list(subID, chunks, range, _):
            "􀟈 \"LIST\" \"\(subID)\" - File Byte Offset Range: \(range.lowerBound) ... \(range.upperBound)\n"
                + chunks.map(\.info)
                .joined(separator: "\n")
                .split(separator: "\n")
                .map { " 􀄵 \($0)" }
                .joined(separator: "\n")
        case let .info(range, _):
            "􀟈 \"INFO\" - File Byte Offset Range: \(range.lowerBound) ... \(range.upperBound)"
        case let .generic(id, range, _):
            "􀟈 \"\(id)\" - File Byte Offset Range: \(range.lowerBound) ... \(range.upperBound)"
        }
    }
}

// MARK: - Collection Methods

extension Sequence<RIFFFile.Chunk> {
    public func filter(id: String) -> [Element] {
        filter { $0.id.rawValue == id }
    }
    
    public func filter(id: RIFFFile.ChunkID) -> [Element] {
        filter { $0.id == id }
    }
    
    public func first(id: String) -> Element? {
        first { $0.id.rawValue == id }
    }
    
    public func first(id: RIFFFile.ChunkID) -> Element? {
        first { $0.id == id }
    }
}
