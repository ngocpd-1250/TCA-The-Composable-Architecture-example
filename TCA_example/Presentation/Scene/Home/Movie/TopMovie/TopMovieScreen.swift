//
//  TopMovie.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 23/05/2024.
//

import SwiftUI
import ComposableArchitecture
import Factory

struct TopMoviesScreen: View {
    @Bindable var store: StoreOf<TopMovieFeature>

    init(store: StoreOf<TopMovieFeature>) {
        self.store = store
    }

    @ViewBuilder
    func upcomingMovies(upcomingMovies: [Movie]) -> some View {
        Section(title: R.string.localizable.movieUpcoming()) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(upcomingMovies) { movie in
                        Button {
                            store.send(.toDetail(id: movie.id))
                        } label: {
                            HorizontalMovieCard(movie: movie)
                        }
                        .tint(.black)
                    }
                }
            }
        }
    }

    @ViewBuilder
    func topRatedMovies(topRatedMovies: [Movie]) -> some View {
        Section(title: R.string.localizable.movieTopRated()) {
            ForEach(topRatedMovies) { movie in
                Button {
                    store.send(.toDetail(id: movie.id))
                } label: {
                    VerticalMovieCard(movie: movie)
                }
                .tint(.black)
            }
        }
    }

    var body: some View {
        Screen(isLoading: .constant(store.isLoading),
               localizeTitleResource: R.string.localizable.movieWatchTitle) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    if !store.upcoming.isEmpty {
                        upcomingMovies(upcomingMovies: store.upcoming)
                    }
                    if !store.topRated.isEmpty {
                        topRatedMovies(topRatedMovies: store.topRated)
                    }
                }
            }
            .padding(Spacing.normal.value)
            .refreshable {
                store.send(.loadTopRatedMovies(isReload: true))
                store.send(.loadUpcomingMovies(isReload: true))
            }
        }
        .onFirstAppear {
            store.send(.loadTopRatedMovies(isReload: false))
            store.send(.loadUpcomingMovies(isReload: false))
        }
        .alert(isPresented: Binding<Bool>(
            get: { store.error != nil },
            set: { _ in store.send(.setError(nil)) })
        ) {
            Alert(title: Text("Error"),
                  message: Text(store.error?.localizedDescription ?? ""),
                  dismissButton: .default(Text("OK")))
        }
    }
}

struct TopMovieScreen_Previews: PreviewProvider {
    static var previews: some View {
        let perform: (MovieFlowAction) -> Void = { _ in
        }
        return Container.shared.topMovieScreen(perform)
    }
}
