import Foundation
struct MockData {
    
    static let sampleEntries: [ExerciseEntry] = [
        
        // 1. First Exercise: Bench Press
        ExerciseEntry(
            exercise: WorkoutExercise(name: "Barbell Bench Press", category: "Chest", details: "Keep elbows tucked slightly."),
            sets: [
                ExerciseSet(setNumber: 1, weight: 60.0, reps: 12),
                ExerciseSet(setNumber: 2, weight: 65.0, reps: 10),
                ExerciseSet(setNumber: 3, weight: 70.0, reps: 8)
            ]
        ),
        
        // 2. Second Exercise: Squats
        ExerciseEntry(
            exercise: WorkoutExercise(name: "Back Squat", category: "Legs", details: "Break at the hips and knees simultaneously."),
            sets: [
                ExerciseSet(setNumber: 1, weight: 100.0, reps: 8),
                ExerciseSet(setNumber: 2, weight: 105.0, reps: 8),
                ExerciseSet(setNumber: 3, weight: 110.0, reps: 6)
            ]
        ),
        
        // 3. Third Exercise: Pull-ups
        ExerciseEntry(
            exercise: WorkoutExercise(name: "Pull-ups", category: "Back", details: "Bodyweight only. Full range of motion."),
            sets: [
                ExerciseSet(setNumber: 1, weight: 0.0, reps: 10),
                ExerciseSet(setNumber: 2, weight: 0.0, reps: 8),
                ExerciseSet(setNumber: 3, weight: 0.0, reps: 7)
            ]
        ),
        
        // 4. Fourth Exercise: Overhead Press
        ExerciseEntry(
            exercise: WorkoutExercise(name: "Overhead Press", category: "Shoulders", details: "Core tight, don't arch the lower back."),
            sets: [
                ExerciseSet(setNumber: 1, weight: 40.0, reps: 10),
                ExerciseSet(setNumber: 2, weight: 45.0, reps: 8),
                ExerciseSet(setNumber: 3, weight: 50.0, reps: 5)
            ]
        )
    ]
    
    // The complete Workout object wrapping the entries
    static let sampleWorkout = Workout(
        date: Date(),
        duration: 3600, // 1 hour in seconds
        templateName: "Full Body Power",
        isTemplate: false,
        entries: sampleEntries
    )
}
