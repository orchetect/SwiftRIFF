//
//  ChunkItem.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftRIFFCore

struct ChunkItem: Equatable, Hashable, Identifiable, Sendable {
    let id = UUID()
    let chunk: AnyRIFFFileChunk
    let subitems: [ChunkItem]?
    
    init(chunk: AnyRIFFFileChunk) {
        self.chunk = chunk
        subitems = chunk.chunks?.map(ChunkItem.init)
    }
}
