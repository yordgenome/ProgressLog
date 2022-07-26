//
//  UserDefaults-Extension.swift
//  ProgressLog
//
//  Created by Yo Tahara on 2022/07/18.
//

import Foundation


extension UserDefaults {

    func getWorkoutMenu(_ key:String = "WorkoutMenu") -> [WorkoutMenu]? {
        
        guard let workoutMenu = self.array(forKey: key) as? [Data] else { return [WorkoutMenu]() }

        let decodedWorkoutMenu = workoutMenu.map { try! JSONDecoder().decode(WorkoutMenu.self, from: $0) }
           return decodedWorkoutMenu
    }

    func setWorkoutMenu(_ WorkoutMenu: [WorkoutMenu],_ key: String = "WorkoutMenu") {
        let data = WorkoutMenu.map { try! JSONEncoder().encode($0) }
        self.set(data as [Any], forKey: key)
    }
}
