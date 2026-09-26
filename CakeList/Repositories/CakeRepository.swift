//
//  CakeRepository.swift
//  CakeList
//
//  Created by Eren on 26/09/2026.
//

import Foundation

/// Source of cakes. The view model depends on this, not on the network stack.
nonisolated protocol CakeRepository: Sendable {
    func fetchCakes() async throws -> [Cake]
}
