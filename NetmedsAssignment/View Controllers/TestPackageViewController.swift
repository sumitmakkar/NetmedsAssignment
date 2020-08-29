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
    @IBOutlet weak var cartButton: UIButton!
    
    // MARK: - Properties
    private let      searchController                           = UISearchController(searchResultsController: nil)
    private lazy var testPackageViewModel: TestPackageViewModel =
                                                                  {
                                                                      return TestPackageViewModel { [weak self] (isCartButtonHidden) in
                                                                          guard let strongSelf = self else { return }
                                                                          DispatchQueue.main.async
                                                                          {
                                                                              strongSelf.cartButton.isHidden = isCartButtonHidden
                                                                          }
                                                                      }
                                                                  }()
    
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
        title                                                 = "Netmeds"
        fetchDataAndUpdateScreen()
        searchController.searchResultsUpdater                 = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder                = "Search"
        navigationItem.searchController                       = searchController
        definesPresentationContext                            = true
        searchController.searchBar.delegate                   = self
    }
    
    //Adding Table View
    private func setUpTestPackageDataTableView()
    {
        testPackageDataTableView.keyboardDismissMode = .onDrag
        testPackageDataTableView.tableFooterView     = UIView() //This will avoid extra separators of UITableView
        testPackageDataTableView.dataSource          = self
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
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.startLoading()
        }
        testPackageViewModel.fetchTestPackageData { [weak self] (networkError) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.stopLoading()
            }
            if let networkErr = networkError
            {
                debugPrint(networkErr.localizedDescription)
                strongSelf.navigateToErrorScreen(with: networkErr.localizedDescription)
            }
            else
            {
                strongSelf.reloadTestPackageDataTableview()
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func cartButtonTapAction(_ sender: UIButton)
    {
        
    }
    
    // MARK: - Navigation Methods
    private func navigateToErrorScreen(with errorMessage: String)
    {
        let errorPageVC                    = ErrorPageViewController.instantiate()
        errorPageVC.errorDescriptionString = errorMessage
        errorPageVC.retryClosure           = { [weak self] in
                                                guard let strongSelf = self else { return }
                                                strongSelf.fetchDataAndUpdateScreen()
                                             }
        present(errorPageVC, animated: true)
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

// MARK: - SearchBar Result Updating
extension TestPackageViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        testPackageViewModel.filterTestPackagesData(with: searchController.searchBar.text ?? "") { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.reloadTestPackageDataTableview()
        }
    }
}

// MARK: - Searchbar delegate
extension TestPackageViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        
    }
}
