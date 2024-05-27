//
//  SettingsScreen.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 22/05/2024.
//

import SwiftUI
import ComposableArchitecture

struct SettingsScreen: View {
    @Bindable var store: StoreOf<SettingsFeature>

    init(store: StoreOf<SettingsFeature>) {
        self.store = store
        self.store.send(.load)
    }

    var body: some View {
        Screen {
            ScrollView {
                VStack(spacing: Spacing.normal.value) {
                    SettingItem(title: R.string.localizable.settingsDarkmode(),
                                value: store.isDarkMode) {
                        store.send(.toggleDarkMode)
                    }

                    SettingItem(title: R.string.localizable.languageJapanese(),
                                value: store.isJapanese) {
                        store.send(.toggleLanguage)
                    }

                    SettingItem(title: R.string.localizable.settingsLogout()) {
                        store.send(.logout)
                    }
                }
                .padding(Spacing.normal.value)
            }
        }
    }
}
