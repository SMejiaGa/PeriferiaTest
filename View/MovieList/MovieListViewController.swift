//
//  MovieListViewController.swift
//  PeriferiaTest
//
//  Created by Sebastian Mejia on 19/05/24.
//

import UIKit

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var moviesDataTableView: UITableView!
    @IBOutlet weak var generalFilterSegmentedControl: UISegmentedControl!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var emptyResultLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let cellIdentifier = "MovieTableViewCell"
    var viewModel = MovieViewModel()
    var moviesList: [Movie] = []
    var filteredMoviesList: [Movie] = []
    var isAdultSelected: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isAdultSelectedKey)
    var origianlLanguage: String =  UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedLanguageKey) ?? "en"
    var voteAverage = ( 
        UserDefaults.standard.string(forKey: UserDefaultsKeys.minVoteAverageKey) ?? "0",
        UserDefaults.standard.string(forKey: UserDefaultsKeys.maxVoteAverageKey) ?? "10")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupView()
        activityIndicator.startAnimating()
        applyFilters(includeAdult: isAdultSelected, language: origianlLanguage, voteAvg: voteAverage)
        emptyResultLabel.text = "There are no results with the selected filters"
    }
    
    @objc func segmentChanged() {
        applyFilters(includeAdult: isAdultSelected, language: origianlLanguage, voteAvg: voteAverage)
    }
    
    func applyFilters(includeAdult: Bool, language: String, voteAvg: (String, String)) {
        updateLocalVars()
        moviesDataTableView.isHidden = true
        viewModel.getMovies(isPopular: generalFilterSegmentedControl.selectedSegmentIndex == 0 ? true : false, includeAdult: includeAdult, language: language)
        getFilteredData()
        self.moviesDataTableView.isHidden = !self.filteredMoviesList.isEmpty

    }
    
    func setupView() {
        searchBar.delegate = self
        setupTableViews()
        setupFilterButton()
        generalFilterSegmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    func setupTableViews() {
        moviesDataTableView.dataSource = self
        moviesDataTableView.delegate = self
        moviesDataTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
    }
    
    func setupFilterButton() {
        filterButton.addTarget(self, action: #selector(showFilterView), for: .touchUpInside)
    }
    
    @objc func showFilterView() {
        let storyboard = UIStoryboard(name: "FiltersViewStoryboard", bundle: nil)
        if let filterVC = storyboard.instantiateViewController(withIdentifier: "FiltersViewController") as? FiltersViewController {
            filterVC.delegate = self
            present(filterVC, animated: true, completion: nil)
        }
    }
    
    func getFilteredData(searchedText: String = "") {
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
            self.moviesDataTableView.reloadData()
            self.moviesDataTableView.isHidden = !self.filteredMoviesList.isEmpty
        }
    }
    func updateLocalVars() {
         isAdultSelected = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isAdultSelectedKey)
         origianlLanguage =  UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedLanguageKey) ?? "en"
         voteAverage = (
            UserDefaults.standard.string(forKey: UserDefaultsKeys.minVoteAverageKey) ?? "0",
            UserDefaults.standard.string(forKey: UserDefaultsKeys.maxVoteAverageKey) ?? "10")
    }

    
}

extension MovieListViewController: MovieViewModelDelegate {
    
    func didReceiveMovies(_ movies: [Movie]) {
        moviesList = movies
        getFilteredData()
        DispatchQueue.main.async {
            self.moviesDataTableView.reloadData()
            self.moviesDataTableView.isHidden = false
        }
    }
    
    func didFailWithError(_ error: Error) {
        print("Failed to get movies: \(error.localizedDescription)")
    }
}

extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMoviesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        if !filteredMoviesList.isEmpty {
            let movie = filteredMoviesList[indexPath.row]
            cell.config(movie: movie)
        }
        return cell
    }
}


extension MovieListViewController: FilterViewControllerDelegate {
    
    func didApplyFilters(includeAdult: Bool, language: String, voteAvg: (String, String)) {
        applyFilters(includeAdult: includeAdult, language: language, voteAvg: voteAvg)
    }
}

extension MovieListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getFilteredData(searchedText: searchBar.text ?? String())
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = String()
        getFilteredData()
    }
}
