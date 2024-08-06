//
//  LoginScreen.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 20/05/2024.
//

import SwiftUI
import ComposableArchitecture
import FlowStacks
import Factory

struct LoginScreen: View {
    @Bindable var store: StoreOf<LoginFeature>
    @EnvironmentObject var coordinator: AuthCoordinatorViewModel

    init(store: StoreOf<LoginFeature>) {
        self.store = store
    }

    var body: some View {
        Screen(isLoading: .constant(store.isLoading)) {
            VScrollView {
                VStack {
                    Text(R.string.localizable.commonLogin())
                        .font(.title)
                        .padding(.bottom, Spacing.medium.value)
                        .foregroundStyle(Color(R.color.primary))

                    BaseTextField(text: $store.username.sending(\.usernameChanged),
                                  placeholder: R.string.localizable.commonUsername(),
                                  image: Image(R.image.icon_email),
                                  errorMessage: store.usernameValidationMessage)
                        .padding(.bottom)

                    BaseTextField(text: $store.password.sending(\.passwordChanged),
                                  placeholder: R.string.localizable.commonPassword(),
                                  image: Image(R.image.icon_password),
                                  isSecure: true,
                                  errorMessage: store.passwordValidationMessage)
                        .padding(.bottom)

                    BaseButton(title: R.string.localizable.commonLogin(), isEnabled: store.isEnable) {
                        store.send(.login)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .padding(.top, Spacing.normal.value)

                    Text(R.string.localizable.commonDontHaveAccount())
                        .padding(.top, Spacing.extraLarge.value)

                    Button {
                        coordinator.perform(.toRegister)
                    } label: {
                        Text(R.string.localizable.commonRegister())
                            .foregroundStyle(Color(R.color.primary))
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: Binding<Bool>(
            get: { store.error != nil },
            set: { _ in store.send(.setError(nil)) })
        ) {
            Alert(title: Text("Error"),
                  message: Text(store.error?.localizedDescription ?? ""),
                  dismissButton: .default(Text("OK")))
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        return Container.shared.loginScreen.resolve()
    }
}
