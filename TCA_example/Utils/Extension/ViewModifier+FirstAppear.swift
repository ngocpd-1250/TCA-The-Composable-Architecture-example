//
//  ViewModifier+FirstAppear.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 27/05/2024.
//

import SwiftUI

extension View {
    func onFirstAppear(_ action: @escaping () -> Void) -> some View {
        modifier(FirstAppear(action: action))
    }
}

private struct FirstAppear: ViewModifier {
    let action: () -> Void
    @State private var hasAppeared = false

    func body(content: Content) -> some View {
        content.onAppear {
            guard !hasAppeared else {
                return
            }
            hasAppeared = true
            action()
        }
    }
}
