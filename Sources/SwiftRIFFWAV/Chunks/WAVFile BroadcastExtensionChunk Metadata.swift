//
//  WAVFile BroadcastExtensionChunk Metadata.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OTCore
import SwiftRIFFCore
import TimecodeKitCore

extension WAVFile.BroadcastExtensionChunk {
    public struct Metadata {
        /// Description.
        ///
        /// (Maximum 256 characters; unused trailing characters should be null bytes.)
        public var bwavDescription: String {
            get { bwavDescriptionData.nullTerminatedASCIIString() ?? "" }
            set { if let ascii = newValue.data(using: .ascii) { bwavDescriptionData = ascii } }
        }
        
        /// Description (raw bytes).
        ///
        /// (Maximum 256 characters; unused trailing characters should be null bytes.)
        public var bwavDescriptionData: Data {
            didSet {
                if bwavDescriptionData.count > 256 { bwavDescriptionData = bwavDescriptionData.prefix(256) }
                if bwavDescriptionData.count < 256 { bwavDescriptionData = bwavDescriptionData.padding(toLength: 256, withPad: 0x00) }
            }
        }
        
        public var originator: String {
            get { originatorData.nullTerminatedASCIIString() ?? "" }
            set { if let ascii = newValue.data(using: .ascii) { originatorData = ascii } }
        }
        
        public var originatorData: Data {
            didSet {
                if originatorData.count > 32 { originatorData = originatorData.prefix(32) }
                if originatorData.count < 32 { originatorData = originatorData.padding(toLength: 32, withPad: 0x00) }
            }
        }
        
        public var originatorReference: String {
            get { originatorReferenceData.nullTerminatedASCIIString() ?? "" }
            set { if let ascii = newValue.data(using: .ascii) { originatorReferenceData = ascii } }
        }
        
        public var originatorReferenceData: Data {
            didSet {
                if originatorReferenceData.count > 32 { originatorReferenceData = originatorReferenceData.prefix(32) }
                if originatorReferenceData.count < 32 { originatorReferenceData = originatorReferenceData.padding(toLength: 32, withPad: 0x00) }
            }
        }
        
        public var originationDate: String {
            didSet { if originationDate.count > 10 { originationDate = String(originationDate.prefix(10)) } }
        }
        
        public var originationTime: String {
            didSet { if originationTime.count > 8 { originationTime = String(originationTime.prefix(8)) } }
        }
        
        /// Timecode of the start of the audio.
        ///
        /// A 64-bit value which contains the first sample count since midnight. The number
        /// of samples per second depends on the sample rate which is defined  in the file's
        /// format ("fmt ") chunk.
        public var timeReference: UInt64
        
        /// Version of the Broadcast Extension chunk specification.
        ///
        /// Version 1 and 2 are common, where 2 is the latest.
        public var version: UInt16
        
        /// UMID (Unique Material Identifier) as defined by SMPTE ST 330M (64 bytes).
        /// If only a 32 byte "basic UMID" is used, the last 32 bytes should be null bytes.
        ///
        /// See: https://en.wikipedia.org/wiki/Unique_Material_Identifier
        public var umid: Data {
            didSet { if umid.count != 64 { umid = umid.umidPadding() } }
        }
        
        public var loudnessValue: UInt16
        
        public var loudnessRange: UInt16
        
        public var maxTruePeakLevel: UInt16
        
        public var maxMomentaryLoudness: UInt16
        
        public var maxShortTermLoudness: UInt16
        
        public var codingHistory: String
        
        public init(
            description: String = "",
            originator: String = "",
            originatorReference: String = "",
            originationDate: String = "",
            originationTime: String = "",
            timeReference: UInt64 = 0,
            version: UInt16 = 2,
            umid: Data = Data(repeating: 0x00, count: 64),
            loudnessValue: UInt16 = 0,
            loudnessRange: UInt16 = 0,
            maxTruePeakLevel: UInt16 = 0,
            maxMomentaryLoudness: UInt16 = 0,
            maxShortTermLoudness: UInt16 = 0,
            codingHistory: String = ""
        ) {
            self.bwavDescriptionData = description
                .prefix(256)
                .data(using: .ascii)?
                .padding(toLength: 256, withPad: 0x00)
                ?? Data(repeating: 0x00, count: 256)
            self.originatorData = originator
                .prefix(32)
                .data(using: .ascii)?
                .padding(toLength: 32, withPad: 0x00)
                ?? Data(repeating: 0x00, count: 32)
            self.originatorReferenceData = originatorReference
                .prefix(32)
                .data(using: .ascii)?
                .padding(toLength: 32, withPad: 0x00)
                ?? Data(repeating: 0x00, count: 32)
            self.originationDate = String(originationDate.prefix(10))
            self.originationTime = String(originationTime.prefix(8))
            self.timeReference = timeReference
            self.version = version
            self.umid = umid.umidPadding()
            self.loudnessValue = loudnessValue
            self.loudnessRange = loudnessRange
            self.maxTruePeakLevel = maxTruePeakLevel
            self.maxMomentaryLoudness = maxMomentaryLoudness
            self.maxShortTermLoudness = maxShortTermLoudness
            self.codingHistory = codingHistory
        }
    }
}

