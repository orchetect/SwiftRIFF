//
//  RIFFFileChunkID data.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-16.
//

import OTCore
import SwiftRIFFCore

extension RIFFFileChunkID {
    /// WAV file data chunk ID ("data").
    public static var wavFile_data: Self { Self(id: "data") }
}
