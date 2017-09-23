//
//  HuffmanTests.swift
//  CompressCodec
//
//  Created by Bernardo Breder on 06/01/17.
//
//

import XCTest
@testable import CompressDataCodec
@testable import DataCodec

class HuffmanTests: XCTestCase {

    func testExample() {
        let frequency = [String: Int](dictionaryLiteral: ("A", 6), ("B", 5), ("C", 4), ("D", 3), ("E", 2), ("F", 1))
        let huffman = Huffman(frequency: frequency)
        XCTAssertEqual("00", huffman.entrys["A"]?.description)
        XCTAssertEqual("10", huffman.entrys["B"]?.description)
        XCTAssertEqual("11", huffman.entrys["C"]?.description)
        XCTAssertEqual("010", huffman.entrys["D"]?.description)
        XCTAssertEqual("0110", huffman.entrys["E"]?.description)
        XCTAssertEqual("0111", huffman.entrys["F"]?.description)
    }
    
    func testCodec() {
        let frequency = [String: Int](dictionaryLiteral: ("A", 6), ("B", 5), ("C", 4), ("D", 3), ("E", 2), ("F", 1))
        let huffman = Huffman(frequency: frequency)
        let bytes = huffman.root.encoded()!
        XCTAssertEqual(bytes, HuffmanNode(decoder: DataDecoder(bytes: bytes))!.encoded()!)
    }

}
