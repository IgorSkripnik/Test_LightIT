//
//  Review.swift
//  Test
//
//  Created by Igor Skripnik on 8/31/19.
//  Copyright © 2019 IS. All rights reserved.
//

import Foundation

typealias ReviewList = [Review]

struct Review: Codable {
    let id, product, rate: Int?
    let text: String?
    let created_by: CreatedBy?
    let created_at: String?
}

struct CreatedBy: Codable {
    let id: Int?
    let username: String?
    let first_name, last_name: String?
    let email: String?
    
}
