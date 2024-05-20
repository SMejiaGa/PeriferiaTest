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
      
      override func viewDidLoad() {
          super.viewDidLoad()
          viewModel.delegate = self
          setupView()
          activityIndicator.startAnimating()
          viewModel.getMovies(isPopular: true, includeAdult: viewModel.isAdultSelected, language: viewModel.originalLanguage)
          emptyResultLabel.text = "There are no results with the selected filters"
      }
      
      @objc func segmentChanged() {
          viewModel.getMovies(isPopular: generalFilterSegmentedControl.selectedSegmentIndex == 0, includeAdult: viewModel.isAdultSelected, language: viewModel.originalLanguage)
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
  }

  extension MovieListViewController: MovieViewModelDelegate {
      
      func didReceiveMovies(_ movies: [Movie]) {
          DispatchQueue.main.async {
              self.moviesDataTableView.reloadData()
              self.moviesDataTableView.isHidden = movies.isEmpty
              self.activityIndicator.stopAnimating()
          }
      }
      
      func didFailWithError(_ error: Error) {
          DispatchQueue.main.async {
              print("Failed to get movies: \(error.localizedDescription)")
              self.activityIndicator.stopAnimating()
          }
      }
  }

  extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return viewModel.filteredMoviesList.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MovieTableViewCell else {
              return UITableViewCell()
          }
          if !viewModel.filteredMoviesList.isEmpty {
              let movie = viewModel.filteredMoviesList[indexPath.row]
              cell.config(movie: movie)
          }
          return cell
      }
  }

  extension MovieListViewController: FilterViewControllerDelegate {
      
      func didApplyFilters(includeAdult: Bool, language: String, voteAvg: (String, String)) {
          viewModel.updateFilters(includeAdult: includeAdult, language: language, voteAvg: voteAvg)
      }
  }

  extension MovieListViewController: UISearchBarDelegate {
      
      func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
          viewModel.filterMovies(searchedText: searchText)
      }
      
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          searchBar.endEditing(true)
      }
      
      func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
          searchBar.endEditing(true)
          searchBar.text = ""
          viewModel.filterMovies()
      }
  }
