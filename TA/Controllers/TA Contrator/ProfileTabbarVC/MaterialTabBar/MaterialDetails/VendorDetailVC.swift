//
//  VendorDetailVC.swift
//  TA
//
//  Created by Dev on 21/04/22.
//

import UIKit
import WebKit

class VendorDetailVC: UIViewController {

    @IBOutlet var topView: UIView!
    @IBOutlet var webView: WKWebView!
   
    var vandorLink = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.addCustomShadow()
        let myUrl = URL(string: vandorLink)
        let myRequest = URLRequest(url: myUrl!)
        self.webView.load(myRequest)
    }
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
