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

public class CompressDataDecoder {
    
    public let data: Data
    
    public init?(compressedData: Data) {
        let decoder = DataDecoder(data: compressedData)
        guard let root = HuffmanNode(decoder: decoder) else { return nil }
        guard let count = decoder.readInt32() else { return nil }
        guard let bitSet = BitSet(decoder: decoder) else { return nil }
        var out = ""
        var i = 0
        for _ in 0 ..< count {
            var aux: HuffmanNode? = root
            while let auxLet = aux, auxLet.word == nil {
                aux = bitSet.isSet(i) ? auxLet.right : auxLet.left
                i += 1
            }
            guard let auxLet = aux, let word = auxLet.word else { return nil }
            out += word
        }
        guard let data = out.data(using: .utf8) else { return nil }
        self.data = data
    }
    
}
