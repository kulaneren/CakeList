//
//  CakeListApp.swift
//  CakeList
//
//  Created by Eren on 26/09/2026.
//

import SwiftUI

@main
struct CakeListApp: App {
    private let viewModel = CakeListViewModel(
        repository: RemoteCakeRepository(
            apiClient: DefaultAPIClient(baseURL: APIConfiguration.baseURL)
        )
    )

    var body: some Scene {
        WindowGroup {
            CakeListView(viewModel: viewModel)
        }
    }
}
