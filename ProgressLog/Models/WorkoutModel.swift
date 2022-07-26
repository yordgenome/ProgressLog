//
//  Workout.swift
//  ProgressLog
//
//  Created by Yo Tahara on 2022/07/18.
//

import UIKit
import FirebaseFirestore

struct WorkoutModel {
    var doneAt: Timestamp = Timestamp(date: Date())
    var targetPart: String = ""
    var workoutName: String = ""
    var weight: Double = 1
    var reps: Int = 1
    var volume: Double


    init(doneAt: Timestamp,
         targetPart: String,
         workoutName: String,
         weight: Double,
         reps: Int,
         volume: Double){

        self.doneAt = doneAt
        self.targetPart = targetPart
        self.workoutName = workoutName
        self.weight = weight
        self.reps = reps
        self.volume = weight * Double(reps)
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "doneAt": doneAt,
            "targetPart" : targetPart,
            "workoutName" : workoutName,
            "weight": weight,
            "reps": reps,
            "volume": volume
        ]
    }
}
