//
//  RIFFFileChunk.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftExtensions
import SwiftRadix

public protocol RIFFFileChunk: Equatable, Hashable, Sendable {
    /// Chunk ID.
    ///
    /// 4-Byte ASCII identifier, padded with ASCII 32 (space) if less than 4 characters.
    ///
    /// This identifier determines the specification outlining the structure and format of this chunk.
    var id: RIFFFileChunkID { get }
    
    /// The total byte offset range of the entire chunk.
    var range: ClosedRange<UInt64> { get }
    
    /// The byte offset range of the chunk's usable data portion.
    var dataRange: ClosedRange<UInt64>? { get }
    
    init(
        handle: FileHandle,
        endianness: NumberEndianness,
        additionalChunkTypes: RIFFFileChunkTypes
    ) throws(RIFFFileReadError)
}

// MARK: - Proxy properties for trait protocols

extension RIFFFileChunk {
    /// Convenience:
    /// Conditionally casts as ``RIFFFileChunkHasSubID`` and returns `subID` if successful.
    public var getSubID: String? {
        guard let self = self as? any RIFFFileChunkHasSubID else { return nil }
        return self.subID
    }
    
    /// Convenience:
    /// Conditionally casts as ``RIFFFileChunkHasChunks`` and returns `chunks` if successful.
    public var getChunks: [AnyRIFFFileChunk]? {
        guard let self = self as? any RIFFFileChunkHasChunks else { return nil }
        return self.chunks
    }
}

// MARK: - Generic Methods

extension RIFFFileChunk {
    /// Returns the byte offset range of the chunk's usable data portion, excluding the sub-ID if present.
    public var dataRangeExcludingSubID: ClosedRange<UInt64>? {
        guard getSubID != nil else { return dataRange }
        guard let dataRange else { return nil }
        
        let proposedLowerBound = dataRange.lowerBound.advanced(by: 4)
        
        guard proposedLowerBound <= dataRange.upperBound else { return nil }
        
        return proposedLowerBound ... dataRange.upperBound
    }
    
    /// Returns a hierarchical info string describing the RIFF file's basic structure, suitable for debugging.
    public var info: String {
        var out = "􀟈 \"\(id)\""
        if let subID = getSubID { out += " \"\(subID)\"" }
        out += "\n"
        
        out += "- Size: \(range.count) bytes\n"
        
        let hexLowerBound = range.lowerBound.hex.stringValue(padToEvery: 2, prefix: false)
        let hexUpperBound = range.upperBound.hex.stringValue(padToEvery: 2, prefix: false)
        out += "- Byte Range (Hex): \(hexLowerBound) ... \(hexUpperBound)\n"
        
        out += "- Byte Range (Int): \(range.lowerBound) ... \(range.upperBound)\n"
        
        out += (getChunks ?? []).map(\.base)
            .map(\.info)
            .map {
                var lines = $0.split(separator: "\n")
                let firstLine = lines.removeFirst()
                return "􀄵 \(firstLine)\n" + (lines.map { "   \($0)" }.joined(separator: "\n"))
            }
            .joined(separator: "\n")
        return out
    }
}

// MARK: - Type Erasure

extension RIFFFileChunk {
    /// Convenience to return the RIFF file chunk wrapped in a type-erased ``AnyRIFFFileChunk`` box.
    public func asAnyRIFFFileChunk() -> AnyRIFFFileChunk {
        AnyRIFFFileChunk(base: self)
    }
}

extension Sequence<any RIFFFileChunk> {
    /// Convenience to return the RIFF file chunk elements wrapped in type-erased ``AnyRIFFFileChunk`` boxes.
    public func asAnyRIFFFileChunks() -> [AnyRIFFFileChunk] {
        map(AnyRIFFFileChunk.init(base:))
    }
}

// MARK: - Collection Methods

extension Sequence<any RIFFFileChunk> {
    /// Returns an array containing chunk(s) matching the given chunk ID string.
    public func filter(id: String) -> [Element] {
        filter { $0.id.id == id }
    }
    
    /// Returns an array containing chunk(s) matching the given chunk IDs.
    public func filter(id: RIFFFileChunkID) -> [Element] {
        filter { $0.id == id }
    }
    
    /// Returns the first chunk matching the given chunk ID string.
    public func first(id: String) -> Element? {
        first { $0.id.id == id }
    }
    
    /// Returns the first chunk matching the given chunk ID.
    public func first(id: RIFFFileChunkID) -> Element? {
        first { $0.id == id }
    }
}
