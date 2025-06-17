//
//  RIFFFileReadError.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-16.
//

import Foundation

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
        case let .fileReadError(subError): 
            "File read error."
                + (subError != nil ? " \(subError!.localizedDescription)" : "")
        case .unsupportedRIF2Type:
            "Unsupported RIF2 type. Support may be added in future."
        case .missingRIFFHeader:
            "Missing RIFx identifier at file start. File may not be a RIFF/RIFX/RIF2 file."
        case .fileLengthInvalid:
            "File length invalid."
        case .missingFileTypeIdentifier:
            "Missing file type identifier."
        case let .missingChunkSubtypeIdentifier(chunkID: chunkID):
            "Missing chunk subtype identifier for chunk \"\(chunkID)\"."
        case let .invalidChunkTypeIdentifier(chunkID: chunkID):
            "Invalid chunk type identifier"
                + (chunkID != nil ? ": \(chunkID!)\"" : "" )
                + "."
        case let .chunkLengthInvalid(forChunkID: chunkID):
            "Chunk \"\(chunkID)\" length invalid."
        }
    }
}
