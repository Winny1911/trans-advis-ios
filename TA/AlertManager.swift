//
//  AlertManager.swift
//  TA
//
//  Created by Applify  on 10/12/21.
//

import Foundation
import UIKit

typealias AlertClosure = (() -> Void)?
class AlertManager {
    func showAlert(_ title: String, message: String, actions: [UIAlertAction], on viewController: UIViewController, completion: AlertClosure) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        
        viewController.present(alertController, animated: true, completion: completion)
    }
    
//    func showAlert(_ title: String, message: String, actions: [UIAlertAction]) {
//        let alertController = AlertViewController(title: title, message: message, preferredStyle: .alert)
//        for action in actions {
//            alertController.addAction(action)
//        }
//        alertController.show()
//    }
}
