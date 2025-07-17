//
//  RIFFTests.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftRIFFCore
import Testing

private enum SampleRIFF {
    // (all integers are stored little-endian)
    // note that this mocks the structure of a wave file for purposes of unit testing,
    // but does not actually contain a valid wave file data chunk.
    // it is however correctly formatted as a RIFF file.
    static var fileBytes: [UInt8] {
        var output: [UInt8] = [
            // start of file
            0x52, 0x49, 0x46, 0x46, // "RIFF"
            0x28, 0x00, 0x00, 0x00, // Total file length minus 8 bytes == int 40
            0x57, 0x41, 0x56, 0x45 // "WAVE" file type
        ]
        output += fmtChunkBytes
        output += dataChunkBytes
        return output
    }
    
    static let fmtChunkBytes: [UInt8] = [
        0x66, 0x6D, 0x74, 0x20, // “fmt "
        0x10, 0x00, 0x00, 0x00, // Format chunk length == int 16
        0x01, 0x00, // Format type. PCM == int 1
        0x02, 0x00, // Number of channels == int 2
        0x80, 0xBB, 0x00, 0x00, // Sample Rate == int 48_000
        0x00, 0x65, 0x04, 0x00, // (SampleRate * BitsPerSample * Channels) / 8 == int 288_000
        0x06, 0x00, // (BitsPerSample * Channels) / 8 == int 6
        0x18, 0x00 // Bits per sample == int 24
    ]
    
    static let dataChunkBytes: [UInt8] = [
        0x64, 0x61, 0x74, 0x61, // "data" chunk ID
        0x03, 0x00, 0x00, 0x00, // Data chunk length == int 3
        0x01, 0x02, 0x03, 0x00 // 3 bytes of data + 1 byte of null padding
    ]
}

@Suite struct RIFFTests {
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func parseRIFFDescriptor() async throws {
        // write to file on disk so we can parse it
        let tempFile = URL.temporaryDirectory.appending(component: "\(UUID().uuidString).riff")
        print("Writing to temp file: \(tempFile.path)")
        try Data(SampleRIFF.fileBytes).write(to: tempFile)
        
        let h = try FileHandle(forReadingFrom: tempFile)
        
        let descriptor = try h.parseRIFFChunkDescriptor(endianness: .littleEndian)
        
        #expect(descriptor.id == .riff)
        #expect(descriptor.subID == "WAVE")
        #expect(descriptor.length == 40)
        #expect(descriptor.chunkRange == 0 ... 47)
        #expect(descriptor.dataRange?.usableRange == 8 ... 47)
        #expect(descriptor.dataRange?.encodedRange == 8 ... 47)
    }
    
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func parseFMTChunkDescriptor() async throws {
        // write to file on disk so we can parse it
        let tempFile = URL.temporaryDirectory.appending(component: "\(UUID().uuidString).riff")
        print("Writing to temp file: \(tempFile.path)")
        try Data(SampleRIFF.fmtChunkBytes).write(to: tempFile)
        
        let h = try FileHandle(forReadingFrom: tempFile)
        
        let descriptor = try h.parseRIFFChunkDescriptor(endianness: .littleEndian)
        
        #expect(descriptor.id == .init(id: "fmt "))
        #expect(descriptor.subID == nil)
        #expect(descriptor.length == 16)
        #expect(descriptor.chunkRange == 0 ... 23)
        #expect(descriptor.dataRange?.usableRange == 8 ... 23)
        #expect(descriptor.dataRange?.encodedRange == 8 ... 23)
    }
    
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func parseRIFFFile() async throws {
        // write to file on disk so we can parse it
        let tempFile = URL.temporaryDirectory.appending(component: "\(UUID().uuidString).riff")
        print("Writing to temp file: \(tempFile.path)")
        try Data(SampleRIFF.fileBytes).write(to: tempFile)
        
        let riffFile = try RIFFFile(url: tempFile)
        
        #expect(riffFile.riffFormat == .riff)
        
        #expect(riffFile.chunks.count == 1)
        
        let mainChunk = riffFile.chunks[0]
        #expect(mainChunk.id == .riff)
        
        #expect(mainChunk.subID == "WAVE")
        #expect(mainChunk.range == 0 ... 47)
        #expect(mainChunk.dataRange == 8 ... 47)
        #expect(mainChunk.chunks?.count == 2)
        
        let fmtChunk = try #require(mainChunk.chunks?[0])
        #expect(fmtChunk.id == .init(id: "fmt "))
        #expect(fmtChunk.range == 12 ... 35)
        #expect(fmtChunk.dataRange == 20 ... 35) // 16 bytes (even)
        
        let dataChunk = try #require(mainChunk.chunks?[1])
        #expect(dataChunk.id == .init(id: "data"))
        #expect(dataChunk.range == 36 ... 47) // includes one trailing null pad byte
        #expect(dataChunk.dataRange == 44 ... 46) // 3 bytes (odd)
        
        // output info block
        print(riffFile.info)
    }
    
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func writeRIFFFileChunk() async throws {
        // write to file on disk so we can parse it
        let tempFile = URL.temporaryDirectory.appending(component: "\(UUID().uuidString).riff")
        print("Writing to temp file: \(tempFile.path)")
        try Data(SampleRIFF.fileBytes).write(to: tempFile)
        
        // read existing chunk
        var riffFile = try RIFFFile(url: tempFile)
        
        var fmtChunk = try #require(riffFile.chunks[0].chunks?.first(id: "fmt ")?.base)
        
        // generate new chunk
        let newFMTData: [UInt8] = [
            0x01, 0x00, // Format type. PCM == int 1
            0x04, 0x00, // Number of channels == int 4
            0x00, 0x77, 0x01, 0x00, // Sample Rate == int 96_000
            0x00, 0x70, 0x17, 0x00, // (SampleRate * BitsPerSample * Channels) / 8 == int 1_536_000
            0x10, 0x00, // (BitsPerSample * Channels) / 8 == int 16
            0x20, 0x00 // Bits per sample == int 32
        ]
        
        try riffFile.write(chunk: fmtChunk, data: Data(newFMTData))
        
        // reload file
        riffFile = try RIFFFile(url: tempFile)
        
        fmtChunk = try #require(riffFile.chunks[0].chunks?.first(id: "fmt ")?.base)
        
        #expect(fmtChunk.id == .init(id: "fmt "))
        #expect(fmtChunk.getSubID == nil)
        let fmtDataRangeExcludingSubID = try #require(fmtChunk.dataRangeExcludingSubID)
        
        let h = try FileHandle(forReadingFrom: tempFile)
        try h.seek(toOffset: fmtDataRangeExcludingSubID.lowerBound)
        let fmtData = try h.read(upToCount: fmtDataRangeExcludingSubID.count)
        #expect(fmtData == Data(newFMTData))
    }
}
