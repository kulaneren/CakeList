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
    // TODO: Cancel an in-flight load when a new one starts so overlapping refreshes can't race.
    func load() async {
        if case .loaded = state {} else {
            state = .loading
        }

        do {
            let cakes = try await repository.fetchCakes()
            // TODO: Confirm with the API owners whether a cake is identified by title alone; duplicates are currently exact matches.
            state = .loaded(cakes.uniqued().sortedByTitle())
        } catch is CancellationError {
            // The owning view went away; nothing to present.
        } catch {
            // TODO: Keep stale content and surface refresh failures non-modally instead of replacing the list.
            state = .failed(message: error.localizedDescription)
        }
    }
}
