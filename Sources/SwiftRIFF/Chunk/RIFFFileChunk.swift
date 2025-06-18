//
//  RIFFFileChunk.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-17.
//

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
}

extension RIFFFileChunk {
    /// Convenience:
    /// Conditionally casts as ``RIFFFileChunkHasSubID`` and returns `subID` if successful.
    public var getSubID: String? {
        guard let self = self as? any RIFFFileChunkHasSubID else { return nil }
        return self.subID
    }
    
    /// Convenience:
    /// Conditionally casts as ``RIFFFileChunkHasChunks`` and returns `chunks` if successful.
    public var getChunks: [AnyRIFFFileChunk] {
        guard let self = self as? any RIFFFileChunkHasChunks else { return [] }
        return self.chunks
    }
}

//extension RIFFFileChunk /* : Equatable */ {
//    public static func == (lhs: Self, rhs: Self) -> Bool {
//        lhs.isEqual(to: rhs)
//    }
//    
//    public static func == (lhs: Self, rhs: any RIFFFileChunk) -> Bool {
//        lhs.id == rhs.id
//            && lhs.subID == rhs.subID
//            && lhs.range == rhs.range
//            && lhs.dataRange == rhs.dataRange
//            && lhs.chunks.elementsEqual(rhs.chunks, by: { $0.isEqual(to: $1) })
//    }
//    
//    public func isEqual(to other: any RIFFFileChunk) -> Bool {
//        id == other.id
//            && subID == other.subID
//            && range == other.range
//            && dataRange == other.dataRange
//            && chunks.elementsEqual(other.chunks, by: { $0.isEqual(to: $1) })
//    }
//}
//
//public func == (lhs: any RIFFFileChunk, rhs: any RIFFFileChunk) -> Bool {
//    lhs.id == rhs.id
//        && lhs.subID == rhs.subID
//        && lhs.range == rhs.range
//        && lhs.dataRange == rhs.dataRange
//        && lhs.chunks.elementsEqual(rhs.chunks, by: { $0.isEqual(to: $1) })
//}

//extension RIFFFileChunk /* : Hashable */ {
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//        hasher.combine(subID)
//        hasher.combine(range)
//        hasher.combine(dataRange)
//        hasher.combine(chunks.map(\.hashValue))
//    }
//}

extension RIFFFileChunk {
    /// Returns the byte offset range of the chunk's usable data portion, excluding the sub-ID if present.
    public var dataRangeExcludingSubID: ClosedRange<UInt64>? {
        guard getSubID != nil else { return dataRange }
        guard let dataRange else { return nil }
        
        let proposedLowerBound = dataRange.lowerBound.advanced(by: 4)
        
        guard proposedLowerBound <= dataRange.upperBound else { return nil }
        
        return proposedLowerBound ... dataRange.upperBound
    }
    
    public var info: String {
        var out = "􀟈 \"\(id)\""
        if let subID = getSubID { out += " \"\(subID)\"" }
        out += " - File Byte Offset Range: \(range.lowerBound) ... \(range.upperBound)\n"
        out += getChunks.map(\.info)
            .joined(separator: "\n")
            .split(separator: "\n")
            .map { " 􀄵 \($0)" }
            .joined(separator: "\n")
        return out
    }
}

// MARK: - Collection Methods

extension RIFFFileChunk {
    public func asAnyRIFFFileChunk() -> AnyRIFFFileChunk {
        AnyRIFFFileChunk(base: self)
    }
}

extension Sequence<any RIFFFileChunk> {
    public func asAnyRIFFFileChunks() -> [AnyRIFFFileChunk] {
        map(AnyRIFFFileChunk.init(base:))
    }
}

extension Sequence<AnyRIFFFileChunk> {
    public func filter(id: String) -> [Element] {
        filter { $0.id.id == id }
    }
    
    public func filter(id: RIFFFileChunkID) -> [Element] {
        filter { $0.id == id }
    }
    
    public func first(id: String) -> Element? {
        first { $0.id.id == id }
    }
    
    public func first(id: RIFFFileChunkID) -> Element? {
        first { $0.id == id }
    }
}
