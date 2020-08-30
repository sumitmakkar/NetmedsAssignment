//
//  CartViewModel.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 29/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import Foundation

enum CartStateEnum
{
    case orderCompletion
    case empty
}

class CartViewModel
{
    // MARK: - Properties
    private let testPackagesTableName: String = "testPackages"
    private let dbHelper                      = DBHelper()
    private var orderPlaceString              = ""
    
    private lazy var cartDataArray: TestPackagesModel = {
        return dbHelper.readTestPackagesFromTable(tableName: testPackagesTableName)
    }()
    
    var numberOfRows: Int
    {
        return cartDataArray.count
    }
    
    var screenTitle: String
    {
        return "CART"
    }
    
    // MARK: - API Methods
    func getTotalAmount() -> String
    {
        var total = 0
        for element in cartDataArray
        {
            total += element.minPrice ?? 0
        }
        return "₹ \(total)"
    }
    
    func removeElementFromCartAndCheckIfCartIsEmpty(at index: Int) -> Bool
    {
        guard let sNo = cartDataArray[index].sNo else { return false }
        cartDataArray.remove(at: index)
        dbHelper.deleteTestPackageFromTable(tableName: testPackagesTableName, where: " where sNo = \(sNo)")
        return cartDataArray.isEmpty
    }
    
    func removeAllElementsFromCart()
    {
        for (index, item) in cartDataArray.enumerated()
        {
            if index == 0
            {
                orderPlaceString += item.itemName ?? ""
            }
            else
            {
                orderPlaceString += ", \(item.itemName ?? "")"
            }
        }
        orderPlaceString += " of \(getTotalAmount())"
        cartDataArray.removeAll()
        dbHelper.deleteTestPackageFromTable(tableName: testPackagesTableName)
    }
    
    func getCartHeaderOn(cartState: CartStateEnum) -> String
    {
        return cartState == CartStateEnum.orderCompletion ? "Thank You!" : "Your cart is empty!"
    }
    
    func getCartDescriptionOn(cartState: CartStateEnum) -> String
    {
        if cartState == CartStateEnum.empty
        {
            return "You have items in cart.\nPlease add items in cart."
        }
        return "Your order for \(orderPlaceString) has been placed successfully."
    }
}

extension CartViewModel: CartTableViewCellRepresentable
{
    func getTestPackageName(at indexPath: IndexPath) -> String
    {
        guard indexPath.row < cartDataArray.count else { return "" }
        return cartDataArray[indexPath.row].itemName ?? ""
    }
    
    func getLabName(at indexPath: IndexPath) -> String
    {
        guard indexPath.row < cartDataArray.count, let labName = cartDataArray[indexPath.row].labName, !labName.isEmpty else { return "Lab Name : N/A" }
        return "Lab Name : \(labName)"
    }
    
    func getTestPackageAmount(at indexPath: IndexPath) -> String
    {
        guard indexPath.row < cartDataArray.count else { return "" }
        return "₹ \(cartDataArray[indexPath.row].minPrice ?? 0)"
    }
}
