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
    }
    
    private var action: UIAction
    
    init(style: GymionButtonStyle, action: @autoclosure @escaping () -> Void) {
        
        self.action = UIAction {_ in
            action()
        }
        super.init(frame: .zero)
        
        self.baseConfiguration()
        
        switch style {
        case .saving:
            configureSavingButton()
        case .dismising:
            confiugreDismissingButton()
        case .adding:
            print("nothing implemented")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func baseConfiguration(){
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.translatesAutoresizingMaskIntoConstraints = false
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
