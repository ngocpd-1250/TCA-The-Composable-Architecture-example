//
//  AuthCoordinator.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 20/05/2024.
//

import Foundation
import SwiftUI
import FlowStacks
import ComposableArchitecture
import Defaults
import Factory

enum AuthScreenType {
    case onboarding(OnboardingScreen)
    case login(LoginScreen)
    case register(RegisterScreen)
}

enum AuthFlowAction: NavigationAction {
    case initRoute
    case toLogin
    case toRegister
    case pop
}

final class AuthCoordinatorViewModel: ObservableObject, CoordinatorViewModel {
    @Published var routes: Routes<AuthScreenType> = []
    @Injected(\.factory) private var factory

    init() {
        perform(.initRoute)
    }

    func perform(_ action: AuthFlowAction) {
        switch action {
        case .initRoute:
            let isOnboardingCompleted = Defaults[.isOnboardingCompleted]
            let loginScreen = factory.loginScreen.resolve()
            let onboardingScreen = factory.onboardingScreen.resolve()
            routes = [.root(isOnboardingCompleted ? .login(loginScreen) : .onboarding(onboardingScreen),
                            embedInNavigationView: true)]
        case .toLogin:
            let screen = factory.loginScreen.resolve()
            routes = [.root(.login(screen),
                            embedInNavigationView: true)]
        case .toRegister:
            let screen = factory.registerScreen.resolve()
            routes.push(.register(screen))
        case .pop:
            routes.pop()
        }
    }
}

struct AuthCoordinator: View {
    @ObservedObject var viewModel: AuthCoordinatorViewModel

    var body: some View {
        Router($viewModel.routes) { screen in
            switch screen {
            case .onboarding(let screen):
                screen
            case .login(let screen):
                screen
            case .register(let screen):
                screen
            }
        }
        .environmentObject(viewModel)
    }
}
