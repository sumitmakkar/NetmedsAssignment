//
//  APIRequestManager.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 27/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import Foundation

extension ServiceManager
{
    func fetchTestPackagesData(completion: @escaping (Result<TestPackagesModel, NetworkError>) -> Void)
    {
        return performAPIRequest(urlString: URLConstants.testPackagesList.urlString, parameters: nil, completion: completion)
    }
}
