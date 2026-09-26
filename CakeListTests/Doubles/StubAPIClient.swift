//
//  StubAPIClient.swift
//  CakeListTests
//
//  Created by Eren on 26/09/2026.
//

import Foundation
@testable import CakeList

/// Returns a canned value (or error) and records every endpoint it was asked for.
final class StubAPIClient: APIClient, @unchecked Sendable {
    struct TypeMismatch: Error {}

    private(set) var endpoints: [Endpoint] = []
    private let result: Result<any Sendable, any Error>

    init(returning value: any Sendable) {
        result = .success(value)
    }

    init(throwing error: any Error) {
        result = .failure(error)
    }

    func request<Response: Decodable & Sendable>(_ endpoint: Endpoint, as type: Response.Type) async throws -> Response {
        endpoints.append(endpoint)
        guard let response = try result.get() as? Response else {
            throw TypeMismatch()
        }
        return response
    }
}
