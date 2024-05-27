//
//  AuthRepository.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 20/05/2024.
//

import Foundation
import Combine
import Factory
import Defaults
import ComposableArchitecture

protocol AuthRepository {
    func updateOnboardingStatus(isDone: Bool)
    func validateEmail(email: String) -> ValidationResult
    func validatePassword(password: String) -> ValidationResult
    func validateConfirmPassword(password: String, confirmPassword: String) -> ValidationResult
    func login(email: String, password: String) async throws
    func setIsLoggedIn(_ value: Bool)
    func register(email: String, password: String) async throws
}

struct AuthRepositoryImpl: AuthRepository {
    @Injected(\.auth) private var auth

    func updateOnboardingStatus(isDone: Bool) {
        Defaults[.isOnboardingCompleted] = isDone
    }

    func validateEmail(email: String) -> ValidationResult {
        Validator.validateEmail(email).mapToVoid()
    }

    func validatePassword(password: String) -> ValidationResult {
        Validator.validatePassword(password).mapToVoid()
    }

    func validateConfirmPassword(password: String, confirmPassword: String) -> ValidationResult {
        Validator.validateConfirmPassword(password, confirmPassword: confirmPassword).mapToVoid()
    }

    func login(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }

    func setIsLoggedIn(_ value: Bool) {
        Defaults[.isLoggedIn] = value
    }

    func register(email: String, password: String) async throws {
        try await auth.createUser(withEmail: email, password: password)
    }
}
