//
//  AwaitingApprovalVC.swift
//  TA
//
//  Created by Designer on 09/12/21.
//

import UIKit

class AwaitingApprovalVC: BaseViewController {

    @IBOutlet weak var btnEditDetails: UIButton!
    var isFrom = ""
    var completionHandlerGoToLogin: (() -> Void)?
    var completionHandlerGoToEditProfile: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnEditDetails.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 16.0)
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
