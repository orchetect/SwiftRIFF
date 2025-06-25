//
//  WAVFileFMTChunkMetadataTests.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftRIFFWAV
import Testing

@Suite struct WAVFileFMTChunkMetadataTests {
    @Test
    func fmtReadChunkMetadata() async throws {
        let fmtBytes: [UInt8] = [
            // 0x66, 0x6D, 0x74, 0x20, // “fmt "
            // 0x10, 0x00, 0x00, 0x00, // Format chunk length == int 16
            0x01, 0x00, // Format type. PCM == int 1
            0x02, 0x00, // Number of channels == int 2
            0x80, 0xBB, 0x00, 0x00, // Sample Rate == int 48_000
            0x00, 0x65, 0x04, 0x00, // (SampleRate * BitsPerSample * Channels) / 8 == int 288_000
            0x06, 0x00, // (BitsPerSample * Channels) / 8 == int 6
            0x18, 0x00 // Bits per sample == int 24
        ]
        
        // parse data
        let format = try WAVFile.FMTChunk.Metadata(data: Data(fmtBytes), endianness: .littleEndian)
        
        // check parsed data
        #expect(format.encoding == .microsoft_PCM)
        #expect(format.sampleRate == .sr48000)
        #expect(format.bitDepth == .bd24)
        #expect(format.channels == 2)
        #expect(format.extraBytes == nil)
        
        // check raw data creation
        #expect(format.data(endianness: .littleEndian) == Data(fmtBytes))
    }
    
    @Test
    func fmtReadChunkMetadataWithExtraBytes() async throws {
        let fmtBytes: [UInt8] = [
            // 0x66, 0x6D, 0x74, 0x20, // “fmt "
            // 0x10, 0x00, 0x00, 0x00, // Format chunk length == int 40
            0x01, 0x10, // Format type. PCM == int 4097 / hex 0x1001
            0x06, 0x00, // Number of channels == int 6
            0x44, 0xAC, 0x00, 0x00, // Sample Rate == int 44_100
            0x30, 0x13, 0x08, 0x00, // (SampleRate * BitsPerSample * Channels) / 8 == int 529_200
            0x0C, 0x00, // (BitsPerSample * Channels) / 8 == int 12
            0x10, 0x00, // Bits per sample == int 16
            0x02, 0x00, 0x03, 0x04 // extra bytes
        ]
        
        // parse data
        let format = try WAVFile.FMTChunk.Metadata(data: Data(fmtBytes), endianness: .littleEndian)
        
        // check parsed data
        #expect(format.encoding == .olivetti_ADPCM)
        #expect(format.sampleRate == .sr44100)
        #expect(format.bitDepth == .bd16)
        #expect(format.channels == 6)
        #expect(format.extraBytes == Data([0x02, 0x00, 0x03, 0x04]))
        
        // check raw data creation
        #expect(format.data(endianness: .littleEndian) == Data(fmtBytes))
    }
}
