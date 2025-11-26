//
//  RIFFFileReadError.swift
//  swift-riff • https://github.com/orchetect/swift-riff
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Error cases returned by `RIFFile` read/parse methods.
public enum RIFFFileReadError: LocalizedError {
    case fileReadError(subError: Error?)
    case unsupportedRIF2Type
    case missingRIFFHeader
    case fileLengthInvalid
    case missingFileTypeIdentifier
    case missingChunkSubtypeIdentifier(chunkID: String)
    case invalidChunkTypeIdentifier(chunkID: String?)
    case chunkLengthInvalid(forChunkID: String)
}

extension RIFFFileReadError {
    public var errorDescription: String? {
        switch self {
        case let .fileReadError(subError: subError):
            "File read error"
                + (subError != nil ? ": \(subError!.localizedDescription)" : ".")
        case .unsupportedRIF2Type:
            "Unsupported RIF2 type. Support may be added in future."
        case .missingRIFFHeader:
            "Missing RIFF identifier at file start. File may not be a RIFF/RIFX/RF64/RIF2 file."
        case .fileLengthInvalid:
            "File length invalid."
        case .missingFileTypeIdentifier:
            "Missing file type identifier."
        case let .missingChunkSubtypeIdentifier(chunkID: chunkID):
            "Missing chunk subtype identifier for chunk \"\(chunkID)\"."
        case let .invalidChunkTypeIdentifier(chunkID: chunkID):
            "Invalid chunk type identifier"
                + (chunkID != nil ? ": \(chunkID!)\"" : "")
                + "."
        case let .chunkLengthInvalid(forChunkID: chunkID):
            "Chunk \"\(chunkID)\" length invalid."
        }
    }
}
