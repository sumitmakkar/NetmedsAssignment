//
//  NetworkRequestBuilder.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 27/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import Foundation

final class NetworkRequestBuilder
{
    func buildRequest(_ request: Request) throws -> URLRequest
    {
        guard let url = URL(string: request.url)
        else
        {
            throw NetworkError.badUrl
        }

        guard let body = try? JSONSerialization.data(withJSONObject: request.body, options: [])
        else
        {
            throw NetworkError.decodingError
        }
        
        var urlRequest        = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        if request.body.count > 0
        {
            urlRequest.httpBody = body
        }
        
        return urlRequest
    }
}
