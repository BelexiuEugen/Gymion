//
//  GymionStack.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 17.02.2026.
//

import UIKit

class GymionStack: UIStackView {

    enum Margins {
        case topBar
        case normal
        case onlyTopAndBottom
        
        var value: UIEdgeInsets{
            switch self {
            case .normal:
                UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
            case .topBar:
                UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
            case .onlyTopAndBottom:
                UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
            }
        }
    }
    
    init(axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 0, distribution: UIStackView.Distribution = .equalSpacing, layout: Margins? = nil){
        super.init(frame: .zero)
        self.axis = axis
        self.distribution = distribution
        self.spacing = spacing
        configure(layout: layout)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(layout: Margins? = nil){
        translatesAutoresizingMaskIntoConstraints = false
        isLayoutMarginsRelativeArrangement = true
        guard let layout else { return }
        
        self.layoutMargins = layout.value
    }
}
