//
//  StubHTTPClient.swift
//  CakeListTests
//
//  Created by Eren on 26/09/2026.
//

import Foundation
@testable import CakeList

/// Returns a canned result and records every request it receives.
final class StubHTTPClient: HTTPClient, @unchecked Sendable {
    private(set) var requests: [URLRequest] = []
    private let result: Result<(Data, URLResponse), any Error>

    init(result: Result<(Data, URLResponse), any Error>) {
        self.result = result
    }

    convenience init(data: Data, statusCode: Int = 200, url: URL = URL(string: "https://example.com")!) {
        let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        self.init(result: .success((data, response)))
    }

    convenience init(error: any Error) {
        self.init(result: .failure(error))
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        requests.append(request)
        return try result.get()
    }
}
