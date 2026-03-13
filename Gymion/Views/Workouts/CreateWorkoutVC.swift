//
//  CreateWorkoutVC.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 04.03.2026.
//

import UIKit

class CreateWorkoutVC: UIViewController {
    
    var workoutTable: UITableView = UITableView()
    let viewModel: CreateWorkoutViewModel

    // MARK: – Section drag state
    private var draggingSourceSection: Int?
    private var draggingCurrentSection: Int?
    private var snapshotView: UIView?
    private var dragInitialTouchY: CGFloat = 0
    private var dragInitialSnapshotCenterY: CGFloat = 0
    private var lastDragTouchY: CGFloat = 0
    
    init(persistenceStore: any PersistenceStore){
        self.viewModel = CreateWorkoutViewModel(persistenceStore: persistenceStore)
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

        // Long-press drives the Strong-style section reorder.
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleSectionDrag(_:)))
        longPress.minimumPressDuration = 0.4
        longPress.delegate = self
        workoutTable.addGestureRecognizer(longPress)
    }
    
    func configureAddExerciseButton() -> UIView {
        let addExerciseButton = GymionButton(style: .addExercise, action: (self.createNewSection()))
        return addExerciseButton.addContainer(width: view.frame.width, containerHeight: 60, viewHeight: 40)
    }
    
    func createNewSection() {
        let exerciseVC = ExerciseVC(persistenceStore: viewModel.persistenceStore)
        let stack = UINavigationController(rootViewController: exerciseVC)
        
        exerciseVC.onSelect = { [weak self] exercise in
            guard let self = self else { return }
            self.dismiss(animated: true)
            viewModel.addNewSection(exercise: exercise)
            workoutTable.insertSections(IndexSet(integer: viewModel.exerciseEntries.count - 1), with: .top)
        }
        
        self.present(stack, animated: true)
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
        dismissController()
    }
    
    func dismissController(){
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
        viewModel.saveWorkout()
        dismissController()
        
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
        let verticalStack = GymionStack(axis: .horizontal)

        let exerciseName = viewModel.exerciseEntries[section].exercise.name
        let label = GymionLabel(text: exerciseName, textAlignment: .left, style: .blueTitle)

        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self]_ in
            self?.viewModel.deleteSection(section: section)
            tableView.performBatchUpdates {
                tableView.deleteSections(IndexSet(integer: section), with: .automatic)
            } completion: { _ in
                tableView.reloadData()
            }
        }

        verticalStack.addArrangedSubviews(label)

        if !viewModel.isHeaderSelected {
            let spacer = UIView()
            spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
            let menuOptions = GymionButton(style: .menu, action: ())
            menuOptions.menu = UIMenu(title: "menu", children: [deleteAction])
            menuOptions.showsMenuAsPrimaryAction = true
            verticalStack.addArrangedSubviews(spacer, menuOptions)
        }

        headerStack.addArrangedSubview(verticalStack)

        if !viewModel.isHeaderSelected {
            let row = WorkoutSetRowView(setName: "Sets", previousLabel: "Previous", weight: "KG", reps: "Reps", isHeader: true)
            headerStack.addArrangedSubview(row)
        }
        
        let container = headerStack.addContainer(width: tableView.frame.width, containerHeight: 80, viewHeight: 70)
        container.tag = section + 1000
        // While its snapshot floats above, hide the original slot completely.
        label.alpha = (draggingSourceSection == section) ? 0 : 1
        return container
    }
    
    
    //Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if !viewModel.isHeaderSelected{
            
            let button = GymionButton(style: .addSet, action: self.addNewSetFor(section: section))
            button.tag = section
            
            return button.addContainer(width: tableView.frame.width, containerHeight: 70, viewHeight: 30)
        }
        
        return nil
    }
    
    // Footer Height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if viewModel.isHeaderSelected { return 0}
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel.isHeaderSelected {
            return 50
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.isHeaderSelected {
            return 0
        }
        
        return 60
    }
    
    // Drag
    func tableView(_ tableView: UITableView, itemsForBeginning session: any UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        guard sourceIndexPath.section == proposedDestinationIndexPath.section else { return sourceIndexPath }
        return proposedDestinationIndexPath
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

        
        guard !viewModel.isHeaderSelected else { return cell }
        
        cell.selectionStyle = .none
        
        let section = indexPath.section
        let row = indexPath.row
        
        
        var setNameString = ""
        var weightString = ""
        var repsString = ""
        var perviousLabel:String?
        
        var setName = viewModel.exerciseEntries[section].sets[row].setNumber
        var weight = viewModel.exerciseEntries[section].sets[row].weight
        var reps = viewModel.exerciseEntries[section].sets[row].reps
        
        if let setName, let weight, let reps {
            setNameString = String(setName)
            weightString = String(weight)
            repsString = String(reps)
            perviousLabel = weightString + " x " + repsString
        }
        
        let rowView = WorkoutSetRowView(
            setName: setNameString,
            previousLabel: perviousLabel ?? "",
            weight: weightString,
            reps: repsString,
        )
        
        rowView.onRepsChange = { [weak self] repCount in
            guard let self else { return }
            viewModel.exerciseEntries[section].sets[row].reps = repCount
        }
        
        rowView.onWeightChange = { [weak self] weightCount in
            guard let self else { return }
            viewModel.exerciseEntries[section].sets[row].weight = weightCount
        }
        
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
        print("I was moved from: ", sourceIndexPath.row, " To: ", destinationIndexPath.row)
        viewModel.moveIndexFrom(section: sourceIndexPath.section, row: sourceIndexPath.row, to: destinationIndexPath.row)
        
        tableView.reloadSections(IndexSet(integer: sourceIndexPath.section), with: .automatic)
    }
    
}

