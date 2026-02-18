//
//  GymionLabel.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 17.02.2026.
//

import UIKit

class GymionLabel: UILabel {
    
    init(text: String, textAlignment: NSTextAlignment = .left) {
        super.init(frame: .zero)
        self.text = text
        self.textAlignment = textAlignment
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        self.font = .boldSystemFont(ofSize: 16)
    }
}
