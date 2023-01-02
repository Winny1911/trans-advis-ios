//
//  ResetRequestVC.swift
//  TA
//
//  Created by Dev on 07/12/21.
//

import UIKit

class ResetRequestVC: BaseViewController {
    var resetButtonClosour: (()->())?
    var completionHandlerGoToLoginScreen: (() -> Void)?

    @IBOutlet weak var btnGotIt: UIButton!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var resetRequestView: UIView!
   
    let viewModel: ForgetPasswordVM = ForgetPasswordVM()
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.lblEmail.text = self.email
        btnGotIt.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 16.0)
        self.resetRequestView.roundCorners(corners: [.topLeft, .topRight], radius:18.0)
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblEmail.text = self.email
        self.resetRequestView.roundCorners(corners: [.topLeft, .topRight], radius:18.0)
    }
    
    @IBAction func actionResend(_ sender: Any) {
        var devToken = ""
        if let deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as? String {
            devToken = deviceToken
        } else {
            devToken = "01234567890"
        }
        let params = ["email": email, "deviceType": "IOS", "deviceToken": devToken]
        viewModel.forgotPasswordApiCall(params) { (model) in
            if model?.data?.customMessage == "Email sent successfully" {
                showMessage(with: SucessMessage.emailSentSuccessfully, theme: .success)
                self.dismiss(animated: true, completion: nil)
            } else {
                showMessage(with: "Please try after \(model?.data?.remainingTime ?? 0) seconds")
            }
        }
        
    }
    
    @IBAction func resetButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.completionHandlerGoToLoginScreen?()
        
    }
}
