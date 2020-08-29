//
//  CartTableViewCellRepresentable.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 29/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import Foundation

protocol CartTableViewCellRepresentable
{
    func getTestPackageName(at indexPath: IndexPath) -> String
    func getLabName(at indexPath: IndexPath) -> String
    func getTestPackageAmount(at indexPath: IndexPath) -> String
}
