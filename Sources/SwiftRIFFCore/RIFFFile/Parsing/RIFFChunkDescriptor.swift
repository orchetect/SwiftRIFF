//
//  RIFFChunkDescriptor.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

/// Lightweight descriptor for a RIFF file chunk including its identity and byte ranges.
public struct RIFFChunkDescriptor {
    public let id: RIFFFileChunkID
    public let subID: String? // applicable to RIFF or LIST chunks only
    public let length: UInt32
    public let chunkRange: ClosedRange<UInt64>
    public let dataRange: (usableRange: ClosedRange<UInt64>, encodedRange: ClosedRange<UInt64>)?
}

extension RIFFChunkDescriptor: Equatable {
    public static func == (lhs: RIFFChunkDescriptor, rhs: RIFFChunkDescriptor) -> Bool {
        lhs.id == rhs.id
            && lhs.subID == rhs.subID
            && lhs.length == rhs.length
            && lhs.chunkRange == rhs.chunkRange
            && lhs.dataRange?.usableRange == rhs.dataRange?.usableRange
            && lhs.dataRange?.encodedRange == rhs.dataRange?.encodedRange
    }
}

extension RIFFChunkDescriptor: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(subID)
        hasher.combine(length)
        hasher.combine(chunkRange)
        hasher.combine(dataRange?.usableRange)
        hasher.combine(dataRange?.encodedRange)
    }
}

extension RIFFChunkDescriptor: Sendable { }
