//
//  Product.swift
//  Test
//
//  Created by Igor Skripnik on 8/31/19.
//  Copyright © 2019 IS. All rights reserved.
//

import Foundation

typealias ProductList = [Product]

struct Product: Codable {
    let id: Int
    let title, img, text: String
}
