//
//  CakeListViewModel.swift
//  CakeList
//
//  Created by Eren on 26/09/2026.
//

import Foundation
import Observation

@Observable
final class CakeListViewModel {
    enum State: Equatable {
        case idle
        case loading
        case loaded([Cake])
        case failed(message: String)
    }

    private(set) var state: State = .idle
    private let repository: any CakeRepository

    init(repository: any CakeRepository) {
        self.repository = repository
    }

    /// Loads the list. Keeps existing content visible while refreshing.
    func load() async {
        if case .loaded = state {} else {
            state = .loading
        }

        do {
            let cakes = try await repository.fetchCakes()
            state = .loaded(cakes.uniqued().sortedByTitle())
        } catch is CancellationError {
            // The owning view went away; nothing to present.
        } catch {
            // TODO: Keep stale content and surface refresh failures non-modally instead of replacing the list.
            state = .failed(message: error.localizedDescription)
        }
    }
}
