//
//  ChangePasswordVC.swift
//  TA
//
//  Created by Designer on 31/12/21.
//

import UIKit

class ChangePasswordVC: BaseViewController {
    
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var oldPassword: FloatingLabelInput!
    @IBOutlet weak var newPassword: FloatingLabelInput!
    @IBOutlet weak var confirmPassword: FloatingLabelInput!
    @IBOutlet weak var oldPasswordShowHideBtn: UIButton!
    @IBOutlet weak var newPasswordShowHideBtn: UIButton!
    @IBOutlet weak var confirmPasswordShowHideBtn: UIButton!
    
    @IBOutlet weak var oldPasswordView: UIView!
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var confirmPasswordView: UIView!
    
    var changePasswordViewModel: ChangePasswordVM = ChangePasswordVM()
    var logoutVM: LogoutVM = LogoutVM()
    
    var completionHandlerGoToLogin: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.oldPassword.delegate = self
        self.newPassword.delegate = self
        self.confirmPassword.delegate = self
        
        oldPassword.setLeftPadding(14)
        newPassword.setLeftPadding(14)
        confirmPassword.setLeftPadding(14)
        
        oldPasswordView.setRoundCorners(radius: 4.0)
        newPasswordView.setRoundCorners(radius: 4.0)
        confirmPasswordView.setRoundCorners(radius: 4.0)
        
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
        topView.layer.shadowRadius = 3.0
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize.zero
        
        buttomView.layer.masksToBounds = false
        buttomView.layer.shadowColor = UIColor.lightGray.cgColor
        buttomView.layer.shadowOffset = CGSize(width: 0, height: 1)
        buttomView.layer.shadowRadius = 3.0
        buttomView.layer.shadowOpacity = 0.5
        buttomView.layer.shadowOffset = CGSize.zero
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.oldPassword.text = ""
        self.oldPassword.resetFloatingLable()
        self.newPassword.text = ""
        self.newPassword.resetFloatingLable()
        self.confirmPassword.text = ""
        self.confirmPassword.resetFloatingLable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.oldPassword.text = ""
        self.oldPassword.resetFloatingLable()
        self.newPassword.text = ""
        self.newPassword.resetFloatingLable()
        self.confirmPassword.text = ""
        self.confirmPassword.resetFloatingLable()
    }
    
    @IBAction func tapDidBackButtonAction(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func tapDidChangePasswordButtonAction(_ sender: UIButton) {
        
        let oldPass = oldPassword.text?.trimmed ?? ""
        let newpass = newPassword.text?.trimmed ?? ""
        let confirmpass = confirmPassword.text?.trimmed ?? ""
        let loginModel  = ChangePasswordModel(oldPassword: oldPass, newPassword: newpass, confirmPassword: confirmpass)
        changePasswordViewModel.model = loginModel
        
        changePasswordViewModel.validateChangePasswordModel {[weak self] (success, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                if let params = success {
                    changePasswordViewModel.changePasswordApiCall(params) { modal in
                        TA_Storage.shared.rememberLoginPassword = confirmpass
                        self?.logoutVM.logOutApiCall { modal in
                            let defaults = UserDefaults.standard
                            let dictionary = defaults.dictionaryRepresentation()
                            dictionary.keys.forEach { key in
                                if key == "rememberMe" || key == "rememberMeEmail" || key == "rememberMePassword" {
                                    
                                } else {
                                    defaults.removeObject(forKey: key)
                                }
                            }
                            self?.navigationController?.popViewController(animated: true)
                            self?.completionHandlerGoToLogin?()
                        }
                    }
                }
            }
            else {
                if let errorMsg = strongSelf.changePasswordViewModel.error {
                    showMessage(with: errorMsg)
                }
            }
        }
    }
    
    
    
    @IBAction func tapDidOldPasswordShowHideBtnAction(_ sender: UIButton) {
        if sender.titleLabel?.text == "Show " {
            sender.setTitle("Hide ", for: .normal)
            oldPassword.isSecureTextEntry = false
        }else {
            oldPassword.isSecureTextEntry = true
            sender.setTitle("Show ", for: .normal)
        }
    }
    
    @IBAction func tapDidNewPasswordShowHideBtnAction(_ sender: UIButton) {
        if sender.titleLabel?.text == "Show " {
            sender.setTitle("Hide ", for: .normal)
            newPassword.isSecureTextEntry = false
        }else {
            newPassword.isSecureTextEntry = true
            sender.setTitle("Show ", for: .normal)
        }
    }
    
    @IBAction func tapDidConfirmPasswordShowHideBtnAction(_ sender: UIButton) {
        if sender.titleLabel?.text == "Show " {
            sender.setTitle("Hide ", for: .normal)
            confirmPassword.isSecureTextEntry = false
        }else {
            confirmPassword.isSecureTextEntry = true
            sender.setTitle("Show ", for: .normal)
        }
    }
}


extension ChangePasswordVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.oldPasswordShowHideBtn.titleLabel?.text == "Show " {
            self.oldPassword.isSecureTextEntry = true
        } else {
            self.oldPassword.isSecureTextEntry = false
        }
        
        if self.newPasswordShowHideBtn.titleLabel?.text == "Show " {
            self.newPassword.isSecureTextEntry = true
        } else {
            self.newPassword.isSecureTextEntry = false
        }
        
        if self.confirmPasswordShowHideBtn.titleLabel?.text == "Show " {
            self.confirmPassword.isSecureTextEntry = true
        } else {
            self.confirmPassword.isSecureTextEntry = false
        }
    }
}