extension CreateWorkoutVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Only allow our custom long press to fire if the user is touching a header.
        // This prevents interference with the table's native row dragging.
        let touchPoint = touch.location(in: workoutTable)
        return headerSection(at: touchPoint) != nil
    }
}

extension CreateWorkoutVC {

    @objc func handleSectionDrag(_ gesture: UILongPressGestureRecognizer) {
        print("i'm here ?")
        let touchPoint = gesture.location(in: workoutTable)

        switch gesture.state {

        case .began:
            guard let section = headerSection(at: touchPoint),
                  let headerView = findHeaderView(forSection: section) else { return }

            let frameInView = workoutTable.convert(headerView.frame, to: view)

            // Render a compact version of the header for the snapshot.
            viewModel.isHeaderSelected = true
            draggingSourceSection = nil // Ensure alpha is 1 for the render
            guard let compactHeader = self.tableView(workoutTable, viewForHeaderInSection: section) else { return }
            compactHeader.frame = CGRect(x: 0, y: 0, width: headerView.frame.width, height: 50)
            compactHeader.layoutIfNeeded()

            let renderer = UIGraphicsImageRenderer(bounds: compactHeader.bounds)
            let image = renderer.image { ctx in
                compactHeader.layer.render(in: ctx.cgContext)
            }
            let snapshot = UIImageView(image: image)

            draggingSourceSection = section
            draggingCurrentSection = section

            snapshot.frame = CGRect(x: frameInView.minX, y: frameInView.minY, width: frameInView.width, height: 50)
            view.addSubview(snapshot)
            snapshotView = snapshot

            dragInitialTouchY = touchPoint.y
            lastDragTouchY = touchPoint.y
            dragInitialSnapshotCenterY = snapshot.center.y

            let allSections = IndexSet(integersIn: 0..<workoutTable.numberOfSections)
            workoutTable.reloadSections(allSections, with: .fade)

            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.2) {
                snapshot.transform = CGAffineTransform(scaleX: 1.04, y: 1.04)
                snapshot.layer.shadowColor = UIColor.black.cgColor
                snapshot.layer.shadowOpacity = 0.28
                snapshot.layer.shadowOffset = CGSize(width: 0, height: 8)
                snapshot.layer.shadowRadius = 12
            }

        case .changed:
            guard let snapshot = snapshotView, let current = draggingCurrentSection else { return }

            let delta = touchPoint.y - dragInitialTouchY
            snapshot.center.y = dragInitialSnapshotCenterY + delta

            let deltaY = touchPoint.y - lastDragTouchY
            lastDragTouchY = touchPoint.y

            // Directional hit-testing prevents jitter when the dragged section height is 0.
            var newCurrent = current
            if deltaY > 0 {
                while newCurrent < workoutTable.numberOfSections - 1 {
                    let rect = workoutTable.rect(forSection: newCurrent + 1)
                    if touchPoint.y > rect.midY { newCurrent += 1 } else { break }
                }
            } else if deltaY < 0 {
                while newCurrent > 0 {
                    let rect = workoutTable.rect(forSection: newCurrent - 1)
                    if touchPoint.y < rect.midY { newCurrent -= 1 } else { break }
                }
            }

            if newCurrent != current {
                viewModel.moveSection(from: current, to: newCurrent)
                workoutTable.moveSection(current, toSection: newCurrent)
                draggingSourceSection = newCurrent
                draggingCurrentSection = newCurrent
            }

        case .ended, .cancelled, .failed:
            endSectionDrag()

        default:
            break
        }
    }

    // MARK: Helpers

    private func findHeaderView(forSection section: Int) -> UIView? {
        // Since we return a plain UIView from viewForHeaderInSection, 
        // workoutTable.headerView(forSection:) is nil. We find it by its unique tag.
        return workoutTable.viewWithTag(section + 1000)
    }

    /// Section whose header rect contains the given table-coordinate point.
    private func headerSection(at point: CGPoint) -> Int? {
        for i in 0..<workoutTable.numberOfSections {
            let rect = workoutTable.rect(forSection: i)
            // Use the full rect height (header + rows + footer) for hit testing.
            let headerRect = CGRect(x: rect.minX, y: rect.minY,
                                    width: rect.width,
                                    height: workoutTable.delegate?.tableView?(workoutTable, heightForHeaderInSection: i) ?? 80)
            if headerRect.contains(point) { return i }
        }
        return nil
    }

    private func endSectionDrag() {
        guard let snapshot = snapshotView else { return }
        UIView.animate(withDuration: 0.2, animations: {
            snapshot.transform = .identity
            snapshot.alpha = 0
        }, completion: { _ in
            snapshot.removeFromSuperview()
        })
        snapshotView = nil
        draggingSourceSection = nil
        draggingCurrentSection = nil
        viewModel.isHeaderSelected = false
        workoutTable.reloadData()
    }
}
