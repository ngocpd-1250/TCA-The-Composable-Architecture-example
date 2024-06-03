//
//  RegisterFeature.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 21/05/2024.
//

import ComposableArchitecture
import Factory

@Reducer
struct RegisterFeature {
    @Injected(\.authRepository) private var repository
    let performNavigation: (AuthFlowAction) -> Void

    @ObservableState
    struct State {
        var isLoading = false
        var isEnable = true
        var username = ""
        var password = ""
        var confirmPassword = ""
        var usernameValidationMessage = ""
        var passwordValidationMessage = ""
        var confirmPasswordValidationMessage = ""
        var hasPressedLoginButton = false
        var error: Error?
        var alert: Alert?
    }

    enum Action {
        case usernameChanged(String)
        case passwordChanged(String)
        case confirmPasswordChanged(String)
        case toLogin
        case register
        case registerResponse(Result<Void, Error>)
        case setAlert(Alert?)
    }

    enum Alert: Identifiable {
        var id: ObjectIdentifier {
            switch self {
            case .error(let error):
                return ObjectIdentifier(error as AnyObject)
            case .isRegistered:
                return ObjectIdentifier(Self.isRegistered as AnyObject)
            }
        }

        case error(Error?)
        case isRegistered
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

            case let .confirmPasswordChanged(password):
                if state.hasPressedLoginButton {
                    validate(&state)
                }
                state.confirmPassword = password
                return .none

            case .register:
                state.hasPressedLoginButton = true
                let isValid = validate(&state)

                if isValid {
                    state.isLoading = true
                    let username = state.username
                    let password = state.password
                    return .run { send in
                        do {
                            try await repository.register(email: username, password: password)
                            await send(.registerResponse(.success(())))
                        } catch {
                            await send(.registerResponse(.failure(error)))
                        }
                    }
                }
                return .none

            case .registerResponse(let result):
                state.isLoading = false
                switch result {
                case .success:
                    state.alert = .isRegistered
                case .failure(let error):
                    state.alert = .error(error)
                }
                return .none

            case .setAlert(let alert):
                state.alert = alert
                return .none

            case .toLogin:
                performNavigation(.pop)
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

        let confirmPasswordValidationResult = repository.validateConfirmPassword(password: state.password,
                                                                                 confirmPassword: state.confirmPassword)
        state.confirmPasswordValidationMessage = confirmPasswordValidationResult.message

        let isValid = emailValidationResult.isValid
            && passwordValidationResult.isValid
            && confirmPasswordValidationResult.isValid
        state.isEnable = isValid
        return isValid
    }
}
