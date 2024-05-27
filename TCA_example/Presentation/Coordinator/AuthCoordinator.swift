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
    @Injected(\.container) private var container

    init() {
        performNavigation(.initRoute)
    }

    func performNavigation(_ action: AuthFlowAction) {
        switch action {
        case .initRoute:
            let isOnboardingCompleted = Defaults[.isOnboardingCompleted]
            let loginScreen = container.loginScreen(performNavigation)
            let onboardingScreen = container.onboardingScreen(performNavigation)
            routes = [.root(isOnboardingCompleted ? .login(loginScreen) : .onboarding(onboardingScreen),
                            embedInNavigationView: true)]
        case .toLogin:
            let screen = container.loginScreen(performNavigation)
            routes = [.root(.login(screen),
                            embedInNavigationView: true)]
        case .toRegister:
            let screen = container.registerScreen(performNavigation)
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
    }
}