extension WAVFile.BroadcastExtensionChunk.Metadata: Equatable { }

extension WAVFile.BroadcastExtensionChunk.Metadata: Hashable { }

extension WAVFile.BroadcastExtensionChunk.Metadata: Sendable { }

extension WAVFile.BroadcastExtensionChunk.Metadata {
    /// Initializes from the data portion of the chunk (omitting leading chunk ID and length).
    public init(data: Data, endianness: NumberEndianness) throws(WAVFileReadError) {
        // "bext" chunk is minimum 610 bytes including chunk name/length (602 for data chunk).
        // The data may or may not continue with an arbitrary number of ASCII characters defining its
        // Coding History segment.
        
        guard data.count >= 602
        else { throw .malformedBroadcastExtensionChunk }
        
        // description (256 bytes)
        bwavDescriptionData = data[0 ... 255]
        // guard let bwavDescription = data.nullTerminatedASCIIString(in: 0 ... 255)
        // else { throw .malformedBroadcastExtensionChunk }
        // self.bwavDescription = bwavDescription
        
        // originator (32 bytes)
        originatorData = data[256 ... 287]
        // guard let originator = data.nullTerminatedASCIIString(in: 256 ... 287)
        // else { throw .malformedBroadcastExtensionChunk }
        // self.originator = originator
        
        // originator reference (32 bytes)
        originatorReferenceData = data[288 ... 319]
        // guard let originatorReference = data.nullTerminatedASCIIString(in: 288 ... 319)
        // else { throw .malformedBroadcastExtensionChunk }
        // self.originatorReference = originatorReference
        
        // origination date (10 bytes)
        guard let originationDate = data[320 ... 329]
            .toString(using: .ascii)?
            .trimmingCharacters(in: .null)
        else { throw .malformedBroadcastExtensionChunk }
        self.originationDate = originationDate
        
        // origination time (8 bytes)
        guard let originationTime = data[330 ... 337]
            .toString(using: .ascii)?
            .trimmingCharacters(in: .null)
        else { throw .malformedBroadcastExtensionChunk }
        self.originationTime = originationTime
        
        // time reference (2 x 4-bytes)
        guard let timeReference = data[338 ... 345].toUInt64(from: endianness)
        else { throw .malformedBroadcastExtensionChunk }
        self.timeReference = timeReference
        
        // version (2 bytes)
        guard let version = data[346 ... 347].toUInt16(from: endianness)
        else { throw .malformedBroadcastExtensionChunk }
        self.version = version
        
        // umid (64 bytes)
        umid = data[348 ... 411]
        
        // loudness value (2 bytes)
        guard let loudnessValue = data[412 ... 413].toUInt16(from: endianness)
        else { throw .malformedBroadcastExtensionChunk }
        self.loudnessValue = loudnessValue
        
        // loudness range (2 bytes)
        guard let loudnessRange = data[414 ... 415].toUInt16(from: endianness)
        else { throw .malformedBroadcastExtensionChunk }
        self.loudnessRange = loudnessRange
        
        // max true peak level (2 bytes)
        guard let maxTruePeakLevel = data[416 ... 417].toUInt16(from: endianness)
        else { throw .malformedBroadcastExtensionChunk }
        self.maxTruePeakLevel = maxTruePeakLevel
        
        // max momentary loudness (2 bytes)
        guard let maxMomentaryLoudness = data[418 ... 419].toUInt16(from: endianness)
        else { throw .malformedBroadcastExtensionChunk }
        self.maxMomentaryLoudness = maxMomentaryLoudness
        
        // max short term loudness (2 bytes)
        guard let maxShortTermLoudness = data[420 ... 421].toUInt16(from: endianness)
        else { throw .malformedBroadcastExtensionChunk }
        self.maxShortTermLoudness = maxShortTermLoudness
        
        // reserved (180 bytes)
        // (data[422 ... 601] should be all null bytes)
        
        // coding history (0 or more bytes)
        if data.count > 602 {
            codingHistory = data[602...]
                .toString(using: .ascii) ?? ""
        } else {
            codingHistory = ""
        }
    }
    
