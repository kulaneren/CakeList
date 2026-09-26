//
//  RemoteCakeRepositoryTests.swift
//  CakeListTests
//
//  Created by Eren on 26/09/2026.
//

import Foundation
import Testing
@testable import CakeList

struct RemoteCakeRepositoryTests {

    @Test func requestsCakesEndpoint() async throws {
        let apiClient = StubAPIClient(returning: [Cake]())
        let repository = RemoteCakeRepository(apiClient: apiClient)

        _ = try await repository.fetchCakes()

        #expect(apiClient.endpoints == [Endpoint(path: "cakes")])
    }

    @Test func returnsDecodedCakes() async throws {
        let cakes = [Cake(title: "Donut", description: "Not technically a cake", imageURL: nil)]
        let repository = RemoteCakeRepository(apiClient: StubAPIClient(returning: cakes))

        let result = try await repository.fetchCakes()

        #expect(result == cakes)
    }

    @Test func propagatesErrors() async {
        let repository = RemoteCakeRepository(apiClient: StubAPIClient(throwing: NetworkError.invalidResponse))

        await #expect(throws: NetworkError.self) {
            try await repository.fetchCakes()
        }
    }
}
