//
//  FiltersViewController.swift
//  PeriferiaTest
//
//  Created by Sebastian Mejia on 20/05/24.
//

import UIKit

class FiltersViewController: UIViewController {
    
    @IBOutlet weak var includeAdultSwitch: UISwitch!
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var minVoteAverageTextField: UITextField!
    @IBOutlet weak var maxVoteAverageTextField: UITextField!
    
    weak var delegate: FilterViewControllerDelegate?
    
    var selectedLanguage: String = "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        includeAdultSwitch.isOn = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isAdultSelectedKey)
        languageTextField.text = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedLanguageKey) ?? "en"
        minVoteAverageTextField.text = UserDefaults.standard.string(forKey: UserDefaultsKeys.minVoteAverageKey) ?? "0"
        maxVoteAverageTextField.text = UserDefaults.standard.string(forKey: UserDefaultsKeys.maxVoteAverageKey) ?? "10"
    }
    @IBAction func applyFiltersButtonTapped(_ sender: Any) {
        let includeAdult = includeAdultSwitch.isOn
        let language = languageTextField.text ?? "en"
        let minVoteAvg = minVoteAverageTextField.text ?? "0"
        let maxVoteAvg = maxVoteAverageTextField.text ?? "10"
        
        UserDefaults.standard.set(includeAdult, forKey: UserDefaultsKeys.isAdultSelectedKey)
        UserDefaults.standard.set(language, forKey: UserDefaultsKeys.selectedLanguageKey)
        UserDefaults.standard.set(minVoteAvg, forKey: UserDefaultsKeys.minVoteAverageKey)
        UserDefaults.standard.set(maxVoteAvg, forKey: UserDefaultsKeys.maxVoteAverageKey)
        
        delegate?.didApplyFilters(includeAdult: includeAdult, language: language, voteAvg: (minVoteAvg, maxVoteAvg))
        
        dismiss(animated: true, completion: nil)
    }
}
