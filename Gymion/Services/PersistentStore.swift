//
//  PersistentStore.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 16.02.2026.
//

import Foundation

protocol PersistenceStore {
    func add(exercise: WorkoutExercise) throws
    func fetchExercises() throws -> [WorkoutExercise]
    func deleteAllExercises() throws
    func deleteExercise(withName name: String) throws
    func saveWorkout(workout: Workout) throws
}
