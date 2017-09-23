//
//  Package.swift
//  CompressDataCodec
//
//

import PackageDescription

let package = Package(
	name: "CompressDataCodec",
	targets: [
		Target(name: "CompressDataCodec", dependencies: ["BitSetCodec", "DataCodec", "HeapQueue"]),
		Target(name: "BitSet", dependencies: []),
		Target(name: "BitSetCodec", dependencies: ["BitSet", "DataCodec"]),
		Target(name: "DataCodec", dependencies: []),
		Target(name: "HeapQueue", dependencies: []),
	]
)

