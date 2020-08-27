//
//  TestPackageViewModel.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 27/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import UIKit

class TestPackageViewModel
{
    private var testPackagesDataModel        : TestPackagesModel?
    private var filteredTestPackagesDataModel: TestPackagesModel?
    
    var numberOfRows: Int
    {
        guard let dataModel = filteredTestPackagesDataModel else { return 0 }
        return dataModel.count
    }
    
    //updateActualIndexesOfTestPackageData() will redude the complexity of finding element in testPackagesDataModel to O(1)
    private func updateActualIndexesOfTestPackageData()
    {
        guard let testPackageModel = testPackagesDataModel, let filterTestPackageModel = filteredTestPackagesDataModel, testPackageModel.count == filterTestPackageModel.count else { return }
        for index in 0..<testPackageModel.count
        {
            testPackagesDataModel?[index].actualIndex         = index
            filteredTestPackagesDataModel?[index].actualIndex = index   //This needs to be done in filteredTestPackagesDataModel because TestPackagesModel is a structure. So it's a value type
        }
    }
    
    private func isTestPackageAlreadyInCart(at indexPath: IndexPath) -> Bool
    {
        guard let dataModel = filteredTestPackagesDataModel, indexPath.row < dataModel.count else { return false }
        return dataModel[indexPath.row].isAlreadyInCart
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
                    strongSelf.testPackagesDataModel         = testPackagesModel
                    strongSelf.filteredTestPackagesDataModel = testPackagesModel
                    strongSelf.updateActualIndexesOfTestPackageData()
                    completionHandler?(nil)
                case .failure(let error):
                    strongSelf.testPackagesDataModel         = nil
                    strongSelf.filteredTestPackagesDataModel = nil
                    completionHandler?(error)
            }
        }
    }
    
    func filterTestPackagesData(with searchedString: String, andPerform completionHandler: (() -> Void)?)
    {
        if !searchedString.isEmpty
        {
            filteredTestPackagesDataModel = testPackagesDataModel?.filter({ ($0.itemName?.lowercased().contains(searchedString.lowercased()))! })
        }
        else
        {
            filteredTestPackagesDataModel = testPackagesDataModel
        }
        completionHandler?()
    }
}

extension TestPackageViewModel: TestPackageTableViewCellRepresentable
{
    func getTestPackageName(at indexPath: IndexPath) -> String
    {
        guard let dataModel = filteredTestPackagesDataModel, indexPath.row < dataModel.count else { return "" }
        return dataModel[indexPath.row].itemName ?? ""
    }
    
    func getLabName(at indexPath: IndexPath) -> String
    {
        guard let dataModel = filteredTestPackagesDataModel, indexPath.row < dataModel.count else { return "" }
        return dataModel[indexPath.row].labName ?? ""
    }
    
    func getTestPackageAmount(at indexPath: IndexPath) -> String
    {
        guard let dataModel = filteredTestPackagesDataModel, indexPath.row < dataModel.count, let price = dataModel[indexPath.row].minPrice else { return "" }
        return "₹ \(price)"
    }
    
    func addOrRemoveTestPackageFromCart(at indexPath: IndexPath)
    {
        guard let dataModel = filteredTestPackagesDataModel, indexPath.row < dataModel.count else { return }
        filteredTestPackagesDataModel?[indexPath.row].isAlreadyInCart                 = !dataModel[indexPath.row].isAlreadyInCart
        testPackagesDataModel?[dataModel[indexPath.row].actualIndex].isAlreadyInCart  = !dataModel[indexPath.row].isAlreadyInCart
    }
    
    func getCartButtonText(at indexPath: IndexPath) -> String
    {
        return isTestPackageAlreadyInCart(at: indexPath) ? "Remove From Cart" : "Add To Cart"
    }
    
    func getCartButtonTextColor(at indexPath: IndexPath) -> UIColor
    {
        return isTestPackageAlreadyInCart(at: indexPath) ? UIColor.red : UIColor.systemGreen
    }
}
