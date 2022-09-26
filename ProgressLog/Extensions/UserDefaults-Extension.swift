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
    
    func setBaseVolume(dateString: String, volume: Double,_ key: String = "BaseVolume") {
        let data = ["dateString": dateString, "volume": volume] as [String : Any]
        self.set(data, forKey: key)
    }
    
    func getBaseVolume(_ key: String = "BaseVolume") -> [String: Any]? {
        let data = self.dictionary(forKey: key)
        return data
    }
    
    func setMaxVolume(dateString: String, volume: Double,_ key: String = "MaxVolume") {
        let data = ["dateString": dateString, "volume": volume] as [String : Any]
        self.set(data, forKey: key)
    }
    
    func getMaxVolume(_ key: String = "MaxVolume") -> [String: Any]? {
        let data = self.dictionary(forKey: key)
        return data
    }
}
