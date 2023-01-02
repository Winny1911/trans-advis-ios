//
//  TermsAndConditionVC.swift
//  TA
//
//  Created by applify on 08/03/22.
//

import UIKit
import WebKit



class TermsAndConditionVC: UIViewController{
    
    @IBOutlet weak var webView: WKWebView!
    var helpAndSupportViewModel :  HelpAndSupportVM = HelpAndSupportVM()
    var terms = ""
    var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var topView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        topView.addCustomShadow()
        self.termsAndConditionAPI()
      
        setIndicator()
    }
    

    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func termsAndConditionAPI(){
        helpAndSupportViewModel.helpAndSupportApi([:]){ response in
            self.terms = response?.data.termsOfServices ?? ""
            let myUrl = URL(string: self.terms)
            let myRequest = URLRequest(url: myUrl!)
            //DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.webView.load(myRequest)
            //}
            
        }
    }
}
extension TermsAndConditionVC :WKUIDelegate, WKNavigationDelegate{
    
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
