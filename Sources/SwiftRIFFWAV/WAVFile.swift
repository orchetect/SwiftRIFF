//
//  WAVFile.swift
//  swift-riff • https://github.com/orchetect/swift-riff
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftExtensions
import SwiftRIFFCore

// WAVE File Format
//
// Byte
// Offset   Example      Value        Description
// -------  -----------  -----------  -----------
//  0 -  3  “RIFF”       4 Bytes      Marks the file as a riff file. Characters are each 1 byte long.
//  4 -  7  (File size)  32-bit int*  Size in bytes of the overall file, minus 8 bytes.
//                                    Typically, you’d fill this in after creation.
//  8 - 11  “WAVE”       4 Bytes      File type ID. For wave audio it is always “WAVE”.
// < ... >               < ... >      (Be aware other chunks may possibly be inserted here)
// 12 - 15  “fmt "       4 Bytes      Format chunk marker. Includes trailing null
// 16 - 19  16           32-bit int*  Length of format chunk (16 bytes for PCM format data to follow)
// 20 - 21  1            16-bit int*  Encoding (1 is PCM -- but others are possible)
// 22 - 23  2            16-bit int*  Number of channels
// 24 - 27  44100        32-bit int*  Sample Rate (Hz)
// 28 - 31  176400       32-bit int*  Average bytes per second (SampleRate * BitsPerSample * Channels) / 8
// 32 - 33  4            16-bit int*  Block align (BitsPerSample * Channels) / 8
// 34 - 35  16           16-bit int*  Bits per sample
// <extra>                            Note that extra format bytes may be present.
// < ... >               < ... >      (Be aware other chunks may possibly be inserted here)
// 36 - 39  “data”       4 Bytes      Data chunk header. Marks the beginning of the data section.
// 40 - 43  (Data size)  32-bit int*  Size of the data section.
// 44...    (PCM data)                PCM data.
//
// * All integers are stored little-endian.
//

/// Wave audio file RIFF structure.
public struct WAVFile {
    /// The underlying RIFF structure of the WAV file.
    public let riffFile: RIFFFile
    
    /// Known chunk types specific to the WAV file format.
    static let chunkTypes: RIFFFileChunkTypes = [
        .wavFile_fmt: FMTChunk.self,
        .wavFile_data: DataChunk.self,
        .wavFile_bext: BroadcastExtensionChunk.self,
        .wavFile_iXML: iXMLChunk.self
    ]
}

extension WAVFile: Equatable { }

extension WAVFile: Hashable { }

extension WAVFile: Sendable { }

extension WAVFile {
    public init(url: URL) throws {
        riffFile = try RIFFFile(url: url, additionalChunkTypes: Self.chunkTypes)
    }
}
