//
//  TopMovieFeature.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 23/05/2024.
//

import ComposableArchitecture
import Factory

@Reducer
struct TopMovieFeature {
    @Injected(\.movieRepository) private var repository

    @ObservableState
    struct State {
        var isLoading: Bool {
            return loadingCount > 0
        }

        var topRated: [Movie] = []
        var upcoming: [Movie] = []
        var loadingCount = 0
        var error: Error?
    }

    enum Action {
        case loadTopRatedMovies(isReload: Bool)
        case topRatedMoviesResponse(movies: [Movie])
        case loadUpcomingMovies(isReload: Bool)
        case upcomingMoviesMoviesResponse(movies: [Movie])
        case setLoading(Bool)
        case setError(Error?)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadTopRatedMovies(let isReload):
                if !isReload {
                    increaseLoading(&state)
                }
                return .run { send in
                    do {
                        let movies = try await repository.getTopRatedMovies(page: 1)
                        await send(.topRatedMoviesResponse(movies: movies))
                    } catch {
                        await send(.setError(error))
                    }
                }

            case .topRatedMoviesResponse(let movies):
                decreaseLoading(&state)
                state.topRated = movies
                return .none

            case .loadUpcomingMovies(let isReload):
                if !isReload {
                    increaseLoading(&state)
                }
                return .run { send in
                    do {
                        let movies = try await repository.getUpcomingMovies(page: 1)
                        await send(.upcomingMoviesMoviesResponse(movies: movies))
                    } catch {
                        await send(.setError(error))
                    }
                }

            case .upcomingMoviesMoviesResponse(let movies):
                decreaseLoading(&state)
                state.upcoming = movies
                return .none

            case .setLoading(let isLoading):
                state.loadingCount = isLoading ? 1 : 0
                return .none

            case .setError(let error):
                decreaseLoading(&state)
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
