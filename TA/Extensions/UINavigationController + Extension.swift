//
//  UINavigationController + Extension.swift
//  TA
//
//  Created by global on 17/04/22.
//

import UIKit

extension UINavigationController {
    
    func getViewController(ofClass: AnyClass) -> UIViewController? {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            return vc
        }
        return nil
    }
}
