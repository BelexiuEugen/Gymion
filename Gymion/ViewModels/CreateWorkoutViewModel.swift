//
//  CreateWorkoutViewModel.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 09.03.2026.
//

import Foundation

class CreateWorkoutViewModel{
    var exerciseEntries: [ExerciseEntry] = MockData.sampleEntries
    var isHeaderSelected: Bool = false
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
    
    func moveSection(from: Int, to: Int){
        guard from != to, from >= 0, from < exerciseEntries.count, to >= 0, to < exerciseEntries.count else { return }
        let element = exerciseEntries.remove(at: from)
        exerciseEntries.insert(element, at: to)
    }
    
    func deleteSection(section: Int) {
        exerciseEntries.remove(at: section)
    }
    
    func saveWorkout(){
        
    }
    
    func moveIndexFrom(section: Int, row: Int, to index: Int) {
        row > index ? moveUp(section: section, row: row, to: index) : moveDown(section: section, row: row, to: index)
    }
    
    func moveUp(section: Int, row: Int, to index: Int){
        
        var storedRow = exerciseEntries[section].sets[index]
        exerciseEntries[section].sets[index] = exerciseEntries[section].sets[row]
        exerciseEntries[section].sets[index].setNumber = index + 1
        
        for i in (index + 1)...row{
            let temp = exerciseEntries[section].sets[i]
            exerciseEntries[section].sets[i] = storedRow
            exerciseEntries[section].sets[i].setNumber = i + 1
            storedRow = temp
        }
    }
    
    func moveDown(section: Int, row: Int, to index: Int){
        let storedRow = exerciseEntries[section].sets[row]
        
        for i in row..<index{
            exerciseEntries[section].sets[i] = exerciseEntries[section].sets[i + 1]
            exerciseEntries[section].sets[i].setNumber = i + 1
        }
        
        exerciseEntries[section].sets[index] = storedRow
        exerciseEntries[section].sets[index].setNumber = index + 1
    }
    
}
