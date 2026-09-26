//
//  Endpoint.swift
//  CakeList
//
//  Created by Eren on 26/09/2026.
//

import Foundation

nonisolated enum HTTPMethod: String, Sendable {
    case get = "GET"
}

/// Describes a request relative to an API's base URL.
nonisolated struct Endpoint: Hashable, Sendable {
    var path: String
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem] = []
    var headers: [String: String] = [:]

    func urlRequest(relativeTo baseURL: URL) throws -> URLRequest {
        guard var components = URLComponents(url: baseURL.appending(path: path), resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        for (field, value) in headers {
            request.setValue(value, forHTTPHeaderField: field)
        }
        return request
    }
}
