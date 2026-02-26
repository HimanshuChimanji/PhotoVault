//
//  Extension.swift
//  PhotoVault
//
//  Created by Himanshu Chimanji on 26/02/26.
//

import Foundation
import UIKit
import KRActivityIndicatorView

let activityIndicator = KRActivityIndicatorView()
var customView = UIView()
let screenSize = UIScreen.main.bounds

let screenHeight = screenSize.height
let screenWidth = screenSize.width


extension UIViewController {
    
    func showActivityIndicator(bgColor: UIColor = UIColor.white)
    {
        DispatchQueue.main.async {
            customView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            activityIndicator.frame=CGRect(x: 0, y: 0, width: 60, height: 60)
            activityIndicator.colors=[UIColor.blue]
            
            activityIndicator.center = self.view.center
            self.view.isUserInteractionEnabled = false
            self.view.backgroundColor = bgColor
            customView.addSubview(activityIndicator)
            self.view.addSubview(customView)
            activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator()
    {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            
            activityIndicator.removeFromSuperview()
            customView.removeFromSuperview()
            activityIndicator.stopAnimating()
        }
    }
}
