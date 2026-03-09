//
//  UIView+Ext.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 09.03.2026.
//

import Foundation
import UIKit

extension UIView{
    
    func addContainer(width: CGFloat, containerHeight: CGFloat, viewHeight: CGFloat) -> UIView {
        let container = UIView()
        // Setting a temporary frame helps the TableView footer initialization
        container.frame = CGRect(x: 0, y: 0, width: width, height: containerHeight)
        
//        let addExerciseButton = GymionButton(style: .addExercise, action: ())
//        addExerciseButton.translatesAutoresizingMaskIntoConstraints = false // Mandatory for constraints
        container.addSubview(self)
        
        NSLayoutConstraint.activate([
            // Pin to the leading/trailing edges with a bit of padding if you want (e.g., 10)
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            self.heightAnchor.constraint(equalToConstant: viewHeight)
            
        ])
        
        return container
    }
}
