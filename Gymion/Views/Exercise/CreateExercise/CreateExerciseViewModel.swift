//
//  CreateExerciseViewModel.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 17.02.2026.
//

import Foundation

class CreateExerciseViewModel {
    
    func createExercise(name: String, description: String, category: String){
        CoreDataService.shared.addTask(name: name, description: description, category: category)
    }
}
