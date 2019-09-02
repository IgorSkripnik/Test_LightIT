//
//  User.swift
//  Test
//
//  Created by Igor Skripnik on 8/31/19.
//  Copyright © 2019 IS. All rights reserved.
//

import Foundation

struct User: Codable {
    let username, password: String
    init(name: String, pass: String) {
        username = name
        password = pass
    }
}
