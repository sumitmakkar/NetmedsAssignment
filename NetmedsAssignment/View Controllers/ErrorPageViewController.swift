//
//  ErrorPageViewController.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 29/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import UIKit

class ErrorPageViewController: UIViewController
{
    // MARK: - Properties
    private let errorViewHeight         : CGFloat = (UIScreen.main.bounds.height * 2)/5
    private let topAndBottomPadding     : CGFloat = 30
    private let paddingBetweenComponents: CGFloat = 10
    var         errorDescriptionString  : String?
    var         retryClosure            : (() -> Void)?
    var         viewCartClosure         : (() -> Void)?
    
    private lazy var componentsWeightage: [CGFloat] = {
        let divisionFactor: CGFloat = 7
        let availableSpace          = errorViewHeight - (2 * topAndBottomPadding) - (4 * paddingBetweenComponents)
        let weightArray: [CGFloat]  = [availableSpace * getPart(part: 1, of: divisionFactor), availableSpace * getPart(part: 3, of: divisionFactor), availableSpace * getPart(part: 1, of: divisionFactor), availableSpace * getPart(part: 1, of: divisionFactor), availableSpace * getPart(part: 1, of: divisionFactor)]
        return weightArray
    }()
    
    private lazy var isCartButtonEnabled: Bool = {
        let dbHelper = DBHelper()
        return !dbHelper.readTestPackagesFromTable(tableName: "testPackages").isEmpty
    }()
    
    private lazy var errorBackgroundView: UIView = {
        let bgView                = UIView()
        bgView.backgroundColor    = .white
        bgView.layer.cornerRadius = 10
        return bgView
    }()
    
    private lazy var errorHeaderLabel: UILabel = {
        let headerLabel           = UILabel()
        headerLabel.text          = "OOPS!"
        headerLabel.textAlignment = .center
        headerLabel.font          = UIFont.boldSystemFont(ofSize: 25)
        return headerLabel
    }()
    
    private lazy var errorDescriptionLabel: UILabel = {
        let descriptionLabel           = UILabel()
        descriptionLabel.textAlignment = .center
        descriptionLabel.font          = UIFont.systemFont(ofSize: 20)
        descriptionLabel.numberOfLines = 3
        descriptionLabel.text          = self.errorDescriptionString ?? "There is some techical error."
        return descriptionLabel
    }()
    
