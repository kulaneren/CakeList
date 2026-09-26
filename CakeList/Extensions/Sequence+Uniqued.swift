//
//  Sequence+Uniqued.swift
//  CakeList
//
//  Created by Eren on 26/09/2026.
//

nonisolated extension Sequence where Element: Hashable {
    /// Removes duplicate elements, keeping the first occurrence and the original order.
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
