//
//  AppearTransition.swift
//  CakeList
//
//  Created by Eren on 26/09/2026.
//

import SwiftUI

/// Fades and slides content into place the first time it appears, staggered by its position in a list.
private struct AppearTransition: ViewModifier {
    let index: Int

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 16)
            .onAppear {
                guard !reduceMotion else {
                    isVisible = true
                    return
                }
                withAnimation(.easeOut(duration: 0.35).delay(min(Double(index) * 0.05, 0.3))) {
                    isVisible = true
                }
            }
    }
}

extension View {
    func appearTransition(index: Int) -> some View {
        modifier(AppearTransition(index: index))
    }
}
