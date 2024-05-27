//
//  SettingsRepository.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 22/05/2024.
//

import Foundation
import Defaults

protocol SettingsRepository {
    func getCurrentLanguage() -> String
    func getDarkModeStatus() -> Bool
    func setLanguage(_ language: String)
    func toggleDarkMode()
    func logout()
}

struct SettingsRepositoryImpl: SettingsRepository {
    func getCurrentLanguage() -> String {
        Defaults[.language]
    }

    func getDarkModeStatus() -> Bool {
        Defaults[.isDarkMode]
    }

    func setLanguage(_ language: String) {
        Defaults[.language] = language
    }

    func toggleDarkMode() {
        Defaults[.isDarkMode].toggle()
    }

    func logout() {
        Defaults[.isLoggedIn] = false
    }
}
