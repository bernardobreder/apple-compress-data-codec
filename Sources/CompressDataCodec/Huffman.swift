//
//  Huffman.swift
//  CompressCodec
//
//  Created by Bernardo Breder on 06/01/17.
//
//

import Foundation

#if SWIFT_PACKAGE
    import HeapQueue
    import BitSet
    import DataCodec
#endif

public class Huffman {
    
    let root: HuffmanNode
    
    let entrys: [String: BitSet]
    
    public init(frequency: [String: Int]) {
        var leafs: [HuffmanEntry] = []
        let queue = HeapQueue<HuffmanEntry> { $0.value <= $1.value }
        for item in frequency.map({ (key: $0, value: ($1)) }) {
            let entry = HuffmanEntry(word: item.key, value: item.value)
            leafs.append(entry)
            queue.add(entry)
        }
        while queue.count > 1 {
            let right = queue.remove()!
            let left = queue.remove()!
            let entry = HuffmanEntry(word: nil, value: left.value + right.value, left: left, right: right)
            left.parent = entry
            right.parent = entry
            queue.add(entry)
        }
        let entry = queue.remove()!
        self.root = HuffmanNode(entry: entry)
        var entrys: [String: BitSet] = [:]
        for leaf in leafs {
            entrys[leaf.word!] = leaf.bitSet
        }
        self.entrys = entrys
    }
    
    public func bitSet(_ key: String) -> BitSet? {
        return entrys[key]
    }
    
}

public class HuffmanEntry {
    
    public let word: String?
    
    public let value: Int
    
    public var left: HuffmanEntry?
    
    public var right: HuffmanEntry?
    
    public weak var parent: HuffmanEntry?
    
    public init(word: String? = nil, value: Int, left: HuffmanEntry? = nil, right: HuffmanEntry? = nil, parent: HuffmanEntry? = nil) {
        self.word = word
        self.value = value
        self.left = left
        self.right = right
        self.parent = parent
    }
    
    public init?(decoder: DataDecoder) {
        guard let hasWord = decoder.readHasData() else { return nil }
        word = hasWord ? decoder.readString16() : nil
        guard let value32 = decoder.readInt32() else { return nil }
        value = Int(value32)
        guard let hasLeft = decoder.readHasData() else { return nil }
        left = hasLeft ? HuffmanEntry(decoder: decoder) : nil
        guard let hasRight = decoder.readHasData() else { return nil }
        right = hasRight ? HuffmanEntry(decoder: decoder) : nil
    }
    
    public var parents: [HuffmanEntry] {
        var array: [HuffmanEntry] = []
        var aux: HuffmanEntry? = parent
        while let item: HuffmanEntry = aux {
            aux = item.parent
            array.append(item)
        }
        return array
    }
    
    public var bitSet: BitSet {
        let parents = self.parents
        let bit = BitSet(count: parents.count)
        var i = bit.count - 1
        var aux = self
        for item in parents {
            if item.right === aux {
                bit.set(i)
            }
            aux = item
            i -= 1
        }
        return bit
    }
    
}

public class HuffmanNode {
    
    public let word: String?
    
    public var left: HuffmanNode?
    
    public var right: HuffmanNode?
    
    public init(word: String? = nil, left: HuffmanNode? = nil, right: HuffmanNode? = nil) {
        self.word = word
        self.left = left
        self.right = right
    }
    
    public convenience init(entry: HuffmanEntry) {
        let left = entry.left == nil ? nil : HuffmanNode(entry: entry.left!)
        let right = entry.right == nil ? nil : HuffmanNode(entry: entry.right!)
        self.init(word: entry.word, left: left, right: right)
    }
    
    public init?(decoder: DataDecoder) {
        guard let hasWord = decoder.readHasData() else { return nil }
        word = hasWord ? decoder.readString16() : nil
        guard let hasLeft = decoder.readHasData() else { return nil }
        left = hasLeft ? HuffmanNode(decoder: decoder) : nil
        guard let hasRight = decoder.readHasData() else { return nil }
        right = hasRight ? HuffmanNode(decoder: decoder) : nil
    }
    
    public func encoded(encoder: DataEncoder) {
        if let word = encoder.write(ifLet: word) {
            encoder.write(string16: word)
        }
        if let left = encoder.write(ifLet: left) {
            left.encoded(encoder: encoder)
        }
        if let right = encoder.write(ifLet: right) {
            right.encoded(encoder: encoder)
        }
    }
    
    public func encoded() -> [UInt8]? {
        let encoder = DataEncoder()
        encoded(encoder: encoder)
        return encoder.bytes()
    }
    
}
