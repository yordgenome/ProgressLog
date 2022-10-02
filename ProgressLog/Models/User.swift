//
//  User.swift
//  ProgressLog
//
//  Created by 田原葉 on 2022/09/27.
//

import Foundation
import FirebaseFirestore

struct User {
    var id: String
    var name: String
    var email: String
    var createdAt: Timestamp
}

class UserData {
    static var name: String = ""
    static var email: String = ""
    static var createdAt: Timestamp = Timestamp()
    static var baseVolume: Double = 0
}
