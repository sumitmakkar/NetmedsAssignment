//
//  ViewController.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 27/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import UIKit

class TestPackageViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ServiceManager.shared.fetchTestPackagesData { (res) in
            print(res)
        }
    }
}
