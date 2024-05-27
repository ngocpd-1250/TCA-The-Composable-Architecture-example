//
//  MovieCoordinator.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 22/05/2024.
//

import SwiftUI
import ComposableArchitecture
import FlowStacks
import Factory

enum MovieScreenType {
    case movieList(TopMoviesScreen)
    case movieDetail(MovieDetailScreen)
}

enum MovieFlowAction: NavigationAction {
    case initRoute
    case toMovieDetail(id: Int)
}

final class MovieCoordinatorViewModel: ObservableObject, CoordinatorViewModel {
    @Published var routes: Routes<MovieScreenType> = []
    @Injected(\.container) private var container

    init() {
        performNavigation(.initRoute)
    }

    func performNavigation(_ action: MovieFlowAction) {
        switch action {
        case .initRoute:
            routes = [.root(.movieList(container.topMovieScreen(performNavigation)),
                            embedInNavigationView: true)]
        case .toMovieDetail(let id):
            let params = (id, performNavigation)
            routes.push(.movieDetail(container.movieDetailScreen(params)))
        }
    }
}

struct MovieCoordinator: View {
    @ObservedObject var viewModel: MovieCoordinatorViewModel

    var body: some View {
        Router($viewModel.routes) { screen in
            switch screen {
            case .movieList(let screen):
                screen
            case .movieDetail(let screen):
                screen
            }
        }
    }
}
