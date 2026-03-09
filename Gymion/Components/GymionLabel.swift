//
//  GymionLabel.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 17.02.2026.
//

import UIKit

class GymionLabel: UILabel {
    
    enum GymionLabelStyle {
        case bigTitle
        case blueTitle
        case setNumber
    }
    
    init(text: String, textAlignment: NSTextAlignment = .left, font: UIFont = .boldSystemFont(ofSize: 16), textColor: UIColor = .label, style: GymionLabelStyle? = nil) {
        super.init(frame: .zero)
        self.text = text
        self.textAlignment = textAlignment
        self.font = font
        self.textColor = textColor
        configure(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(style: GymionLabelStyle? = nil){
        self.translatesAutoresizingMaskIntoConstraints = false
        
        switch style {
        case .bigTitle:
            configureBigTitle()
        case .blueTitle:
            configureBlueTitle()
        case nil:
            configureNormalLabel()
        case .setNumber:
            configureSetNumber()
        }
    }
    
    func configureBigTitle(){
        self.font = .boldSystemFont(ofSize: 25)
    }
    
    func configureNormalLabel(){
        
    }
        
    func configureBlueTitle(){
        self.font = .boldSystemFont(ofSize: 18)
        self.textColor = .darkBlue
    }
    
    func setWidth() {
        let fontAttributes = [NSAttributedString.Key.font: self.font!]
        let digitString = "00000" // "0" is usually the widest digit in most fonts
        let size = (digitString as NSString).size(withAttributes: fontAttributes)
        
        self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }
    
    func configureSetNumber(){
        self.backgroundColor = UIColor.systemGray6
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.font = .boldSystemFont(ofSize: 16)
    }
    
    func configurePreviousSetNumber(){
        
    }
}
