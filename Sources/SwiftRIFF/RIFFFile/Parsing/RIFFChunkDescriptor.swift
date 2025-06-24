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
    public let encodedDataRange: ClosedRange<UInt64>?
    public let dataRange: ClosedRange<UInt64>?
}

extension RIFFChunkDescriptor: Equatable { }

extension RIFFChunkDescriptor: Hashable { }

extension RIFFChunkDescriptor: Sendable { }
