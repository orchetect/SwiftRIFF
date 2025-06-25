//
//  WAVFile BitDepth.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension WAVFile {
    public enum BitDepth: UInt16 {
        case bd8 = 8
        case bd16 = 16
        case bd24 = 24
        case bd32 = 32
        case bd64 = 64
    }
}

extension WAVFile.BitDepth: Equatable { }

extension WAVFile.BitDepth: Hashable { }

extension WAVFile.BitDepth: CaseIterable { }

extension WAVFile.BitDepth: Sendable { }

extension WAVFile.BitDepth: CustomStringConvertible {
    public var description: String {
        "\(rawValue)-bit"
    }
}
