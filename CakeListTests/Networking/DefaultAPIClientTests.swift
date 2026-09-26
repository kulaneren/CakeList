//
//  DefaultAPIClientTests.swift
//  CakeListTests
//
//  Created by Eren on 26/09/2026.
//

import Foundation
import Testing
@testable import CakeList

struct DefaultAPIClientTests {
    private struct Payload: Decodable, Equatable {
        let name: String
    }

    private let baseURL = URL(string: "https://api.example.com/v1")!

    @Test func buildsRequestFromBaseURLAndEndpoint() async throws {
        let http = StubHTTPClient(data: Data(#"{"name":"cake"}"#.utf8))
        let client = DefaultAPIClient(baseURL: baseURL, httpClient: http)
        let endpoint = Endpoint(
            path: "cakes",
            queryItems: [URLQueryItem(name: "page", value: "2")],
            headers: ["Accept": "application/json"]
        )

        _ = try await client.request(endpoint, as: Payload.self)

        let request = try #require(http.requests.first)
        #expect(request.url?.absoluteString == "https://api.example.com/v1/cakes?page=2")
        #expect(request.httpMethod == "GET")
        #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
    }

    @Test func decodesSuccessfulResponse() async throws {
        let http = StubHTTPClient(data: Data(#"{"name":"cake"}"#.utf8))
        let client = DefaultAPIClient(baseURL: baseURL, httpClient: http)

        let payload = try await client.request(Endpoint(path: "cakes"), as: Payload.self)

        #expect(payload == Payload(name: "cake"))
    }

    @Test func failsOnUnacceptableStatusCode() async {
        let http = StubHTTPClient(data: Data(), statusCode: 500)
        let client = DefaultAPIClient(baseURL: baseURL, httpClient: http)

        await #expect {
            try await client.request(Endpoint(path: "cakes"), as: Payload.self)
        } throws: { error in
            guard case NetworkError.unacceptableStatusCode(500) = error else { return false }
            return true
        }
    }

    @Test func failsOnNonHTTPResponse() async {
        let response = URLResponse(url: baseURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        let http = StubHTTPClient(result: .success((Data(), response)))
        let client = DefaultAPIClient(baseURL: baseURL, httpClient: http)

        await #expect {
            try await client.request(Endpoint(path: "cakes"), as: Payload.self)
        } throws: { error in
            guard case NetworkError.invalidResponse = error else { return false }
            return true
        }
    }

    @Test func wrapsTransportErrors() async {
        let http = StubHTTPClient(error: URLError(.notConnectedToInternet))
        let client = DefaultAPIClient(baseURL: baseURL, httpClient: http)

        await #expect {
            try await client.request(Endpoint(path: "cakes"), as: Payload.self)
        } throws: { error in
            guard case NetworkError.transport(let underlying) = error else { return false }
            return (underlying as? URLError)?.code == .notConnectedToInternet
        }
    }

    @Test func wrapsDecodingErrors() async {
        let http = StubHTTPClient(data: Data("not json".utf8))
        let client = DefaultAPIClient(baseURL: baseURL, httpClient: http)

        await #expect {
            try await client.request(Endpoint(path: "cakes"), as: Payload.self)
        } throws: { error in
            guard case NetworkError.decodingFailed = error else { return false }
            return true
        }
    }
}
