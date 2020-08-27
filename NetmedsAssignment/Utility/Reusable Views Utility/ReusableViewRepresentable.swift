//
//  ReusableViewRepresentable.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 27/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import Foundation

protocol ReusableViewRepresentable
{
    static var reuseIdentifier: String { get }
}

extension ReusableViewRepresentable
{
    static var reuseIdentifier: String
    {
        return String(describing: self)
    }
}