    private lazy var retryButton: UIButton = {
        let retryButton                = UIButton()
        retryButton.backgroundColor    = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        retryButton.layer.cornerRadius = 5
        retryButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        retryButton.setTitle("Retry", for: UIControl.State.normal)
        retryButton.addTarget(self, action: #selector(retryButtonSelector(_:)), for: UIControl.Event.touchUpInside)
        return retryButton
    }()
    
    private lazy var viewCartButton: UIButton = {
        let viewCartButton                      = UIButton()
        viewCartButton.backgroundColor          = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        viewCartButton.layer.cornerRadius       = 5
        viewCartButton.isUserInteractionEnabled = isCartButtonEnabled
        viewCartButton.alpha                    = isCartButtonEnabled ? 1 : 0.2
        viewCartButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        viewCartButton.setTitle("View Cart", for: UIControl.State.normal)
        viewCartButton.addTarget(self, action: #selector(viewCartButtonSelector(_:)), for: UIControl.Event.touchUpInside)
        return viewCartButton
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton                = UIButton()
        cancelButton.backgroundColor    = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        cancelButton.layer.cornerRadius = 5
        cancelButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        cancelButton.setTitle("Cancel", for: UIControl.State.normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonSelector(_:)), for: UIControl.Event.touchUpInside)
        return cancelButton
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
        //Adding subviews
        view.addSubview(errorBackgroundView)
        errorBackgroundView.addSubview(errorHeaderLabel)
        errorBackgroundView.addSubview(errorDescriptionLabel)
        errorBackgroundView.addSubview(retryButton)
        errorBackgroundView.addSubview(viewCartButton)
        errorBackgroundView.addSubview(cancelButton)
        
        //Adding Constraints
        addErrorBackgroundViewConstraints()
        addErrorHeaderLabelConstraints()
        addErrorDescriptionLabelConstraints()
        addRetryButtonConstraints()
        addViewCartButtonConstraints()
        addCancelButtonConstraints()
    }
    
    //Adding Constraints
    private func addErrorBackgroundViewConstraints()
    {
        errorBackgroundView.translatesAutoresizingMaskIntoConstraints                                       = false
        errorBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive    = true
        errorBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        errorBackgroundView.heightAnchor.constraint(equalToConstant: errorViewHeight).isActive              = true
        errorBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive     = true
        errorBackgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive     = true
    }
    
    private func addErrorHeaderLabelConstraints()
    {
        errorHeaderLabel.translatesAutoresizingMaskIntoConstraints                                                            = false
        errorHeaderLabel.leadingAnchor.constraint(equalTo: errorBackgroundView.leadingAnchor, constant: 16).isActive          = true
        errorHeaderLabel.topAnchor.constraint(equalTo: errorBackgroundView.topAnchor, constant: topAndBottomPadding).isActive = true
        errorHeaderLabel.trailingAnchor.constraint(equalTo: errorBackgroundView.trailingAnchor, constant: -16).isActive       = true
        errorHeaderLabel.heightAnchor.constraint(equalToConstant: componentsWeightage[0]).isActive                            = true
    }
    
    private func addErrorDescriptionLabelConstraints()
    {
        errorDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorDescriptionLabel.leadingAnchor.constraint(equalTo: errorBackgroundView.leadingAnchor, constant: 16),
            errorDescriptionLabel.topAnchor.constraint(equalTo: errorHeaderLabel.bottomAnchor, constant: paddingBetweenComponents),
            errorDescriptionLabel.trailingAnchor.constraint(equalTo: errorBackgroundView.trailingAnchor, constant: -16),
            errorDescriptionLabel.heightAnchor.constraint(equalToConstant: componentsWeightage[1])
            ])
    }
    
    private func addRetryButtonConstraints()
    {
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            retryButton.leadingAnchor.constraint(equalTo: errorBackgroundView.leadingAnchor, constant: 16),
            retryButton.topAnchor.constraint(equalTo: errorDescriptionLabel.bottomAnchor, constant: paddingBetweenComponents),
            retryButton.trailingAnchor.constraint(equalTo: errorBackgroundView.trailingAnchor, constant: -16),
            retryButton.heightAnchor.constraint(equalToConstant: componentsWeightage[2])
            ])
    }
    
    private func addViewCartButtonConstraints()
    {
        viewCartButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewCartButton.leadingAnchor.constraint(equalTo: errorBackgroundView.leadingAnchor, constant: 16),
            viewCartButton.topAnchor.constraint(equalTo: retryButton.bottomAnchor, constant: paddingBetweenComponents),
            viewCartButton.trailingAnchor.constraint(equalTo: errorBackgroundView.trailingAnchor, constant: -16),
            viewCartButton.heightAnchor.constraint(equalToConstant: componentsWeightage[3])
            ])
    }
    
    private func addCancelButtonConstraints()
    {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: errorBackgroundView.leadingAnchor, constant: 16),
            cancelButton.topAnchor.constraint(equalTo: viewCartButton.bottomAnchor, constant: paddingBetweenComponents),
            cancelButton.trailingAnchor.constraint(equalTo: errorBackgroundView.trailingAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: componentsWeightage[4])
            ])
    }
    
    // MARK: - Selectors
    @objc private func retryButtonSelector(_ sender: UIButton)
    {
        dismiss(animated: true)
        retryClosure?()
    }
    
    @objc private func viewCartButtonSelector(_ sender: UIButton)
    {
        dismiss(animated: true)
        viewCartClosure?()
    }
    
    @objc private func cancelButtonSelector(_ sender: UIButton)
    {
        dismiss(animated: true)
    }
    
    // MARK: - Logic Methods
    private func getPart(part: CGFloat, of denominator: CGFloat) -> CGFloat
    {
        return part/denominator
    }
}

// MARK: - Conforming ViewController to Storyboardable
extension ErrorPageViewController: Storyboardable {}
