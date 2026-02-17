//
//  CoreDataService.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 16.02.2026.
//

import Foundation
import CoreData
import UIKit

class CoreDataService {
    static let shared = CoreDataService()
    
    private init() {}
    
    var context: NSManagedObjectContext{
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addTask(name: String, description: String, category: String) {
        let newExercise = Excerise(context: context)
        newExercise.category = category
        newExercise.name = name
        newExercise.exerciseDescription = description
        
        saveContext()
    }
    
    func fetchExerciseTasks() -> [Excerise]{
            // 1. Create the request for a specific Entity
            let request = NSFetchRequest<Excerise>(entityName: "Excerise")
            
            do {
                // 2. Ask the context to execute the request
                let users = try context.fetch(request)
                return users
            } catch {
                print("Fetch failed: \(error)")
                return []
            }
    }
    
    func deleteAllExercise() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Excerise")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            saveContext()
        } catch {
            print("Eroare la ștergere: \(error)")
        }
    }
    
    func deleteExercise(withName name: String){
        let fetch: NSFetchRequest<Excerise> = Excerise.fetchRequest()
        
        fetch.predicate = NSPredicate(format: "name == %@", name)
        
        do{
            let result = try context.fetch(fetch)
            
            for object in result {
                context.delete(object)
            }
            
            saveContext()
            
        } catch {
            
        }
    }
}
