//
//  CompressCodec.swift
//  CompressCodec
//
//  Created by Bernardo Breder on 06/01/17.
//
//

import XCTest
import Foundation
@testable import CompressDataCodec

class CompressDataCodecTests: XCTestCase {

	func test() throws {
        let compress = CompressEncoder()
        let array = ["abc", "abc", "Teste de Texto",
                     "abc", "abc", "Teste de Texto",
                     "abc", "abc", "abc", "abc",
                     "abc", "abc", "abc", "abc",
                     ]
        var msg = ""
        for item in array {
            compress.write(item)
            msg += item
        }
        let compressedData = compress.data()!
        let plainData = msg.data(using: .utf8)!
        XCTAssertEqual(plainData, CompressDataDecoder(compressedData: compressedData)!.data)
    }

}

