//
//  MovieTableViewCell.swift
//  PeriferiaTest
//
//  Created by Sebastian Mejia on 19/05/24.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(movie: Movie) {
        movieNameLabel.text = "\(movie.adult ? "+18!: " : "")\(movie.title)"
        releaseDateLabel.text = movie.releaseDate
        overviewLabel.text = movie.overview
        ratingLabel.text =  String(movie.voteAverage)
        
    }
    
}
