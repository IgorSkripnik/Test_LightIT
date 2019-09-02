//
//  ResultObj.swift
//  Test
//
//  Created by Igor Skripnik on 8/31/19.
//  Copyright © 2019 IS. All rights reserved.
//

import Foundation

struct ResultObj: Codable {
    let success: Bool?
    let token: String?
    
    init(_ dictionary: Dictionary<String, Any>) {
        success = dictionary["success"] as? Bool
        token = dictionary["token"] as? String
    }
}
