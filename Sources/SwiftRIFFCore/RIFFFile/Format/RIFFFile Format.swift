//
//  RIFFFile Format.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import OTCore

extension RIFFFile {
    /// RIFx container format.
    public enum Format: String {
        /// RIFF container.
        ///
        /// Uses little-endian unsigned integer byte ordering.
        case riff = "RIFF"
        
        /// RIFX container.
        ///
        /// Uses little-endian unsigned integer byte ordering.
        case rifx = "RIFX"
        
        /// RIF2 container.
        ///
        /// A 64-bit RIFF format used by Steinberg in Cubase and Nuendo.
        case rif2 = "RIF2"
        
        /// RF64 container.
        ///
        /// A BWF-compatible multichannel audio file format enabling file sizes to exceed 4 GiB.
        ///
        /// See [Wikipedia](https://en.wikipedia.org/wiki/RF64)
        case rf64 = "RF64"
    }
}

extension RIFFFile.Format: Equatable { }

extension RIFFFile.Format: Hashable { }

extension RIFFFile.Format: CaseIterable { }

extension RIFFFile.Format: Sendable { }

extension RIFFFile.Format: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}

extension RIFFFile.Format {
    public var endianness: NumberEndianness {
        switch self {
        case .riff: .littleEndian
        case .rifx: .bigEndian
        case .rif2: .littleEndian // TODO: need to double-check this
        case .rf64: .littleEndian // TODO: need to double-check this
        }
    }
}
