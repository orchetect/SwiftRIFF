//
//  RIFFFileWriteError.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-16.
//

import Foundation

public enum RIFFFileWriteError: LocalizedError {
    case fileReadError(subError: Error?)
    case fileWriteError(subError: Error?)
    case noFileURL
    case newChunkDoesNotMatchExistingChunkSize
    case invalidChunkID
    case invalidChunkSubID
    case invalidChunkLength
    case fileTooSmall
}

extension RIFFFileWriteError {
    public var errorDescription: String? {
        switch self {
        case let .fileReadError(subError: subError):
            "File read error"
                + (subError != nil ? " \(subError!.localizedDescription)" : ".")
        case let .fileWriteError(subError: subError):
            "File write error"
                + (subError != nil ? " \(subError!.localizedDescription)" : ".")
        case .noFileURL:
            "No file URL specified."
        case .newChunkDoesNotMatchExistingChunkSize:
            "New chunk does not match existing chunk size."
        case .invalidChunkID:
            "Invalid chunk ID. String is the wrong length or contains non-ASCII characters."
        case .invalidChunkSubID:
            "Invalid chunk sub-ID. String is the wrong length or contains non-ASCII characters."
        case .invalidChunkLength:
            "Invalid chunk length."
        case .fileTooSmall:
            "File is too small to write the requested data to."
        }
    }
}
