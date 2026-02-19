//
//  CoreDataService.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 16.02.2026.
//

import Foundation
import CoreData

class CoreDataService: PersistenceStore {
    
    private let persistentContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    init(){
        persistentContainer = NSPersistentContainer(name: "Gymion")
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError?{
                fatalError("Unresolved Error: \(error), \(error.userInfo)")
            }
        }
    }

    func saveContext(specificError: PersistenceStoreError) throws{
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                throw specificError
            }
        }
    }
    
    func add(exercise: Exercise) throws{
    
        let newExercise = ExerciseEntity(context: context)
        newExercise.category = exercise.category
        newExercise.name = exercise.name
        newExercise.exerciseDescription = exercise.exerciseDescription
        
        try saveContext(specificError: .errorSaving)
    }
    
    func fetchExercises() throws -> [Exercise]{

        let request = NSFetchRequest<ExerciseEntity>(entityName: EntityNames.exercise.rawValue)
            
            do {
                let users = try context.fetch(request)
                
                return users.map { user -> Exercise in
                    Exercise(name: user.name,
                             category: user.category,
                             exerciseDescription: user.exerciseDescription)
                }

            } catch {
                throw PersistenceStoreError.errorFetchingExerciseTasks
            }
    }
    
    func deleteAllExercises() throws{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityNames.exercise.rawValue)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            context.reset()
        } catch {
            throw PersistenceStoreError.errorDeletingExercise
        }
        
        try saveContext(specificError: .errorDeletingExercise)
    }
    
    func deleteExercise(withName name: String) throws{
        let fetch: NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
        
        fetch.predicate = NSPredicate(format: "name == %@", name)
        
        do{
            let result = try context.fetch(fetch)
            
            for object in result {
                context.delete(object)
            }
        } catch {
            throw PersistenceStoreError.noExerciseFound
        }
        
        try saveContext(specificError: .errorDeletingExercise)
    }
}
