import UIKit

class WorkoutSetRowView: UIView {
    
    // UI Elements
    let setNumberLabel = GymionLabel(text: "", textAlignment: .center, style: .setNumber)
    let previousLabel = GymionLabel(text: "", textAlignment: .center, font: .boldSystemFont(ofSize: 16), textColor: .systemGray)
    let weightTextField = GymionTextField(style: .setRow)
    let repsTextField = GymionTextField(style: .setRow)
    var isHeader: Bool
    
    // Constants
    private let maxDigits = 5
    
    required init?(coder: NSCoder) {
        self.isHeader = false
        super.init(coder: coder)
        setupView()
        configureTextFields()
    }
    
    init(setName: String, previousLabel: String, weight: String, reps: String, isHeader: Bool = false){
        self.isHeader = isHeader
        super.init(frame: .zero)
        
        setNumberLabel.text = setName
        self.previousLabel.text = previousLabel
        weightTextField.text = weight
        repsTextField.text = reps
        setupView()
        configureTextFields()
    }
    
    private func configureTextFields() {
        weightTextField.delegate = self
        repsTextField.delegate = self
        // Ensure numeric keypad for digit input
        weightTextField.keyboardType = .numberPad
        repsTextField.keyboardType = .numberPad
    }
    
    private func clearBackgrounds(){
        setNumberLabel.backgroundColor = .clear
        previousLabel.textColor = .label
        weightTextField.backgroundColor = .clear
        repsTextField.backgroundColor = .clear
    }
    
    private func setupView() {
        
        if isHeader {
            clearBackgrounds()
        }
        
        let horizontalStack = GymionStack(axis: .vertical, spacing: 8)
        let stackView = GymionStack(axis: .horizontal, spacing: 8, distribution: .fill, alignment: .fill)
        
        stackView.addArrangedSubviews(setNumberLabel, previousLabel, weightTextField, repsTextField)
        
        horizontalStack.addArrangedSubviews(stackView, RestTimerDividerView())

        addSubview(horizontalStack)
        
        NSLayoutConstraint.activate([

            horizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStack.topAnchor.constraint(equalTo: topAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 27),
            
            setNumberLabel.widthAnchor.constraint(equalToConstant: 35),
            weightTextField.widthAnchor.constraint(equalToConstant: 140),
            repsTextField.widthAnchor.constraint(equalToConstant: 140),
        ])
    }
}


extension WorkoutSetRowView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow deletions
        if string.isEmpty { return true }
        // Only allow digits 0-9
        if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil { return false }
        // Current text
        let currentText = textField.text ?? ""
        // Compute prospective text after the change
        guard let textRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        // Enforce max length
        return updatedText.count <= maxDigits
    }
}

