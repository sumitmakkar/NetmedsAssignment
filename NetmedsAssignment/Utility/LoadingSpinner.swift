//
//  LoadingSpinner.swift
//  NetmedsAssignment
//
//  Created by Sumit Makkar on 27/08/20.
//  Copyright © 2020 Sumit Makkar. All rights reserved.
//

import UIKit

extension UIViewController {
    var activityIndicatorTag: Int { return 999999 }
    
    func startLoading(style: UIActivityIndicatorView.Style = UIActivityIndicatorView.Style.large, location: CGPoint? = nil) {
        let loc = location ?? self.view.center
        DispatchQueue.main.async
            {
            let activityIndicator              = UIActivityIndicatorView(style: style)
            activityIndicator.tag              = self.activityIndicatorTag
            activityIndicator.center           = loc
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
        }
    }
    
    func stopLoading()
    {
        DispatchQueue.main.async
        {
            if let activityIndicator = self.view.subviews.filter( {
                $0.tag == self.activityIndicatorTag}).first as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }
}
