//
//  OnboardingScreen.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 16/05/2024.
//

import ComposableArchitecture
import SwiftUI
import Factory

struct OnboardingScreen: View {
    let store: StoreOf<OnboardingFeature>

    @State var selectedPage = 0
    private var pages = OnboardingPage.allCases
    private var isLastPage: Bool {
        return selectedPage == pages.count - 1
    }

    init(store: StoreOf<OnboardingFeature>) {
        self.store = store
    }

    var body: some View {
        Screen {
            TabView(selection: $selectedPage) {
                ForEach(pages.indices, id: \.self) { index in
                    page(pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .navigationBarHidden(true)
        }
    }

    @ViewBuilder
    func page(_ page: OnboardingPage) -> some View {
        VStack {
            page.image
                .padding(.vertical, Spacing.small.value)

            Text(page.title)
                .font(.title)
                .foregroundStyle(Color(R.color.labelPrimary))

            Text(page.description)
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(R.color.labelPrimary))

            if isLastPage {
                BaseButton(title: R.string.localizable.onboardingGetStarted()) {
                    store.send(.toLogin)
                }
                .frame(width: 240, height: 52)
                .padding(.top, Spacing.normal.value)
            }
        }
        .padding(Spacing.normal.value)
    }
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        let perform: (AuthFlowAction) -> Void = { _ in
        }
        return Container.shared.onboardingScreen(perform)
    }
}
