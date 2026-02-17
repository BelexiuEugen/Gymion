//
//  ExerciseViewModel.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 10.02.2026.
//

import Foundation

class ExerciseViewModel {
    
    var exercises: [String] = ["Bench Press", "Deadlift", "Squats", "Overhead Press"]
    
    init() {
        fetchExercises()
    }
    
    func addNewExercise(){
        print("Message Recived")
        CoreDataService.shared.addTask(title: "", dueDate: .now)
        fetchExercises()
    }
    
    func fetchExercises(){
        let result = CoreDataService.shared.fetchExerciseTasks()
        print(result)
        for exercise in result {
            exercises.append(exercise.name ?? "Nothing found")
        }
    }
}
