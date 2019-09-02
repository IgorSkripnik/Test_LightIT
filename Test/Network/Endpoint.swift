//
//  Endpoint.swift
//  Test
//
//  Created by Igor Skripnik on 8/31/19.
//  Copyright © 2019 IS. All rights reserved.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var urlParameters: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension Endpoint {
    var urlComponents: URLComponents? {
        var urlComponents = URLComponents(string: self.baseURL)
        urlComponents?.path = path
        if let params = self.urlParameters {
            urlComponents?.queryItems = params
        }
        return urlComponents
    }
}

enum ProductEndpoint: Endpoint {
    
    case register(username: String, password: String)
    case login(username: String, password: String)
    case products
    case reviews(productId: String)
    case review(rate: Int, review: String, prodId: String)
    
    var baseURL: String {
        return BaseUrl
    }
    
    var path: String {
        
        switch self {
        case .register:
            return Path.register.rawValue
        case .products:
            return Path.products.rawValue
        case .login:
            return Path.login.rawValue
        case .reviews(let id), .review(_, _, let id):
            return Path.reviews.rawValue + "/\(id)"
        }
    }
    
    var urlParameters: [URLQueryItem]? {
        switch self {
        case .products, .register, .login, .reviews,.review:
            return nil
        }
    }
    var body: Data? {
        switch self {
        case .products, .reviews:
            return nil
        case .register(let username, let password), .login(let username, let password):
            
            let dict = ["username" : username,
                        "password" : password]
            let data = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.sortedKeys)
            return data
        case .review(let rate, let review, _):
             let dict = ["rate" : rate,
                         "text" : review] as [String : Any]
             let data = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.sortedKeys)
             return data
        }
    }
    func request(_ method: Method, token: String?) -> URLRequest {
        var request = URLRequest(url: (urlComponents?.url)!)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        if let token = token {
            request.addValue("Token " + token, forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
// destanation path
enum Path: String {
    case register = "/api/register/"
    case products = "/api/products"
    case login = "/api/login/"
    case reviews = "/api/reviews"
}
