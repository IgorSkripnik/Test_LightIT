//
//  StorageManager.swift
//  Test
//
//  Created by Igor Skripnik on 8/31/19.
//  Copyright © 2019 IS. All rights reserved.
//

import Foundation

final class Settings {
    
    private enum Keys: String {
        case token = "token"
    }
   
    static var token: String? {
        get {
            guard let state = UserDefaults.standard.value(forKey: Keys.token.rawValue) as? String? else {
                return nil
            }
            return state
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.token.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}
