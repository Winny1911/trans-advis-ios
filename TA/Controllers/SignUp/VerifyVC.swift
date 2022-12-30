//
//  VerifyVC.swift
//  TA
//
//  Created by Dev on 07/12/21.
//

import UIKit

class VerifyVC: BaseViewController {

    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var verifyView: UIView!
    
    let viewModel: SignUpVM = SignUpVM()
    
    var completionHandlerGoToCreateProfile: (() -> Void)?
    
    var isFromLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.verifyView.roundCorners(corners: [.topLeft, .topRight], radius: 18.0)
        btnResend.titleLabel?.font = UIFont(name: PoppinsFont.medium, size: 18.0)
        
        self.viewModel.checkEmailVerify { [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.completionHandlerGoToCreateProfile?()
            })
        }
    }

    @IBAction func actionResend(_ sender: Any) {
        var email = String()
        if isFromLogin == true {
            if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
                email = obj.email ?? ""
            }
        } else {
            if let obj = UserDefaults.standard.retrieve(object: signupDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
                email = obj.email ?? ""
            }
        }
        let params = ["email": email]
        viewModel.resendUserApiCall(params) { (model) in
            showMessage(with: SucessMessage.emailSentSuccessfully, theme: .success)
        }
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
    }
}
