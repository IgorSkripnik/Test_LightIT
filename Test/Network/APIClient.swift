//
//  APIClient.swift
//  Test
//
//  Created by imac on 3/28/19.
//  Copyright © 2019 imac. All rights reserved.
//

import Foundation
import Alamofire

enum Either<T> {
    case success(T)
    case error(Error)
}

enum APIError: Error {
    case badResponse
    case emptiData
    case jsonDecoder
}

protocol APIClient {
    func general<T: Codable>(_ request: URLRequest, completion: @escaping (Either<T>) -> Void)
}
extension APIClient {
 
    func general<T: Codable>(_ request: URLRequest, completion:
        @escaping (Either<T>) -> Void) {

        AF.request(request).response { response in
            if response.result.isSuccess {
                guard let data = response.data else {
                    completion(.error(APIError.emptiData))
                    return
                }
                do {
                    switch request.httpMethod {
                    case Method.post.rawValue:
                        let val = String(decoding: data, as: UTF8.self)
                        print(val.html2Attributed as Any)
                        guard let dict = self.convertJsonStringToDictionary(text: val) else {
                            completion(.error(APIError.jsonDecoder))
                            return
                        }
                        if let resultObj = ResultObj(dict) as? T {
                            completion(Either.success(resultObj))
                        }
                    case Method.get.rawValue:
                    
                        let value = try JSONDecoder().decode(T.self, from: data)
                        completion(Either.success(value))
                    default:
                        completion(.error(APIError.jsonDecoder))
                    }
                    
                } catch let error {
                    print(error)
                    completion(.error(APIError.jsonDecoder))
                }
            } else {
                completion(.error(APIError.badResponse))
            }
        }
    }
    
    private func convertJsonStringToDictionary(text: String) -> [String: Any]? {
        if let data = text.replacingOccurrences(of: "\n", with: "").data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
