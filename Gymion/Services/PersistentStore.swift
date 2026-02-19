//
//  PersistentStore.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 16.02.2026.
//

import Foundation

protocol PersistenceStore {
    func add(exercise: Exercise) throws
    func fetchExercises() throws -> [Exercise]
    func deleteAllExercises() throws
    func deleteExercise(withName name: String) throws
}
