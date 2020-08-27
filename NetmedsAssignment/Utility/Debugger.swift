//
//  Debugger.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 27/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import Foundation

public extension Data {
    var dictionary: [String: Any]? {
        return (try? JSONSerialization.jsonObject(with: self, options: .mutableContainers)).flatMap { $0 as? [String: Any] }
    }
    
    var arrayDictionary: [[String: Any]]? {
        return (try? JSONSerialization.jsonObject(with: self, options: .mutableContainers)).flatMap { $0 as? [[String: Any]] }
    }
}

open class Debugger
{
    static func printDictionary(dictionary: [String: Any]?)
    {
        do
        {
            guard let dict = dictionary else {return}
            let data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue) { debugPrint(json) }
        }
        catch
        {
            debugPrint("JSON string could not be printed")
        }
    }
    
    static func printArrayDictionary(arrayDictionary: [[String: Any]]?)
    {
        do
        {
            guard let arrDict = arrayDictionary else {return}
            let data = try JSONSerialization.data(withJSONObject: arrDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue) { debugPrint(json) }
        }
        catch
        {
            debugPrint("JSON string could not be printed")
        }
    }
}

