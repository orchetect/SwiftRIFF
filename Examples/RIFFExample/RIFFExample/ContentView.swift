//
//  ContentView.swift
//  swift-riff • https://github.com/orchetect/swift-riff
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftRIFFCore
import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var file: RIFFFile?
    
    var body: some View {
        VStack {
            if let file {
                FileInfoView(file: file)
            } else {
                BlankView(label: "Drop RIFF file here.", systemImage: "square.and.arrow.down")
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
                  let url = await provider.loadFileURL()
            else { return }
            
            do {
                file = try RIFFFile(url: url)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
