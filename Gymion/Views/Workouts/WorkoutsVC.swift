//
//  WorkoutsVC.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 09.02.2026.
//

import UIKit

class WorkoutsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure(){
        configureSearchBar()
        configureAddButton()
    }
    
    func configureSearchBar(){
        let workoutSearchBar = UISearchController(searchResultsController: nil)
        workoutSearchBar.searchBar.placeholder = "Search Workout"
        workoutSearchBar.searchResultsUpdater = self
        workoutSearchBar.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = workoutSearchBar
        
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func configureAddButton(){
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        navigationItem.rightBarButtonItem = addButton
    }

}

extension WorkoutsVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension WorkoutsVC{
    @objc func addButtonTapped(){
        
        let nextVC = CreateWorkoutVC()
        
        nextVC.hidesBottomBarWhenPushed = true
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        transition.type = .moveIn
        transition.subtype = .fromTop
        
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        
        
        
        navigationController?.pushViewController(nextVC, animated: false)
    }
}
