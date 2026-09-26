//
//  Cake.swift
//  CakeList
//
//  Created by Eren on 26/09/2026.
//

import Foundation

/// A single cake entry as served by the cakes API.
nonisolated struct Cake: Hashable, Sendable {
    let title: String
    let description: String
    let imageURL: URL?
}

nonisolated extension Cake: Decodable {
    private enum CodingKeys: String, CodingKey {
        case title
        case description = "desc"
        case imageURL = "image"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        // A malformed image URL should degrade to a placeholder, not fail the whole list.
        imageURL = try container
            .decodeIfPresent(String.self, forKey: .imageURL)
            .flatMap(URL.init(string:))
    }
}
