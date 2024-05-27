//
//  LoginFeature.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 20/05/2024.
//

import ComposableArchitecture
import Factory

@Reducer
struct LoginFeature {
    @Injected(\.authRepository) private var repository
    let performNavigation: (AuthFlowAction) -> Void

    @ObservableState
    struct State {
        var isLoading = false
        var isEnable = true
        var username = ""
        var password = ""
        var usernameValidationMessage = ""
        var passwordValidationMessage = ""
        var hasPressedLoginButton = false
        var error: Error?
    }

    enum Action {
        case usernameChanged(String)
        case passwordChanged(String)
        case toRegister
        case login
        case loginResponse(Result<Void, Error>)
        case setError(Error?)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .usernameChanged(username):
                if state.hasPressedLoginButton {
                    validate(&state)
                }
                state.username = username
                return .none

            case let .passwordChanged(password):
                if state.hasPressedLoginButton {
                    validate(&state)
                }
                state.password = password
                return .none

            case .login:
                state.hasPressedLoginButton = true
                let isValid = validate(&state)

                if isValid {
                    state.isLoading = true
                    let username = state.username
                    let password = state.password
                    return .run { send in
                        do {
                            try await repository.login(email: username, password: password)
                            await send(.loginResponse(.success(())))
                        } catch {
                            await send(.loginResponse(.failure(error)))
                        }
                    }
                }
                return .none

            case .loginResponse(let result):
                state.isLoading = false
                switch result {
                case .success:
                    repository.setIsLoggedIn(true)
                    return .none
                case .failure(let error):
                    return .run { send in
                        await send(.setError(error))
                    }
                }

            case .setError(let error):
                state.error = error
                return .none

            case .toRegister:
                performNavigation(.toRegister)
                return .none
            }
        }
    }

    @discardableResult
    private func validate(_ state: inout State) -> Bool {
        let emailValidationResult = repository.validateEmail(email: state.username)
        state.usernameValidationMessage = emailValidationResult.message

        let passwordValidationResult = repository.validatePassword(password: state.password)
        state.passwordValidationMessage = passwordValidationResult.message

        let isValid = emailValidationResult.isValid && passwordValidationResult.isValid
        state.isEnable = isValid
        return isValid
    }
}
