//
//  Collection+Move.swift
//  MiniList
//
//  Created by Codex on 08.03.2026.
//

import Foundation

extension Collection {

    func moved(from indices: IndexSet, to offset: Int) -> [Element] {
        var result = Array(self)
        result.move(from: indices, to: offset)
        return result
    }
}

extension RangeReplaceableCollection where Self: MutableCollection, Index == Int {

    mutating func move(from indices: IndexSet, to offset: Int) {
        let validIndices = IndexSet(indices.filter { $0 >= 0 && $0 < count })
        guard !validIndices.isEmpty else {
            return
        }

        let clampedOffset = Swift.max(0, Swift.min(offset, count))
        let elementsToMove = validIndices.map { self[$0] }

        for index in validIndices.reversed() {
            remove(at: index)
        }

        let removedBeforeOffset = validIndices.filter { $0 < clampedOffset }.count
        let destination = Swift.max(0, Swift.min(clampedOffset - removedBeforeOffset, count))
        insert(contentsOf: elementsToMove, at: destination)
    }
}
