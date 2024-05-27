//
//  SettingsCoordinator.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 22/05/2024.
//

import SwiftUI
import ComposableArchitecture
import FlowStacks
import Factory

enum SettingsScreenType {
    case settings(SettingsScreen)
}

enum SettingsFlowAction: NavigationAction {}

final class SettingsCoordinatorViewModel: ObservableObject, CoordinatorViewModel {
    @Published var routes: Routes<SettingsScreenType> = []
    @Injected(\.container) private var container

    init() {
        initRoutes()
    }

    private func initRoutes() {
        routes = [.root(.settings(container.settingsScreen(performNavigation)))]
    }

    func performNavigation(_: SettingsFlowAction) {}
}

struct SettingsCoordinator: View {
    @ObservedObject var viewModel: SettingsCoordinatorViewModel

    var body: some View {
        Router($viewModel.routes) { screen in
            switch screen {
            case .settings(let screen):
                screen
            }
        }
    }
}
