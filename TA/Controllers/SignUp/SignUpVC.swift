//
//  SignUpVC.swift
//  TA
//
//  Created by Dev on 06/12/21.
//

import UIKit
import SafariServices
import GooglePlaces
import Alamofire

class SignUpVC: BaseViewController {

    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var btnAcceptTerms: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnShowHide: UIButton!
    @IBOutlet weak var btnContractor: UIButton!
    @IBOutlet weak var btnHomeOwner: UIButton!
    @IBOutlet weak var companyNameView: UIView!
    @IBOutlet weak var emailTextField: FloatingLabelInput!
    @IBOutlet weak var passwordTextField: FloatingLabelInput!
    @IBOutlet weak var firstNameTextField: FloatingLabelInput!
    @IBOutlet weak var lastNameTextField: FloatingLabelInput!
    @IBOutlet weak var phoneNumberTextField: FloatingLabelInput!
    @IBOutlet weak var companyNameTextField: FloatingLabelInput!
    @IBOutlet weak var zipCodeTextField: FloatingLabelInput!
    @IBOutlet weak var searchAddressTextField: FloatingLabelInput!
    @IBOutlet weak var addressLine1TextField: FloatingLabelInput!
    @IBOutlet weak var cityTextField: FloatingLabelInput!
    @IBOutlet weak var stateTextField: FloatingLabelInput!
    @IBOutlet weak var zipcodeTextField: FloatingLabelInput!
    
    var fullName: String = ""
    var latitude: String = "0"
    var longitude: String = "0"
    var userType = String()
    var isUpdateLocation = true
    let viewModel: SignUpVM = SignUpVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.delegate = self
        searchAddressTextField.delegate = self
        phoneNumberTextField.delegate = self
        
        self.searchAddressTextField.text = "Enter a Address"
        searchAddressTextField.resetFloatingLable()
        btnContractor.setRoundCorners(radius: 4.0)
        btnHomeOwner.setRoundCorners(radius: 4.0)
        
