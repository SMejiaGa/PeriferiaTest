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
    
    let cellIdentifier = "MovieTableViewCell"
    var viewModel = MovieViewModel()
    var moviesList: [Movie] = []
    var filteredMoviesList: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupView()
        applyFilters(includeAdult: false, language: "en", voteAvg: ("0", "10"))
        print("print works!")
    }
    
    @objc func segmentChanged() {
        applyFilters(includeAdult: false, language: "en", voteAvg: ("0","10"))
    }
    
    func applyFilters(includeAdult: Bool, language: String, voteAvg: (String, String)) {
        moviesDataTableView.isHidden = true
        viewModel.getMovies(isPopular: generalFilterSegmentedControl.selectedSegmentIndex == 0 ? true : false, includeAdult: includeAdult, language: language, voteAvg: voteAvg)
    }
    
    func setupView() {
        setupTableViews()
        generalFilterSegmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    func setupTableViews() {
        moviesDataTableView.dataSource = self
        moviesDataTableView.delegate = self
        moviesDataTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
    }
    
}

extension MovieListViewController: MovieViewModelDelegate {
    
    func didReceiveMovies(_ movies: [Movie]) {
        filteredMoviesList = movies.filter { $0.overview.isEmpty == false }
        moviesList = filteredMoviesList
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
        return moviesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let movie = moviesList[indexPath.row]
        cell.config(movie: movie)
        return cell
        
    }
}

extension UIImageView {
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Error converting data to image")
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
