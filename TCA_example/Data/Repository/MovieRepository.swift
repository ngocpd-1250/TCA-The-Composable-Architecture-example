//
//  MovieRepository.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 23/05/2024.
//

import Foundation

protocol MovieRepository {
    func getTopRatedMovies(page: Int) async throws -> [Movie]
    func getUpcomingMovies(page: Int) async throws -> [Movie]
    func getMovieDetail(id: Int) async throws -> Movie
}

struct MovieRepositoryImpl: MovieRepository {
    func getTopRatedMovies(page _: Int) async throws -> [Movie] {
        let input = API.GetTopRatedMoviesInput()
        return try await API.shared.getTopRatedMovies(input).movies
    }

    func getUpcomingMovies(page _: Int) async throws -> [Movie] {
        let input = API.GetUpcomingMoviesInput()
        return try await API.shared.getUpcomingMovies(input).movies
    }

    func getMovieDetail(id: Int) async throws -> Movie {
        let input = API.GetMovieDetailInput(id: id)
        return try await API.shared.getMovieDetail(input).movie
    }
}
