//
//  RIFFFileChunkID iXML.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-16.
//

import OTCore
import SwiftRIFFCore

extension RIFFFileChunkID {
    /// Broadcast Wave iXML ID ("iXML").
    ///
    /// - See: https://en.wikipedia.org/wiki/IXML
    /// - See: https://en.wikipedia.org/wiki/Broadcast_Wave_Format
    public static var wavFile_iXML: Self { Self(id: "iXML") }
}
