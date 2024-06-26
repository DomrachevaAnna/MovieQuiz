//
//  MovesLoader.swift
//  MovieQuiz
//
//  Created by Anna Domracheva on 26.06.2024.
//

import Foundation

protocol MovesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
struct MovesLoader: MovesLoading {
    //MARK: NetworkClient
    private let networkClient = NetworkClient()
    
    //MARK: URL
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    print("Получен ответ от сервера")
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    print(mostPopularMovies)
                    handler(.success(mostPopularMovies))
                } catch {
                    print("Запрос вернулся с ошибкой \(error)")
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
