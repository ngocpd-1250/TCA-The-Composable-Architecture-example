//
//  LoginFeatureTests.swift
//  TCA_exampleTests
//
//  Created by phan.duong.ngoc on 21/05/2024.
//

@testable import TCA_example
import XCTest
import ComposableArchitecture
import Factory

final class LoginFeatureTests: XCTestCase {
    private var store: TestStoreOf<LoginFeature>!
    private var authRepository: AuthRepositoryMock!
    private var state: LoginFeature.State {
        return store.state
    }

    override func setUp() {
        super.setUp()
        authRepository = AuthRepositoryMock()
        Container.shared.authRepository.register { self.authRepository }

        store = TestStore(initialState: LoginFeature.State()) {
            LoginFeature()
        }
        store.exhaustivity = .off(showSkippedAssertions: false)
    }

    func test_usernameChanged_updateUsernameState() async {
        // action
        await store.send(.usernameChanged("foo@gmail.com"))

        // assert
        XCTAssertEqual(state.username, "foo@gmail.com")
    }

    func test_passwordChanged_updatePasswordState() async {
        // action
        await store.send(.passwordChanged("Aa@123456"))

        // assert
        XCTAssertEqual(state.password, "Aa@123456")
    }

    func test_login_withEmptyUsernameEmptyPassword_showErrors() async {
        // action
        await store.send(.usernameChanged(""))
        await store.send(.passwordChanged(""))
        await store.send(.login)

        // assert
        XCTAssertEqual(state.usernameValidationMessage, R.string.localizable.validationEmailEmpty())
        XCTAssertEqual(state.passwordValidationMessage, R.string.localizable.validationPasswordEmpty())
        XCTAssertFalse(state.isEnable)
        XCTAssertTrue(state.hasPressedLoginButton)
    }

    func test_login_withInvalidUsername_showError() async {
        // action
        await store.send(.usernameChanged("foo@gmail"))
        await store.send(.passwordChanged("Aa@123456"))
        await store.send(.login)

        // assert
        XCTAssertEqual(state.usernameValidationMessage, R.string.localizable.validationEmailInvalid())
        XCTAssertEqual(state.passwordValidationMessage, "")
        XCTAssertFalse(state.isEnable)
    }

    func test_login_withInvalidPassword_showError() async {
        // action
        await store.send(.usernameChanged("foo@gmail.com"))
        await store.send(.passwordChanged("Aa@"))
        await store.send(.login)

        // assert
        XCTAssertEqual(state.usernameValidationMessage, "")
        XCTAssertEqual(state.passwordValidationMessage, R.string.localizable.validationPasswordInvalid())
        XCTAssertFalse(state.isEnable)
    }

    func test_login_withValidUsernameAndPassword_success() async {
        // action
        await store.send(.usernameChanged("foo@gmail.com"))
        await store.send(.passwordChanged("Aa@123456"))
        await store.send(.login)

        // assert
        await store.receive(/.loginResponse(.success(()))) {
            $0.isLoading = false
        }

        XCTAssertEqual(state.usernameValidationMessage, "")
        XCTAssertEqual(state.passwordValidationMessage, "")
        XCTAssertTrue(state.isEnable)
        XCTAssertTrue(authRepository.isLoggedIn)
    }

    func test_login_withValidUsernameAndPassword_error() async {
        // action
        let loginError = TestError()
        authRepository.loginError = loginError
        await store.send(.usernameChanged("foo@gmail.com"))
        await store.send(.passwordChanged("Aa@123456"))
        await store.send(.login) {
            $0.isLoading = true
        }

        // assert
        await store.receive(/.loginResponse(.failure(loginError))) {
            $0.isLoading = false
        }
        await store.receive(/.setError(loginError))
        XCTAssertEqual(state.usernameValidationMessage, "")
        XCTAssertEqual(state.passwordValidationMessage, "")
        XCTAssertTrue(state.isEnable)
        XCTAssertFalse(authRepository.isLoggedIn)
        XCTAssert(state.error is TestError)
    }
}

extension LoginFeature.State: Equatable {
    public static func == (lhs: LoginFeature.State, rhs: LoginFeature.State) -> Bool {
        return lhs.isLoading == rhs.isLoading &&
            lhs.isEnable == rhs.isEnable &&
            lhs.username == rhs.username &&
            lhs.password == rhs.password &&
            lhs.usernameValidationMessage == rhs.usernameValidationMessage &&
            lhs.passwordValidationMessage == rhs.passwordValidationMessage &&
            lhs.hasPressedLoginButton == rhs.hasPressedLoginButton &&
            (lhs.error as NSError?) == (rhs.error as NSError?)
    }
}
