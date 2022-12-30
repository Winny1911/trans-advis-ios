//
//  SplashVC.swift
//  TA
//
//  Created by Applify  on 12/12/21.
//

import UIKit

class SplashVC: BaseViewController {

    @IBOutlet weak var splashImageView: UIImageView!
    enum Route: String {
        case login
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.animateSplashLogo()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let accessToken = TA_Storage.shared.apiAccessToken
            
            AppVersion.shared.appVersionApi()

            if accessToken.count < 10 || !TA_Storage.shared.isLoggedIn {
                self.moveToLogin()
            } else {
                if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
                    if obj.userType == UserType.homeOwner {
                        self.changeRootController(storyboadrId: "TabBarHO", bundle: nil, controllerId: "TabBarHOVC")
                    } else {
                        self.changeRootController(storyboadrId: "ContratorTabBar", bundle: nil, controllerId: "ContratorTabBarVC")
                    }
                }
            }
        }
    }
    
    func animateSplashLogo() {
        splashImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut) {
                self.splashImageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            }
        }
    }
    
    func goFoeSignUpModel() {
        if let obj = UserDefaults.standard.retrieve(object: signupDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData), obj.emailVerified == "1" {
            
            if let isProfileCreated = UserDefaults.standard.value(forKey: TA_Storage.TA_Storage_Constants.kProfileCreated) as? Bool {
                if isProfileCreated == true {
                    if obj.userType == UserType.homeOwner {
                        // Set tab bar
                        if obj.firstName != nil  && obj.firstName != "" {
                            self.changeRootController(storyboadrId: "TabBarHO", bundle: nil, controllerId: "TabBarHOVC")
                        } else {
                            self.moveToCreateAccount()
                        }
                    } else {
                        if obj.profileStatus == "1" {
                            self.changeRootController(storyboadrId: "ContratorTabBar", bundle: nil, controllerId: "ContratorTabBarVC")
                        } else {
                            self.moveToAwaiting()
                        }
                        // check profile approval
                    }
                } else {
                    self.moveToCreateAccount()
                }
            } else {
                self.moveToCreateAccount()
            }
        } else {
            self.moveToLogin()
        }
    }
    
    func goForUserProfileModel() {
        if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData), obj.emailVerified == 1 {

            if let isProfileCreated = UserDefaults.standard.value(forKey: TA_Storage.TA_Storage_Constants.kProfileCreated) as? Bool {
                if isProfileCreated == true {
                    if obj.userType == UserType.homeOwner {
                        // Set tab bar
                        if obj.firstName != nil  && obj.firstName != "" {
                            self.changeRootController(storyboadrId: "TabBarHO", bundle: nil, controllerId: "TabBarHOVC")
                        } else {
                            self.moveToCreateAccount()
                        }
                    } else {
                        if obj.profileStatus == 1 {
                            self.changeRootController(storyboadrId: "ContratorTabBar", bundle: nil, controllerId: "ContratorTabBarVC")
                        } else {
                            self.moveToAwaiting()
                        }
                        // check profile approval
                    }
                } else {
                    self.moveToCreateAccount()
                }
            } else {
                self.moveToCreateAccount()
            }
        } else {
            self.moveToLogin()
        }
    }
    
    
    func moveToAwaiting() {
        let vc = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "AwaitingApprovalVC") as? AwaitingApprovalVC
        vc!.completionHandlerGoToLogin = { [weak self] in
            self!.moveToLogin()
        }
        vc!.completionHandlerGoToEditProfile = { [weak self] in
            self!.moveToEditProfile()
        }
        vc!.modalPresentationStyle = .overCurrentContext
        self.present(vc!, animated: true)
    }
    
    func moveToEditProfile() {
        let vc = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "CreateAccountTAC") as? CreateAccountTAC
        vc!.isFromEdit = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func moveToCreateAccount() {
        let vc =  Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "CreateAccountTAC") as? CreateAccountTAC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func moveToLogin() {
        let newVC = Storyboard.login.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}
