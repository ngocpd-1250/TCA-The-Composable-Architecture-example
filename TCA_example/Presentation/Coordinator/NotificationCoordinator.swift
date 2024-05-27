//
//  NotificationCoordinator.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 29/05/2024.
//

import SwiftUI
import ComposableArchitecture
import FlowStacks
import Factory

enum NotificationScreenType {
    case notification(NotificationScreen)
}

enum NotificationFlowAction: NavigationAction {
    case initRoute
}

final class NotificationCoordinatorViewModel: ObservableObject, CoordinatorViewModel {
    @Published var routes: Routes<NotificationScreenType> = []
    @Injected(\.container) private var container

    init() {
        performNavigation(.initRoute)
    }

    func performNavigation(_ action: NotificationFlowAction) {
        switch action {
        case .initRoute:
            let screen = container.notificationScreen(performNavigation)
            routes = [.root(.notification(screen))]
        }
    }
}

struct NotificationCoordinator: View {
    @ObservedObject var viewModel: NotificationCoordinatorViewModel

    var body: some View {
        Router($viewModel.routes) { screen in
            switch screen {
            case .notification(let screen):
                screen
            }
        }
    }
}
