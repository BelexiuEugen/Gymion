//
//  ExerciseVC.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 09.02.2026.
//

import UIKit

class ExerciseVC: UIViewController {
    
    
    var viewModel: ExerciseViewModel = ExerciseViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        
        configure()
    }
    
    func configure(){
        configureAddButton()
        configureSearchBar()
        configureTableView()
    }
    
    func configureAddButton(){
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureSearchBar(){
        let exerciseSearchBar = UISearchController(searchResultsController: nil)
        exerciseSearchBar.searchBar.placeholder = "Search Exercise"
        exerciseSearchBar.searchResultsUpdater = self
        exerciseSearchBar.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = exerciseSearchBar
        
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func configureTableView(){
        let exerciseTableView = UITableView()
        
        exerciseTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(exerciseTableView)
        
        exerciseTableView.dataSource = self
        exerciseTableView.delegate = self
        
        NSLayoutConstraint.activate([
            exerciseTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            exerciseTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            exerciseTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            exerciseTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        exerciseTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension ExerciseVC: UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
            guard let text = searchController.searchBar.text else { return }
            print("User is typing: \(text)")
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
        
        cell.textLabel?.text = viewModel.exercises[indexPath.row]
        return cell
    }
    
    
}

extension ExerciseVC{

    @objc private func addButtonTapped() {
        let createVC = CreateExcersiseVC()
        
        createVC.modalPresentationStyle = .overCurrentContext
        createVC.modalTransitionStyle = .crossDissolve
        
        self.present(createVC, animated: true)
    }
}
