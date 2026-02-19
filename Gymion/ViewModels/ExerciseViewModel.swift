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
    let persistenceStore: PersistenceStore
    var onError: ((String) -> Void)?
    
    init(persistenceStore: PersistenceStore) {
        self.persistenceStore = persistenceStore
        fetchExercises()
    }
    
    func fetchExercises(){
        exercises = []
        
        do{
            let result = try persistenceStore.fetchExercises()
            exercises = result.map{ $0.name ?? "No Exercise Found"}
        }catch let error as PersistenceStoreError{
            onError?(error.errorDescription)
        } catch {
            onError?(PersistenceStoreError.restartTheApp.errorDescription)
        }
        filteredExercises = exercises
    }
    
    func deleteExercise(name: String, result: @escaping (Bool) -> Void){
        
        do{
            try persistenceStore.deleteExercise(withName: name)
            result(true)
        }catch let error as PersistenceStoreError{
            onError?(error.errorDescription)
        }catch{
            onError?(PersistenceStoreError.restartTheApp.errorDescription)
        }
        
        result(false)
    }
    
    func updateSearchingRange(searchText: String){
        filteredExercises = exercises.filter { $0.lowercased().contains(searchText.lowercased())}
    }
    
}
