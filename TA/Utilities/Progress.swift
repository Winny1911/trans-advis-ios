//
//  Progress.swift
//  Villages GPS
//
//  Created by netset on 17/09/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import MBProgressHUD

class Progress: NSObject {
    
    static let instance = Progress()
    var hud = MBProgressHUD()
    var window: UIWindow?
    
    override init() {
        window = UIApplication.shared.keyWindow
    }
    
    func show() {
        
        hud = MBProgressHUD.showAdded(to: window!, animated: true)
        hud.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        hud.bezelView.color = .black
        hud.mode = .indeterminate
        hud.bezelView.style = .solidColor
        hud.contentColor = .white
    }
    
    func hide() {
        MBProgressHUD.hide(for: window!, animated: true)
    }
    
//    func displayAlert( userMessage: String,  completion: (() -> ())? = nil) {
//        var topVC = UIApplication.shared.keyWindow?.rootViewController
//        while((topVC!.presentedViewController) != nil){
//            topVC = topVC!.presentedViewController
//        }
//        let alertView = UIAlertController(title: Constants.App.name, message: userMessage, preferredStyle: .alert)
//        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
//            if completion != nil {
//                completion!()
//            }
//        }))
//        topVC?.present(alertView, animated: true, completion: nil)
//    }
}
