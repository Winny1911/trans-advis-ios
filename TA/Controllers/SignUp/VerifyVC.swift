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
    
    @IBOutlet weak var labelLink: UILabel!
    var viewModel: SignUpVM = SignUpVM()
    
    var completionHandlerGoToCreateProfile: (() -> Void)?
    
    var isFromLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.verifyView.isHidden = false
        self.verifyView.roundCorners(corners: [.topLeft, .topRight], radius: 18.0)
        btnResend.titleLabel?.font = UIFont(name: PoppinsFont.medium, size: 18.0)
        
//        self.viewModel.checkEmailVerify { [weak self] in
//            self?.dismiss(animated: true, completion: {
//                self?.completionHandlerGoToCreateProfile?()
//            })
//        }
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
        let email = viewModel.model.email
        let password = viewModel.model.password
        let emailVerified = viewModel.model.emailVerified
        let loginModel  = LoginModel(email: email, password: password)
        let viewModelLogin: LoginVM = LoginVM()
        viewModelLogin.model = loginModel
        
        viewModelLogin.validateLoginModel { success, error in
            //            guard let strongSelf = self else { return }
            if error == nil {
                if let params = success {
                    print("params: ", params)
                    if TA_Storage.shared.isRememberLogin == true {
                        TA_Storage.shared.rememberLoginEmail = email
                        TA_Storage.shared.rememberLoginPassword = password
                    }
                    viewModelLogin.loginUserApiCall(params) { (model) in
                        UserDefaults.standard.save(customObject: model?.data, inKey:TA_Storage.TA_Storage_Constants.kPersonalDetailsData)
                        TA_Storage.shared.apiAccessToken = "Bearer \(model?.data?.accessToken! ?? "")"
                        
                        TA_Storage.shared.userId = model?.data?.id ?? -1
                        fireBaseUserTable().updateOwnProfileOnFirebase()
                        /*
                         Fetch chat history
                         */
                        ChatHistoryModel.fetchChatHistory()
                        
                        if model?.data?.userType == UserType.homeOwner {
                            if model?.data?.emailVerified == 1 {
                                if model?.data?.firstName != "" && model?.data?.firstName != nil {
                                    TA_Storage.shared.iskProfileCreated = true
                                    
                                    self.changeRootController(storyboadrId: "TabBarHO", bundle: nil, controllerId: "TabBarHOVC")
                                }
                            }
                        } else {
                            self.changeRootController(storyboadrId: "CreateAccountTAC", bundle: nil, controllerId: "UploadLicenceVC")
                        }
                    }
                }
                else {
//                    if let errorMsg = strongSelf.viewModelLogin.error {
//                        showMessage(with: errorMsg)
//                    }
                }
            }
        }
    }
}
