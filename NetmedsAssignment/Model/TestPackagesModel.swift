//
//  TestPackagesModel.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 27/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import Foundation

typealias TestPackagesModel = [TestPackagesModelElement]

// MARK: - TestPackagesModelElement
struct TestPackagesModelElement: Codable {
    let sNo: Int?
    let itemID, itemName: String?
    let type: String?
    let keyword: String?
    let bestSellers: String?
    let testCount: Int?
    let includedTests, url: String?
    let minPrice: Int?
    let labName: String?
    let fasting, availableAt: Int?
    let popular: String?
    let category: String?
    let objectID: String?
    var isAlreadyInCart: Bool = false
    var actualIndex: Int      = -1      // This variable holds the actual position of element in the array of model

    enum CodingKeys: String, CodingKey {
        case sNo           = "S.no"
        case itemID        = "itemId"
        case itemName      = "itemName"
        case type          = "type"
        case keyword       = "Keyword"
        case bestSellers   = "Best-sellers"
        case testCount     = "testCount"
        case includedTests = "Included Tests"
        case url           = "url"
        case minPrice      = "minPrice"
        case labName       = "labName"
        case fasting       = "fasting"
        case availableAt   = "availableAt"
        case popular       = "popular"
        case category      = "category"
        case objectID      = "objectID"
    }
}
