//
//  NetworkError.swift
//  CakeList
//
//  Created by Eren on 26/09/2026.
//

import Foundation

nonisolated enum NetworkError: Error {
    case invalidURL
    case transport(any Error)
    case invalidResponse
    case unacceptableStatusCode(Int)
    case decodingFailed(any Error)
}

nonisolated extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "The request URL could not be built."
        case .transport:
            "Couldn't reach the server. Check your connection and try again."
        case .invalidResponse:
            "The server returned an unexpected response."
        case .unacceptableStatusCode(let code):
            "The server responded with status \(code)."
        case .decodingFailed:
            "The server response couldn't be read."
        }
    }
}
