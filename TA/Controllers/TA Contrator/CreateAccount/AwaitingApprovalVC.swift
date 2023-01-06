//
//  AwaitingApprovalVC.swift
//  TA
//
//  Created by Designer on 09/12/21.
//

import UIKit

class AwaitingApprovalVC: BaseViewController {

    @IBOutlet weak var bodyMessageApproval: UILabel!
    @IBOutlet weak var btnEditDetails: UIButton!
    var isFrom = ""
    var completionHandlerGoToLogin: (() -> Void)?
    var completionHandlerGoToEditProfile: (() -> Void)?
    var emailShared = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailShared = TA_Storage.shared.rememberLoginEmail
        btnEditDetails.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 16.0)
        self.fillUpMessageApproval()
    }
    
    func fillUpMessageApproval() {
        var message = "Your account has been created! It will be activated once our team at TA123 has reviewed your account. You will be notified upon approval. Please verify your email. We've sent an email to \(emailShared) to verity your email address and activate your account. For any inquiries please contact us at"
        self.bodyMessageApproval.text = message
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
    
}
