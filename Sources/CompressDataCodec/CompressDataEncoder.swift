//
//  CompressCodec.swift
//  CompressCodec
//
//  Created by Bernardo Breder on 06/01/17.
//
//

import Foundation

#if SWIFT_PACKAGE
    import BitSet
    import BitSetCodec
    import DataCodec
#endif

public class CompressEncoder {
    
    private var order: [String] = []
    
    private var stringFreq: [String: Int] = [:]
    
    private var error: Bool = false
    
    public init() {
    }
    
    @discardableResult
    public func write(_ string: String) -> Self {
        order.append(string)
        let count = string.characters.count
        stringFreq[string] = (stringFreq[string] ?? 0) + count
        return self
    }
    
    public func data() -> Data? {
        let encoder = DataEncoder()
        let huffman = Huffman(frequency: stringFreq)
        huffman.root.encoded(encoder: encoder)
        guard encoder.canWrite(int32: order.count) else { return nil }
        encoder.write(int32: Int32(order.count))
        var count = 0
        for item in order {
            guard let bitSet = huffman.bitSet(item) else { return nil }
            count += bitSet.count
        }
        let bitWriter = BitSetWriter()
        for item in order {
            guard let bitSet = huffman.bitSet(item) else { return nil }
            bitWriter.set(bitSet: bitSet)
        }
        bitWriter.bitSet().encode(encoder: encoder)
        guard let bytes = encoder.bytes() else { return nil }
        return Data(bytes: bytes)
    }
    
    
}
