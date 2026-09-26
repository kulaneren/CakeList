//
//  APIClient.swift
//  CakeList
//
//  Created by Eren on 26/09/2026.
//

import Foundation

/// Typed request layer: resolves an `Endpoint`, validates the HTTP response and decodes the body.
nonisolated protocol APIClient: Sendable {
    func request<Response: Decodable & Sendable>(_ endpoint: Endpoint, as type: Response.Type) async throws -> Response
}

nonisolated extension APIClient {
    func request<Response: Decodable & Sendable>(_ endpoint: Endpoint) async throws -> Response {
        try await request(endpoint, as: Response.self)
    }
}

nonisolated struct DefaultAPIClient: APIClient {
    private let baseURL: URL
    private let httpClient: any HTTPClient
    private let decoder: JSONDecoder

    init(baseURL: URL, httpClient: any HTTPClient = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.baseURL = baseURL
        self.httpClient = httpClient
        self.decoder = decoder
    }

    func request<Response: Decodable & Sendable>(_ endpoint: Endpoint, as type: Response.Type) async throws -> Response {
        let request = try endpoint.urlRequest(relativeTo: baseURL)

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await httpClient.data(for: request)
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            throw NetworkError.transport(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.unacceptableStatusCode(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