        searchAddressTextField.isUserInteractionEnabled = false
        passwordView.setRoundCorners(radius: 4.0)
        btnLogin.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 12.0)
        btnContractor.titleLabel?.font = UIFont(name: PoppinsFont.medium, size: 14.0)
        btnHomeOwner.titleLabel?.font = UIFont(name: PoppinsFont.medium, size: 14.0)
        btnShowHide.titleLabel?.font = UIFont(name: PoppinsFont.medium, size: 14.0)
        btnAcceptTerms.titleLabel?.font = UIFont(name: PoppinsFont.medium, size: 14.0)
        btnSignUp.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 16.0)
        companyNameView.isHidden = true
        
        
        firstNameTextField.setLeftPadding(14)
        lastNameTextField.setLeftPadding(14)
        companyNameTextField.setLeftPadding(14)
        searchAddressTextField.setLeftPadding(14)
        addressLine1TextField.setLeftPadding(14)
        cityTextField.setLeftPadding(14)
        emailTextField.setLeftPadding(14)
        passwordTextField.setLeftPadding(14)
        stateTextField.setLeftPadding(14)
        zipCodeTextField.setLeftPadding(14)
        phoneNumberTextField.setLeftPadding(14)
        
        //addressLine1TextField.maxLength = 150
        //cityTextField.maxLength = 150
        //stateTextField.maxLength = 150
        zipCodeTextField.maxLength = 10
        phoneNumberTextField.maxLength = 13
        companyNameTextField.maxLength = 50
        firstNameTextField.maxLength = 50
        lastNameTextField.maxLength = 50
        passwordTextField.maxLength = 16
        emailTextField.maxLength = 100
        
        setlblPrivacyNtermsLabel()
        
    }
    
    
    
    // MARK: - Customize Privacy Label
    private func setlblPrivacyNtermsLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedOnlblPrivacyNtermsLabel))
        self.termsLabel.addGestureRecognizer(tapGesture)
        termsLabel.isUserInteractionEnabled = true

        let primaryFont = UIFont(name: PoppinsFont.medium, size: 14) ?? UIFont.systemFont(ofSize: 14)
        let primaryColor = UIColor.appFloatText
        let secondaryFont = UIFont(name: PoppinsFont.medium, size: 14) ?? UIFont.systemFont(ofSize: 14)
        let secondaryColor = UIColor.appColorBlue

        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: primaryFont,
            NSAttributedString.Key.foregroundColor: primaryColor]

        let attributes1: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: secondaryFont,
            NSAttributedString.Key.foregroundColor: secondaryColor]

        let agree = NSAttributedString(string: "I agree with ", attributes: attributes)
        let terms = NSAttributedString(string: "Terms & Conditions", attributes: attributes1)
        let and = NSAttributedString(string: " and ", attributes: attributes)
        let policy = NSAttributedString(string: "Privacy Policy.", attributes: attributes1)

        let string = NSMutableAttributedString(attributedString: agree)
        string.append(terms)
        string.append(and)
        string.append(policy)

        self.termsLabel.attributedText = string
    }

    @objc private func tappedOnlblPrivacyNtermsLabel(_ tapGesture: UITapGestureRecognizer) {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: self.termsLabel.text ?? "")
        let termsRange: NSRange = attributedString.mutableString.range(of: "Terms & Conditions", options: .caseInsensitive)
        let policyRange: NSRange = attributedString.mutableString.range(of: "Privacy Policy.", options: .caseInsensitive)

        if tapGesture.didTapAttributedTextInLabel(label: self.termsLabel, inRange: termsRange) {
            let destinationVC = Storyboard.profileHO.instantiateViewController(withIdentifier: "TermsAndConditionVC") as? TermsAndConditionVC
            self.navigationController?.pushViewController(destinationVC!, animated: true)
        } else if tapGesture.didTapAttributedTextInLabel(label: self.termsLabel, inRange: policyRange) {
            let destinationVC = Storyboard.profileHO.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as? PrivacyPolicyVC
            self.navigationController?.pushViewController(destinationVC!, animated: true)
        }
    }

    //MARK: Handle Onwer Contractor
    func handleOnwerContractor(selectedBtn:UIButton, unselectedBtn:UIButton) {

        selectedBtn.backgroundColor = UIColor.appBtnColorOrange
        unselectedBtn.backgroundColor = UIColor.clear

        selectedBtn.borderColor = UIColor.clear
        unselectedBtn.borderColor = UIColor.appBtnColorGrey
        unselectedBtn.border = 1.0

        selectedBtn.tintColor = UIColor.appBtnColorWhite
        unselectedBtn.tintColor = UIColor.appBtnColorGrey
       
        self.companyNameView.isHidden = selectedBtn == btnHomeOwner
    
        if !companyNameView.isHidden{
            self.companyNameTextField.text = ""
            self.companyNameTextField.resetFloatingLable()
        }

    }

    //MARK: ACTION LOGIN
    @IBAction func loginButtonTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: ACTION HOME OWNER
    @IBAction func actionHomeOwner(_ sender: Any) {
        userType = UserType.homeOwner
        handleOnwerContractor(selectedBtn: btnHomeOwner, unselectedBtn: btnContractor)
    }

    //MARK: ACTION CONTRACTOR
    @IBAction func actionContractor(_ sender: Any) {
        userType = UserType.contractor
        handleOnwerContractor(selectedBtn: btnContractor, unselectedBtn: btnHomeOwner)
    }

    //MARK: ACTION SHOW PASSWORD
    @IBAction func toggleSecureTextButtonDidTap(_ sender: UIButton) {
        if sender.titleLabel?.text == "Show " {
            sender.setTitle("Hide ", for: .normal)
            passwordTextField.isSecureTextEntry = false
        }else {
            passwordTextField.isSecureTextEntry = true
            sender.setTitle("Show ", for: .normal)
        }
    }

    //MARK: ACTION ACCEPT TERMS
    @IBAction func actionAcceptTerms(_ sender: UIButton) {
        if sender.currentImage?.pngData() == UIImage(named: "ic_check_box")?.pngData() {
            sender.setImage(UIImage(named: "checkBoxSelected"), for: .normal)
        }else {
            sender.setImage(UIImage(named: "ic_check_box"), for: .normal)
        }
    }


    //MARK: ACTION SIGNUP
    @IBAction func signUpButtonTap(_ sender: Any) {

        let email = emailTextField.text?.trimmed ?? ""
        let password = passwordTextField.text?.trimmed ?? ""
        let firstName = firstNameTextField.text?.trimmed ?? ""
        let lastName = lastNameTextField.text?.trimmed ?? ""
        let phoneNumber = replaceSpecialCharFromPhoneNumber(phoneNumber: phoneNumberTextField.text?.trimmed ?? "")
        let emailVerified = 0
        let state = stateTextField.text?.trimmed ?? ""
        let city = cityTextField.text?.trimmed ?? ""
        let addressLine1 = addressLine1TextField.text?.trimmed ?? ""
        let zipCode = zipCodeTextField.text?.trimmed ?? ""
        var termsAccepted = false
        let companyName = companyNameTextField.text?.trimmed ?? ""
        
        if btnAcceptTerms.currentImage?.pngData() == UIImage(named: "ic_check_box")?.pngData() {
            termsAccepted = false
        } else {
            termsAccepted = true
        }
        var devToken = ""
        if let deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as? String {
            devToken = deviceToken
        } else {
            devToken = "01234567890"
        }
        
        let signupModel = SignupModel(email: email, password: password, userType: self.userType, termsAccepted: termsAccepted, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, emailVerified: emailVerified, state: state, city: city, addressLine1: addressLine1, latitude: latitude, longitude: longitude, zipCode: zipCode, deviceToken: devToken, deviceType: "IOS", companyName: companyName)
        viewModel.model = signupModel
            viewModel.validateSignUpModel {[weak self] (success, error) in
                guard let strongSelf = self else { return }
                if error == nil {
                    if let params = success {
                        print("params: ", params)
                        viewModel.signUpUserApiCall(params) { (model) in
                            UserDefaults.standard.save(customObject: model?.data, inKey:TA_Storage.TA_Storage_Constants.kPersonalDetailsData)
                            TA_Storage.shared.apiAccessToken = "Bearer \(model?.data?.accessToken! ?? "")"
                            TA_Storage.shared.userId = model?.data?.id ?? -1
                            fireBaseUserTable().updateOwnProfileOnFirebase()
                            TA_Storage.shared.rememberLoginEmail = model?.data?.email ?? ""
                            UserDefaults.standard.set(nil, forKey: "BankId")
                            //if model?.data?.userType == UserType.homeOwner {
                                let destinationViewController = Storyboard.signUp.instantiateViewController(withIdentifier: "VerifyVC") as? VerifyVC
                                //                            destinationViewController!.completionHandlerGoToCreateProfile = { [weak self] in
                                //                                guard let strongSelf = self else { return }
                                //                                let vc = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "CreateAccountTAC") as? CreateAccountTAC
                                //                                strongSelf.navigationController?.pushViewController(vc!, animated: true)
                                //                            }
                                destinationViewController!.modalPresentationStyle = .overCurrentContext
                                destinationViewController?.viewModel = self!.viewModel
                                self?.present(destinationViewController!, animated: true)
//                            } else {
//                                let destinationViewController = Storyboard.signUp.instantiateViewController(withIdentifier: "VerifyVC") as? VerifyVC
//                                //self?.changeRootController(storyboadrId: "CreateAccountTAC", bundle: nil, controllerId: "UploadLicenceVC")
//                            }
                        }
                    }
                } else {
                    if let errorMsg = strongSelf.viewModel.error {
                        showMessage(with: errorMsg)
                    }
                }
            }
    }
    
    @IBAction func actionFindLocation(_ sender: Any) {
        
        let destinationViewController = (Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController)
        destinationViewController?.btnTapAction3 = {
            () in
            
            self.addressLine1TextField.text = destinationViewController?.addressLine1
            self.addressLine1TextField.resetFloatingLable()
            self.cityTextField.text = destinationViewController?.city ?? ""
            self.cityTextField.resetFloatingLable()
            self.stateTextField.text = destinationViewController?.state ?? ""
            self.stateTextField.resetFloatingLable()
            self.zipcodeTextField.text = destinationViewController?.zipcode
            self.zipcodeTextField.resetFloatingLable()
            self.longitude = ""
            self.latitude = ""
            self.longitude = "\(destinationViewController?.lng ?? Double(0.0))"
            self.latitude = "\(destinationViewController?.lat ?? Double(0.0))"
        }
        self.navigationController?.present(destinationViewController!, animated: true)
    }
    
}

extension SignUpVC {
    func replaceSpecialCharFromPhoneNumber(phoneNumber:String) -> String {
        let phoneString = phoneNumber
        let phoneString2 = phoneString.replacingOccurrences(of: "-", with: "")
        let phoneString3 = phoneString2.replacingOccurrences(of: "(", with: "")
        let phoneString4 = phoneString3.replacingOccurrences(of: ")", with: "")
        let phoneString5 = phoneString4.replacingOccurrences(of: " ", with: "")
        return phoneString5
    }
}

extension SignUpVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
            self.passwordTextField.isSecureTextEntry = self.btnShowHide.titleLabel?.text == "Show "
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField {
            if string.count > 0 {
                self.phoneNumberTextField.resetFloatingLable()
            }
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = textField.format(with: "(XXX)-XXX-XXXX", phone: newString)
            return false
        }
        return true
    }
}

