//
//  HomeCoordinator.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 21/05/2024.
//

import Foundation
import SwiftUI
import FlowStacks
import ComposableArchitecture
import Factory

enum HomeScreenType {
    case home(HomeMainScreen)
}

enum HomeFlowAction: NavigationAction {
    case initRoute
}

final class HomeCoordinatorViewModel: ObservableObject, CoordinatorViewModel {
    @Published var routes: Routes<HomeScreenType> = []
    @Injected(\.container) private var container

    init() {
        performNavigation(.initRoute)
    }

    func performNavigation(_ action: HomeFlowAction) {
        switch action {
        case .initRoute:
            let homeScreen = HomeMainScreen()
            routes = [.root(.home(homeScreen), embedInNavigationView: true)]
        }
    }
}

struct HomeCoordinator: View {
    @ObservedObject var viewModel: HomeCoordinatorViewModel

    var body: some View {
        Router($viewModel.routes) { screen in
            switch screen {
            case .home(let screen):
                screen
            }
        }
    }
}
