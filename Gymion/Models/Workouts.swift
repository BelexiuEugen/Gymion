//
//  Workouts.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 09.03.2026.
//

import Foundation

struct WorkoutExercise {
    let name: String
    let category: String?
    let details: String?
}

struct ExerciseSet {
    var setNumber: Int?
    var weight: Double?
    var reps: Int?
}

struct ExerciseEntry {
    let exercise: WorkoutExercise
    var sets: [ExerciseSet]
}

struct Workout {
    let date: Date?
    let duration: TimeInterval?
    let templateName: String
    let isTemplate: Bool
    let entries: [ExerciseEntry]
}