    /// Returns the data portion of the chunk (omitting leading chunk ID and length).
    ///
    /// - Parameters:
    ///   - endianness: Byte ordering.
    /// - Returns: Chunk data.
    public func data(endianness: NumberEndianness) -> Data {
        let descriptionBytes = bwavDescriptionData
        let originatorBytes = originatorData
        let originatorReferenceBytes = originatorReferenceData
        let originationDateBytes = originationDate.nullPaddedASCIIStringBytes(length: 10)
        let originationTimeBytes = originationTime.nullPaddedASCIIStringBytes(length: 8)
        let timeReferenceBytes = timeReference.toData(endianness).toUInt8Bytes()
        let versionBytes = version.toData(endianness).toUInt8Bytes()
        let umidBytes = umid.padding(toLength: 64, withPad: 0x00)
        let loudnessValueBytes = loudnessValue.toData(endianness).toUInt8Bytes()
        let loudnessRangeBytes = loudnessRange.toData(endianness).toUInt8Bytes()
        let maxTruePeakLevelBytes = maxTruePeakLevel.toData(endianness).toUInt8Bytes()
        let maxMomentaryLoudnessBytes = maxMomentaryLoudness.toData(endianness).toUInt8Bytes()
        let maxShortTermLoudnessBytes = maxShortTermLoudness.toData(endianness).toUInt8Bytes()
        let reservedBytes = Data(repeating: 0x00, count: 180)
        
        var bytes: [UInt8] = []
        bytes += descriptionBytes
        bytes += originatorBytes
        bytes += originatorReferenceBytes
        bytes += originationDateBytes
        bytes += originationTimeBytes
        bytes += timeReferenceBytes
        bytes += versionBytes
        bytes += umidBytes
        bytes += loudnessValueBytes
        bytes += loudnessRangeBytes
        bytes += maxTruePeakLevelBytes
        bytes += maxMomentaryLoudnessBytes
        bytes += maxShortTermLoudnessBytes
        bytes += reservedBytes
        
        // chunk data up to Coding History (variable length of 0 or more bytes) should be 602 bytes
        assert(bytes.count == 602)
        
        bytes += codingHistory.toData(using: .ascii) ?? Data()
        
        return Data(bytes)
    }
}

extension WAVFile.BroadcastExtensionChunk.Metadata {
    public func timecode(at frameRate: TimecodeFrameRate, sampleRate: WAVFile.SampleRate) throws -> Timecode {
        try Timecode(
            .samples(Int(timeReference), sampleRate: Int(sampleRate.rawValue)),
            at: frameRate
        )
    }
}

extension WAVFile.BroadcastExtensionChunk.Metadata: CustomStringConvertible {
    public var description: String {
        var output = ""
        output += "- description: \(bwavDescription.trimmingCharacters(in: .null).quoted)\n"
        output += "- originator: \(originator.trimmingCharacters(in: .null))\n"
        output += "- originatorReference: \(originatorReference.trimmingCharacters(in: .null))\n"
        output += "- originationDate: \(originationDate.trimmingCharacters(in: .null))\n"
        output += "- originationTime: \(originationTime.trimmingCharacters(in: .null))\n"
        
        output += "- timeReference: \(timeReference.hex.stringValue(padTo: 16, prefix: true))\n"
        func tc(at fr: TimecodeFrameRate, sr: WAVFile.SampleRate) {
            guard let tc = try? timecode(at: fr, sampleRate: sr).stringValueVerbose else { return }
            output += "  (\(tc), \(sr))\n"
        }
        tc(at: .fps23_976, sr: .sr44100)
        tc(at: .fps24, sr: .sr44100)
        tc(at: .fps29_97, sr: .sr44100)
        tc(at: .fps29_97d, sr: .sr44100)
        tc(at: .fps30, sr: .sr44100)
        
        tc(at: .fps23_976, sr: .sr48000)
        tc(at: .fps24, sr: .sr48000)
        tc(at: .fps29_97, sr: .sr48000)
        tc(at: .fps29_97d, sr: .sr48000)
        tc(at: .fps30, sr: .sr48000)
        
        output += "- version: \(version)\n"
        output += "- umid (hex bytes): \(umid.hex.stringValue(padTo: 2, prefix: false, separator: "", uppercase: true))\n"
        output += "- loudnessValue: \(loudnessValue)\n"
        output += "- loudnessRange: \(loudnessRange)\n"
        output += "- maxTruePeakLevel: \(maxTruePeakLevel)\n"
        output += "- maxMomentaryLoudness: \(maxMomentaryLoudness)\n"
        output += "- maxShortTermLoudness: \(maxShortTermLoudness)\n"
        output += "- codingHistory: \(codingHistory.isEmpty ? "<empty>" : codingHistory.quoted)"
        
        return output
    }
}

// MARK: - Utilities

extension StringProtocol {
    /// Converts string to ASCII and ensures it is a static width by either padding trailing bytes
    /// with null bytes or truncating the string to its desired `length`.
    ///
    /// If the string cannot be converted to ASCII, this method fails silently and returns an array
    /// of null bytes of the desired `length`.
    func nullPaddedASCIIStringBytes(length: Int) -> [UInt8] {
        padding(toLength: length, withPad: "\n", startingAt: 0)
            .toData(using: .ascii)?
            .toUInt8Bytes() ?? Data(count: length).toUInt8Bytes()
    }
}

extension Data {
    /// Pads data bytes to an exact length by either adding pad bytes or truncating the bytes as necessary.
    func padding(toLength: Int, withPad: UInt8) -> Data {
        if count > toLength {
            prefix(toLength)
        } else if count == toLength {
            self
        } else {
            self + Data(repeating: 0x00, count: toLength - count)
        }
    }
    
    /// Pad to comply with SMPTE UMID format
    func umidPadding() -> Data {
        padding(toLength: 64, withPad: 0x00)
    }
}

extension CharacterSet {
    static let null = CharacterSet(charactersIn: "\0")
}
