//
//  MovieViewModel.swift
//  PeriferiaTest
//
//  Created by Sebastian Mejia on 19/05/24.
//

import Foundation

class MovieViewModel {
    
    weak var delegate: MovieViewModelDelegate?
    private var networkService: MovieService

    init(networkService: MovieService = MovieService()) {
        self.networkService = networkService
    }

    func getMovies(isPopular: Bool, includeAdult: Bool, language: String)  {
        networkService.fetchMovies(isPopular: isPopular, includeAdult: includeAdult, language: language) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.delegate?.didReceiveMovies(movies)
            case .failure(let error):
                self?.delegate?.didFailWithError(error)
            }
        }
    }
}
