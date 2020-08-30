//
//  CartViewController.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 29/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import UIKit

class CartViewController: UIViewController
{
    // MARK: - IBOutlets
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var TotalAmountLabel: UILabel!
    
    // MARK: - Properties
    var testPackagesFetchRequiredClosure: ((Bool) -> Void)?
    private lazy var cartViewModel      : CartViewModel = {
        return CartViewModel()
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpScreen()
    }
    
    // MARK: - UI Methods
    private func setUpScreen()
    {
        cartTableView.dataSource      = self
        cartTableView.tableFooterView = UIView()
        title                         = cartViewModel.screenTitle
        updateTotalAmountLabel()
    }
    
    private func updateTotalAmountLabel()
    {
        TotalAmountLabel.text = cartViewModel.getTotalAmount()
    }
    
    // MARK: - IBActions
    @IBAction func proceedButtonTapAction(_ sender: UIButton)
    {
        cartViewModel.removeAllElementsFromCart()
        cartTableView.reloadSections([0], with: UITableView.RowAnimation.automatic)
        updateTotalAmountLabel()
        testPackagesFetchRequiredClosure?(true)
        createCartHandlingViewWith(header: cartViewModel.getCartHeaderOn(cartState: CartStateEnum.orderCompletion), and: cartViewModel.getCartDescriptionOn(cartState: CartStateEnum.orderCompletion), withSelector: #selector(goToButtoonSelector))
    }
}

extension CartViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cartViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: CartTableViewCell     = tableView.dequeueReusableCell(for: indexPath)
        cell.setUpCell(cellModel: cartViewModel, at: indexPath)
        cell.cartTableViewReloadClosure = { [weak self] (index) in
            guard let strongSelf = self else { return }
            let isCartEmpty = strongSelf.cartViewModel.removeElementFromCartAndCheckIfCartIsEmpty(at: index)
            DispatchQueue.main.async
            {
                strongSelf.cartTableView.reloadSections([0], with: UITableView.RowAnimation.automatic)
                strongSelf.updateTotalAmountLabel()
                if isCartEmpty
                {
                    strongSelf.createCartHandlingViewWith(header: strongSelf.cartViewModel.getCartHeaderOn(cartState: CartStateEnum.empty), and: strongSelf.cartViewModel.getCartDescriptionOn(cartState: CartStateEnum.empty), withSelector: #selector(strongSelf.goToButtoonSelector))
                }
            }
            strongSelf.testPackagesFetchRequiredClosure?(true)
        }
        return cell
    }
}

extension CartViewController: Storyboardable {}

extension CartViewController: PurchaseCompletionOrEmptyCartViewPresenter
{
    @objc func goToButtoonSelector()
    {
        navigationController?.popViewController(animated: true)
    }
}
