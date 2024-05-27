//
//  MovieDetailFeature.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 24/05/2024.
//

import ComposableArchitecture
import Factory

@Reducer
struct MovieDetailFeature {
    let id: Int
    let performNavigation: (MovieFlowAction) -> Void
    @Injected(\.movieRepository) private var repository

    @ObservableState
    struct State {
        var isLoading: Bool {
            return loadingCount > 0
        }

        var loadingCount = 0
        var movie: Movie?
        var error: Error?
    }

    enum Action {
        case loadMovie(isReload: Bool)
        case movieResponse(movie: Movie)
        case setLoading(Bool)
        case setError(Error?)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadMovie(let isReload):
                if !isReload {
                    increaseLoading(&state)
                }
                return .run { send in
                    do {
                        let movie = try await repository.getMovieDetail(id: id)
                        await send(.movieResponse(movie: movie))
                    } catch {
                        await send(.setError(error))
                    }
                }

            case .movieResponse(let movie):
                decreaseLoading(&state)
                state.movie = movie
                return .none

            case .setLoading(let isLoading):
                state.loadingCount = isLoading ? 1 : 0
                return .none

            case .setError(let error):
                state.error = error
                return .none
            }
        }
    }

    private func increaseLoading(_ state: inout State) {
        state.loadingCount += 1
    }

    private func decreaseLoading(_ state: inout State) {
        if state.loadingCount > 0 {
            state.loadingCount -= 1
        }
    }
}
