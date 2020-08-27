//
//  TestPackageTableViewCell.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 27/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import UIKit

class TestPackageTableViewCell: UITableViewCell
{
    // MARK: - IBOutlets
    @IBOutlet weak var testOrPackageNameLabel: UILabel!
    @IBOutlet weak var labNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var addRemoveCartButton: UIButton!
    
    // MARK: - Properties
    private var cellDataModel: TestPackageTableViewCellRepresentable?
    
    // MARK: - UI Methods
    func setUpCell(with cellModel: TestPackageTableViewCellRepresentable, at indexPath: IndexPath)
    {
        testOrPackageNameLabel.text = cellModel.getTestPackageName(at: indexPath)
        labNameLabel.text           = cellModel.getLabName(at: indexPath)
        amountLabel.text            = cellModel.getTestPackageAmount(at: indexPath)
        cellDataModel               = cellModel
        addRemoveCartButton.tag     = indexPath.row
        updateAddRemoveCartButtonText(at: indexPath)
    }
    
    private func updateAddRemoveCartButtonText(at cellIndexPath: IndexPath)
    {
        addRemoveCartButton.setTitle(cellDataModel?.getCartButtonText(at: cellIndexPath), for: UIControl.State.normal)
        addRemoveCartButton.setTitleColor(cellDataModel?.getCartButtonTextColor(at: cellIndexPath), for: UIControl.State.normal)
    }
    
    // MARK: - IBActions
    @IBAction func addToOrRemoveFromButtonAction(_ sender: UIButton)
    {
        let cellIndexPath = IndexPath(row: sender.tag, section: 0)
        cellDataModel?.addOrRemoveTestPackageFromCart(at: cellIndexPath)
        updateAddRemoveCartButtonText(at: cellIndexPath)
    }
}
