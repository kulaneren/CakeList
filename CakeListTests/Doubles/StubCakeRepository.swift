//
//  StubCakeRepository.swift
//  CakeListTests
//
//  Created by Eren on 26/09/2026.
//

import Foundation
@testable import CakeList

/// Returns a canned result that tests can swap between calls.
final class StubCakeRepository: CakeRepository, @unchecked Sendable {
    var result: Result<[Cake], any Error>

    init(result: Result<[Cake], any Error>) {
        self.result = result
    }

    func fetchCakes() async throws -> [Cake] {
        try result.get()
    }
}
