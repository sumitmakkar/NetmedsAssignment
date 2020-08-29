//
//  CartTableViewCell.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 29/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell
{
    // MARK: - IBOutlets
    @IBOutlet weak var testPackageNamelabel: UILabel!
    @IBOutlet weak var labNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    // MARK: - Properties
    var cartTableViewReloadClosure: ((Int) -> Void)?

    // MARK: - UI Methods
    func setUpCell(cellModel: CartTableViewCellRepresentable, at indexPath: IndexPath)
    {
        testPackageNamelabel.text = cellModel.getTestPackageName(at: indexPath)
        labNameLabel.text         = cellModel.getLabName(at: indexPath)
        amountLabel.text          = cellModel.getTestPackageAmount(at: indexPath)
        deleteButton.tag          = indexPath.row
    }
    
    // MARK: - IBActions
    @IBAction func deleteButtonTapAction(_ sender: UIButton)
    {
        cartTableViewReloadClosure?(sender.tag)
    }
}
