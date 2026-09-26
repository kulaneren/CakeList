//
//  RemoteCakeRepository.swift
//  CakeList
//
//  Created by Eren on 26/09/2026.
//

import Foundation

nonisolated struct RemoteCakeRepository: CakeRepository {
    private let apiClient: any APIClient

    init(apiClient: any APIClient) {
        self.apiClient = apiClient
    }

    func fetchCakes() async throws -> [Cake] {
        try await apiClient.request(.cakes)
    }
}

private extension Endpoint {
    static let cakes = Endpoint(path: "cakes")
}
