//
//  AddEditBankDetailVC.swift
//  TA
//
//  Created by Designer on 05/01/22.
//

import UIKit

class AddEditBankDetailVC: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var accountNumberTextField: FloatingLabelInput!
    @IBOutlet weak var accountHolderNameTextField: FloatingLabelInput!
    @IBOutlet weak var bankNameTextField: FloatingLabelInput!
    @IBOutlet weak var branchTextField: FloatingLabelInput!
    @IBOutlet weak var txtFldSSN: FloatingLabelInput!
    @IBOutlet weak var addBankAccountLabel: UILabel!
    
    let viewModel: CreateAccountTACVM = CreateAccountTACVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accountHolderNameTextField.delegate = self
        self.branchTextField.delegate = self
        self.txtFldSSN.delegate = self
        
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
        
        accountNumberTextField.setLeftPadding(14)
        txtFldSSN.setLeftPadding(14)
        branchTextField.setLeftPadding(14)
        accountHolderNameTextField.setLeftPadding(14)
        
        if let bankId = UserDefaults.standard.value(forKey: "BankId") as? Int {
            viewModel.getankAccountApi(bankId) { response in
                self.txtFldSSN.text = response?.data?.listing?.ssn
                self.accountNumberTextField.text = response?.data?.listing?.accountNo
                self.branchTextField.text = response?.data?.listing?.routingNumber
                self.accountHolderNameTextField.text = response?.data?.listing?.accountHolderName
                
                self.txtFldSSN.resetFloatingLable()
                self.accountNumberTextField.resetFloatingLable()
                self.branchTextField.resetFloatingLable()
                self.accountHolderNameTextField.resetFloatingLable()
                self.addBankAccountLabel.text = "Edit Bank Details"
            }
        } else {
            self.addBankAccountLabel.text = "Add Bank Details"
        }
    }
    
    // MARK: TextField delegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if textField == accountHolderNameTextField {
            let currentText = accountHolderNameTextField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else {
                return false
            }
            let updateText = currentText.replacingCharacters(in: stringRange, with: string)
            return updateText.count < 31
        }
        
        if textField == branchTextField {
            let currentText = branchTextField.text ?? ""
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
    
    @IBAction func tapDidBackButtonAction(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func tapDidSubmitButtonAction(_ sender: UIButton) {
        let accountNumber = accountNumberTextField.text?.trimmed ?? ""
        let accountName = accountHolderNameTextField.text?.trimmed ?? ""
        let routing = branchTextField.text?.trimmed ?? ""
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
                        let params = ["accountNo": model.accountNumber,"bankName": bankName, "routingNumber": model.routing, "ssn": model.ssn, "id": bankId] as [String : Any]
                        viewModel.updateBankAccountApi(params) { (model) in
//                            self?.goToAwaiting()
                            self?.navigationController!.popViewController(animated: true)
                        }
                    } else {
                        let params = ["accountNo": model.accountNumber,"bankName": bankName, "routingNumber": model.routing, "ssn": model.ssn]
                        viewModel.addBankAccountApi(params) { (model) in
                            UserDefaults.standard.removeObject(forKey: "BankId")
                            UserDefaults.standard.set(model?.data?.SaveData?.id, forKey: "BankId")
                            UserDefaults.standard.synchronize()
//                            self?.goToAwaiting()
                            self?.navigationController!.popViewController(animated: true)
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
