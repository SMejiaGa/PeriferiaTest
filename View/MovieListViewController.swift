//
//  MovieListViewController.swift
//  PeriferiaTest
//
//  Created by Sebastian Mejia on 19/05/24.
//

import UIKit

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var popularTableView: UITableView!
    @IBOutlet weak var topRatedTableView: UITableView!
    @IBOutlet weak var generalFilterSegmentedControl: UISegmentedControl!
    let cellIdentifier = "MoviesListTableViewTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        generalFilterSegmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        view.addSubview(generalFilterSegmentedControl)
        
        popularTableView.dataSource = self
        popularTableView.delegate = self
        popularTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        topRatedTableView.dataSource = self
        topRatedTableView.delegate = self
        topRatedTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        view.addSubview(popularTableView)
    }
    
    @objc func segmentChanged() {
        if generalFilterSegmentedControl.selectedSegmentIndex == 0 {
            topRatedTableView.isHidden = true
            popularTableView.isHidden = false

        } else {
            topRatedTableView.isHidden = false
            popularTableView.isHidden = true
        }
    }
}

extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == popularTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            cell.textLabel?.text = "Table 1 Row \(indexPath.row)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            cell.textLabel?.text = "Table 2 Row \(indexPath.row)"
            return cell
        }
    }
}
