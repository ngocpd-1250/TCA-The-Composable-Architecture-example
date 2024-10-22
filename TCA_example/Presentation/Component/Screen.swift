//
//  Screen.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 20/05/2024.
//

import SwiftUI
import Defaults
import RswiftResources

struct Screen<Content>: View where Content: View {
    @Binding private var isLoading: Bool
    @State private var language = Defaults[.language]
    @Default(.isDarkMode) var isDarkMode
    private var localizeTitleResource: StringResource?
    private var title: String?

    var content: () -> Content

    init(isLoading: Binding<Bool> = .constant(false),
         localizeTitleResource: StringResource? = nil,
         title: String? = nil,
         content: @escaping () -> Content) {
        _isLoading = isLoading
        self.localizeTitleResource = localizeTitleResource
        self.title = title
        self.content = content
    }

    private func getTitle() -> String {
        if let resource = localizeTitleResource {
            return String(resource: resource, preferredLanguages: [language])
        }
        return title ?? ""
    }

    var body: some View {
        LoadingView(isShowing: $isLoading) {
            content()
        }
        .navigationTitle(getTitle())
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(R.color.backgroundPrimary))
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onAppear {
            Task {
                for await value in Defaults.updates(.language) {
                    language = value
                }
            }
        }
    }
}
