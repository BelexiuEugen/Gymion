//
//  GymionTextField.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 18.02.2026.
//

import UIKit

class GymionTextField: UITextField {

    init(placeholder: String?, backgroundColor: UIColor, borderStyle: UITextField.BorderStyle, returnKeyType: UIReturnKeyType){
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.backgroundColor = backgroundColor
        self.borderStyle = borderStyle
        self.returnKeyType = returnKeyType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        
    }
}
