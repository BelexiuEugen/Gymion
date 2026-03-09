//
//  CreateWorkoutVC.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 04.03.2026.
//

import UIKit

class CreateWorkoutVC: UIViewController {

    let bodyStack: GymionStack = GymionStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    func configure(){
        configureTopBar()
        configureBody()
    }
    
    func configureTopBar(){
        configureDismissButton()
        configureTopBarName()
        configureSaveButton()
    }
    
    func configureDismissButton(){
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        
        dismissButton.tintColor = .systemRed
        
        navigationItem.leftBarButtonItem = dismissButton
    }
    
    func configureTopBarName(){
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "New Template"
    }
    
    func configureSaveButton(){
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveWorkout))
        
        saveButton.tintColor = .systemBlue
        
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func configureBody() {
        // Outer vertical stack view
        let outerStack = GymionStack()
        view.addSubview(outerStack)

        // Scroll view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        outerStack.addArrangedSubview(scrollView)

        // Content stack inside scroll view
        let contentStack = GymionStack(distribution: .fill)
        scrollView.addSubview(contentStack)

        // Label aligned to upper left
        let titleLabel = GymionLabel(text: "New Template", textAlignment: .left, style: .bigTitle)
        contentStack.addArrangedSubview(titleLabel)

        // Add some spacing below the label
        contentStack.addArrangedSubviews(bodyStack)

        // Button stretches horizontally
        let addExerciseButton = configureAddExerciseButton()
        contentStack.addArrangedSubview(addExerciseButton)

        NSLayoutConstraint.activate([
            outerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            outerStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            outerStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            outerStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            scrollView.widthAnchor.constraint(equalTo: outerStack.widthAnchor),
            scrollView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0), // Avoid ambiguity

            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
    }
    
    func configureAddExerciseButton() -> UIButton{
        
        let addExerciseButton = GymionButton(style: .addExercise, action: self.addNewExercise())
        return addExerciseButton
        
    }
    
    func createDataRow() -> GymionStack{
        let dataRow = GymionStack(axis: .horizontal, spacing: 5, distribution: .fill)
        
        let setLabel = GymionLabel(text: "Set", textAlignment: .center)
        let previousLabel = GymionLabel(text: "Previous", textAlignment: .center)
        let weightLabel = GymionLabel(text: "Weight", textAlignment: .center)
        let repsLabel = GymionLabel(text: "Reps", textAlignment: .center)
        
        dataRow.addArrangedSubviews(setLabel, previousLabel, weightLabel, repsLabel)
        
        return dataRow
    }
    
    func createSetRow(bodyStack: UIStackView){

        let myView = WorkoutSetRowView(setName: "1", previousLabel: "80 Kg x 12", weight: "20", reps: "20")
        
        bodyStack.addArrangedSubview(myView)
    }
    
    func createNewSetButton() -> GymionButton{
        let myButton = GymionButton(style: .addSet, action: ())
        return myButton
    }
}

extension CreateWorkoutVC{
    @objc func dismissView(){
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        transition.type = .reveal
        transition.subtype = .fromBottom
        
        self.navigationController?.view.layer.add(transition, forKey: nil)
        
        navigationController?.popViewController(animated: false)
    }
    
    func addNewExercise(){
        let newExerciseExample = GymionStack(spacing: 10, layout: .onlyTopAndBottom)
        
        let exerciseName = GymionLabel(text: "Example of exercise", textAlignment: .left, style: .blueTitle)
        let dataRow = WorkoutSetRowView(setName: "Set", previousLabel: "Previous", weight: " Kg ", reps: "Reps", isHeader: true)
        let setsStack = GymionStack(spacing: 5, layout: .onlyTopAndBottom)
        setsStack.addArrangedSubviews(dataRow)
        createSetRow(bodyStack: setsStack)
        
        let setsTable = UITableView()
        setsTable.delegate = self
        setsTable.dataSource = self
        setsTable.heightAnchor.constraint(equalToConstant: 400).isActive = true
        setsTable.separatorStyle = .none
        setsTable.dragInteractionEnabled = true
        setsTable.dragDelegate = self
        setsTable.dropDelegate = self
        
        let newSetButton = GymionButton(style: .addSet, action: self.createSetRow(bodyStack: setsStack))
        
        newExerciseExample.addArrangedSubviews(exerciseName, setsTable, newSetButton)
        bodyStack.addArrangedSubviews(newExerciseExample)
    }
    
    @objc func saveWorkout(){
        
    }
}

extension CreateWorkoutVC: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate{
    func tableView(_ tableView: UITableView, itemsForBeginning session: any UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal{
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: any UITableViewDropCoordinator) {
//        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        
        
        let rowView = WorkoutSetRowView(setName: "1", previousLabel: "80 kg x 12", weight: "KG", reps: "Reps")
        rowView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.contentView.addSubview(rowView)
        
        // Pin it to the edges of the cell
        NSLayoutConstraint.activate([
            rowView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            rowView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            rowView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
}

