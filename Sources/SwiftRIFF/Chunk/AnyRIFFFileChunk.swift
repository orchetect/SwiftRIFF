//
//  AnyRIFFFileChunk.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-17.
//

/// Type-erased box containing a specialized concrete ``RIFFFileChunk`` instance.
public struct AnyRIFFFileChunk {
    public var base: any RIFFFileChunk
    
    public init(base: any RIFFFileChunk) {
        self.base = base
    }
}

extension AnyRIFFFileChunk: Equatable {
    public static func == (lhs: AnyRIFFFileChunk, rhs: AnyRIFFFileChunk) -> Bool {
        lhs.base.hashValue == rhs.base.hashValue
    }
}

extension AnyRIFFFileChunk: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(base.hashValue)
    }
}

extension AnyRIFFFileChunk: Sendable { }

extension AnyRIFFFileChunk: CustomStringConvertible {
    public var description: String {
        "\(base)"
    }
}

extension AnyRIFFFileChunk: RIFFFileChunk {
    public var id: RIFFFileChunkID {
        base.id
    }
    
    public var range: ClosedRange<UInt64> {
        base.range
    }
    
    public var dataRange: ClosedRange<UInt64>? {
        base.dataRange
    }
}

extension AnyRIFFFileChunk /* : RIFFFileChunkHasSubID */ {
    public var subID: String? {
        base.getSubID
    }
}

extension AnyRIFFFileChunk /* : RIFFFileChunkHasChunks */ {
    public var chunks: [AnyRIFFFileChunk] {
        base.getChunks
    }
}
