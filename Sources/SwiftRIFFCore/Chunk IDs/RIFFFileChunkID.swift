//
//  RIFFFileChunkID.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import OTCore

/// RIFF File chunk ID.
public struct RIFFFileChunkID {
    public let id: String
    
    public init(id: String) {
        self.id = id
    }
}

extension RIFFFileChunkID: Equatable {
    // mixed-type methods in addition to the synthesized methods
    
    public static func == (lhs: Self, rhs: some StringProtocol) -> Bool {
        lhs.id == rhs
    }
    
    public static func == (lhs: some StringProtocol, rhs: Self) -> Bool {
        lhs == rhs.id
    }
    
    public static func != (lhs: Self, rhs: some StringProtocol) -> Bool {
        lhs.id != rhs
    }
    
    public static func != (lhs: some StringProtocol, rhs: Self) -> Bool {
        lhs != rhs.id
    }
}

extension RIFFFileChunkID: Hashable { }

extension RIFFFileChunkID: Sendable { }

extension RIFFFileChunkID: CustomStringConvertible {
    public var description: String {
        id
    }
}

// MARK: - Validation

extension RIFFFileChunkID {
    /// Returns `true` if the string is formatted as a valid RIFF chunk identifier.
    public var isValid: Bool {
        guard id.count == 4 else { return false }
        guard id.isASCII else { return false }
        guard !id.contains("\0") else { return false }
        return true
    }
}
