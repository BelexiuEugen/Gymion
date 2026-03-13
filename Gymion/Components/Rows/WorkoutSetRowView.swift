import UIKit

class WorkoutSetRowView: UIView {
    
    // UI Elements
    let setNumberLabel = GymionLabel(text: "", textAlignment: .center, style: .setNumber)
    let previousLabel = GymionLabel(text: "", textAlignment: .center, font: .boldSystemFont(ofSize: 16), textColor: .systemGray)
    let weightTextField = GymionTextField(style: .setRow)
    let repsTextField = GymionTextField(style: .setRow)
    
    var onWeightChange: ((Double) -> ())?
    var onRepsChange: ((Int) -> ())?
    
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
    }
    
    private func clearBackgrounds(){
        setNumberLabel.backgroundColor = .clear
        previousLabel.textColor = .label
        weightTextField.backgroundColor = .clear
        repsTextField.backgroundColor = .clear
    }
    
    private func setupView() {
        
        let stackView = GymionStack(axis: .horizontal, spacing: 8, distribution: .fill, alignment: .fill)
        stackView.addArrangedSubviews(setNumberLabel, previousLabel, weightTextField, repsTextField)
        
        if isHeader {
            clearBackgrounds()
            addSubview(stackView)
            configureStackView(stack: stackView)
            return
        }
        
        let horizontalStack = GymionStack(axis: .vertical, spacing: 8)
        
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

extension WorkoutSetRowView {
    func configureStackView(stack: UIStackView){
        NSLayoutConstraint.activate([

            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.heightAnchor.constraint(equalToConstant: 27),
            
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
        
        let allowedCharacter = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))
        
        if string.rangeOfCharacter(from: allowedCharacter.inverted) != nil { return false }
        
        guard let count = textField.text?.filter({ $0 == "."}).count else { return false}
        
        if string == "." && count > 0 { return false }
        
        let currentText = textField.text ?? ""
        // Compute prospective text after the change
        guard let textRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        // Enforce max length
        return updatedText.count <= maxDigits
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard
            let text = textField.text,
            let number = Double(text)
        else { return }
        
        if textField == weightTextField{
            onWeightChange?(number)
            return
        }
        onRepsChange?(Int(number))
    }
}

