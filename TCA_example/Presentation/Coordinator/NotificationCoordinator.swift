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
    @Injected(\.factory) private var factory

    init() {
        perform(.initRoute)
    }

    func perform(_ action: NotificationFlowAction) {
        switch action {
        case .initRoute:
            let screen = factory.notificationScreen.resolve()
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
        .environmentObject(viewModel)
    }
}
