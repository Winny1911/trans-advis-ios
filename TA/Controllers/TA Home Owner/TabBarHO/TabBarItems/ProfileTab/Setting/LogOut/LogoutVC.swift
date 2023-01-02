//
//  LogoutVC.swift
//  TA
//
//  Created by Designer on 05/01/22.
//

import UIKit

class LogoutVC: BaseViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    var completionHandlerGoToLogin: (() -> Void)?
    
    var logoutVM: LogoutVM = LogoutVM()
    var profileVM: ProfileVM = ProfileVM()
    var isForm = ""
    var callBackTologinScreen: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isForm == "Delete" {
            textLabel.text = "Are you sure you want to Delete Account ?"
        } else {
            textLabel.text = "Are you sure you want to Logout ?"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isForm == "Delete" {
            textLabel.text = "Are you sure you want to Delete Account ?"
        } else {
            textLabel.text = "Are you sure you want to Logout ?"
        }
    }
    
    func DeleteAccountApi() {
        self.profileVM.DeleteAccountApiCall([:]) { model in
            print(model?.message as Any)
            showMessage(with: "Account deleted successfully", theme: .success)
            self.callBackTologinScreen?()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func tapDidCancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapDidConfirmLogoutButtonAction(_ sender: UIButton) {
        if isForm == "Delete" {
            self.DeleteAccountApi()
        } else {
            logoutVM.logOutApiCall { modal in
                
                //            UserDefaults.standard.removeObject(forKey: "FilterWorkOngoingProjects")
                //            UserDefaults.standard.removeObject(forKey: "FilterLocationOngoingProjects")
                //            UserDefaults.standard.removeObject(forKey: "FilterWorkOngoingProjectHO")
                //            UserDefaults.standard.removeObject(forKey: "FilterLocationOngoingProjectHO")
                //            UserDefaults.standard.removeObject(forKey: "FilterWork")
                //            UserDefaults.standard.removeObject(forKey: "FilterLocation")
                //            UserDefaults.standard.removeObject(forKey: "BankId")
                //            UserDefaults.standard.removeObject(forKey: "FilterWorkHO")
                //            UserDefaults.standard.removeObject(forKey: "FilterLocationHO")
                //            UserDefaults.standard.removeObject(forKey: "profileCreated")
                //            UserDefaults.standard.removeObject(forKey: "personalDetailsData")
                
                let defaults = UserDefaults.standard
                let dictionary = defaults.dictionaryRepresentation()
                dictionary.keys.forEach { key in
                    if key == "rememberMe" || key == "rememberMeEmail" || key == "rememberMePassword" || key == "DeviceToken" {
                        
                    } else {
                        isNotificationRead = true
                        isInviteNotificationRead = true
                        defaults.removeObject(forKey: key)
                    }
                }
                self.dismiss(animated: true, completion: nil)
                self.completionHandlerGoToLogin?()
            }
        }
    }
}
