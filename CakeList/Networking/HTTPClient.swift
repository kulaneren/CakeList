//
//  HTTPClient.swift
//  CakeList
//
//  Created by Eren on 26/09/2026.
//

import Foundation

/// Raw transport abstraction. Everything above this layer talks to `HTTPClient`,
/// never to `URLSession` directly, so it can be swapped for a stub in tests.
nonisolated protocol HTTPClient: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

nonisolated extension URLSession: HTTPClient {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: nil)
    }
}
