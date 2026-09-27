//
//  CakeRow.swift
//  CakeList
//
//  Created by Eren on 26/09/2026.
//

import SwiftUI

struct CakeRow: View {
    let cake: Cake
    /// Changing this re-creates the thumbnail, since `AsyncImage` never retries a failed load on its own.
    let imageLoadID: UUID

    var body: some View {
        HStack(spacing: 12) {
            CakeThumbnail(url: cake.imageURL)
                .id(imageLoadID)
            Text(cake.title)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}

private struct CakeThumbnail: View {
    let url: URL?

    var body: some View {
        // TODO: AsyncImage has no disk cache or downsampling; swap for a cached loader if the list grows.
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image.resizable().scaledToFill()
            case .empty where url != nil:
                ProgressView()
            default:
                Image(systemName: "birthday.cake")
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 64, height: 64)
        .background(Color(.secondarySystemBackground))
        .clipShape(.rect(cornerRadius: 8))
        .accessibilityHidden(true)
    }
}

#Preview {
    List(Cake.samples, id: \.self) { cake in
        CakeRow(cake: cake, imageLoadID: UUID())
    }
    .listStyle(.plain)
}
