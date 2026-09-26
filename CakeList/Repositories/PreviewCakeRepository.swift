//
//  PreviewCakeRepository.swift
//  CakeList
//
//  Created by Eren on 26/09/2026.
//

#if DEBUG
import Foundation

/// In-memory repository for SwiftUI previews.
struct PreviewCakeRepository: CakeRepository {
    var result: Result<[Cake], any Error> = .success(Cake.samples)

    func fetchCakes() async throws -> [Cake] {
        try result.get()
    }
}

extension Cake {
    static let samples = [
        Cake(title: "Victoria Sponge", description: "sponge with jam", imageURL: URL(string: "https://www.oetker.co.uk/Recipe/Recipes/oetker.co.uk/en-GB/baking/image-thumb__2404__RecipeDetailBig/victoria-sponge.jpg")),
        Cake(title: "Carrot Cake", description: "Bugs bunnys favourite", imageURL: nil),
        Cake(title: "Donut", description: "Not technically a cake", imageURL: URL(string: "https://example.com/missing.jpg")),
    ]
}
#endif
