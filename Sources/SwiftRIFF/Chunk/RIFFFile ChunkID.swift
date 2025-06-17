//
//  RIFFFile ChunkID.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-16.
//

extension RIFFFile {
    public enum ChunkID {
        /// RIFF chunk.
        case riff
        
        /// LIST chunk.
        case list
        
        /// The optional INFO chunk.
        ///
        /// > Wikipedia:
        /// >
        /// > The INFO chunk allows RIFF files to be "tagged" with information falling into
        /// > a number of predefined categories, such as copyright ("ICOP"), comments ("ICMT"),
        /// > artist ("IART"), in a standardized way. These details can be read from a RIFF file even
        /// > if the rest of the file format is unrecognized.
        /// >
        /// > The standard also allows the use of user-defined fields. Programmers intending to use
        /// > non-standard fields should bear in mind that the same non-standard subchunk ID may be
        /// > used by different applications in different (and potentially incompatible) ways.
        /// >
        /// > For cataloguing purposes, the optimal position for the INFO chunk is near the beginning
        /// > of the file. However, since the INFO chunk is optional, it is often omitted from the
        /// > detailed specifications of individual file formats, leading to some confusion over the
        /// > correct position for this chunk within a file.
        /// >
        /// > [See Article](https://en.wikipedia.org/wiki/Resource_Interchange_File_Format#Use_of_the_INFO_chunk)
        case info
        
        /// A generic chunk.
        case generic(identifier: String)
    }
}

extension RIFFFile.ChunkID: Equatable { }

extension RIFFFile.ChunkID: Hashable { }

extension RIFFFile.ChunkID: Sendable { }

extension RIFFFile.ChunkID: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}

extension RIFFFile.ChunkID: RawRepresentable {
    public init?(rawValue: String) {
        guard rawValue.isValidRIFFChunkID else { return nil }
        
        switch rawValue {
        case "RIFF": self = .riff
        case "LIST": self = .list
        case "INFO": self = .info
        default: self = .generic(identifier: rawValue)
        }
    }
    
    public var rawValue: String {
        switch self {
        case .riff: "RIFF"
        case .list: "LIST"
        case .info: "INFO"
        case let .generic(identifier): identifier
        }
    }
}

extension StringProtocol {
    /// Returns true if the string is formatted as a valid RIFF chunk identifier.
    public var isValidRIFFChunkID: Bool {
        guard count == 4 else { return false }
        guard isASCII else { return false }
        guard !contains("\0") else { return false }
        return true
    }
}
