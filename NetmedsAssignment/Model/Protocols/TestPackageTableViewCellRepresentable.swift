//
//  TestPackageTableViewCellRepresentable.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 27/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import UIKit

protocol TestPackageTableViewCellRepresentable: CartTableViewCellRepresentable
{
    func addOrRemoveTestPackageFromCart(at indexPath: IndexPath)
    func getCartButtonText(at indexPath: IndexPath) -> String
    func getCartButtonTextColor(at indexPath: IndexPath) -> UIColor
}
