//
//  Extension + UIViewController.swift
//  SpeedTestApp
//
//  Created by Варвара Уткина on 09.04.2024.
//

import UIKit

enum Alert {
    case checkboxIsEmpty
    case urlIsEmpty
    case invalidURL
    
    var title: String {
        switch self {
        case .checkboxIsEmpty:
            "What do you want to measure?"
        case .urlIsEmpty:
            "URL is empty"
        case .invalidURL:
            "Wrong URL!"
        }
    }
    
    var message: String {
        switch self {
        case .checkboxIsEmpty:
            "Please choose type of speed"
        case .urlIsEmpty:
            "Please enter URL"
        case .invalidURL:
            "Please change URL"
        }
    }
}

extension UIViewController {
    func showAlert(withStatus status: Alert) {
        let alert = UIAlertController(
            title: status.title,
            message: status.message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
