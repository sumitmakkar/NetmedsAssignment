//
//  TestPackageViewModel.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 27/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import Foundation

class TestPackageViewModel
{
    private var testPackagesDataModel: TestPackagesModel?
    
    var numberOfRows: Int
    {
        guard let dataModel = testPackagesDataModel else { return 0 }
        return dataModel.count
    }
    
    func fetchTestPackageData(andPerformCompletion completionHandler: ((NetworkError?) -> Void)?)
    {
        ServiceManager.shared.fetchTestPackagesData { [weak self] (responseResult) in
            guard let strongSelf = self
            else
            {
                completionHandler?(.decodingError)
                return
            }
            switch responseResult
            {
                case .success(let testPackagesModel):
                    strongSelf.testPackagesDataModel = testPackagesModel
                    completionHandler?(nil)
                case .failure(let error):
                    strongSelf.testPackagesDataModel = nil
                    completionHandler?(error)
            }
        }
    }
}

extension TestPackageViewModel: TestPackageTableViewCellRepresentable
{
    func getTestPackageName(at indexPath: IndexPath) -> String
    {
        guard let dataModel = testPackagesDataModel else { return "" }
        return dataModel[indexPath.row].itemName ?? ""
    }
    
    func getLabName(at indexPath: IndexPath) -> String
    {
        guard let dataModel = testPackagesDataModel else { return "" }
        return dataModel[indexPath.row].labName ?? ""
    }
    
    func getTestPackageAmount(at indexPath: IndexPath) -> String
    {
        guard let dataModel = testPackagesDataModel, let price = dataModel[indexPath.row].minPrice else { return "" }
        return "₹ \(price)"
    }
    
    func addOrRemoveTestPackageFromCart(at indexPath: IndexPath)
    {
        
    }
    
    
}
