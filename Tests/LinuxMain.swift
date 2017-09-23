//
//  CompressDataCodecTests.swift
//  CompressDataCodec
//
//  Created by Bernardo Breder.
//
//

import XCTest
@testable import CompressDataCodecTests

extension CompressDataEncoderTests {

	static var allTests : [(String, (CompressDataEncoderTests) -> () throws -> Void)] {
		return [
			("test", test),
		]
	}

}

extension CompressDataCodecTests {

	static var allTests : [(String, (CompressDataCodecTests) -> () throws -> Void)] {
		return [
			("test", test),
		]
	}

}

extension HuffmanTests {

	static var allTests : [(String, (HuffmanTests) -> () throws -> Void)] {
		return [
			("testCodec", testCodec),
			("testExample", testExample),
		]
	}

}

XCTMain([
	testCase(CompressDataEncoderTests.allTests),
	testCase(CompressDataCodecTests.allTests),
	testCase(HuffmanTests.allTests),
])

