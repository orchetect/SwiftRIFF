//
//  ChunkSizeTests.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftRIFFCore
import Testing

private enum SampleRIFF {
    // (all integers are stored little-endian)
    static var fileBytes: [UInt8] {
        var output: [UInt8] = [
            // start of file
            0x52, 0x49, 0x46, 0x46, // "RIFF"
            0x38, 0x00, 0x00, 0x00, // Total file length minus 8 bytes == int 56
            0x44, 0x4D, 0x4D, 0x59 // "DMMY" file type
        ]
        output += chk0ChunkBytes
        output += chk1ChunkBytes
        output += chk2ChunkBytes
        output += chk3ChunkBytes
        output += chk4ChunkBytes
        return output
    }
    
    static let chk0ChunkBytes: [UInt8] = [
        0x63, 0x68, 0x6B, 0x30, // “chk0"
        0x00, 0x00, 0x00, 0x00 // Chunk length == int 0
        // no data bytes
    ]
    
    static let chk1ChunkBytes: [UInt8] = [
        0x63, 0x68, 0x6B, 0x31, // “chk1"
        0x01, 0x00, 0x00, 0x00, // Chunk length == int 1
        0x7F, // one data byte
        0x00 // one null data pad byte
    ]
    
    static let chk2ChunkBytes: [UInt8] = [
        0x63, 0x68, 0x6B, 0x32, // “chk2"
        0x02, 0x00, 0x00, 0x00, // Chunk length == int 2
        0x40, 0x41 // two data bytes
    ]
    
    static let chk3ChunkBytes: [UInt8] = [
        0x63, 0x68, 0x6B, 0x33, // “chk3"
        0x03, 0x00, 0x00, 0x00, // Chunk length == int 3
        0x40, 0x41, 0x42, // three data bytes
        0x00 // one null data pad byte
    ]
    
    static let chk4ChunkBytes: [UInt8] = [
        0x63, 0x68, 0x6B, 0x34, // “chk4"
        0x04, 0x00, 0x00, 0x00, // Chunk length == int 4
        0x40, 0x41, 0x42, 0x43 // four data bytes
    ]
}

@Suite struct ChunkSizeTests {
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
        #expect(descriptor.subID == "DMMY")
        #expect(descriptor.length == 56)
        #expect(descriptor.chunkRange == 0 ... 63)
        #expect(descriptor.dataRange?.usableRange == 8 ... 63)
        #expect(descriptor.dataRange?.encodedRange == 8 ... 63)
    }
    
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func parseRIFF() async throws {
        // write to file on disk so we can parse it
        let tempFile = URL.temporaryDirectory.appending(component: "\(UUID().uuidString).riff")
        print("Writing to temp file: \(tempFile.path)")
        try Data(SampleRIFF.fileBytes).write(to: tempFile)
        
        let riffFile = try RIFFFile(url: tempFile)
        
        #expect(riffFile.riffFormat == .riff)
        #expect(riffFile.chunks.count == 1)
        
        let mainChunk = riffFile.chunks[0]
        #expect(mainChunk.id == .riff)
        
        #expect(mainChunk.chunks?.count == 5)
    }
}
