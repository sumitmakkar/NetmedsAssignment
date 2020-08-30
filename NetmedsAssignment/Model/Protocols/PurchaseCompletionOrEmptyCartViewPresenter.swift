//
//  PurchaseCompletionOrEmptyCartViewPresenter.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 30/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import UIKit

protocol PurchaseCompletionOrEmptyCartViewPresenter
{
    func createCartHandlingViewWith(header: String, and description: String, withSelector goToSearchButtonSelector: Selector)
}

extension PurchaseCompletionOrEmptyCartViewPresenter where Self: UIViewController
{
    func createCartHandlingViewWith(header: String, and description: String, withSelector goToSearchButtonSelector: Selector)
    {
        let backgroundView   = createBackgroundView()
        let headerLabel      = createHeaderLabelWith(header: header)
        let descriptionLabel = createDescriptionLabelWith(description: description)
        let goToSearchButton = createGoToSearchButton(with: goToSearchButtonSelector)
        backgroundView.addSubview(headerLabel)
        backgroundView.addSubview(descriptionLabel)
        backgroundView.addSubview(goToSearchButton)
        view.addSubview(backgroundView)
        addConstraintsTo(backgroundView: backgroundView)
        addConstraintsTo(headerLabel: headerLabel, withPadding: 100)
        addConstraintsTo(descriptionLabel: descriptionLabel, withTopViewAs: headerLabel, andWtihTopPadding: 20)
        addConstraintsTo(gotoSearchButton: goToSearchButton)
    }
    
    private func createBackgroundView() -> UIView
    {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }
    
    private func createHeaderLabelWith(header: String) -> UILabel
    {
        let headerLabel           = UILabel()
        headerLabel.text          = header
        headerLabel.font          = UIFont.boldSystemFont(ofSize: 25)
        headerLabel.textAlignment = .center
        return headerLabel
    }
    
    private func createDescriptionLabelWith(description: String) -> UILabel
    {
        let descriptionLabel           = UILabel()
        descriptionLabel.text          = description
        descriptionLabel.font          = UIFont.systemFont(ofSize: 20)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        return descriptionLabel
    }
    
    private func createGoToSearchButton(with goToSearchSelector: Selector) -> UIButton
    {
        let searchButton              = UIButton()
        searchButton.backgroundColor  = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        searchButton.setTitle("Go To Search", for: UIControl.State.normal)
        searchButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        searchButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        searchButton.addTarget(self, action: goToSearchSelector, for: UIControl.Event.touchUpInside)
        return searchButton
    }
    
    private func addConstraintsTo(backgroundView: UIView)
    {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    private func addConstraintsTo(headerLabel: UILabel, withPadding padding: CGFloat)
    {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func addConstraintsTo(descriptionLabel: UILabel, withTopViewAs topView: UIView, andWtihTopPadding padding: CGFloat)
    {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func addConstraintsTo(gotoSearchButton: UIButton)
    {
        gotoSearchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gotoSearchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            gotoSearchButton.heightAnchor.constraint(equalToConstant: 60),
            gotoSearchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            gotoSearchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }
}
