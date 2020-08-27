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
    // MARK: - IBOutlets
    @IBOutlet weak var testPackageDataTableView: UITableView!
    
    // MARK: - Properties
    private lazy var testPackageViewModel: TestPackageViewModel = { return TestPackageViewModel() }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupScreen()
    }
    
    override func loadView()
    {
        super.loadView()
        setUpTestPackageDataTableView()
    }
    
    // MARK: - UI Methods
    private func setupScreen()
    {
        title = "Netmeds"
        fetchDataAndUpdateScreen()
    }
    
    //Adding Table View
    private func setUpTestPackageDataTableView()
    {
        testPackageDataTableView.tableFooterView = UIView() //This will avoid extra separators of UITableView
        testPackageDataTableView.dataSource      = self
    }
    
    private func reloadTestPackageDataTableview()
    {
        DispatchQueue.main.async
        { [weak self] in
            guard let strongSelf = self else { return }
            UIView.transition(with: strongSelf.testPackageDataTableView, duration: 0.30, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                strongSelf.testPackageDataTableView.reloadData()
            })
        }
    }
    
    // MARK: - Fetching Data
    private func fetchDataAndUpdateScreen()
    {
        startLoading()
        testPackageViewModel.fetchTestPackageData { [weak self] (networkError) in
            guard let strongSelf = self else { return }
            strongSelf.stopLoading()
            if let networkErr = networkError
            {
                debugPrint(networkErr.localizedDescription)
            }
            else
            {
                strongSelf.reloadTestPackageDataTableview()
            }
        }
    }
}

// MARK: - UITableView Datasource
extension TestPackageViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return testPackageViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: TestPackageTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setUpCell(with: testPackageViewModel, at: indexPath)
        return cell
    }
}
