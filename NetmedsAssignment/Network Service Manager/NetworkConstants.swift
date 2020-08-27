//
//  NetworkConstants.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 27/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import Foundation

public enum HTTPMethod: String
{
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

public struct Request
{
    let method: HTTPMethod
    let url   : String
    let body  : [String: Any]
    
    public init(method: HTTPMethod, url: String, body: [String: Any] = [:])
    {
        self.method = method
        self.url    = url
        self.body   = body
    }
}

public enum NetworkError: Error
{
    case noInternetError
    case domainError
    case decodingError
    case badUrl
    case business
    case badResponse(code: Int?, description: String?)
    case badAllErrorResponse(code: Int?, description: String?, errorCode: String?, errorMessage: String?, errorReason: String?)
}

struct ErrorResponse: Codable
{
    let status, message, errorCode, errorMessage, errorReason: String?
}
