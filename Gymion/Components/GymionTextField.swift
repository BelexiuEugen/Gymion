//
//  GymionTextField.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 18.02.2026.
//

import UIKit

class GymionTextField: UITextField {

    enum TextFieldsType{
        case setRow
    }
    
    init(placeholder: String?, backgroundColor: UIColor, borderStyle: UITextField.BorderStyle, returnKeyType: UIReturnKeyType){
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.backgroundColor = backgroundColor
        self.borderStyle = borderStyle
        self.returnKeyType = returnKeyType
    }
    
    init(style: TextFieldsType){
        super.init(frame: .zero)
        
        switch style {
        case .setRow:
            configureRowTextField()
        }
        
        setWidth()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureRowTextField(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.systemGray6
        self.textAlignment = .center
        self.layer.cornerRadius = 8
        self.font = .boldSystemFont(ofSize: 16)
        self.keyboardType = .numbersAndPunctuation
        self.returnKeyType = .done
    }
    
    func configure(){
        
    }
    
    func setWidth(){
        let fontAttributes = [NSAttributedString.Key.font: self.font!]
        let digitString = "00000000" // "0" is usually the widest digit in most fonts
        let size = (digitString as NSString).size(withAttributes: fontAttributes)
        
        
        self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }
}
