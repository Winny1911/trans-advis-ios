//
//  AwaitingApprovalVC.swift
//  TA
//
//  Created by Designer on 09/12/21.
//

import UIKit

protocol ChooseEmailActionSheetPresenter {
    var chooseEmailActionSheet: UIAlertController? { get }
    func setupChooseEmailActionSheet(withTitle title: String?) -> UIAlertController
}

class AwaitingApprovalVC: BaseViewController {

    @IBOutlet weak var bodyMessageApproval: UILabel!
    @IBOutlet weak var btnEditDetails: UIButton!
    @IBOutlet weak var btnEmailContractor: UIButton!
    @IBOutlet weak var btnEmailTA: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var bodyMessageApprovalSeccond: UILabel!
    
    var isFrom = ""
    var completionHandlerGoToLogin: (() -> Void)?
    var completionHandlerGoToEditProfile: (() -> Void)?
    var emailShared = ""
    var chooseEmailActionSheet: UIAlertController?
    var emailActionSheet: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailShared = TA_Storage.shared.rememberLoginEmail
        btnEditDetails.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 16.0)
        chooseEmailActionSheet = setupChooseEmailActionSheet()
        self.fillUpMessageApproval()
    }
    
    func fillUpMessageApproval() {
        let message = "Your account has been created! It will be activated once our team at TA123 has reviewed your account. You will be notified upon approval. Please verify your email. We've sent an email to"
        let messageEmail = emailShared
        let messageSeccond = "to verity your email address and activate your account. For any inquiries please contact us at"
        self.bodyMessageApproval.text = message
        self.bodyMessageApprovalSeccond.text = messageSeccond
        self.btnEmailContractor.setTitle(messageEmail, for: .normal)
    }
    
    func sendToEmail(emailTo: String) {
        if let url = URL(string: "mailto:\(emailTo)"), UIApplication.shared.canOpenURL(url) {
            if let action = openAction(withURL: "mailto:\(emailTo)", andTitleActionTitle: "Mail") {
                emailActionSheet!.addAction(action)
            }
            
            if let action = openAction(withURL: "googlegmail:///", andTitleActionTitle: "Gmail") {
                emailActionSheet!.addAction(action)
            }
            
            if let action = openAction(withURL: "inbox-gmail://", andTitleActionTitle: "Inbox") {
                emailActionSheet!.addAction(action)
            }
            
            if let action = openAction(withURL: "ms-outlook://", andTitleActionTitle: "Outlook") {
                emailActionSheet!.addAction(action)
            }
            
            if let action = openAction(withURL: "x-dispatch:///", andTitleActionTitle: "Dispatch") {
                emailActionSheet!.addAction(action)
            }
        }
        
        show(chooseEmailActionSheet!, sender: self)
    }
    
    fileprivate func openAction(withURL: String, andTitleActionTitle: String) -> UIAlertAction? {
        guard let url = URL(string: withURL), UIApplication.shared.canOpenURL(url) else {
            return nil
        }
        let action = UIAlertAction(title: andTitleActionTitle, style: .default) { (action) in
            UIApplication.shared.openURL(url)
        }
        return action
    }
    
    @IBAction func crossButtonAction(_ sender: UIButton) {
        if self.isFrom == "Login" {
            self.dismiss(animated: true, completion: nil)
            } else {
                self.dismiss(animated: true, completion: nil)
                self.completionHandlerGoToLogin?()
            }
    }
    
    @IBAction func actionEditDetails(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.completionHandlerGoToEditProfile?()
    }
    
    @IBAction func openEmailContractor(_ sender: Any) {
        //sendToEmail(emailTo: self.emailShared)
    }
    @IBAction func openEmailTA(_ sender: Any) {
        //sendToEmail(emailTo: "help@ta123.com")
    }
    @IBAction func doLogout(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.completionHandlerGoToLogin?()
    }
    
    fileprivate func openGmailSupportAction(withFrom: String?, withSubject: String?) -> UIAlertAction? {
        
        var gmailUrlString = "googlegmail:///"
        
        if let from = withFrom {
            gmailUrlString += "co?to=\(from)"
        }
        
        if let subject = withSubject {
            gmailUrlString += "&subject=\(subject)"
        }
        
        return openAction(withURL: gmailUrlString, andTitleActionTitle: "Gmail")
    }
    
}

extension AwaitingApprovalVC: ChooseEmailActionSheetPresenter {
    
    func setupChooseEmailActionSheet(withTitle title: String? = "Choose email") -> UIAlertController {
        let emailActionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        emailActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        return emailActionSheet
    }
}
