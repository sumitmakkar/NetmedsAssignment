//
//  URLResponse+Status.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 27/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import Foundation

extension URLResponse
{
    var isSuccess: Bool
    {
        return httpStatusCode >= 200 && httpStatusCode < 300
    }

    var httpStatusCode: Int
    {
        guard let statusCode = (self as? HTTPURLResponse)?.statusCode
        else
        {
            return 0
        }
        return statusCode
    }
}
