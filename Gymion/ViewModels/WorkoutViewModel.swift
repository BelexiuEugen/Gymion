//
//  WorkoutViewModel.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 11.03.2026.
//

import Foundation

class WorkoutViewModel {
    
    let persistenceStore: PersistenceStore
    
    init(persistenceStore: PersistenceStore) {
        self.persistenceStore = persistenceStore
    }
}
