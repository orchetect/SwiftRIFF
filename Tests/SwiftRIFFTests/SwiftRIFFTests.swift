import Foundation
@testable import SwiftRIFF
import Testing

// (all integers are stored little-endian)
// note that this mocks the structure of a wave file for purposes of unit testing,
// but does not actually contain a valid wave file data chunk.
// it is however correctly formatted as a RIFF file.
private let riffBytes: [UInt8] = [
    // start of file
    0x52, 0x49, 0x46, 0x46, // "RIFF"
    0x28, 0x00, 0x00, 0x00, // Total file length minus 8 bytes == int 40
    0x57, 0x41, 0x56, 0x45, // "WAVE" file type
    0x66, 0x6D, 0x74, 0x20, // “fmt "
    0x10, 0x00, 0x00, 0x00, // Format chunk length == int 16
    0x01, 0x00, // Format type. PCM == int 1
    0x02, 0x00, // Number of channels == int 2
    0x80, 0xBB, 0x00, 0x00, // Sample Rate == int 48_000
    0x00, 0x65, 0x04, 0x00, // (SampleRate * BitsPerSample * Channels) / 8 == int 288_000
    0x06, 0x00, // (BitsPerSample * Channels) / 8 == int 6
    0x18, 0x00, // Bits per sample == int 24
    0x64, 0x61, 0x74, 0x61, // "data" chunk ID
    0x03, 0x00, 0x00, 0x00, // Data chunk length == int 3
    0x01, 0x02, 0x03, 0x00 // 3 bytes of data + 1 byte of null padding
]

private let fmtBytes: [UInt8] = [
    0x66, 0x6D, 0x74, 0x20, // “fmt "
    0x10, 0x00, 0x00, 0x00, // Format chunk length == int 16
    0x01, 0x00, // Format type. PCM == int 1
    0x02, 0x00, // Number of channels == int 2
    0x80, 0xBB, 0x00, 0x00, // Sample Rate == int 48_000
    0x00, 0x65, 0x04, 0x00, // (SampleRate * BitsPerSample * Channels) / 8 == int 288_000
    0x06, 0x00, // (BitsPerSample * Channels) / 8 == int 6
    0x18, 0x00 // Bits per sample == int 24
]

@Test
func parseRIFFDescriptor() async throws {
    // write to file on disk so we can parse it
    let tempFile = URL.temporaryDirectory.appending(component: "\(UUID().uuidString).riff")
    print("Writing to temp file: \(tempFile.path)")
    try Data(riffBytes).write(to: tempFile)
    
    let h = try FileHandle(forReadingFrom: tempFile)
    
    let descriptor = try h.readChunkDescriptor(endianness: .littleEndian)
    
    #expect(descriptor.id == .riff)
    #expect(descriptor.subID == "WAVE")
    #expect(descriptor.length == 40)
    #expect(descriptor.chunkRange == 0 ... 47)
    #expect(descriptor.encodedDataRange == 8 ... 47)
    #expect(descriptor.dataRange == 8 ... 47)
}

@Test
func parseFMTChunkDescriptor() async throws {
    // write to file on disk so we can parse it
    let tempFile = URL.temporaryDirectory.appending(component: "\(UUID().uuidString).riff")
    print("Writing to temp file: \(tempFile.path)")
    try Data(fmtBytes).write(to: tempFile)
    
    let h = try FileHandle(forReadingFrom: tempFile)
    
    let descriptor = try h.readChunkDescriptor(endianness: .littleEndian)
    
    #expect(descriptor.id == .generic(identifier: "fmt "))
    #expect(descriptor.subID == nil)
    #expect(descriptor.length == 16)
    #expect(descriptor.chunkRange == 0 ... 23)
    #expect(descriptor.encodedDataRange == 8 ... 23)
    #expect(descriptor.dataRange == 8 ... 23)
}

@Test
func parseRIFFFile() async throws {
    // write to file on disk so we can parse it
    let tempFile = URL.temporaryDirectory.appending(component: "\(UUID().uuidString).riff")
    print("Writing to temp file: \(tempFile.path)")
    try Data(riffBytes).write(to: tempFile)
    
    let riffFile = try RIFFFile(url: tempFile)
    
    #expect(riffFile.riffFormat == .riff)
    
    #expect(riffFile.chunks.count == 1)
    
    let mainChunk = riffFile.chunks[0]
    guard case let .riff(riffSubID, chunks, riffRange, riffDataRange) = mainChunk
    else { Issue.record(); return }
    
    #expect(riffSubID == "WAVE")
    #expect(riffRange == 0 ... 47)
    #expect(riffDataRange == 12 ... 47)
    #expect(chunks.count == 2)
    
    guard case let .generic(fmtID, fmtRange, fmtDataRange) = chunks[0]
    else { Issue.record(); return }
    #expect(fmtID == "fmt ")
    #expect(fmtRange == 12 ... 35)
    #expect(fmtDataRange == 20 ... 35)
    
    guard case let .generic(dataID, dataRange, dataDataRange) = chunks[1]
    else { Issue.record(); return }
    #expect(dataID == "data")
    #expect(dataRange == 36 ... 46)
    #expect(dataDataRange == 44 ... 46)
    
    // output info block
    print(riffFile.info)
}
