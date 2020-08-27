//
//  ServiceManager+APIRequestPerformer.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 27/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import Foundation

public extension ServiceManager
{
    func performAPIRequest<T: Codable>(urlString: String, parameters: [String: Any]?, httpMethod: HTTPMethod = .get, requestModel: T? =  nil, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        guard let url =  URL(string: urlString) else {
            completion(.failure(.badUrl))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let parameters = parameters
        {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        if let decodable = requestModel
        {
            let encoder         = JSONEncoder()
            let data            = try? encoder.encode(decodable)
            urlRequest.httpBody =  data
        }
        
        loadNetworkRequest(request: urlRequest, completion: completion)
    }
}
