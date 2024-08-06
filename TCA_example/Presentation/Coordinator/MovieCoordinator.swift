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
    @Injected(\.factory) private var factory

    init() {
        perform(.initRoute)
    }

    func perform(_ action: MovieFlowAction) {
        switch action {
        case .initRoute:
            routes = [.root(.movieList(factory.topMovieScreen.resolve()),
                            embedInNavigationView: true)]
        case .toMovieDetail(let id):
            routes.push(.movieDetail(factory.movieDetailScreen(id)))
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
        .environmentObject(viewModel)
    }
}
