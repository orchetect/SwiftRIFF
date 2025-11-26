//
//  WAVFile SampleRate Tests.swift
//  swift-riff • https://github.com/orchetect/swift-riff
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftRIFFWAV
import Testing

@Suite struct WAVFile_SampleRate_Tests {
    @Test
    func sampleRate_rawValue_0Hz() async throws {
        #expect(WAVFile.SampleRate(rawValue: 0) == nil)
    }
    
    @Test
    func sampleRate_unsafe_0Hz() async throws {
        // only asserts in debug builds. only testable with Xcode 26+ on macOS.
        #if os(macOS) && DEBUG && compiler(>=6.2)
        await #expect(processExitsWith: .failure) {
            _ = WAVFile.SampleRate(unsafe: 0)
        }
        #endif
    }
}
