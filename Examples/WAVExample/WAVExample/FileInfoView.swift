//
//  FileInfoView.swift
//  swift-riff • https://github.com/orchetect/swift-riff
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftRadix
import SwiftRIFFWAV
import SwiftUI

struct FileInfoView: View {
    let file: WAVFile
    @State private var formatMetadata: WAVFile.FMTChunk.Metadata?
    @State private var bwavExtensionMetadata: WAVFile.BroadcastExtensionChunk.Metadata?
    
    var body: some View {
        VStack(spacing: 20) {
            Text(file.riffFile.url?.path ?? "-")
                .truncationMode(.middle)
            
            ScrollView {
                VStack(spacing: 20) {
                    if let formatMetadata {
                        FormatInfoView(metadata: formatMetadata)
                    }
                    
                    if let bwavExtensionMetadata, let sampleRate = formatMetadata?.sampleRate {
                        BextInfoView(sampleRate: sampleRate, metadata: bwavExtensionMetadata)
                    }
                }
            }
        }
        .onAppear {
            loadMetadata(from: file)
        }
        .onChange(of: file) { newValue in
            loadMetadata(from: newValue)
        }
    }
}

extension FileInfoView {
    private func loadMetadata(from file: WAVFile) {
        formatMetadata = try? file.format()?.metadata
        bwavExtensionMetadata = try? file.bext()?.metadata
    }
}
