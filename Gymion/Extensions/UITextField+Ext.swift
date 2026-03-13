//
//  UITextField+Ext.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 12.03.2026.
//

import Foundation

import UIKit

extension UITextField {
    func addDoneButtonOnKeyboard() {
        // Create a toolbar
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        // Create an empty space to push the "Done" button to the right
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Create the "Done" button
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        // Add items to toolbar
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        
        // Assign the toolbar to the text field's inputAccessoryView
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder() // Dismiss the keyboard
    }
}
