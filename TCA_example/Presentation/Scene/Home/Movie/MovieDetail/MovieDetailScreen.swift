//
//  MovieDetailScreen.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 24/05/2024.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct MovieDetailScreen: View {
    @Bindable var store: StoreOf<MovieDetailFeature>

    init(store: StoreOf<MovieDetailFeature>) {
        self.store = store
    }

    @ViewBuilder
    func backdrop(movie: Movie) -> some View {
        ZStack(alignment: .bottom) {
            if let url = URL(string: movie.backdropUrl) {
                VStack(alignment: .leading) {
                    KFImage(url)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 210)
                        .frame(maxWidth: .infinity)

                    Spacer()
                        .frame(height: 40)
                }
            }
            if let url = URL(string: movie.posterUrl) {
                HStack(alignment: .bottom) {
                    KFImage(url)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 90, height: 120)
                        .cornerRadius(8)

                    Spacer()
                }
                .padding(.horizontal, Spacing.normal.value)
            }
        }
    }

    @ViewBuilder
    func info(movie: Movie) -> some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(R.image.icon_rating)
                        .frame(width: 16, height: 16)
                    Text("\(Int(movie.voteAverage))/10")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(R.color.orangeFlush))
                }

                Text("\(R.string.localizable.movieRelease()): \(formatDate(movie.releaseDate))")
                    .fontWeight(.bold)

                    .foregroundStyle(Color(R.color.labelPrimary))

                Text("\(movie.overview)")
                    .padding(.top, Spacing.small.value)
                    .foregroundStyle(Color(R.color.labelPrimary))
            }
            .padding(.horizontal, Spacing.normal.value)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    var body: some View {
        Screen(isLoading: .constant(store.isLoading), title: store.movie?.title) {
            ScrollView {
                Group {
                    if let movie = store.movie {
                        VStack(spacing: 16) {
                            backdrop(movie: movie)
                            info(movie: movie)
                        }
                    } else {
                        VStack {}
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .refreshable {
                store.send(.loadMovie(isReload: true))
            }
        }
        .onAppear {
            store.send(.loadMovie(isReload: false))
        }
    }
}
