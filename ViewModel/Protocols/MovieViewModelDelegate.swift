//
//  MovieViewModelDelegate.swift
//  PeriferiaTest
//
//  Created by Sebastian Mejia on 19/05/24.
//

import Foundation

protocol MovieViewModelDelegate: AnyObject {
    func didReceiveMovies(_ movies: [Movie])
    func didFailWithError(_ error: Error)
}
