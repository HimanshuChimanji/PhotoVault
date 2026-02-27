//
//  Extention.swift
//  PhotoVault
//
//  Created by Himanshu Chimanji on 27/02/26.
//

import Foundation
import UIKit

extension UITextView {
    /// Sets the padding for the text view.
    public func setPadding(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        self.textContainerInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}

extension UIViewController {
    func showAlert(title: String, message: String, actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }

}
