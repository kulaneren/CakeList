//
//  CakeTests.swift
//  CakeListTests
//
//  Created by Eren on 26/09/2026.
//

import Foundation
import Testing
@testable import CakeList

struct CakeTests {

    @Test func decodesAPIKeys() throws {
        let json = Data("""
        {"title": "Dundee Cake", "desc": "A staple with Dundonians", "image": "https://example.com/dundee.jpg"}
        """.utf8)

        let cake = try JSONDecoder().decode(Cake.self, from: json)

        #expect(cake.title == "Dundee Cake")
        #expect(cake.description == "A staple with Dundonians")
        #expect(cake.imageURL == URL(string: "https://example.com/dundee.jpg"))
    }

    @Test func decodesMissingImageAsNil() throws {
        let json = Data("""
        {"title": "Donut", "desc": "Not technically a cake"}
        """.utf8)

        let cake = try JSONDecoder().decode(Cake.self, from: json)

        #expect(cake.imageURL == nil)
    }
}
