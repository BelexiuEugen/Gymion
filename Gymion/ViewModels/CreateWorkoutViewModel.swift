//
//  CreateWorkoutViewModel.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 09.03.2026.
//

import Foundation

class CreateWorkoutViewModel{
    var exerciseEntries: [ExerciseEntry] = MockData.sampleEntries
    
    init(){
        
    }
    
    func addSetFor(section index: Int) {
        let setNumber = exerciseEntries[index].sets.count
        let weight = exerciseEntries[index].sets[setNumber - 1].weight
        let reps = exerciseEntries[index].sets[setNumber - 1].reps
        let newSet = ExerciseSet(setNumber: setNumber + 1, weight: weight, reps: reps)
        
        exerciseEntries[index].sets.append(newSet)
    }
    
    func deleteSetFor(section: Int, row: Int) async {
        
        let setCount = exerciseEntries[section].sets.count
        
        for i in row..<setCount{
            guard i < setCount - 1 else { break }
            
            exerciseEntries[section].sets[i] = exerciseEntries[section].sets[i + 1]
            exerciseEntries[section].sets[i].setNumber = i + 1
        }
        
        exerciseEntries[section].sets.removeLast()
    }
    
    
}
