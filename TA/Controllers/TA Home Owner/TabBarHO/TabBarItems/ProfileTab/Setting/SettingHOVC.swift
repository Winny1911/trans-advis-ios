//
//  SettingHOVC.swift
//  TA
//
//  Created by Designer on 28/12/21.
//

import UIKit
import CoreData
import UserNotifications

class SettingHOVC: BaseViewController {

    //MARK: OUTLET
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var settingTableView: UITableView!
    
    var userBankDetailsVM : UserBankDetailsVM = UserBankDetailsVM()
    
    
    //MARK: Variable
    var settingDetail: profileUserDetail?
    var settingDetails: ContractorUserData?
    
//    var settingHOArr = ["Notifications", "Edit Profile","Add/Edit Bank Details", "Change Password","Help & Support","Terms & Conditions","Privacy Policy", "FAQ","Logout"]
    var settingHOArr = ["Notifications", "Edit Profile", "Change Password","Help & Support","Terms & Conditions","Privacy Policy", "FAQ", "Delete Account", "Logout"]
    var settingHOImage: [UIImage] = [
        UIImage(named: "setting_notification")!,
        UIImage(named: "ic_arrow-3")!,
        UIImage(named: "ic_arrow-3")!,
        UIImage(named: "ic_arrow-3")!,
        UIImage(named: "ic_arrow-3")!,
        UIImage(named: "ic_arrow-3")!,
        UIImage(named: "ic_arrow-3")!,
        UIImage(named: "ic_arrow-3")!,
        UIImage(named: "ic_arrow-3")!,
        UIImage(named: "LogOut")!
    ]
    var settingsHoImage = ["setting_notification", "ic_arrow-3", "ic_arrow-3","ic_arrow-3", "ic_arrow-3", "ic_arrow-3", "ic_arrow-3", "ic_arrow-3", "LogOut" ]
    
    var settingArr = ["Notifications", "Edit Profile", "Add/Edit Bank Details", "Change Password","Help & Support","Terms & Conditions","Privacy Policy", "FAQ", "Delete Account", "Logout"]
    var settingImage: [UIImage] = [
        UIImage(named: "setting_notification")!,
        UIImage(named: "ic_arrow-3")!,
        UIImage(named: "ic_arrow-3")!,
        UIImage(named: "ic_arrow-3")!,
        UIImage(named: "ic_arrow-3")!,
        UIImage(named: "ic_arrow-3")!,
        UIImage(named: "ic_arrow-3")!,
        UIImage(named: "ic_arrow-3")!,
        UIImage(named: "ic_arrow-3")!,
        UIImage(named: "LogOut")!
    ]
    var settingsImage = ["setting_notification", "ic_arrow-3", "ic_arrow-3", "ic_arrow-3","ic_arrow-3", "ic_arrow-3", "ic_arrow-3","ic_arrow-3", "ic_arrow-3", "LogOut" ]
    
    //MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentNotification = UNUserNotificationCenter.current()
        currentNotification.getNotificationSettings(completionHandler: { (settings) in
           if settings.authorizationStatus == .notDetermined {
               self.settingsHoImage[0] = "setting_notification"
               self.settingImage[0] = UIImage(named: "setting_notification")!
               self.settingHOImage[0] = UIImage(named: "setting_notification")!
               self.settingsImage[0] = "setting_notification"
              // Notification permission is yet to be been asked go for it!
           } else if settings.authorizationStatus == .denied {
               self.settingsHoImage[0] = "setting_notification"
               self.settingImage[0] = UIImage(named: "setting_notification")!
               self.settingHOImage[0] = UIImage(named: "setting_notification")!
               self.settingsImage[0] = "setting_notification"
              // Notification permission was denied previously, go to settings & privacy to re-enable the permission
           } else if settings.authorizationStatus == .authorized {
               self.settingsHoImage[0] = "ic_switch_active"
               self.settingImage[0] = UIImage(named: "ic_switch_active")!
               self.settingHOImage[0] = UIImage(named: "ic_switch_active")!
               self.settingsImage[0] = "ic_switch_active"
              // Notification permission already granted.
           }
        })
        
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
        topView.layer.shadowRadius = 5.0
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize.zero
        
