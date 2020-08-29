//
//  Storyboardable.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 29/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import UIKit

protocol Storyboardable
{
    static var storyboardName: String { get }
    static var storyboardIdentifier: String { get }
    
    static func instantiate() -> Self
}

extension Storyboardable where Self: UIViewController
{
    static var storyboardName: String
    {
        let viewControllerStoryboardName = String(describing: self)
        switch viewControllerStoryboardName
        {
            case "ErrorPageViewController", "CartViewController":
                return "Main"
            default:
                return ""
        }
    }
    
    static var storyboardIdentifier: String
    {
        return String(describing: self)
    }
    
    static func instantiate() -> Self
    {
        guard let viewController = UIStoryboard(name: self.storyboardName, bundle: nil).instantiateViewController(withIdentifier: self.storyboardIdentifier) as? Self
        else
        {
            fatalError("Unable to Instantiate View Controller With Storyboard Identifier \(String(describing: self))")
        }
        return viewController
    }
}
