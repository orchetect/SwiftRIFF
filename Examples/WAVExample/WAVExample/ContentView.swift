//
//  ContentView.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftRIFFWAV
import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var file: WAVFile?
    
    var body: some View {
        VStack {
            if let file {
                FileInfoView(file: file)
            } else {
                BlankView(label: "Drop WAV file here.", systemImage: "square.and.arrow.down")
            }
        }
        .onDrop(of: [UTType.fileURL], isTargeted: .constant(false)) { providers in
            handleDrop(providers: providers)
            return true
        }
        .padding()
    }
    
    private func handleDrop(providers: [NSItemProvider]) {
        Task {
            guard let provider = providers.first,
                  let url = await provider.loadWAVFileURL()
            else { return }
            
            do {
                file = try WAVFile(url: url)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
