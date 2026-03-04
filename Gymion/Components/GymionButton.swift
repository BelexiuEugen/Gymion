//
//  GymionButton.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 17.02.2026.
//

import UIKit

class GymionButton: UIButton {

    enum GymionButtonStyle {
        case saving
        case dismising
        case adding
        case addExercise
        case addSet
    }
    
    private var action: UIAction
    
    init(style: GymionButtonStyle, action: @autoclosure @escaping () -> Void) {
        
        self.action = UIAction {_ in
            action()
        }
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        switch style {
        case .saving:
            configureSavingButton()
            self.baseConfiguration()
        case .dismising:
            confiugreDismissingButton()
            self.baseConfiguration()
        case .adding:
            print("nothing implemented")
        case .addExercise:
            configureAddExercise()
        case .addSet:
            configureAddSet()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func baseConfiguration(){
        self.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    func configureAction(action: @autoclosure @escaping () -> Void){
        
        let myAction = UIAction{ _ in
            action()
        }
        
        self.action = myAction
    }
    
    func configureSavingButton(){
        self.setTitle("Save", for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        self.setTitleColor(.systemBlue, for: .normal)
        self.addAction(action, for: .touchUpInside)
    }
    
    func confiugreDismissingButton(){
        let config = createSettingsForDismissButton()
        self.configuration = config
        self.addAction(action, for: .touchUpInside)
    }
    
    func configureAddExercise(){
//        self.setTitle("Add Exercise", for: .normal)
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .medium
        config.baseBackgroundColor = .lightBlue
        config.baseForegroundColor = .darkBlue
        
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        config.attributedTitle = AttributedString("Add Exercise", attributes: container)
        
        self.configuration = config
        
        self.addAction(action, for: .touchUpInside)
    }
    
    func configureAddSet(){
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .large
        config.baseForegroundColor = .black
        config.baseBackgroundColor = .systemGray5
        
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        
        config.attributedTitle = AttributedString("+ Add Set (2:00)", attributes: container)
        
        self.configuration = config
        
        self.addAction(action, for: .touchUpInside)
    }

}

extension GymionButton{
    
    override var isEnabled: Bool{
        didSet{
            self.setTitleColor(isEnabled ? .systemBlue : .gray, for: .normal)
        }
    }
    
    func createSettingsForDismissButton() -> UIButton.Configuration{
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .black
        config.baseBackgroundColor = .systemGray5
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        config.image = UIImage(systemName: "xmark", withConfiguration: symbolConfig)
        config.cornerStyle = .large
        
        return config
    }
}
