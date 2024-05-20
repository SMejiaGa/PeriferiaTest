//
//  FilterViewControllerDelegate.swift
//  PeriferiaTest
//
//  Created by Sebastian Mejia on 20/05/24.
//

import Foundation

protocol FilterViewControllerDelegate: AnyObject {
    func didApplyFilters(includeAdult: Bool, language: String, voteAvg: (String, String))
}
