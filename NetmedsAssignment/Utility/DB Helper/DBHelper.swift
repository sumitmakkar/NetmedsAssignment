//
//  DBHelper.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 28/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import Foundation
import SQLite3

enum DatabaseCRUDOperation: String
{
    case insertion = "INSERT INTO "
    case read      = "SELECT * FROM "
    case delete    = "DELETE FROM "
}

class DBHelper
{
    var netmedsDatabase: OpaquePointer?
    var databaseName   : String = "netmedsAppDatabase.sqlite"
    
    init(with tableQuery: String? = nil)
    {
        netmedsDatabase = createDB()
        if let query = tableQuery
        {
            createTable(with: query)
        }
    }
    
    private func createDB() -> OpaquePointer?
    {
        guard let filePath = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(databaseName) else { return nil }
        debugPrint("DB File created at: \(filePath)")
        
        var database: OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &database) != SQLITE_OK
        {
            debugPrint("There is error in creating DB")
            return nil
        }
        else
        {
            debugPrint("Database has been created with path \(databaseName)")
            return database
        }
    }
    
    func createTable(with query: String)
    {
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(netmedsDatabase, query, -1, &statement, nil) == SQLITE_OK
        {
            if sqlite3_step(statement) == SQLITE_DONE
            {
                debugPrint("Table creation success")
            }
            else
            {
                debugPrint("Table creation fail")
            }
        }
        else
        {
            debugPrint("Prepration fail")
        }
    }
    
    func insertIntoTable(tableName: String, fromDictionary attributesAndValuesDictionary: [String: Any]?)
    {
        guard let attrValDict = attributesAndValuesDictionary else { return }
        let query = createQuery(for: DatabaseCRUDOperation.insertion, with: attrValDict, in: tableName)
        
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(netmedsDatabase, query, -1, &statement, nil) == SQLITE_OK
        {
            var index: Int32 = 0
            for dictKey in attrValDict.keys
            {
                index += 1
                if let value = attrValDict[dictKey] as? Int
                {
                    sqlite3_bind_int(statement, index, Int32(value))
                }
                else if let value = attrValDict[dictKey] as? NSString
                {
                    sqlite3_bind_text(statement, index, value.utf8String, -1, nil)
                }
            }
            
            if sqlite3_step(statement) == SQLITE_DONE
            {
                debugPrint("Data inserted success")
            }
            else
            {
                debugPrint("Data is not inserted in table")
            }
        }
        else
        {
            debugPrint("Query is not as per requirement")
        }
        
    }
    
    func readTestPackagesFromTable(tableName: String, where whereQueryClause: String? = nil) -> TestPackagesModel
    {
        let query = DatabaseCRUDOperation.read.rawValue + tableName + (whereQueryClause != nil ? " WHERE \(whereQueryClause!);" : ";")
        var statement: OpaquePointer? = nil
        var testPackagesModel         = TestPackagesModel()
        if sqlite3_prepare_v2(netmedsDatabase, query, -1, &statement, nil) == SQLITE_OK
        {
            while sqlite3_step(statement) == SQLITE_ROW
            {
                let sNo           = Int(sqlite3_column_int(statement, 0))
                let itemID        = String(cString: sqlite3_column_text(statement, 1))
                let itemName      = String(cString: sqlite3_column_text(statement, 2))
                let type          = String(cString: sqlite3_column_text(statement, 3))
                let keyword       = String(cString: sqlite3_column_text(statement, 4))
                let bestSellers   = String(cString: sqlite3_column_text(statement, 5))
                let testCount     = Int(sqlite3_column_int(statement, 6))
                let includedTests = String(cString: sqlite3_column_text(statement, 7))
                let url           = String(cString: sqlite3_column_text(statement, 8))
                let minPrice      = Int(sqlite3_column_int(statement, 9))
                let labName       = String(cString: sqlite3_column_text(statement, 10))
                let fasting       = Int(sqlite3_column_int(statement, 11))
                let availableAt   = Int(sqlite3_column_int(statement, 12))
                let popular       = String(cString: sqlite3_column_text(statement, 13))
                let category      = String(cString: sqlite3_column_text(statement, 14))
                let objectID      = String(cString: sqlite3_column_text(statement, 15))

                let testPackageElement = TestPackagesModelElement(sNo: sNo, itemID: itemID, itemName: itemName, type: type, keyword: keyword, bestSellers: bestSellers, testCount: testCount, includedTests: includedTests, url: url, minPrice: minPrice, labName: labName, fasting: fasting, availableAt: availableAt, popular: popular, category: category, objectID: objectID)
                testPackagesModel.append(testPackageElement)
            }
        }
        return testPackagesModel
    }
    
    func deleteTestPackageFromTable(tableName: String, where whereQueryClause: String? = nil)
    {
        let query                     = DatabaseCRUDOperation.delete.rawValue + tableName + (whereQueryClause ?? "")
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(netmedsDatabase, query, -1, &statement, nil) == SQLITE_OK
        {
            if sqlite3_step(statement) == SQLITE_DONE
            {
                print("Data delete success")
            }
            else
            {
                print("Data is not deleted in table")
            }
        }
    }
    
    // MARK: - Prvate Methods
    private func createQuery(for operation: DatabaseCRUDOperation, with attributesAndValuesDictionary: [String: Any], in tableName: String) -> String
    {
        var attributesString = " ("
        var valuesString     = " ("
        for attributeKey in attributesAndValuesDictionary.keys
        {
            if attributesString != " ("
            {
                attributesString += ", \(attributeKey)"
                valuesString     += ", ?"
            }
            else
            {
                attributesString += attributeKey
                valuesString     += "?"
            }
        }
        attributesString += ")"
        valuesString     += ");"
        return (operation.rawValue + tableName + attributesString + " VALUES " + valuesString)
    }
}
