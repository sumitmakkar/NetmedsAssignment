//
//  UITableViewExtension+Representable.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 27/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import UIKit

// MARK: - UITableView
extension UITableViewCell: ReusableViewRepresentable {}

extension UITableView
{
    func dequeueReusableCell<Target: UITableViewCell>(for indexPath: IndexPath) -> Target
    {
        guard let cell = dequeueReusableCell(withIdentifier: Target.reuseIdentifier, for: indexPath) as? Target
        else
        {
            fatalError("Unable to dequeue Table View Cell")
        }
        return cell
    }
}
