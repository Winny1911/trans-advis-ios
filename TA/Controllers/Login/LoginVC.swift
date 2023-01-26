//
//  LoginVC.swift
//  TA
//
//  Created by Dev on 06/12/21.
//

import UIKit

class LoginVC: BaseViewController {
    

    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnRegisterNow: UIButton!
    @IBOutlet weak var btnRememberMe: UIButton!
    @IBOutlet weak var btnRemember: UIButton!
    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var emailTextField: FloatingLabelInput!
    @IBOutlet weak var passwordTextField: FloatingLabelInput!
    @IBOutlet weak var showButton: UIButton!
    
    let viewModel: LoginVM = LoginVM()
    override func viewDidLoad() {
        super.viewDidLoad()
             
        passwordTextField.delegate = self
        viewPassword.setRoundCorners(radius: 4.0)
        emailTextField.setLeftPadding(14)
        passwordTextField.setLeftPadding(14)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if TA_Storage.shared.isRememberLogin == true {
            self.emailTextField.text = TA_Storage.shared.rememberLoginEmail
            self.passwordTextField.text = TA_Storage.shared.rememberLoginPassword
            imgCheckBox.image = UIImage(named: "checkBoxSelected")
            self.emailTextField.resetFloatingLable()
            self.passwordTextField.resetFloatingLable()
            TA_Storage.shared.isRememberLogin = true
        }
    }
    
    //MARK: FUNCTION Move To Awaiting
    func moveToawaiting() {
        let destinationViewController = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "AwaitingApprovalVC") as? AwaitingApprovalVC
        destinationViewController!.isFrom = "Login"
        destinationViewController!.completionHandlerGoToLogin = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.popViewController(animated: true)
        }
        
        destinationViewController!.completionHandlerGoToEditProfile = { [weak self] in
            for controller in (self?.navigationController!.viewControllers)! as Array<Any> {
                if (controller as AnyObject).isKind(of: CreateAccountTAC.self) {
                    NotificationCenter.default.post(name: Notification.Name("IsFromEdit"), object: nil)
                    self?.navigationController!.popToViewController(controller as! BaseViewController, animated: true)
                    break
                } else {
                    NotificationCenter.default.post(name: Notification.Name("IsFromEdit"), object: nil)
                    let vc = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "CreateAccountTAC") as? CreateAccountTAC
                    vc!.isFromEdit = true
                    self?.navigationController?.pushViewController(vc!, animated: true)
                    break
                }
            }
        }
        
        destinationViewController!.modalPresentationStyle = .overCurrentContext
        self.present(destinationViewController!, animated: true)
    }
    
    func moveToCreateProfile() {
        let vc = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "CreateAccountTAC") as? CreateAccountTAC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //MARK: ACTION REGISTER
    @IBAction func RegisterNowButtonDidTap(_ sender: Any) {
        let vc = Storyboard.signUp.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //MARK: ACTION LOGIN
    @IBAction func actionLogin(_ sender: Any) {
        let email = emailTextField.text?.trimmed ?? ""
        let password = passwordTextField.text?.trimmed ?? ""
        let loginModel  = LoginModel(email: email, password: password)
        viewModel.model = loginModel
        viewModel.validateLoginModel {[weak self] (success, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                if let params = success {
                    print("params: ", params)
                    if TA_Storage.shared.isRememberLogin == true {
                        TA_Storage.shared.rememberLoginEmail = email
                        TA_Storage.shared.rememberLoginPassword = password
                    }
                    viewModel.loginUserApiCall(params) { (model) in
                        UserDefaults.standard.save(customObject: model?.data, inKey:TA_Storage.TA_Storage_Constants.kPersonalDetailsData)
                        TA_Storage.shared.apiAccessToken = "Bearer \(model?.data?.accessToken! ?? "")"
                        
                        TA_Storage.shared.userId = model?.data?.id ?? -1
                        fireBaseUserTable().updateOwnProfileOnFirebase()
                        /*
                         Fetch chat history
                         */
                        ChatHistoryModel.fetchChatHistory()
                        
                        if model?.data?.userType == UserType.homeOwner {
                            TA_Storage.shared.iskProfileCreated = true
                            self!.changeRootController(storyboadrId: "TabBarHO", bundle: nil, controllerId: "TabBarHOVC")
                        } else {
                            if model?.data?.profileStatus == 1{
                                self?.changeRootController(storyboadrId: "ContratorTabBar", bundle: nil, controllerId: "ContratorTabBarVC")
                            } else {
                                self?.moveToawaiting()
                            }
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
    
    //MARK: ACTION FORGOT PASSWORD
    @IBAction func actionForgotPassword(_ sender: Any) {
        guard let destinationViewController = Storyboard.forgotPassword.instantiateViewController(withIdentifier: "ForgetPasswordVC") as? ForgetPasswordVC else{
            print("Error: Controller not found!!!")
            return
        }
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    //MARK: ACTION SHOW PASSWORD
    @IBAction func toggleSecureTextButtonDidTap(_ sender: UIButton) {
        if sender.titleLabel?.text == "Show" {
            sender.setTitle("Hide", for: .normal)
            passwordTextField.isSecureTextEntry = false
        }else {
            passwordTextField.isSecureTextEntry = true
            sender.setTitle("Show", for: .normal)
        }
    }
    
    //MARK: ACTION REMEMBER ME
    @IBAction func actionRememberMe(_ sender: UIButton) {
        if imgCheckBox.image == UIImage(named: "checkBoxSelected") {
            imgCheckBox.image = UIImage(named: "ic_check_box")
            TA_Storage.shared.isRememberLogin = false
        } else {
            imgCheckBox.image = UIImage(named: "checkBoxSelected")
            TA_Storage.shared.isRememberLogin = true
        }
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.showButton.titleLabel?.text == "Show" {
            self.passwordTextField.isSecureTextEntry = true
        } else {
            self.passwordTextField.isSecureTextEntry = false
        }
    }
}
