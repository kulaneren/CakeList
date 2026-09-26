//
//  CakeListView.swift
//  CakeList
//
//  Created by Eren on 26/09/2026.
//

import SwiftUI

struct CakeListView: View {
    @State private var viewModel: CakeListViewModel

    init(viewModel: CakeListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Cakes")
        }
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading cakes…")
        case .loaded(let cakes):
            List(cakes, id: \.self, rowContent: CakeRow.init)
                .listStyle(.plain)
        case .failed(let message):
            ContentUnavailableView(
                "Couldn't load cakes",
                systemImage: "wifi.exclamationmark",
                description: Text(message)
            )
        }
    }
}

#Preview("Loaded") {
    CakeListView(viewModel: CakeListViewModel(repository: PreviewCakeRepository()))
}

#Preview("Failed") {
    CakeListView(viewModel: CakeListViewModel(repository: PreviewCakeRepository(result: .failure(NetworkError.invalidResponse))))
}
