//
//  WAVFile SampleRate.swift
//  SwiftRIFF
//
//  Created by Steffan Andrews on 2025-06-16.
//

import Foundation

extension WAVFile {
    public struct SampleRate {
        public let rawValue: UInt32
        
        init(unsafe rate: UInt32) {
            assert(rate > 0)
            rawValue = rate
        }
    }
}

extension WAVFile.SampleRate: Equatable { }

extension WAVFile.SampleRate: Hashable { }

extension WAVFile.SampleRate: CaseIterable {
    public static let allCases: [WAVFile.SampleRate] = [
        .sr8000,
        .sr11025,
        .sr16000,
        .sr22050,
        .sr32000,
        .sr44100,
        .sr48000,
        .sr88200,
        .sr96000,
        .sr176400,
        .sr192000
    ]
    
    /// Returns `true` if the rate is a standard (common) rate, such as 44100Hz or 48000Hz.
    public var isStandard: Bool {
        Self.allCases.contains(self)
    }
}

extension WAVFile.SampleRate: Sendable { }

extension WAVFile.SampleRate {
    /// 8000Hz
    public static let sr8000 = Self(unsafe: 8000)
    
    /// 11025Hz
    public static let sr11025 = Self(unsafe: 11025)
    
    /// 16000Hz
    public static let sr16000 = Self(unsafe: 16000)
    
    /// 22050Hz
    public static let sr22050 = Self(unsafe: 22050)
    
    /// 32000Hz
    public static let sr32000 = Self(unsafe: 32000)
    
    /// 44100Hz
    public static let sr44100 = Self(unsafe: 44100)
    
    /// 48000Hz
    public static let sr48000 = Self(unsafe: 48000)
    
    /// 88200Hz
    public static let sr88200 = Self(unsafe: 88200)
    
    /// 96000Hz
    public static let sr96000 = Self(unsafe: 96000)
    
    /// 176400Hz
    public static let sr176400 = Self(unsafe: 176400)
    
    /// 192000Hz
    public static let sr192000 = Self(unsafe: 192000)
}

extension WAVFile.SampleRate: RawRepresentable {
    public init?(rawValue: UInt32) {
        guard rawValue > 0 else { return nil }
        self.rawValue = rawValue
    }
}

extension WAVFile.SampleRate: CustomStringConvertible {
    public var description: String {
        khzString()
    }
    
    public var verboseDescription: String {
        description + (!isStandard ? " (Non-Standard)" : "")
    }
    
    public var hzString: String {
        "\(rawValue)Hz"
    }
    
    public func khzString(padded: Bool = false) -> String {
        let value = if padded {
            "\(rawValue / 1000).\(("000" + String(rawValue % 1000)).suffix(3))"
        } else {
            (Decimal(rawValue) / 1000).string
        }
        return "\(value)KHz"
    }
}
