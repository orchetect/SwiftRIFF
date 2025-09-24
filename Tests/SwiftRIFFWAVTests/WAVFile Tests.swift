//
//  WAVFile Tests.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftRIFFCore
@testable import SwiftRIFFWAV
import Testing

@Suite struct WAVFile_Tests {
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func wavFile() async throws {
        // write to file on disk so we can parse it
        let tempFile = URL.temporaryDirectory.appending(component: "\(UUID().uuidString).wav")
        print("Writing to temp file: \(tempFile.path)")
        try Data(SampleWAV.fileBytes).write(to: tempFile)
        
        let wavFile = try WAVFile(url: tempFile)
        
        // format chunk
        
        let formatChunk = try #require(try wavFile.format())
        let format = formatChunk.metadata
        
        #expect(format.encoding == .microsoft_PCM)
        #expect(format.sampleRate == .sr48000)
        #expect(format.bitDepth == .bd24)
        #expect(format.channels == 2)
        
        // data chunk
        
        let dataChunk = try #require(try wavFile.data())
        let dataRange = try #require(dataChunk.dataRange)
        #expect(dataRange == 44 ... 46)
        
        let h = try FileHandle(forReadingFrom: tempFile)
        try h.seek(toOffset: dataRange.lowerBound)
        let data = try h.read(upToCount: dataRange.count)
        #expect(data == Data([0x01, 0x02, 0x03]))
    }
    
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func fmtChunkWrite_SameChunkSizes() async throws {
        // write to file on disk so we can parse it
        let tempFile = URL.temporaryDirectory.appending(component: "\(UUID().uuidString).wav")
        print("Writing to temp file: \(tempFile.path)")
        try Data(SampleWAV.fileBytes).write(to: tempFile)
        
        let wavFile = try WAVFile(url: tempFile)
        
        // create new fmt data
        let newFMT = WAVFile.FMTChunk.Metadata(
            encoding: .olivetti_ADPCM,
            sampleRate: .sr32000,
            bitDepth: .bd16,
            channels: 6
        )
        
        try wavFile.write(format: newFMT)
        
        // reload file and re-parse it
        let wavFile2 = try WAVFile(url: tempFile)
        
        // check format data
        let fmtChunk = try #require(try wavFile2.format())
        let format = fmtChunk.metadata
        #expect(format.encoding == .olivetti_ADPCM)
        #expect(format.sampleRate == .sr32000)
        #expect(format.bitDepth == .bd16)
        #expect(format.channels == 6)
    }
    
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func fmtChunkWrite_NewChunkSmallerSize() async throws {
        // write to file on disk so we can parse it
        let tempFile = URL.temporaryDirectory.appending(component: "\(UUID().uuidString).wav")
        print("Writing to temp file: \(tempFile.path)")
        try Data(SampleWAV2.fileBytes).write(to: tempFile)
        
        let wavFile = try WAVFile(url: tempFile)
        
        // create new fmt data
        var newFMT = WAVFile.FMTChunk.Metadata(
            encoding: .olivetti_ADPCM,
            sampleRate: .sr32000,
            bitDepth: .bd16,
            channels: 6
        )
        
        #expect(throws: RIFFFileWriteError.self /* .newChunkDoesNotMatchExistingChunkSize */ ) {
            try wavFile.write(format: newFMT)
        }
        
        // add extra bytes to match existing data length
        newFMT.extraBytes = Data([0x02, 0x00, 0x05, 0x06])
        
        try wavFile.write(format: newFMT)
        
        // reload file and re-parse it
        let wavFile2 = try WAVFile(url: tempFile)
        
