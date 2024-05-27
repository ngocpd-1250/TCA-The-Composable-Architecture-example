//
//  AuthRepositoryMock.swift
//  TCA_exampleTests
//
//  Created by phan.duong.ngoc on 21/05/2024.
//

@testable import TCA_example

final class AuthRepositoryMock: AuthRepository {
    var updateOnboardingStatusCalled = false
    var isDoneOnboarding = false

    func updateOnboardingStatus(isDone: Bool) {
        updateOnboardingStatusCalled = true
        isDoneOnboarding = isDone
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

    var loginCalled = false
    var loginError: Error?

    func login(email _: String, password _: String) async throws {
        loginCalled = true
        if let loginError = loginError {
            throw loginError
        }
    }

    var isLoggedIn = false

    func setIsLoggedIn(_ value: Bool) {
        isLoggedIn = value
    }

    var registerCalled = false
    var registerError: Error?

    func register(email _: String, password _: String) async throws {
        registerCalled = true
        if registerError != nil {
            throw registerError ?? TestError()
        }
    }
}
