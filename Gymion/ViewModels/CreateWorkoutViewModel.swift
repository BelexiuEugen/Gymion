//
//  CreateWorkoutViewModel.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 09.03.2026.
//

import Foundation

class CreateWorkoutViewModel{
    var exerciseEntries: [ExerciseEntry] = MockData.sampleEntries
    
    var persistenceStore: PersistenceStore
    
    init(persistenceStore: any PersistenceStore){
        self.persistenceStore = persistenceStore
    }
    
    func addSetFor(section index: Int) {
        
        var newSet = ExerciseSet(setNumber: 1, weight: 0, reps: 0)
        
        if self.exerciseEntries[index].sets.count > 0{
            let setNumber = exerciseEntries[index].sets.count
            let weight = exerciseEntries[index].sets[setNumber - 1].weight
            let reps = exerciseEntries[index].sets[setNumber - 1].reps
            newSet = ExerciseSet(setNumber: setNumber + 1, weight: weight, reps: reps)
        }

        
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
    
    func addNewSection(exercise: WorkoutExercise) {
        let newEntry = ExerciseEntry(exercise: exercise, sets: [])
        exerciseEntries.append(newEntry)
    }
    
    func deleteSection(section: Int) {
        
    }
    
    func saveWorkout(){
        
    }
    
}
