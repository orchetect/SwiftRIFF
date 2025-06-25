//
//  BextInfoView.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftRIFFWAV
import SwiftUI
import SwiftRadix
import TimecodeKitCore

struct BextInfoView: View {
    let sampleRate: WAVFile.SampleRate
    let metadata: WAVFile.BroadcastExtensionChunk.Metadata
    
    @State private var timecodeFrameRate: TimecodeFrameRate = .fps30
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Broadcast Wave Extension Chunk")
                .font(.title2)
            Divider()
            
            HStack {
                Text("Description")
                Spacer()
                Text("\"\(metadata.bwavDescription)\"")
            }
            
            HStack {
                Text("Originator")
                Spacer()
                Text("\"\(metadata.originator)\"")
            }
            
            HStack {
                Text("Originator Reference")
                Spacer()
                Text("\"\(metadata.originatorReference)\"")
            }
            
            HStack {
                Text("Origination Date")
                Spacer()
                Text("\"\(metadata.originationDate)\"")
            }
            
            HStack {
                Text("Origination Time")
                Spacer()
                Text("\"\(metadata.originationTime)\"")
            }
            
            HStack {
                Text("Time Reference (Timecode Stamp)")
                
                Picker("", selection: $timecodeFrameRate) {
                    ForEach(TimecodeFrameRate.allCases) { frameRate in
                        Text(frameRate.stringValueVerbose)
                    }
                }
                .labelsHidden()
                .frame(width: 150)
                
                Spacer()
                Text(timecode)
            }
            
            HStack {
                Text("BWAV Specification Version")
                Spacer()
                Text("\(metadata.version)")
            }
            
            HStack {
                Text("UMID (SMPTE Unique Material Identifier) Bytes")
                Spacer()
                Text(metadata.umid.hex.stringValue(padTo: 2, prefix: false, separator: " ", uppercase: true))
                    .font(.system(size: 12, design: .monospaced))
                    .frame(maxWidth: 250)
            }
            
            HStack {
                Text("Loudness Value")
                Spacer()
                Text("\(metadata.loudnessValue)")
            }
            
            HStack {
                Text("Loudness Range")
                Spacer()
                Text("\(metadata.loudnessRange)")
            }
            
            HStack {
                Text("Max True Peak Level")
                Spacer()
                Text("\(metadata.maxTruePeakLevel)")
            }
            
            HStack {
                Text("Max Momentary yLoudness")
                Spacer()
                Text("\(metadata.maxMomentaryLoudness)")
            }
            
            HStack {
                Text("Max Short-Term Loudness")
                Spacer()
                Text("\(metadata.maxShortTermLoudness)")
            }
            
            HStack {
                Text("Coding History")
                Spacer()
                Text("\"\(metadata.codingHistory)\"")
            }
        }
    }
}

extension BextInfoView {
    private var timecode: String {
        do {
            let timecode = try Timecode(
                .samples(Int(metadata.timeReference), sampleRate: Int(sampleRate.rawValue)),
                at: timecodeFrameRate
            )
            
            return timecode.stringValue(format: [.showSubFrames])
        } catch {
            return "Error: \(error.localizedDescription)"
        }
    }
}
