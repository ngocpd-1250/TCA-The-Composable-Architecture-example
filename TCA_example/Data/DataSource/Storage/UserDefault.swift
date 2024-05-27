//
//  UserDefault.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 20/05/2024.
//

import Defaults
import Foundation

extension Defaults.Keys {
    static let isOnboardingCompleted = Key<Bool>("isOnboardingCompleted", default: false)
    static let isLoggedIn = Key<Bool>("isLoggedIn", default: false)
    static let isDarkMode = Key<Bool>("isDarkMode", default: true)
    static let language = Key<String>("language", default: "en")
}
