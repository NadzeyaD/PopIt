//
//  RunningEnvironment.swift
//  CatchMe
//
//  Created by Nadia on 3/24/20.
//  Copyright © 2020 Nadzeya. All rights reserved.
//

import Foundation

enum UserDefaultConstants {
    static let recordScore = "recordScore"
}

struct CurrentRunEnvironment {
    static var recordScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultConstants.recordScore)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultConstants.recordScore)
        }
    }
}
