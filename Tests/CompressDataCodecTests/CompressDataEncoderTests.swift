//
//  CompressDataEncoderTests.swift
//  CompressDataCodec
//
//  Created by Bernardo Breder on 08/01/17.
//
//

import XCTest
import Foundation
@testable import CompressDataCodec

class CompressDataEncoderTests: XCTestCase {
    
    func test() throws {
        let compress = CompressEncoder()
        let array = ["abc", "abc", "Teste de Texto",
                     "abc", "abc", "Teste de Texto",
                     "abc", "abc", "abc", "abc",
                     "abc", "abc", "abc", "abc",
                     ]
        for item in array {
            compress.write(item)
        }
        let compressedData = compress.data()!
        var msg = ""
        for item in array {
            msg += item
        }
        let plainData = msg.data(using: .utf8)!
        XCTAssertTrue(compressedData.count < plainData.count)
    }
    
}
