//
//  PhotoViewController.swift
//  Business App
//
//  Created by Ankit Goyal on 27/09/20.
//  Copyright © 2020 Ankit Goyal. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController
{
    @IBOutlet weak var buttonSendPhoto: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    var backgroundImage : UIImage!
    typealias callBackSelectedImageForChat = (_ isSendImage:Bool) -> Void
    var callback: callBackSelectedImageForChat! = nil

    
    // MARK: - View Will Appear and DisAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNeedsStatusBarAppearanceUpdate()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        UIFunction.AGLogs(log: "Jai Shri Ram. JHMPPWPBJASHJH" as AnyObject)
        self.backgroundImageView.image = backgroundImage
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendPhotoButtonAction(_ sender: Any) {
        if (self.callback != nil) {
            self.callback(true)
        }
        self.backButtonAction(Any.self)
    }
}




