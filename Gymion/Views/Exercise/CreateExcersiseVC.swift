//
//  createExcersiseVC.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 16.02.2026.
//

import UIKit

class CreateExcersiseVC: UIViewController {
    
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
        configureContainer()
        configureStack()
    }
    
    func configureContainer(){
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 400)
        ])
    }
    
    func configureStack(){
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        let stackChilds: [UIStackView] = createStackChilds()
        
        stackView.addArrangedSubviews(stackChilds)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
    }
    
    func createStackChilds() -> [UIStackView]{
        var stackChilds: [UIStackView] = []
        
        let topStack = createTopStack()
        
        let newExerciseSection = createNewExerciseSection()
        
        stackChilds.append(contentsOf: [topStack, newExerciseSection])
        
        return stackChilds
    }
    
    func createTopStack() -> UIStackView{
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.backgroundColor = .red
        
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
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(saveButton)
        saveButton.setContentHuggingPriority(.required, for: .horizontal)
        
        return saveButton
    }
    
    func createNewExerciseSection() -> UIStackView{
        let exerciseStack = UIStackView()
        exerciseStack.axis = .vertical
        exerciseStack.spacing = 10
        
        let nameSection = createNameSection(labelName: "Name", textFieldName: "Add Name")
        let descriptionSection = createNameSection(labelName: "Description", textFieldName: "Add Description")
        let cateogorySection = createCateogrySection()
        
        exerciseStack.addArrangedSubviews(nameSection, descriptionSection, cateogorySection)
        
        exerciseStack.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        return exerciseStack
    }
    
    func createNameSection(labelName: String, textFieldName: String) -> UIStackView{
        let nameSection: UIStackView = UIStackView()
        nameSection.axis = .vertical
        
        let nameLabel: UILabel = UILabel()
        nameLabel.text = labelName
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textAlignment = .left
        
        let nameTextField: UITextField = UITextField()
        nameTextField.placeholder = textFieldName
        nameTextField.backgroundColor = .systemGray5
        
        nameSection.addArrangedSubviews(nameLabel, nameTextField)
        
        return nameSection
    }
    
    func createCateogrySection() -> UIStackView{
        let categorySection: UIStackView = UIStackView()
        categorySection.axis = .vertical
        
        let nameLabel: UILabel = UILabel()
        nameLabel.text = "Category"
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textAlignment = .left
        
        let categoryPicker: UIPickerView = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        let nameTextFiled: UITextField = UITextField()
        nameTextFiled.inputView = categoryPicker
        
        categorySection.addArrangedSubviews(nameLabel, nameTextFiled)
        
        return categorySection
        
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
        print("Selected Priority: \(ExerciseCategory.allCases[row])")
    }
    
    
}
