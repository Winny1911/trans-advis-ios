//
//  ForgetPasswordVC.swift
//  TA
//
//  Created by Dev on 07/12/21.
//

import UIKit

class ForgetPasswordVC: UIViewController {

    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var txtFldEmail: FloatingLabelInput!
    
    let viewModel: ForgetPasswordVM = ForgetPasswordVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnReset.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 16.0)
        self.navigationItem.setHidesBackButton(true, animated: true)
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtFldEmail.text = ""
        txtFldEmail.resetFloatingLable()
        txtFldEmail.resignFirstResponder()
    }    
    
   @IBAction func resetButtonAction(_ sender: Any) {
       let email = txtFldEmail.text?.trimmed ?? ""
       let forgetPasswordModel  = ForgetPasswordModel(email: email)
       viewModel.model = forgetPasswordModel
           
       viewModel.validateForgotPasswordModel {[weak self] (success, error) in
           guard let strongSelf = self else { return }
           if error == nil {
               if let params = success {
                   print("params: ", params)
                   viewModel.forgotPasswordApiCall(params) { (model) in
                       if model?.data?.customMessage == "Email sent successfully" {
                           let destinationViewController = Storyboard.forgotPassword.instantiateViewController(withIdentifier: "ResetRequestVC") as? ResetRequestVC
                           destinationViewController!.email = (self?.txtFldEmail.text)!
                           destinationViewController!.modalPresentationStyle = .overFullScreen
                           destinationViewController!.completionHandlerGoToLoginScreen = { [weak self] in
                               self?.navigationController?.popViewController(animated: true)
                                  }
                           self!.present(destinationViewController!, animated: true)
                       } else {
                           showMessage(with: "Please try after \(model?.data?.remainingTime ?? 0) seconds")
                       }
                       
                   }
               }
           }
           else {
               if let errorMsg = strongSelf.viewModel.error {
                   showMessage(with: errorMsg)
               }
           }
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
