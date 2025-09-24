//
//  Data Utilities Tests.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftRIFFCore
import Testing

@Suite struct Data_Utilities_Tests {
    @Test
    func nullTerminatedASCIIString() throws {
        // #expect(Data().nullTerminatedASCIIString(in: 0 ... 0) == nil) // would crash (as expected)
        #expect(Data([0x00]).nullTerminatedASCIIString(in: 0 ... 0) == "")
        
        #expect(Data([0x00, 0x00]).nullTerminatedASCIIString(in: 0 ... 0) == "")
        #expect(Data([0x00, 0x00]).nullTerminatedASCIIString(in: 0 ... 1) == "")
        #expect(Data([0x00, 0x00, 0x00]).nullTerminatedASCIIString(in: 0 ... 0) == "")
        #expect(Data([0x00, 0x00, 0x00]).nullTerminatedASCIIString(in: 0 ... 1) == "")
        #expect(Data([0x00, 0x00, 0x00]).nullTerminatedASCIIString(in: 0 ... 2) == "")
        
        #expect(Data([0x31]).nullTerminatedASCIIString(in: 0 ... 0) == "1")
        #expect(Data([0x31, 0x00]).nullTerminatedASCIIString(in: 0 ... 0) == "1")
        #expect(Data([0x31, 0x00]).nullTerminatedASCIIString(in: 0 ... 1) == "1")
        #expect(Data([0x31, 0x00, 0x00]).nullTerminatedASCIIString(in: 0 ... 0) == "1")
        #expect(Data([0x31, 0x00, 0x00]).nullTerminatedASCIIString(in: 0 ... 1) == "1")
        #expect(Data([0x31, 0x00, 0x00]).nullTerminatedASCIIString(in: 0 ... 2) == "1")
        
        #expect(Data([0x31, 0x00, 0x32]).nullTerminatedASCIIString(in: 0 ... 0) == "1")
        #expect(Data([0x31, 0x00, 0x32]).nullTerminatedASCIIString(in: 0 ... 1) == "1")
        #expect(Data([0x31, 0x00, 0x32]).nullTerminatedASCIIString(in: 0 ... 2) == "1")
        #expect(Data([0x31, 0x00, 0x32]).nullTerminatedASCIIString(in: 1 ... 1) == "")
        #expect(Data([0x31, 0x00, 0x32]).nullTerminatedASCIIString(in: 1 ... 2) == "")
        #expect(Data([0x31, 0x00, 0x32]).nullTerminatedASCIIString(in: 2 ... 2) == "2")
        
        #expect(Data([0x31, 0x00, 0x32, 0x33]).nullTerminatedASCIIString(in: 2 ... 2) == "2")
        #expect(Data([0x31, 0x00, 0x32, 0x33]).nullTerminatedASCIIString(in: 2 ... 3) == "23")
        #expect(Data([0x31, 0x00, 0x32, 0x33, 0x00]).nullTerminatedASCIIString(in: 2 ... 2) == "2")
        #expect(Data([0x31, 0x00, 0x32, 0x33, 0x00]).nullTerminatedASCIIString(in: 2 ... 3) == "23")
        #expect(Data([0x31, 0x00, 0x32, 0x33, 0x00]).nullTerminatedASCIIString(in: 2 ... 4) == "23")
        #expect(Data([0x31, 0x00, 0x32, 0x33, 0x00]).nullTerminatedASCIIString(in: 3 ... 4) == "3")
        #expect(Data([0x31, 0x00, 0x32, 0x33, 0x00]).nullTerminatedASCIIString(in: 4 ... 4) == "")
        
        #expect(Data([0x00, 0x31, 0x00, 0x32, 0x33]).nullTerminatedASCIIString(in: 3 ... 3) == "2")
        #expect(Data([0x00, 0x31, 0x00, 0x32, 0x33]).nullTerminatedASCIIString(in: 3 ... 4) == "23")
        #expect(Data([0x00, 0x31, 0x00, 0x32, 0x33]).nullTerminatedASCIIString(in: 0 ... 4) == "")
        #expect(Data([0x00, 0x31, 0x00, 0x32, 0x33, 0x00]).nullTerminatedASCIIString(in: 3 ... 3) == "2")
        #expect(Data([0x00, 0x31, 0x00, 0x32, 0x33, 0x00]).nullTerminatedASCIIString(in: 3 ... 4) == "23")
        #expect(Data([0x00, 0x31, 0x00, 0x32, 0x33, 0x00]).nullTerminatedASCIIString(in: 3 ... 5) == "23")
        #expect(Data([0x00, 0x31, 0x00, 0x32, 0x33, 0x00]).nullTerminatedASCIIString(in: 4 ... 5) == "3")
        #expect(Data([0x00, 0x31, 0x00, 0x32, 0x33, 0x00]).nullTerminatedASCIIString(in: 5 ... 5) == "")
        #expect(Data([0x00, 0x31, 0x00, 0x32, 0x33, 0x00]).nullTerminatedASCIIString(in: 0 ... 5) == "")
    }
}
