//
//  CakeListView.swift
//  CakeList
//
//  Created by Eren on 26/09/2026.
//

import SwiftUI

struct CakeListView: View {
    @State private var viewModel: CakeListViewModel
    @State private var selectedCake: Cake?
    @State private var imageLoadID = UUID()

    init(viewModel: CakeListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Cakes")
                .toolbar {
                    Button("Refresh", systemImage: "arrow.clockwise") {
                        Task { await reload() }
                    }
                    .disabled(viewModel.state == .loading)
                }
                .alert(selectedCake?.title ?? "", isPresented: isPresentingDescription, presenting: selectedCake) { _ in
                } message: { cake in
                    Text(cake.description)
                }
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
            List(Array(cakes.enumerated()), id: \.element) { index, cake in
                Button {
                    selectedCake = cake
                } label: {
                    CakeRow(cake: cake, imageLoadID: imageLoadID)
                }
                .buttonStyle(.plain)
                .appearTransition(index: index)
            }
            .listStyle(.plain)
            .refreshable {
                await reload()
            }
        case .failed(let message):
            ContentUnavailableView {
                Label("Couldn't load cakes", systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                Button("Retry") {
                    Task { await reload() }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    /// Reloads the list and gives thumbnails a new identity so images that failed earlier are requested again.
    private func reload() async {
        await viewModel.load()
        imageLoadID = UUID()
    }

    private var isPresentingDescription: Binding<Bool> {
        Binding(
            get: { selectedCake != nil },
            set: { if !$0 { selectedCake = nil } }
        )
    }
}

#Preview("Loaded") {
    CakeListView(viewModel: CakeListViewModel(repository: PreviewCakeRepository()))
}

#Preview("Failed") {
    CakeListView(viewModel: CakeListViewModel(repository: PreviewCakeRepository(result: .failure(NetworkError.invalidResponse))))
}
