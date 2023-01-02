//
//  PrivacyPolicyVC.swift
//  TA
//
//  Created by applify on 08/03/22.
//

import UIKit
import WebKit

class PrivacyPolicyVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var topView: UIView!
    var helpAndSupportViewModel :  HelpAndSupportVM = HelpAndSupportVM()
    var privacyURL = String()
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.addCustomShadow()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        setIndicator()
        self.privacyPolicyAPI()
    }

    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func privacyPolicyAPI(){
        helpAndSupportViewModel.helpAndSupportApi([:]){ response in
            self.privacyURL = response?.data.privacyPolicyURL ?? ""
            let myUrl = URL(string: self.privacyURL)
            let myRequest = URLRequest(url: myUrl!)
           // DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.webView.load(myRequest)
           // }
        }
    }
}
extension PrivacyPolicyVC :WKUIDelegate, WKNavigationDelegate{
    
    //, UIDocumentInteractionControllerDelegate,URLSessionDownloadDelegate
    func setIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium

        view.addSubview(activityIndicator)
    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }
}
