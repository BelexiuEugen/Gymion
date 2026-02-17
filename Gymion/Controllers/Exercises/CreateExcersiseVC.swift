//
//  createExcersiseVC.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 16.02.2026.
//

import UIKit

class CreateExcersiseVC: UIViewController {
    
    private let nameTextField: UITextField = UITextField()
    private let descriptioniTextField: UITextField = UITextField()
    private let categoryTextField: UITextField = UITextField()
    private let viewModel = CreateExerciseViewModel()
    
    var onDismiss: ((Bool) -> Void)?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        configure()
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
        
        let dimissButton: UIButton = createDismissButton()
        let title = createTitleLabel()
        let saveButton: UIButton = createSaveButton()
        
        stackView.addArrangedSubviews(dimissButton, title, saveButton)
        
        stackView.setContentHuggingPriority(.required, for: .vertical)
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return stackView
    }
    
    func createDismissButton() -> UIButton{
        let dismissButton: UIButton = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemGray5
        config.baseForegroundColor = .black
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        config.image = UIImage(systemName: "xmark", withConfiguration: symbolConfig)
        config.cornerStyle = .large
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dismissButton)
        
        dismissButton.configuration = config
        dismissButton.setContentHuggingPriority(.required, for: .horizontal)
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        return dismissButton
    }
    
    func createTitleLabel() -> UILabel{
        let title = UILabel()
        title.text = "Create New Exercise"
        title.font = .boldSystemFont(ofSize: 16)
        title.textAlignment = .center
        return title
    }
    
    func createSaveButton() -> UIButton{
        let saveButton: UIButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        saveButton.titleColor(for: .normal)
        saveButton.addTarget(self, action: #selector(saveNewExercise), for: .touchUpInside)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(saveButton)
        saveButton.setContentHuggingPriority(.required, for: .horizontal)
        
        return saveButton
    }
    
    func createNewExerciseSection() -> UIStackView{
        let exerciseStack = GymionStack(distribution: .fillEqually)
        
        let nameSection = createNameSection(labelName: "Name", textField: nameTextField, textFieldName: "Add Name", tag: 1)
        let descriptionSection = createNameSection(labelName: "Description", textField: descriptioniTextField, textFieldName: "Add Description", tag: 2)
        let cateogorySection = createCateogrySection()
        
        exerciseStack.addArrangedSubviews(nameSection, descriptionSection, cateogorySection)
        
        return exerciseStack
    }
    
    func createNameSection(labelName: String, textField: UITextField, textFieldName: String, tag: Int) -> UIStackView{
        
        let nameSection: UIStackView = GymionStack(layout: .normal)
        let nameLabel: UILabel = GymionLabel(text: labelName)
        
        textField.placeholder = textFieldName
        textField.backgroundColor = .systemGray5
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.returnKeyType = .done
        
        nameSection.addArrangedSubviews(nameLabel, textField)
        
        return nameSection
    }
    
    func createCateogrySection() -> UIStackView{
        
        let categorySection: UIStackView = GymionStack(layout: .normal)
        let nameLabel: UILabel = GymionLabel(text: "Category")
        
        let categoryPicker: UIPickerView = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        

        categoryTextField.placeholder = ExerciseCategory.allCases.first?.rawValue
        categoryTextField.inputView = categoryPicker
        categoryTextField.backgroundColor = .systemGray5
        categoryTextField.borderStyle = .roundedRect
        
        categorySection.addArrangedSubviews(nameLabel, categoryTextField)
        
        return categorySection
        
    }

}

extension CreateExcersiseVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Spune-i text field-ului să renunțe la focus (închide tastatura)
        textField.resignFirstResponder()
        return true
    }
}

extension CreateExcersiseVC: UIPickerViewDelegate, UIPickerViewDataSource{
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
        categoryTextField.text = ExerciseCategory.allCases[row].rawValue
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
            let exerciseName = nameTextField.text,
            let descriptionName = descriptioniTextField.text,
            let categoryName = categoryTextField.text
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
