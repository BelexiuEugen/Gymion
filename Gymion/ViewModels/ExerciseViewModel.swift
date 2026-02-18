//
//  ExerciseViewModel.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 10.02.2026.
//

import Foundation

class ExerciseViewModel {
    
    var exercises: [String] = []
    var filteredExercises: [String] = []
    
    init() {
        fetchExercises()
    }
    
    func fetchExercises(){
        exercises = []
        let result = CoreDataService.shared.fetchExerciseTasks()
        for exercise in result {
            exercises.append(exercise.name ?? "Nothing found")
        }
        filteredExercises = exercises
    }
    
    func deleteExercise(name: String){
        CoreDataService.shared.deleteExercise(withName: name)
    }
    
    func updateSearchingRange(searchText: String){
        filteredExercises = []
        for exercise in exercises {
            if exercise.lowercased().contains(searchText.lowercased()){
                filteredExercises.append(exercise)
            }
        }
    }
    
}
