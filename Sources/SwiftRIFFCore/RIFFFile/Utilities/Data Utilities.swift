//
//  Data Utilities.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OTCore

extension Data {
    /// Returns an ASCII string encoded as null-terminated.
    /// If all bytes are non-null, it is assumed no null character is required and all bytes are ASCII characters.
    package func nullTerminatedASCIIString() -> String? {
        guard !isEmpty else { return nil }
        let range = indices.lowerBound ... indices.upperBound - 1
        return nullTerminatedASCIIString(in: range)
    }
    
    /// Returns an ASCII string encoded as null-terminated.
    /// If all bytes are non-null, it is assumed no null character is required and all bytes are ASCII characters.
    package func nullTerminatedASCIIString(in range: ClosedRange<Index>) -> String? {
        let firstNullIndex = firstRange(of: [0x00 as UInt8], in: range)?.lowerBound
        
        if firstNullIndex == nil {
            // possibly all bytes are occupied (non-null)
            return self[range].toString(using: .ascii)
        }
        
        // Check for empty string (first char is a null byte)
        if firstNullIndex == range.lowerBound {
            return ""
        }
        
        // otherwise, assume all bytes prior to the null are ASCII characters
        guard let firstNullIndex else { return nil }
        let parseRange = range.lowerBound ..< firstNullIndex
        return self[parseRange]
            .toString(using: .ascii)
    }
}
