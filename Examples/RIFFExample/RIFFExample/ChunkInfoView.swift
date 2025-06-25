//
//  ChunkInfoView.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftRadix
import SwiftRIFFCore
import SwiftUI

struct ChunkInfoView: View {
    let url: URL?
    let chunk: AnyRIFFFileChunk
    @State private var dataBytesReadCount: Int = 0
    @State private var dataBytesString: String?
    
    let maxDataBytesReadCount = 256
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Chunk ID")
                    Spacer()
                    Text("\"\(chunk.id.id)\"")
                }
                
                HStack {
                    Text("Chunk Size")
                    Spacer()
                    Text("\(chunk.range.count) bytes")
                }
                
                if let subID = chunk.subID {
                    HStack {
                        Text("Chunk Sub-ID (First 4 ASCII bytes of Data Portion)")
                        Spacer()
                        Text("\"\(subID)\"")
                    }
                }
                
                HStack {
                    Text("Chunk Byte Offset Range")
                    Spacer()
                    Text(
                        chunk.range.lowerBound.hex.stringValue(padTo: 4)
                            + " ... "
                            + chunk.range.upperBound.hex.stringValue(padTo: 4)
                    )
                }
                
                if let dataRange = chunk.dataRange {
                    HStack {
                        Text("Chunk Data Size")
                        Spacer()
                        Text("\(dataRange.count) bytes")
                    }
                    
                    HStack {
                        Text("Chunk Data Byte Offset Range")
                        Spacer()
                        Text(
                            dataRange.lowerBound.hex.stringValue(padTo: 4)
                                + " ... "
                                + dataRange.upperBound.hex.stringValue(padTo: 4)
                        )
                    }
                }
                
                if let subitems = chunk.chunks {
                    HStack {
                        Text("Subchunks")
                        Spacer()
                        Text("Contains \(subitems.count) chunks")
                    }
                } else if let dataBytesString {
                    if dataBytesReadCount >= maxDataBytesReadCount {
                        Text("First \(dataBytesReadCount) data portion bytes:")
                    } else {
                        Text("Data portion bytes:")
                    }
                    Text(dataBytesString)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 12, design: .monospaced))
                }
            }
        }
        .onAppear {
            Task { await loadDataBytes(from: chunk) }
        }
        .onChange(of: chunk) { newValue in
            Task { await loadDataBytes(from: newValue) }
        }
    }
}

extension ChunkInfoView {
    private func loadDataBytes(from chunk: AnyRIFFFileChunk) async {
        do {
            // reset variables
            dataBytesString = ""
            dataBytesReadCount = 0
            
            // don't load data for subchunks -- use the list to select them to load their own data instead
            guard chunk.chunks == nil else { return }
            
            guard let url,
                  let dataRange = chunk.dataRange
            else { return }
            
            let h = try FileHandle(forReadingFrom: url)
            try h.seek(toOffset: dataRange.lowerBound)
            
            let readLength = min(dataRange.count, maxDataBytesReadCount)
            let data = try h.read(upToCount: readLength)
            
            dataBytesString = data?
                .hex.stringValue(padToEvery: 2, prefix: false, separator: " ", uppercase: true)
            dataBytesReadCount = readLength
        } catch {
            print(error.localizedDescription)
        }
    }
}
