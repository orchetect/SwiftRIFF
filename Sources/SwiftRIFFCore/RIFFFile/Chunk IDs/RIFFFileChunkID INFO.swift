//
//  RIFFFileChunkID INFO.swift
//  swift-riff • https://github.com/orchetect/swift-riff
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

extension RIFFFileChunkID {
    /// Optional INFO chunk.
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
    public static var info: Self { Self(id: "INFO") }
}
