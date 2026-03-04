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
    }
    
    init(text: String, textAlignment: NSTextAlignment = .left, style: GymionLabelStyle? = nil) {
        super.init(frame: .zero)
        self.text = text
        self.textAlignment = textAlignment
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
        }
    }
    
    func configureBigTitle(){
        self.font = .boldSystemFont(ofSize: 25)
    }
    
    func configureNormalLabel(){
        self.font = .boldSystemFont(ofSize: 16)
    }
        
    func configureBlueTitle(){
        self.font = .boldSystemFont(ofSize: 18)
        self.textColor = .darkBlue
    }
    
    func setColor(_ color: UIColor) {
        self.textColor = color
    }
    
    func setWidth() {
        let fontAttributes = [NSAttributedString.Key.font: self.font!]
        let digitString = "00000" // "0" is usually the widest digit in most fonts
        let size = (digitString as NSString).size(withAttributes: fontAttributes)
        
        self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }
}
