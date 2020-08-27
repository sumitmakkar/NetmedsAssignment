//
//  Debugger.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 27/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import Foundation

open class Debugger {

    static func printDictionary(dictionary: [String: Any]?) {
        do {
            guard let dict = dictionary else {return}
            let data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue) { debugPrint(json) }
        } catch { debugPrint("JSON string could not be printed") }
    }
}

