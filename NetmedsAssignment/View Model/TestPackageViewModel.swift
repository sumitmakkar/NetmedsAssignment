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
    private let testPackagesTableName        : String = "testPackages"
    private var databaseHelper               : DBHelper?
    private var cartButtonStatusClosure      : ((Bool) -> Void)?
    private var cartArray                    : TestPackagesModel?
    {
        didSet
        {
            cartButtonStatusClosure?(cartArray?.count == 0)
        }
    }
    
    private var testPackagesTableCreationQuery: String
    {
        return "CREATE TABLE IF NOT EXISTS \(testPackagesTableName) (sNo INTEGER PRIMARY KEY, itemID TEXT, itemName TEXT, type TEXT, keyword TEXT, bestSellers TEXT, testCount INTEGER, includedTests TEXT, url TEXT, minPrice INTEGER, labName TEXT, fasting INTEGER, availableAt INTEGER, popular TEXT, category TEXT, objectID TEXT);"
    }
    
    var numberOfRows: Int
    {
        guard let dataModel = filteredTestPackagesDataModel else { return 0 }
        return dataModel.count
    }
    
    // MARK: - Initializer
    init(with cartButtonClosure: ((Bool) -> Void)?)
    {
        cartButtonStatusClosure = cartButtonClosure
        databaseHelper          = DBHelper(with: testPackagesTableCreationQuery)
        updateCartArray()
        cartButtonStatusClosure?(cartArray?.count == 0)
    }
    
    // MARK: - API Methods
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
    
    //Updating test packages with already selected in cart
    private func updateAlreadyInCardStatusOfTestPackagesData()
    {
        guard let cartArrayUnwrapped = cartArray, let testPackagesDataModelUnwrapped = testPackagesDataModel else { return }
        for cartElement in cartArrayUnwrapped
        {
            for (index, testPackage) in testPackagesDataModelUnwrapped.enumerated() where testPackage.sNo == cartElement.sNo
            {
                testPackagesDataModel?[index].isAlreadyInCart         = true
                filteredTestPackagesDataModel?[index].isAlreadyInCart = true
            }
        }
    }
    
    private func isTestPackageAlreadyInCart(at indexPath: IndexPath) -> Bool
    {
        guard let dataModel = filteredTestPackagesDataModel, indexPath.row < dataModel.count else { return false }
        return dataModel[indexPath.row].isAlreadyInCart
    }
    
    private func insertOrRemoveTestPackageFromDatabase(at indexPath: IndexPath)
    {
        guard var dataModel = filteredTestPackagesDataModel, indexPath.row < dataModel.count else { return }
        if !dataModel[indexPath.row].isAlreadyInCart
        {
            databaseHelper?.insertIntoTable(tableName: testPackagesTableName, fromDictionary: prepareDictionaryForDatabaseInsertion(from: dataModel[indexPath.row]))
            dataModel[indexPath.row].isAlreadyInCart = true     //Changing isAlreadyInCart property to true. It is although not required
            cartArray?.append(dataModel[indexPath.row])         //Adding in cartArray as well
        }
        else
        {
            guard let sNo = dataModel[indexPath.row].sNo else { return }
            databaseHelper?.deleteTestPackageFromTable(tableName: testPackagesTableName, where: " where sNo = \(sNo)")
            //Deleting from cartArray as well
            if let indexOfElementInCart = cartArray?.firstIndex(where: { $0.sNo == sNo })
            {
                cartArray?.remove(at: indexOfElementInCart)
            }
        }
    }
    
    private func prepareDictionaryForDatabaseInsertion(from testPackage: TestPackagesModelElement) -> [String: Any]
    {
        var dbInsertionDictionary              = [String: Any]()
        dbInsertionDictionary["sNo"]           = testPackage.sNo ?? -1
        dbInsertionDictionary["itemID"]        = testPackage.itemID ?? ""
        dbInsertionDictionary["itemName"]      = testPackage.itemName ?? ""
        dbInsertionDictionary["type"]          = testPackage.type ?? ""
        dbInsertionDictionary["keyword"]       = testPackage.keyword ?? ""
        dbInsertionDictionary["bestSellers"]   = testPackage.bestSellers ?? ""
        dbInsertionDictionary["testCount"]     = testPackage.testCount ?? -1
        dbInsertionDictionary["includedTests"] = testPackage.includedTests ?? ""
        dbInsertionDictionary["url"]           = testPackage.url ?? ""
        dbInsertionDictionary["minPrice"]      = testPackage.minPrice ?? -1
        dbInsertionDictionary["labName"]       = testPackage.labName ?? ""
        dbInsertionDictionary["fasting"]       = testPackage.fasting ?? -1
        dbInsertionDictionary["availableAt"]   = testPackage.availableAt ?? -1
        dbInsertionDictionary["popular"]       = testPackage.popular ?? ""
        dbInsertionDictionary["category"]      = testPackage.category ?? ""
        dbInsertionDictionary["objectID"]      = testPackage.objectID ?? ""

        if let serialNo = testPackage.sNo
        {
            dbInsertionDictionary["sNo"] = serialNo
        }
        if let itemId = testPackage.itemID
        {
            dbInsertionDictionary["itemID"] = itemId
        }
        if let itemName = testPackage.itemName
        {
            dbInsertionDictionary["itemName"] = itemName
        }
        if let type = testPackage.type
        {
            dbInsertionDictionary["type"] = type
        }
        if let keyword = testPackage.keyword
        {
            dbInsertionDictionary["keyword"] = keyword
        }
        if let bestSellers = testPackage.bestSellers
        {
            dbInsertionDictionary["bestSellers"] = bestSellers
        }
        if let testCount = testPackage.testCount
        {
            dbInsertionDictionary["testCount"] = testCount
        }
        if let includedTests = testPackage.includedTests
        {
            dbInsertionDictionary["includedTests"] = includedTests
        }
        if let url = testPackage.url
        {
            dbInsertionDictionary["url"] = url
        }
        if let minPrice = testPackage.minPrice
        {
            dbInsertionDictionary["minPrice"] = minPrice
        }
        if let labName = testPackage.labName
        {
            dbInsertionDictionary["labName"] = labName
        }
        if let fasting = testPackage.fasting
        {
            dbInsertionDictionary["fasting"] = fasting
        }
        if let availableAt = testPackage.availableAt
        {
            dbInsertionDictionary["availableAt"] = availableAt
        }
        if let popular = testPackage.popular
        {
            dbInsertionDictionary["popular"] = popular
        }
        if let category = testPackage.category
        {
            dbInsertionDictionary["category"] = category
        }
        if let objectID = testPackage.objectID
        {
            dbInsertionDictionary["objectID"] = objectID
        }
        return dbInsertionDictionary
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
                    strongSelf.updateAlreadyInCardStatusOfTestPackagesData()
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
    
    func updateCartArray()
    {
        cartArray = databaseHelper?.readTestPackagesFromTable(tableName: testPackagesTableName)
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
        
        insertOrRemoveTestPackageFromDatabase(at: indexPath)        //add it in or remove from db
        
        //toggling the cart effect
        filteredTestPackagesDataModel?[indexPath.row].isAlreadyInCart.toggle()
        testPackagesDataModel?[dataModel[indexPath.row].actualIndex].isAlreadyInCart.toggle()
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
