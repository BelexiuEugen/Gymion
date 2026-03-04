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
        let dataRow = GymionStack(axis: .horizontal)
        
        let setLabel = GymionLabel(text: "Set")
        let PreviousLabel = GymionLabel(text: "Previous")
        let weightLabel = GymionLabel(text: "Weight")
        let Reps = GymionLabel(text: "Reps")
        
        dataRow.addArrangedSubviews(setLabel, PreviousLabel, weightLabel, Reps)
        
        return dataRow
    }
    
    func createSetRow(bodyStack: UIStackView){
        let setRow = GymionStack(axis: .horizontal)
        
        let setNumber = GymionLabel(text: "1")
        let previous = GymionLabel(text: "20 x 15 kg")
        previous.tintColor = .systemGray5
        let weightText = GymionTextField(placeholder: nil, backgroundColor: .systemGray5, borderStyle: .roundedRect, returnKeyType: .next)
        weightText.setWidth()
        let repsText = GymionTextField(placeholder: nil, backgroundColor: .systemGray5, borderStyle: .roundedRect, returnKeyType: .done)
        repsText.setWidth()
        
        setRow.addArrangedSubviews(setNumber, previous, weightText, repsText)
        
        bodyStack.addArrangedSubview(setRow)
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
        let dataRow = createDataRow()
        let setsStack = GymionStack(spacing: 5, layout: .onlyTopAndBottom)
        createSetRow(bodyStack: setsStack)
        
        let newSetButton = GymionButton(style: .addSet, action: self.createSetRow(bodyStack: setsStack))
        
        newExerciseExample.addArrangedSubviews(exerciseName, dataRow, setsStack, newSetButton)
        bodyStack.addArrangedSubviews(newExerciseExample)
    }
    
    @objc func saveWorkout(){
        
    }
}

