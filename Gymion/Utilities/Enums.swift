//
//  Enums.swift
//  Gymion
//
//  Created by Belexiu Eugeniu on 09.02.2026.
//

import UIKit

enum AppImage: String{
    case history = "clock"
    case exerciseList = "dumbbell"
    case workouts = "plus"
    case progress = "chart.line.uptrend.xyaxis"
    
    var image: UIImage?{
        UIImage(systemName: rawValue)
    }
}
