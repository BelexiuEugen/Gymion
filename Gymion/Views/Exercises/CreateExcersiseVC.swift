//
//  createExcersiseVC.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 16.02.2026.
//

import UIKit

class CreateExcersiseVC: UIViewController {
    
    private let textFields: [UITextField] = [
        GymionTextField(placeholder: "Add Name", backgroundColor: .systemGray5, borderStyle: .roundedRect, returnKeyType: .done),
        GymionTextField(placeholder: "Add Description", backgroundColor: .systemGray5, borderStyle: .roundedRect, returnKeyType: .done),
        GymionTextField(placeholder: "Select Category", backgroundColor: .systemGray5, borderStyle: .roundedRect, returnKeyType: .done)
    ]
    
    private var saveButton: UIButton? = nil
    
    private let viewModel: CreateExerciseViewModel
    
    private var isReady: Bool{
        return textFields.allSatisfy{ !($0.text?.isEmpty ?? true) }
    }
    
    var onDismiss: ((Bool) -> Void)?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(persistenceStore: PersistenceStore){
        viewModel = CreateExerciseViewModel(persistentStore: persistenceStore)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        saveButton = GymionButton(style: .saving, action: self.saveNewExercise())
        saveButton?.isEnabled = false
        configure()
        loadTargetsOnTextFields()
        setupBinding()
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
    
    func loadTargetsOnTextFields(){
        for textField in textFields {
            textField.addTarget(self, action: #selector(checkIfReady), for: .editingChanged)
        }
    }
    
    @objc func checkIfReady(){
        if textFields.allSatisfy({ !($0.text?.isEmpty ?? true)}){
            saveButton?.isEnabled = true
        } else {
            saveButton?.isEnabled = false
        }
      
        
        
    }
    
    func configure(){
        setupOutsideTap()
        configureContainer()
        configureStack()
    }
    
    func configureContainer(){
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        ])
    }
    
    func configureStack(){
        
        let stackView: UIStackView = GymionStack(distribution: .fill)
        view.addSubview(stackView)
        stackView.addArrangedSubviews(createStackChilds())
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
    }
    
    func createStackChilds() -> [UIStackView]{
        let topStack = createTopStack()
        
        let newExerciseSection = createNewExerciseSection()
        
        return [topStack, newExerciseSection]
    }
    
    func createTopStack() -> UIStackView{
        let stackView: UIStackView = GymionStack(axis: .horizontal, distribution: .fill, layout: .topBar)
        
        let dimissButton: UIButton = GymionButton(style: .dismising, action: self.dismissView())
        let title = GymionLabel(text: "Create New Exercise", textAlignment: .center)
        
        guard let saveButton else { return stackView }
        
        stackView.addArrangedSubviews(dimissButton, title, saveButton)
        
        stackView.setContentHuggingPriority(.required, for: .vertical)
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return stackView
    }
    
    func createNewExerciseSection() -> UIStackView{
        let exerciseStack = GymionStack(distribution: .fillEqually)
        
        let nameSection = createNameSection(labelName: "Name", textField: textFields[0], addPicker: false)
        let descriptionSection = createNameSection(labelName: "Description", textField: textFields[1], addPicker: false)
        let cateogorySection = createNameSection(labelName: "Category", textField: textFields[2], addPicker: true)
        
        exerciseStack.addArrangedSubviews(nameSection, descriptionSection, cateogorySection)
        
        return exerciseStack
    }
    
    func createNameSection(labelName: String, textField: UITextField, addPicker: Bool) -> UIStackView{
        
        let nameSection: UIStackView = GymionStack(layout: .normal)
        let nameLabel: UILabel = GymionLabel(text: labelName)
        textField.delegate = self
        nameSection.addArrangedSubviews(nameLabel, textField)
        
        guard addPicker else { return nameSection }
        
        let categoryPicker: UIPickerView = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        textField.inputView = categoryPicker
        
        return nameSection
    }

}

extension CreateExcersiseVC: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ExerciseCategory.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ExerciseCategory.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFields[2].text = ExerciseCategory.allCases[row].rawValue
        self.checkIfReady()
    }
}

extension CreateExcersiseVC{
    
    @objc func dismissView() {
        self.dismiss(animated: true) {
            self.onDismiss?(false)
        }
    }
    
    @objc func saveNewExercise(){
        guard
            let exerciseName = textFields[0].text,
            let descriptionName = textFields[1].text,
            let categoryName = textFields[2].text
        else { return }
        
        viewModel.createExercise(name: exerciseName, description: descriptionName, category: categoryName)
        
        self.dismiss(animated: true){
            self.onDismiss?(true)
        }
    }
    
    private func setupOutsideTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))

        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func handleOutsideTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        
        if !containerView.frame.contains(location) {
            dismiss(animated: true)
        }
    }
    
}
