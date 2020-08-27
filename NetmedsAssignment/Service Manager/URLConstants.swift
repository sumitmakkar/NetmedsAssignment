//
//  URLConstants.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 27/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import Foundation

enum URLConstants
{
    //Base URL
    static private let baseURL = "https://5f1a8228610bde0016fd2a74.mockapi.io/"
    
    //End Points
    case testPackagesList
    
    //URL string for end point
    var urlString: String
    {
        switch self
        {
            case .testPackagesList:
                return (URLConstants.baseURL + "getTestList")
        }
    }
}
