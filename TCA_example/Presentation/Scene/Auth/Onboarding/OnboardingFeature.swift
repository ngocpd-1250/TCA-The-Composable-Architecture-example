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

    @ObservableState
    struct State {}

    enum Action {
        case setDoneOnboarding
    }

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .setDoneOnboarding:
                repository.updateOnboardingStatus(isDone: true)
                return .none
            }
        }
    }
}
