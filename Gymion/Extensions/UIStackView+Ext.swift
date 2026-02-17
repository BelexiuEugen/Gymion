//
//  UIViewController+Ext.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 10.02.2026.
//

import UIKit

extension UIStackView{
    func addArrangedSubviews(_ views: UIView...){
        for view in views {
            self.addArrangedSubview(view)
        }
    }
    
    func addArrangedSubviews(_ views: [UIView]){
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