        // check format data
        let fmtChunk = try #require(try wavFile2.format())
        let format = fmtChunk.metadata
        #expect(format.encoding == .olivetti_ADPCM)
        #expect(format.sampleRate == .sr32000)
        #expect(format.bitDepth == .bd16)
        #expect(format.channels == 6)
        #expect(format.extraBytes == Data([0x02, 0x00, 0x05, 0x06]))
    }
    
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func bextChunkRead() async throws {
        // write to file on disk so we can parse it
        let tempFile = URL.temporaryDirectory.appending(component: "\(UUID().uuidString).wav")
        print("Writing to temp file: \(tempFile.path)")
        try Data(SampleBWAV.fileBytes).write(to: tempFile)
        
        let wavFile = try WAVFile(url: tempFile)
        
        // check bext data
        let bextChunk = try #require(try wavFile.bext())
        let bext = bextChunk.metadata
        #expect(bext.bwavDescription == "")
        #expect(bext.originator == "Pro Tools")
        #expect(bext.originatorReference == "aaiRTZy9QKVk")
        #expect(bext.originationDate == "2025-06-18")
        #expect(bext.originationTime == "16:21:34")
        #expect(bext.timeReference == 0x0000_0000_0A4C_B800)
        #expect(bext.version == 1)
        let umidBytes: [UInt8] = [
            0x06, 0x0A, 0x2B, 0x34, 0x01, 0x01, 0x01, 0x05,
            0x01, 0x01, 0x0F, 0x10, 0x13, 0x00, 0x00, 0x00,
            0xF9, 0x2A, 0xF5, 0x8C, 0xED, 0xAC, 0x80, 0x00,
            0x44, 0x50, 0x66, 0x8A, 0xF3, 0xD6, 0xF6, 0x94,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        ]
        #expect(bext.umid == Data(umidBytes))
        #expect(bext.loudnessValue == 0)
        #expect(bext.loudnessRange == 0)
        #expect(bext.maxTruePeakLevel == 0)
        #expect(bext.maxMomentaryLoudness == 0)
        #expect(bext.maxShortTermLoudness == 0)
        #expect(bext.codingHistory == "")
    }
    
    /// Logic Pro writes non-ASCII data to the Description field, and possibly other string fields.
    /// We want to ensure this does not cause unnecessary parsing failures.
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func bextChunkReadLogic() async throws {
        // write to file on disk so we can parse it
        let tempFile = URL.temporaryDirectory.appending(component: "\(UUID().uuidString).wav")
        print("Writing to temp file: \(tempFile.path)")
        try Data(SampleLogicBWAV.bextChunkBytes).write(to: tempFile)
        
        let h = try FileHandle(forReadingFrom: tempFile)
        
        let bextChunk = try WAVFile.BroadcastExtensionChunk(
            handle: h,
            endianness: RIFFFile.Format.riff.endianness,
            additionalChunkTypes: [:]
        )
        
        // check bext data
        let bext = bextChunk.metadata
        
        #expect(bext.bwavDescription == "")
        let bwavDescriptionBytes: [UInt8] = [
            0x00, 0x00, 0x00, 0x00, 0xA9, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x35, 0x60, 0xE0, 0x89,
            0x00, 0x00, 0x00, 0x00, 0xA9, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0xEE, 0x0D, 0x78, 0x68,
            0x00, 0x00, 0x00, 0x00, 0x93, 0x89, 0x37, 0x29,
            0x00, 0x00, 0x00, 0x00, 0xEE, 0x0D, 0x78, 0x68,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x3C, 0x34, 0x23, 0x00,
            0x00, 0x00, 0x00, 0x00, 0xA0, 0x11, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x9C, 0x00, 0x82, 0x45,
            0xA1, 0x79, 0x6D, 0x5B, 0xC0, 0x18, 0xB6, 0xBE,
            0xF7, 0x7F, 0x00, 0x00, 0x10, 0x12, 0xB6, 0xBE,
            0xF7, 0x7F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x12, 0xB6, 0xBE,
            0xF7, 0x7F, 0x00, 0x00, 0xBE, 0x76, 0x00, 0x05,
            0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        ]
        #expect(bext.bwavDescriptionData == Data(bwavDescriptionBytes))
        
        #expect(bext.originator == "Logic Pro")
        let originatorBytes: [UInt8] = [
            0x4C, 0x6F, 0x67, 0x69, 0x63, 0x20, 0x50, 0x72,
            0x6F, 0x00, 0x00, 0x00, 0xC0, 0x11, 0xB6, 0xBE,
            0xF7, 0x7F, 0x00, 0x00, 0x60, 0xF7, 0x2C, 0x0F,
            0xF8, 0x7F, 0x00, 0x00, 0xB4, 0xF8, 0x2C, 0x0F
        ]
        #expect(bext.originatorData == Data(originatorBytes))
        
        #expect(bext.originatorReference == "")
        let originatorReferenceBytes: [UInt8] = [
            0x00, 0x7F, 0x00, 0x00, 0x10, 0x12, 0xB6, 0xBE,
            0xF7, 0x7F, 0x00, 0x00, 0xC0, 0x18, 0xB6, 0xBE,
            0xF7, 0x7F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        ]
        
        #expect(bext.originatorReferenceData == Data(originatorReferenceBytes))
        
        #expect(bext.originationDate == "2025-07-16")
        
        #expect(bext.originationTime == "16:39:10")
        
        #expect(bext.timeReference == 0x0000_0000_0A4C_B800)
        
        #expect(bext.version == 1)
        
        let umidBytes: [UInt8] = [
            0x00, 0x12, 0xB6, 0xBE, 0xF7, 0x7F, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x12, 0xB6, 0xBE, 0xF7, 0x7F, 0x00, 0x00,
            0x6B, 0x3D, 0xFD, 0x04, 0x01, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x13, 0xB6, 0xBE, 0xF7, 0x7F, 0x00, 0x00,
            0x3B, 0x73, 0x00, 0x05, 0x01, 0x00, 0x00, 0x00
        ]
        #expect(bext.umid == Data(umidBytes))
        
        #expect(bext.loudnessValue == 0)
        
        #expect(bext.loudnessRange == 0)
        
        #expect(bext.maxTruePeakLevel == 0)
        
        #expect(bext.maxMomentaryLoudness == 0)
        
        #expect(bext.maxShortTermLoudness == 0)
        
        #expect(bext.codingHistory == "\0")
    }
    
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func bextChunkWrite() async throws {
        // write to file on disk so we can parse it
        let tempFile = URL.temporaryDirectory.appending(component: "\(UUID().uuidString).wav")
        print("Writing to temp file: \(tempFile.path)")
        try Data(SampleBWAV.fileBytes).write(to: tempFile)
        
        let wavFile = try WAVFile(url: tempFile)
        
        // create new bext data
        let newBext = WAVFile.BroadcastExtensionChunk.Metadata(
            description: "1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999991111111111" // 100 chars
                + "AAAAAAAAAABBBBBBBBBBCCCCCCCCCCDDDDDDDDDDEEEEEEEEEEFFFFFFFFFFGGGGGGGGGGHHHHHHHHHHIIIIIIIIIIJJJJJJJJJJ" // 100 chars
                + "ZZZZZZZZZZYYYYYYYYYYXXXXXXXXXXWWWWWWWWWWVVVVVVVVVVUUUUUU", // 56
            originator: "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456", // 32 chars
            originatorReference: "ZYXWVUTSRQPONMLKJIHGFEDCBA987654", // 32 chars
            originationDate: "2035-02-14",
            originationTime: "17:48:02",
            timeReference: 0x0000_0000_0B00_E500,
            version: 2,
            umid: Data(repeating: 0x00, count: 64), // TODO: replace with valid SMPTE UMID bytes
            loudnessValue: 0x1234,
            loudnessRange: 0x2345,
            maxTruePeakLevel: 0x3456,
            maxMomentaryLoudness: 0x4567,
            maxShortTermLoudness: 0x5678,
            codingHistory: "" // can't add string here since existing bext does not have coding history content
        )
        
        try wavFile.write(bext: newBext)
        
        // reload file and re-parse it
        let wavFile2 = try WAVFile(url: tempFile)
        
        // check format data
        let fmtChunk = try #require(try wavFile2.format())
        let format = fmtChunk.metadata
        #expect(format.encoding == .microsoft_PCM)
        #expect(format.sampleRate == .sr48000)
        #expect(format.bitDepth == .bd24)
        #expect(format.channels == 2)
        #expect(format.extraBytes == Data([
            0x16, 0x00, 0x03, 0x04,
            0x05, 0x06, 0x07, 0x08,
            0x09, 0x10, 0x1A, 0x1B,
            0x1C, 0x1D, 0x1E, 0x1F,
            0x20, 0x21, 0x22, 0x23,
            0x24, 0x25, 0x26, 0x27
        ]))
        
        // check bext data
        let bextChunk = try #require(try wavFile2.bext())
        let bext = bextChunk.metadata
        #expect(bext.bwavDescription == newBext.bwavDescription)
        #expect(bext.originator == newBext.originator)
        #expect(bext.originatorReference == newBext.originatorReference)
        #expect(bext.originationDate == newBext.originationDate)
        #expect(bext.originationTime == newBext.originationTime)
        #expect(bext.timeReference == newBext.timeReference)
        #expect(bext.version == newBext.version)
        #expect(bext.umid == newBext.umid)
        #expect(bext.loudnessValue == newBext.loudnessValue)
        #expect(bext.loudnessRange == newBext.loudnessRange)
        #expect(bext.maxTruePeakLevel == newBext.maxTruePeakLevel)
        #expect(bext.maxMomentaryLoudness == newBext.maxMomentaryLoudness)
        #expect(bext.maxShortTermLoudness == newBext.maxShortTermLoudness)
        #expect(bext.codingHistory == newBext.codingHistory)
    }
}
