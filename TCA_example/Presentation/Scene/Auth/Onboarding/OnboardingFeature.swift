//
//  OnboardingFeature.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 16/05/2024.
//

import ComposableArchitecture
import Factory

@Reducer
struct OnboardingFeature {
    @Injected(\.authRepository) private var repository
    let performNavigation: (AuthFlowAction) -> Void

    @ObservableState
    struct State {}

    enum Action {
        case toLogin
        case setDoneOnboarding
    }

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .toLogin:
                performNavigation(.toLogin)
                return .run { send in
                    await send(.setDoneOnboarding)
                }

            case .setDoneOnboarding:
                repository.updateOnboardingStatus(isDone: true)
                return .none
            }
        }
    }
}
