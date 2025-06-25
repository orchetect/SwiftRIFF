//
//  WAVFile FMTChunk Metadata.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OTCore
import SwiftRIFFCore

extension WAVFile.FMTChunk {
    public struct Metadata {
        public var encoding: WAVFile.Encoding
        public var sampleRate: WAVFile.SampleRate
        public var bitDepth: WAVFile.BitDepth
        public var channels: UInt16
        public var extraBytes: Data?
        
        public init(
            encoding: WAVFile.Encoding,
            sampleRate: WAVFile.SampleRate,
            bitDepth: WAVFile.BitDepth,
            channels: UInt16,
            extraBytes: Data? = nil
        ) {
            self.encoding = encoding
            self.sampleRate = sampleRate
            self.bitDepth = bitDepth
            self.channels = channels
            self.extraBytes = extraBytes
        }
    }
}

extension WAVFile.FMTChunk.Metadata: Equatable { }

extension WAVFile.FMTChunk.Metadata: Hashable { }

extension WAVFile.FMTChunk.Metadata: Sendable { }

extension WAVFile.FMTChunk.Metadata {
    /// Initializes from the data portion of the chunk (omitting leading chunk ID and length).
    public init(data: Data, endianness: NumberEndianness) throws(WAVFileReadError) {
        // minimum data length is 16 bytes, but can also contain extra trailing bytes
        guard data.count >= 16 else { throw .malformedFormatChunk }
        
        guard let encodingInt = data[0 ... 1].toUInt16(from: endianness),
              let encoding = WAVFile.Encoding(rawValue: encodingInt)
        else { throw .invalidOrUnrecognizedAudioEncoding }
        self.encoding = encoding
        
        guard let channelCount = data[2 ... 3].toUInt16(from: endianness)
        else { throw .invalidChannelCount }
        channels = channelCount
        
        guard let srInt = data[4 ... 7].toUInt32(from: endianness),
              let sr = WAVFile.SampleRate(rawValue: srInt)
        else { throw .invalidSampleRate }
        sampleRate = sr
        
        guard let bdInt = data[14 ... 15].toUInt16(from: endianness),
              let bd = WAVFile.BitDepth(rawValue: bdInt)
        else { throw .invalidBitDepth }
        bitDepth = bd
        
        // TODO: add validation of non-stored chunk values
        
        // parse extra bytes if present
        if data.count > 16 {
            extraBytes = data[16...]
        }
    }
    
    /// Returns the data portion of the chunk (omitting leading chunk ID and length).
    ///
    /// - Parameters:
    ///   - endianness: Byte ordering.
    ///   - extraBytes: Extra format bytes.
    /// - Returns: Chunk data.
    public func data(endianness: NumberEndianness) -> Data {
        let avgBytesPerSec = UInt32((UInt64(sampleRate.rawValue) * UInt64(bitDepth.rawValue) * UInt64(channels)) / 8)
        let blockAlign = UInt16((bitDepth.rawValue * channels) / 8)
        
        var bytes: [UInt8] = encoding.rawValue.toData(endianness).bytes
            + channels.toData(endianness).bytes
            + sampleRate.rawValue.toData(endianness).bytes
            + avgBytesPerSec.toData(endianness).bytes
            + blockAlign.toData(endianness).bytes
            + bitDepth.rawValue.toData(endianness).bytes
        
        if let extraBytes {
            bytes += extraBytes.bytes
        }
        
        return Data(bytes)
    }
}

extension WAVFile.FMTChunk.Metadata: CustomStringConvertible {
    public var description: String {
        var output = "encoding:\(encoding) samplerate:\(sampleRate) bitdepth:\(bitDepth) channels:\(channels)"
        
        if let extraBytes {
            if extraBytes.allSatisfy({ $0 == 0x00 }) {
                output += " + \(extraBytes.count) trailing null bytes"
            } else {
                output += " + \(extraBytes.count) trailing bytes"
            }
        }
        
        return output
    }
}
