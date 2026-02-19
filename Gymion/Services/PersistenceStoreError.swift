//
//  CoreDataError.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 19.02.2026.
//

import Foundation

enum PersistenceStoreError: Error, LocalizedError{
    case errorFetchingExerciseTasks
    case errorDeletingExercise
    case errorDeletingExercises
    case errorSaving
    case noExerciseFound
    case batchDeleteFailed
    case restartTheApp
    
    var errorDescription: String {
        switch self {
        case .errorFetchingExerciseTasks:
            "We couldn't save your exercises at this time. Please try again later."
        case .errorDeletingExercise:
            "We couldn't delete your exercise at this time. Please try again later."
        case .errorDeletingExercises:
            "We couldn't delete your exercises at this time. Please try again later."
        case .errorSaving:
            "We couldn't save your changes at this time. Please try again later."
        case .noExerciseFound:
            "we couldn't find the requested exercise"
        case .batchDeleteFailed:
            "Failed to clear all data. Please restart the app"
        case .restartTheApp:
            "There was in error please restart the app"
        }
    }
}
