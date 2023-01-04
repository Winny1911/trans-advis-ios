//
//  AddBankAccountVC.swift
//  TA
//
//  Created by Designer on 08/12/21.
//

import UIKit

class AddBankAccountVC: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var accountNumberTextField: FloatingLabelInput!
    //@IBOutlet weak var accountHolderNameTextField: FloatingLabelInput!
    @IBOutlet weak var bankNameTextField: FloatingLabelInput!
    @IBOutlet weak var routingTextField: FloatingLabelInput!
    @IBOutlet weak var txtFldSSN: FloatingLabelInput!
    @IBOutlet weak var addBankAccountLabel: UILabel!
    
    var createAccountModel = CreateAccountModel()
    var createAccountLicenseModel = CreateAccountLicenseModel()
    var createAccountLocationModel = CreateAccountLocationModel()
    let viewModel: CreateAccountTACVM = CreateAccountTACVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accountNumberTextField.delegate = self
        //self.accountHolderNameTextField.delegate = self
        self.routingTextField.delegate = self
        self.txtFldSSN.delegate = self
        
        btnSkip.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 12.0)
        btnSubmit.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 16.0)
        accountNumberTextField.setLeftPadding(14)
        txtFldSSN.setLeftPadding(14)
        routingTextField.setLeftPadding(14)
        //accountHolderNameTextField.setLeftPadding(14)
        
        if let bankId = UserDefaults.standard.value(forKey: "BankId") as? Int {
            viewModel.getankAccountApi(bankId) { response in
                self.txtFldSSN.text = response?.data?.listing?.ssn
                self.accountNumberTextField.text = response?.data?.listing?.accountNo
                self.routingTextField.text = response?.data?.listing?.routingNumber
//                self.accountHolderNameTextField.text = response?.data?.listing?.accountHolderName
                
                self.txtFldSSN.resetFloatingLable()
                self.accountNumberTextField.resetFloatingLable()
                self.routingTextField.resetFloatingLable()
//                self.accountHolderNameTextField.resetFloatingLable()
                self.addBankAccountLabel.text = "Edit Bank Account"
            }
        }
    }
    
    // MARK: TextField delegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if textField == accountNumberTextField {
            let currentText = accountNumberTextField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else {
                return false
            }
            let updateText = currentText.replacingCharacters(in: stringRange, with: string)
            return updateText.count < 20
        }
//        if textField == accountHolderNameTextField {
//            let currentText = accountHolderNameTextField.text ?? ""
//            guard let stringRange = Range(range, in: currentText) else {
//                return false
//            }
//            let updateText = currentText.replacingCharacters(in: stringRange, with: string)
//            return updateText.count < 30
//        }
        
        if textField == routingTextField {
            let currentText = routingTextField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else {
                return false
            }
            let updateText = currentText.replacingCharacters(in: stringRange, with: string)
            return updateText.count < 10
        }
        
        if textField == txtFldSSN {
            let currentText = txtFldSSN.text ?? ""
            guard let stringRange = Range(range, in: currentText) else {
                return false
            }
            let updateText = currentText.replacingCharacters(in: stringRange, with: string)
            return updateText.count < 10
        }
        return true
    }
    
    func goToAwaiting() {
        let vc = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "AwaitingApprovalVC") as? AwaitingApprovalVC
        vc!.isFrom = ""
        vc!.completionHandlerGoToLogin = { [weak self] in
            for controller in (self?.navigationController!.viewControllers)! as Array<Any> {
                if (controller as AnyObject).isKind(of: LoginVC.self) {
                    self?.navigationController!.popToViewController(controller as! BaseViewController, animated: true)
                    break
                } else {
                    let vc = Storyboard.login.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                    self!.navigationController?.pushViewController(vc!, animated: true)
                    break
                }
            }
//            let email = TA_Storage.shared.rememberLoginEmail
//            let password = TA_Storage.shared.rememberLoginPassword
//            let loginModel  = LoginModel(email: email, password: password)
//            let viewModelLogin: LoginVM = LoginVM()
//            viewModelLogin.model = loginModel
//
//            viewModelLogin.validateLoginModel { success, error in
//                if error == nil {
//                    if let params = success {
//                        print("params: ", params)
//                        if TA_Storage.shared.isRememberLogin == true {
//                            TA_Storage.shared.rememberLoginEmail = email
//                            TA_Storage.shared.rememberLoginPassword = password
//                        }
//                        viewModelLogin.loginUserApiCall(params) { (model) in
//                            UserDefaults.standard.save(customObject: model?.data, inKey:TA_Storage.TA_Storage_Constants.kPersonalDetailsData)
//                            TA_Storage.shared.apiAccessToken = "Bearer \(model?.data?.accessToken! ?? "")"
//
//                            TA_Storage.shared.userId = model?.data?.id ?? -1
//                            fireBaseUserTable().updateOwnProfileOnFirebase()
//                            /*
//                             Fetch chat history
//                             */
//                            ChatHistoryModel.fetchChatHistory()
//
//                            self?.changeRootController(storyboadrId: "ContratorTabBar", bundle: nil, controllerId: "ContratorTabBarVC")
//                        }
//                    }
//                }
//            }
        }
        
        vc!.completionHandlerGoToEditProfile = { [weak self] in
            for controller in (self?.navigationController!.viewControllers)! as Array<Any> {
                if (controller as AnyObject).isKind(of: CreateAccountTAC.self) {
                    NotificationCenter.default.post(name: Notification.Name("IsFromEdit"), object: nil)
                    self?.navigationController!.popToViewController(controller as! BaseViewController, animated: true)
                    break
                }
            }
        }
        vc!.modalPresentationStyle = .overCurrentContext
        self.present(vc!, animated: true)
    }
    
    @IBAction func tapDidskipButtonAction(_ sender: UIButton) {
        self.goToAwaiting()
    }
    
    @IBAction func tapDidSubmitButtonAction(_ sender: UIButton) {
        let accountNumber = accountNumberTextField.text?.trimmed ?? ""
        //let accountName = accountHolderNameTextField.text?.trimmed ?? ""
        let routing = routingTextField.text?.trimmed ?? ""
        let ssn = txtFldSSN.text?.trimmed ?? ""
        let bankName = bankNameTextField.text?.trimmed ?? ""
        let createAccountBankModel =  CreateAccountBankModel(accountNumber: accountNumber, routing: routing, ssn: ssn, bankName: bankName)
        viewModel.modelBankAccount = createAccountBankModel
        viewModel.validateBankAccountModel {[weak self] (success, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                if let model = success {
                    print("model: ", model)
                    if let bankId = UserDefaults.standard.value(forKey: "BankId") as? Int {
                        let params = ["accountNo": model.accountNumber, "bankName": bankName, "routingNumber": model.routing, "ssn": model.ssn, "id": bankId] as [String : Any]
                        viewModel.updateBankAccountApi(params) { (model) in
                            self?.goToAwaiting()
                        }
                    } else {
                        let params = ["accountNo": model.accountNumber, "bankName": bankName, "routingNumber": model.routing, "ssn": model.ssn]
                        viewModel.addBankAccountApi(params) { (model) in
                            UserDefaults.standard.removeObject(forKey: "BankId")
                            UserDefaults.standard.set(model?.data?.SaveData?.id, forKey: "BankId")
                            UserDefaults.standard.synchronize()
                            self?.goToAwaiting()
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
}
