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
    private var moviesList: [Movie] = []
    private(set) var filteredMoviesList: [Movie] = []
    
    var isAdultSelected: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isAdultSelectedKey)
    var originalLanguage: String = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedLanguageKey) ?? "en"
    var voteAverage = (
        UserDefaults.standard.string(forKey: UserDefaultsKeys.minVoteAverageKey) ?? "0",
        UserDefaults.standard.string(forKey: UserDefaultsKeys.maxVoteAverageKey) ?? "10"
    )
    
    init(networkService: MovieService = MovieService()) {
        self.networkService = networkService
    }
    
    func getMovies(isPopular: Bool, includeAdult: Bool, language: String) {
        networkService.fetchMovies(isPopular: isPopular, includeAdult: includeAdult, language: language) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.moviesList = movies
                self?.filterMovies(searchedText: "")
                self?.delegate?.didReceiveMovies(self?.filteredMoviesList ?? [])
            case .failure(let error):
                self?.delegate?.didFailWithError(error)
            }
        }
    }
    
    func filterMovies(searchedText: String = "") {
        var minVoteAverage = Double(voteAverage.0) ?? 0.0
        var maxVoteAverage = Double(voteAverage.1) ?? 10.0
        
        if minVoteAverage > maxVoteAverage {
            minVoteAverage = maxVoteAverage
        }
        
        filteredMoviesList = moviesList.filter { movie in
            let matchesTitle = searchedText.isEmpty ? true : movie.title.lowercased().contains(searchedText.lowercased())
            let matchesVoteAverage = (minVoteAverage...maxVoteAverage).contains(Double(movie.voteAverage))
            return matchesTitle && matchesVoteAverage
        }.filter { !$0.overview.isEmpty }
        
        DispatchQueue.main.async {
            self.delegate?.didReceiveMovies(self.filteredMoviesList)
        }
    }
    
    func updateFilters(includeAdult: Bool, language: String, voteAvg: (String, String)) {
        isAdultSelected = includeAdult
        originalLanguage = language
        voteAverage = voteAvg
        getMovies(isPopular: true, includeAdult: includeAdult, language: language)
    }
}
