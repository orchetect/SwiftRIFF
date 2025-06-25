//
//  RIFFFileChunkID fmt.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-16.
//

import OTCore
import SwiftRIFFCore

extension RIFFFileChunkID {
    /// WAV file fmt chunk ID ("fmt ").
    public static var wavFile_fmt: Self { Self(id: "fmt ") }
}
