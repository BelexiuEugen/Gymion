//
//  CreateWorkoutVC.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 04.03.2026.
//

import UIKit

class CreateWorkoutVC: UIViewController {
    
    var workoutTable: UITableView = UITableView()
    let viewModel = CreateWorkoutViewModel()
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        workoutTable = UITableView(frame: .zero, style: .grouped)
        workoutTable.delegate = self
        workoutTable.dataSource = self
        workoutTable.heightAnchor.constraint(equalToConstant: 400).isActive = true
        workoutTable.separatorStyle = .none
        workoutTable.dragInteractionEnabled = true
        workoutTable.dragDelegate = self
        workoutTable.dropDelegate = self
        workoutTable.translatesAutoresizingMaskIntoConstraints = false
        workoutTable.backgroundColor = .clear
        
        let tableLabel = GymionLabel(text: "New Template", textAlignment: .left, style: .bigTitle)
        workoutTable.tableHeaderView = tableLabel.addContainer(width: view.frame.width, containerHeight: 60, viewHeight: 40)
        
        
        let fotterAddExerciseButton = configureAddExerciseButton()
        
        workoutTable.tableFooterView = fotterAddExerciseButton
        
        view.addSubview(workoutTable)
        
        NSLayoutConstraint.activate([
            workoutTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            workoutTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            workoutTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            workoutTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            fotterAddExerciseButton.leadingAnchor.constraint(equalTo: workoutTable.leadingAnchor),
            fotterAddExerciseButton.trailingAnchor.constraint(equalTo: workoutTable.trailingAnchor)
        ])
    }
    
    func configureAddExerciseButton() -> UIView {
        let addExerciseButton = GymionButton(style: .addExercise, action: (self.createNewSection()))
        return addExerciseButton.addContainer(width: view.frame.width, containerHeight: 60, viewHeight: 40)
    }
    
    func createNewSection() {
        let workoutExercise = viewModel.exerciseEntries[0].exercise
        let newEntry = ExerciseEntry(exercise: workoutExercise, sets: [])
        Task{
            await viewModel.exerciseEntries.append(newEntry)
            
            workoutTable.insertSections(IndexSet(integer: viewModel.exerciseEntries.count - 1), with: .top)
        }
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
        let _ = GymionStack(spacing: 10, layout: .onlyTopAndBottom)
        
        let dataRow = WorkoutSetRowView(setName: "Set", previousLabel: "Previous", weight: " Kg ", reps: "Reps", isHeader: true)
        let setsStack = GymionStack(spacing: 5, layout: .onlyTopAndBottom)
        setsStack.addArrangedSubviews(dataRow)
        createSetRow(bodyStack: setsStack)
    }
    
    @objc func saveWorkout(){
        
    }
    
    func addNewSetFor(section: Int){
        viewModel.addSetFor(section: section)
        
        let indexPath = IndexPath(row: viewModel.exerciseEntries[section].sets.count - 1, section: section)
        workoutTable.beginUpdates()
        workoutTable.insertRows(at: [indexPath], with: .bottom)
        workoutTable.endUpdates()
    }
}

extension CreateWorkoutVC: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("I have this sections: \(viewModel.exerciseEntries.count)")
        return viewModel.exerciseEntries.count
    }
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerStack = GymionStack(axis: .vertical, spacing: 8)
        let label = GymionLabel(text: "Example of exercise", textAlignment: .left, style: .blueTitle)
        let row = WorkoutSetRowView(setName: "Sets", previousLabel: "Previous", weight: "KG", reps: "Reps", isHeader: true)
        headerStack.addArrangedSubviews(label, row)

        return headerStack.addContainer(width: tableView.frame.width, containerHeight: 80, viewHeight: 70)
    }
    
    //Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let button = GymionButton(style: .addSet, action: self.addNewSetFor(section: section))
        button.tag = section
        
        return button.addContainer(width: tableView.frame.width, containerHeight: 70, viewHeight: 30)
    }
    
    // Footer Height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    // Drag
    func tableView(_ tableView: UITableView, itemsForBeginning session: any UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        return [dragItem]
    }
    
    // Drop
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal{
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: any UITableViewDropCoordinator) {
//        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    
    // Section Size
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionNumber = viewModel.exerciseEntries[section].sets.count
        return sectionNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        
        let section = indexPath.section
        let row = indexPath.row
        
        let setName = String(viewModel.exerciseEntries[section].sets[row].setNumber)
        let weight = String(viewModel.exerciseEntries[section].sets[row].weight)
        let reps = String(viewModel.exerciseEntries[section].sets[row].reps)
        let previousLabel = weight + " x " + reps
        
        let rowView = WorkoutSetRowView(setName: setName, previousLabel: previousLabel, weight: weight, reps: reps)
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
    
    
    // Delete Action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in

            // First, update the model synchronously if possible
            // Remove the item from the view model for immediate consistency
            // If your viewModel.deleteSetFor is async, we optimistically update UI and persist in background
            // We'll call the async persistence after the animation.
            
            // Optimistically remove from model if you have a sync API; otherwise, proceed to UI update and trust your cell configuration uses indices
            // Here we assume your model is updated in the async call; we still animate immediately and then reload affected rows.
            
            Task { @MainActor in
                await self.viewModel.deleteSetFor(section: indexPath.section, row: indexPath.row)
                
                
                // Animate deletion
                tableView.performBatchUpdates {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                } completion: { _ in
                    // After deletion, reload only the rows below to update their displayed set numbers
                    let section = indexPath.section
                    // Compute the remaining count safely
                    let remainingCount = self.viewModel.exerciseEntries[section].sets.count
                    if indexPath.row < remainingCount {
                        let affected = (indexPath.row..<(remainingCount)).map { IndexPath(row: $0, section: section) }
                        if !affected.isEmpty {
                            tableView.reloadRows(at: affected, with: .fade)
                        }
                    }
                    completionHandler(true)
                }
            }

        }

        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    
    // if it's possible to move row
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
    // When Row Moved
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("I was moved from ", sourceIndexPath, " To ", destinationIndexPath)
    }
    
}

