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
    
    func setWidth(){
        let fontAttributes = [NSAttributedString.Key.font: self.font!]
        let digitString = "00000" // "0" is usually the widest digit in most fonts
        let size = (digitString as NSString).size(withAttributes: fontAttributes)
        
        self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }
}
