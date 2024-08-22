//
//  UIViewController+Alerts.swift
//  SmartSign Dictionary
//
//  Created by Srivinayak Chaitanya Eshwa on 21/08/24.
//

import UIKit

extension UIViewController {
    func showAlert(for error: Error) {
        let title: String
        let message: String
        
        if let projectError = error as? ProjectError {
            title = projectError.title
            message = projectError.message
        }
        else {
            title = "An Error Occurred"
            message = error.localizedDescription
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: String(localized: "Ok"), style: .default)
        )
        
        present(alert, animated: true)
    }
}
