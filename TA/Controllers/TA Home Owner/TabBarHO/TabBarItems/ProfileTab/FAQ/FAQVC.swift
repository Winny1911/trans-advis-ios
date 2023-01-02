//
//  FAQVC.swift
//  TA
//
//  Created by applify on 08/03/22.
//

import UIKit
import WebKit

class FAQVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var topView: UIView!
    var helpAndSupportViewModel :  HelpAndSupportVM = HelpAndSupportVM()
    var faq = ""
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.addCustomShadow()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        setIndicator()
        self.FAQAPI()
//        let myUrl = URL(string: self.faq)
//        let myRequest = URLRequest(url: myUrl!)
//        self.webView.load(myRequest)
        
        
    }
    

    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func FAQAPI(){
       // DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.helpAndSupportViewModel.helpAndSupportApi([:]){ response in
                self.faq = response?.data.faqURL ?? "https://p2-testweb.ta123test.com/faq"
                self.faq = "https://www.ta123.com/web-faq"
                let myUrl = URL(string: self.faq)
                let myRequest = URLRequest(url: myUrl!)
                self.webView.load(myRequest)
                

            }
        //}
    }
}

extension FAQVC :WKUIDelegate, WKNavigationDelegate{
    
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
