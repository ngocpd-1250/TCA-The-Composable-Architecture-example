//
//  RegisterScreen.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 21/05/2024.
//

import SwiftUI
import Combine
import ComposableArchitecture
import Factory

struct RegisterScreen: View {
    @Bindable var store: StoreOf<RegisterFeature>
    @EnvironmentObject var coordinator: AuthCoordinatorViewModel

    init(store: StoreOf<RegisterFeature>) {
        self.store = store
    }

    var body: some View {
        Screen(isLoading: .constant(store.isLoading)) {
            VScrollView {
                VStack {
                    Text(R.string.localizable.commonRegister())
                        .font(.title)
                        .padding(.bottom, Spacing.medium.value)
                        .foregroundStyle(Color(R.color.primary))

                    BaseTextField(text: $store.username.sending(\.usernameChanged),
                                  placeholder: R.string.localizable.commonUsername(),
                                  image: Image(R.image.icon_email),
                                  errorMessage: store.usernameValidationMessage)
                        .padding(.bottom, Spacing.small.value)

                    BaseTextField(text: $store.password.sending(\.passwordChanged),
                                  placeholder: R.string.localizable.commonPassword(),
                                  image: Image(R.image.icon_password),
                                  isSecure: true,
                                  errorMessage: store.passwordValidationMessage)
                        .padding(.bottom, Spacing.small.value)

                    BaseTextField(text: $store.confirmPassword.sending(\.confirmPasswordChanged),
                                  placeholder: R.string.localizable.commonConfirmPassword(),
                                  image: Image(R.image.icon_password),
                                  isSecure: true,
                                  errorMessage: store.confirmPasswordValidationMessage)
                        .padding(.bottom, Spacing.small.value)

                    BaseButton(title: R.string.localizable.commonRegister(), isEnabled: store.isEnable) {
                        store.send(.register)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)

                    Text(R.string.localizable.commonAlreadyHaveAccount())
                        .padding(.top, Spacing.extraLarge.value)

                    Button {
                        coordinator.perform(.pop)
                    } label: {
                        Text(R.string.localizable.commonLogin())
                            .foregroundStyle(Color(R.color.primary))
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
        .alert(item: $store.alert.sending(\.setAlert)) { alert in
            switch alert {
            case .isRegistered:
                return Alert(title: Text("Please Login"),
                             message: Text("Registration succeeded. Please log in again."),
                             dismissButton: .default(Text("OK"), action: {
                                 coordinator.perform(.pop)
                             }))
            case .error(let error):
                let message = error?.localizedDescription ?? ""
                return Alert(title: Text("Error"),
                             message: Text(message),
                             dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct RegisterScreen_Previews: PreviewProvider {
    static var previews: some View {
        return Container.shared.registerScreen.resolve()
    }
}
