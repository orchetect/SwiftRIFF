//
//  FormatInfoView.swift
//  swift-riff • https://github.com/orchetect/swift-riff
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftRIFFWAV
import SwiftUI

struct FormatInfoView: View {
    let metadata: WAVFile.FMTChunk.Metadata
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("WAV Format Chunk")
                .font(.title2)
            Divider()
            
            HStack {
                Text("Encoding")
                Spacer()
                Text(metadata.encoding.name)
            }
            
            HStack {
                Text("Sample Rate")
                Spacer()
                Text(metadata.sampleRate.verboseDescription)
            }
            
            HStack {
                Text("Bit Depth")
                Spacer()
                Text(metadata.bitDepth.description)
            }
            
            HStack {
                Text("# of Channels")
                Spacer()
                Text("\(metadata.channels)")
            }
            
            if let extraBytes = metadata.extraBytes {
                HStack {
                    Text("Extra Format Bytes")
                    Spacer()
                    Text("\(extraBytes.count) bytes")
                }
            }
        }
    }
}
