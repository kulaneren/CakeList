//
//  CakeListViewModelTests.swift
//  CakeListTests
//
//  Created by Eren on 26/09/2026.
//

import Foundation
import Testing
@testable import CakeList

@MainActor
struct CakeListViewModelTests {
    private let victoriaSponge = Cake(title: "Victoria Sponge", description: "sponge with jam", imageURL: nil)
    private let carrotCake = Cake(title: "Carrot Cake", description: "Bugs bunnys favourite", imageURL: nil)
    private let donut = Cake(title: "Donut", description: "Not technically a cake", imageURL: nil)

    @Test func loadSuccessPresentsCakesDedupedAndSorted() async {
        let repository = StubCakeRepository(result: .success([victoriaSponge, carrotCake, donut, carrotCake]))
        let viewModel = CakeListViewModel(repository: repository)

        await viewModel.load()

        #expect(viewModel.state == .loaded([carrotCake, donut, victoriaSponge]))
    }

    @Test func loadFailurePresentsError() async {
        let repository = StubCakeRepository(result: .failure(NetworkError.invalidResponse))
        let viewModel = CakeListViewModel(repository: repository)

        await viewModel.load()

        #expect(viewModel.state == .failed(message: NetworkError.invalidResponse.localizedDescription))
    }

    @Test func reloadAfterFailureRecovers() async {
        let repository = StubCakeRepository(result: .failure(NetworkError.invalidResponse))
        let viewModel = CakeListViewModel(repository: repository)
        await viewModel.load()

        repository.result = .success([donut])
        await viewModel.load()

        #expect(viewModel.state == .loaded([donut]))
    }
}
