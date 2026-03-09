//
//  CreateExerciseViewModel.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 17.02.2026.
//

import Foundation

class CreateExerciseViewModel {
    
    let persistentStore: PersistenceStore
    var onError: ((String) -> Void)?
    
    init(persistentStore: PersistenceStore) {
        self.persistentStore = persistentStore
    }
    
    func createExercise(name: String, details: String, category: String){
        
        let exercise = WorkoutExercise(name: name, category: category, details: details)
        
        do {
            try persistentStore.add(exercise: exercise)
        }catch let error as PersistenceStoreError{
            onError?(error.errorDescription)
        } catch {
            onError?(PersistenceStoreError.restartTheApp.errorDescription)
        }
    }
}