        self.tabBarController?.tabBar.isHidden = true
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
        self.settingTableView.tableFooterView = UIView()
        self.registerCell()
        let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData)
        if obj?.userType == "CO"{
            self.getUserBankDetails()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func getUserBankDetails(){
        userBankDetailsVM.getUserBankDetailsApiCall { modal in
            if modal?.data?.listing?.count ?? 0 > 0 {
                let id = modal?.data?.listing?[0].id ?? 0
                UserDefaults.standard.set(id, forKey: "BankId")  //Integer
            }
        }
    }
    
    //MARK: - REGISTER CELL
    func registerCell() {
        settingTableView.register(UINib.init(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        }

    //MARK: Back Button Action
    @IBAction func tapDIdBackButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingHOVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell
        
        let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData)
        //CO SIDE
        if obj?.userType == "CO"{
            if indexPath.row == 0{
                // settings
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            if indexPath.row == 1{
                let destinationViewController = Storyboard.profileHO.instantiateViewController(withIdentifier: "EditProfleHO") as? EditProfleHO
                destinationViewController?.isFrom = "CO"
                destinationViewController?.settingDetails = settingDetails
                self.navigationController?.pushViewController(destinationViewController!, animated: true)
            }
            if indexPath.row == 2{
                let destinationViewController = Storyboard.profile.instantiateViewController(withIdentifier: "AddEditBankDetailVC") as? AddEditBankDetailVC  //createAccountTACAccount  //AddEditBankDetail
                self.navigationController?.pushViewController(destinationViewController!, animated: true)
            }
            if indexPath.row == 3{
                let destinationViewController = Controllers.changePasswordHO
                self.navigationController?.pushViewController(destinationViewController!, animated: true)
                destinationViewController!.completionHandlerGoToLogin = { [weak self] in
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
            }
            if indexPath.row == 4{
                let destinationVC = Storyboard.profileHO.instantiateViewController(withIdentifier: "HelpAndSupportVC") as? HelpAndSupportVC
                self.navigationController?.pushViewController(destinationVC!, animated: true)
            }
            if indexPath.row == 5{
                let destinationVC = Storyboard.profileHO.instantiateViewController(withIdentifier: "TermsAndConditionVC") as? TermsAndConditionVC
                self.navigationController?.pushViewController(destinationVC!, animated: true)
            }
            if indexPath.row == 6{
                let destinationVC = Storyboard.profileHO.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as? PrivacyPolicyVC
                self.navigationController?.pushViewController(destinationVC!, animated: true)
            }
            if indexPath.row == 7{
                let destinationVC = Storyboard.profileHO.instantiateViewController(withIdentifier: "FAQVC") as? FAQVC
                self.navigationController?.pushViewController(destinationVC!, animated: true)
            }
            if indexPath.row == 8{
                let destinationViewController = Controllers.LogoutHO
                destinationViewController?.isForm = "Delete"
                destinationViewController?.callBackTologinScreen = { [weak self] in
                    for controller in (self?.navigationController!.viewControllers) as Array<Any> {
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
                self.navigationController?.present(destinationViewController!, animated: true)
            }

            if indexPath.row == 9 {
                let destinationViewController = Controllers.LogoutHO
                destinationViewController?.isForm = ""
                self.navigationController?.present(destinationViewController!, animated: true)
                destinationViewController!.completionHandlerGoToLogin = { [weak self] in
                    self?.resetDataOnLogout()
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
            }
        }
        //HO SIDE
        else{
            if indexPath.row == 8 {
                let destinationViewController = Controllers.LogoutHO
                destinationViewController?.isForm = ""
                self.navigationController?.present(destinationViewController!, animated: true)
                destinationViewController!.completionHandlerGoToLogin = { [weak self] in
                    self?.resetDataOnLogout()
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
            }
            if indexPath.row == 1{
                let destinationViewController = Storyboard.profileHO.instantiateViewController(withIdentifier: "EditProfleHO") as? EditProfleHO
                destinationViewController?.settingDetail = settingDetail
                destinationViewController?.isFrom = "HO"
                self.navigationController?.pushViewController(destinationViewController!, animated: true)
            }
            if indexPath.row == 0{
                // settings
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            
//            if indexPath.row == 2{
//                let destinationViewController = Storyboard.profile.instantiateViewController(withIdentifier: "AddEditBankDetailVC") as? AddEditBankDetailVC  //createAccountTACAccount  //AddEditBankDetail
//                self.navigationController?.pushViewController(destinationViewController!, animated: true)
//            }
            if indexPath.row == 2{
                let destinationViewController = Controllers.changePasswordHO
                self.navigationController?.pushViewController(destinationViewController!, animated: true)
                destinationViewController!.completionHandlerGoToLogin = { [weak self] in
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
            }
            if indexPath.row == 3{
                let destinationVC = Storyboard.profileHO.instantiateViewController(withIdentifier: "HelpAndSupportVC") as? HelpAndSupportVC
                self.navigationController?.pushViewController(destinationVC!, animated: true)
            }
            if indexPath.row == 4{
                let destinationVC = Storyboard.profileHO.instantiateViewController(withIdentifier: "TermsAndConditionVC") as? TermsAndConditionVC
                self.navigationController?.pushViewController(destinationVC!, animated: true)
            }
            if indexPath.row == 5{
                let destinationVC = Storyboard.profileHO.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as? PrivacyPolicyVC
                self.navigationController?.pushViewController(destinationVC!, animated: true)
            }
            if indexPath.row == 6{
                let destinationVC = Storyboard.profileHO.instantiateViewController(withIdentifier: "FAQVC") as? FAQVC
                self.navigationController?.pushViewController(destinationVC!, animated: true)
            }
            if indexPath.row == 7 {
                let destinationViewController = Controllers.LogoutHO
                destinationViewController?.isForm = "Delete"
                destinationViewController?.callBackTologinScreen = { [weak self] in
                    for controller in (self?.navigationController!.viewControllers) as Array<Any> {
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
                self.navigationController?.present(destinationViewController!, animated: true)
            }
        
        }
    }
}

extension SettingHOVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData)
        if obj?.userType == "CO"{
            return settingArr.count
        }else{
            return settingHOArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell
        {
            if indexPath.row == 9{
                cell.bottomLine.isHidden = true
            }
        
            let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData)
            if obj?.userType == "CO"{
                let current = UNUserNotificationCenter.current()
                        current.getNotificationSettings(completionHandler: { permission in
                            switch permission.authorizationStatus  {
                            case .authorized:
                                DispatchQueue.main.async {
                                    cell.settingButton.setTitle("ic_toggle_off", for: .normal)
                                }
                            case .denied:
                                DispatchQueue.main.async {
                                    cell.settingButton.setTitle("setting_notification", for: .normal)
                                }
                            @unknown default:
                                print("Unknow Status")
                            }
                        })
                cell.settingButton.setImage(settingImage[indexPath.row], for: .normal)
                cell.settingLabel.text = settingArr[indexPath.row]
                cell.settingImageView.image = UIImage(named: settingsImage[indexPath.row])
            }else{
                let current = UNUserNotificationCenter.current()
                        current.getNotificationSettings(completionHandler: { permission in
                            switch permission.authorizationStatus  {
                            case .authorized:
                                DispatchQueue.main.async {
                                    cell.settingButton.setTitle("ic_toggle_off", for: .normal)
                                }
                            case .denied:
                                DispatchQueue.main.async {
                                    cell.settingButton.setTitle("setting_notification", for: .normal)
                                }
                            @unknown default:
                                print("Unknow Status")
                            }
                        })
                cell.settingButton.setImage(settingHOImage[indexPath.row], for: .normal)
                cell.settingLabel.text = settingHOArr[indexPath.row]
                cell.settingImageView.image = UIImage(named: settingsHoImage[indexPath.row])
            }
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - Reset on logout
extension SettingHOVC {
    func resetDataOnLogout() {
        fireBaseChatInbox().removeAllFirebaseInboxObservers()
        clearDatabase()
        appDelegate().chatObserverArray.removeAllObjects()
    }
    
    func clearDatabase() {
        guard let url = appDelegate().persistentContainer.persistentStoreDescriptions.first?.url else { return }
        let persistentStoreCoordinator = appDelegate().persistentContainer.persistentStoreCoordinator
        
        do {
            try persistentStoreCoordinator.destroyPersistentStore(at:url, ofType: NSSQLiteStoreType, options: nil)
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch let error {
            UIFunction.AGLogs(log: "Attempted to clear persistent store: \(error.localizedDescription)" as AnyObject)
        }
    }
}
