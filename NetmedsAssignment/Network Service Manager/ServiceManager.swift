//
//  ServiceManager.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 27/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import Foundation

public class ServiceManager
{
    public static let shared = ServiceManager()
    
    public func loadNetworkRequest<T: Codable>(request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void)
    {
        
        if !Reachability.isConnectedToNetwork()
        {
            completion(.failure(.noInternetError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error as NSError?, error.domain == NSURLErrorDomain
            {
                completion(.failure(.domainError))
                return
            }
            else
            {
                if let response = response, let data = data, !response.isSuccess
                {
                    do
                    {
                        let result = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        let error  = NetworkError.badAllErrorResponse(code: response.httpStatusCode, description: result.message, errorCode: result.errorCode, errorMessage: result.errorMessage, errorReason: result.errorReason)
                        completion(.failure(error))
                        return
                    }
                    catch
                    {
                        completion(.failure(.decodingError))
                        return
                    }
                }
                
                if let data = data
                {
                    Debugger.printArrayDictionary(arrayDictionary: data.arrayDictionary)
                    do
                    {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(result))
                    }
                    catch
                    {
                        completion(.failure(.decodingError))
                    }
                }
            }
        }.resume()
    }
}
