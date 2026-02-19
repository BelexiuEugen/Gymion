//
//  ExerciseVC.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 09.02.2026.
//

import UIKit

class ExerciseVC: UIViewController {
    
    
    var viewModel: ExerciseViewModel
    var exerciseTableView: UITableView = UITableView()
    
    init(persistenceStore: PersistenceStore){
        viewModel = ExerciseViewModel(persistenceStore: persistenceStore)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        setupBinding()
        configure()
    }
    
    func setupBinding(){
        viewModel.onError = { [weak self] message in
            self?.showAlert(message: message)
        }
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
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

        view.addSubview(exerciseTableView)
        exerciseTableView.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        if text.isEmpty {
            viewModel.filteredExercises = viewModel.exercises
        } else {
            viewModel.updateSearchingRange(searchText: text)
        }
        exerciseTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
        
        cell.textLabel?.text = viewModel.filteredExercises[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            
            let exercise = viewModel.exercises[indexPath.row]
            
            viewModel.deleteExercise(name: exercise) {[weak self] value in
                guard let self, value else { return }
                viewModel.exercises.remove(at: indexPath.row)
                viewModel.filteredExercises.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
}

extension ExerciseVC{

    @objc private func addButtonTapped() {
        let createVC = CreateExcersiseVC(persistenceStore: viewModel.persistenceStore)
        
        createVC.modalPresentationStyle = .overFullScreen
        createVC.modalTransitionStyle = .crossDissolve
        
        createVC.onDismiss = { [weak self] newValue in
            guard let self = self else { return }
            if newValue {
                self.viewModel.fetchExercises()
                self.exerciseTableView.reloadData()
            }
        }
        
        self.present(createVC, animated: true)
    }
}
