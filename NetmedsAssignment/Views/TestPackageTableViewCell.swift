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
    
    // MARK: - UI Methods
    func setUpCell(with cellModel: TestPackageTableViewCellRepresentable, at indexPath: IndexPath)
    {
        testOrPackageNameLabel.text = cellModel.getTestPackageName(at: indexPath)
        labNameLabel.text           = cellModel.getLabName(at: indexPath)
        amountLabel.text            = cellModel.getTestPackageAmount(at: indexPath)
    }
    
    // MARK: - IBActions
    @IBAction func addToOrRemoveFromButtonAction(_ sender: UIButton)
    {
        
    }
}
