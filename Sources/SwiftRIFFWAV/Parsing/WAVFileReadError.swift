//
//  WAVFileReadError.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-16.
//

import Foundation
import SwiftRIFFCore

public enum WAVFileReadError: LocalizedError {
    case riffFileReadError(RIFFFileReadError)
    case riffFileWriteError(RIFFFileReadError)
    
    case malformedBroadcastExtensionChunk
    case malformedFormatChunk
    case missingFormatChunk
    case missingDataChunk
    case invalidOrUnrecognizedAudioEncoding
    case invalidChannelCount
    case invalidSampleRate
    case invalidBitDepth
}

extension WAVFileReadError {
    public var errorDescription: String? {
        switch self {
        case let .riffFileReadError(err): "RIFF read error: \(err.localizedDescription)"
        case let .riffFileWriteError(err): "RIFF write error: \(err.localizedDescription)"
        case .malformedBroadcastExtensionChunk: "Malformed BWAV broadcast extension chunk."
        case .malformedFormatChunk: "Malformed format chunk."
        case .missingFormatChunk: "Missing format chunk."
        case .missingDataChunk: "Missing data chunk."
        case .invalidOrUnrecognizedAudioEncoding: "Invalid or unrecognized audio encoding."
        case .invalidChannelCount: "Invalid or unexpected audio channel count."
        case .invalidSampleRate: "Invalid or unexpected audio sample rate."
        case .invalidBitDepth: "Invalid audio bit depth."
        }
    }
}
