//
//  SettingsFeature.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 22/05/2024.
//

import ComposableArchitecture
import Factory

@Reducer
struct SettingsFeature {
    @Injected(\.settingsRepository) private var repository

    @ObservableState
    struct State {
        var isDarkMode = false
        var isJapanese = false
    }

    enum Action {
        case load
        case toggleDarkMode
        case toggleLanguage
        case logout
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .load:
                state.isJapanese = repository.getCurrentLanguage() == SupportedLanguage.japanese.code
                state.isDarkMode = repository.getDarkModeStatus()
                return .none

            case .toggleDarkMode:
                repository.toggleDarkMode()
                state.isDarkMode = repository.getDarkModeStatus()
                return .none

            case .toggleLanguage:
                let current = repository.getCurrentLanguage()
                let newLanguage = current == SupportedLanguage.japanese.code ? SupportedLanguage.english.code : SupportedLanguage.japanese.code
                state.isJapanese = newLanguage == SupportedLanguage.japanese.code
                repository.setLanguage(newLanguage)
                return .none

            case .logout:
                repository.logout()
                return .none
            }
        }
    }
}
