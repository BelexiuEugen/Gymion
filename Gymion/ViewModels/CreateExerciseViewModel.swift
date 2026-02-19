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
    
    func createExercise(name: String, description: String, category: String){
        
        let exercise = Exercise(name: name, category: category, exerciseDescription: description)
        
        do {
            try persistentStore.add(exercise: exercise)
        }catch let error as PersistenceStoreError{
            onError?(error.errorDescription)
        } catch {
            onError?(PersistenceStoreError.restartTheApp.errorDescription)
        }
    }
}
