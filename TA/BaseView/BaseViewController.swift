//
//  BaseViewController.swift
//  Fitsentive
//
//  Created by Applify  on 15/07/21.
//

import UIKit
import SKPhotoBrowser

@objc protocol Router {
    func route(to routeID: String,
               from context: UIViewController)
    @objc optional func prepare(for segue: UIStoryboardSegue)
}

class BaseViewController: UIViewController {
    var inboxMessagesss = [ChatInbox]()
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint?
    var bottomPadding: CGFloat {
        return 0
    }
    var clearNavigationStackOnAppear: Bool = false

//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        get {
//            return .darkContent
//        }
//    }
    
    var index:Int = -1
    func printFrame(){}
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillChangeFrameNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "VideoAddedNotification"), object: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if clearNavigationStackOnAppear {
            clearNavigationStackOnAppear = false
            self.navigationController?.viewControllers = [self]
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        if let  navVC = self.navigationController {
//            navVC.interactivePopGestureRecognizer?.delegate = navVC.viewControllers.count == 1 ? self: nil
//            navVC.interactivePopGestureRecognizer?.isEnabled = true
//        }
    }
    
    func setNotification(notificationBtn: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if isNotificationRead {
                notificationBtn.setImage(UIImage(named: "ic_HO_notification"), for: .normal)
            } else {
                notificationBtn.setImage(UIImage(named: "ic_HO_notification-1"), for: .normal)
            }
            
            if let tabItems = self.tabBarController?.tabBar.items {
                let tabItem = tabItems[2]
                
                if isInviteNotificationRead {
                    tabItem.badgeValue = nil
                } else {
                    if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
                        if obj.userType == UserType.homeOwner {
                            
                        } else {
                            tabItem.badgeValue = "●"
                            tabItem.badgeColor = .clear
                            tabItem.setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .normal)
                            //tabItem.badgeValue = ""
                        }
                    }
                }
            }
        }
    }
    
    func getAllInboxMessagesForRedDot() {
        self.inboxMessagesss = fireBaseChatInbox().getAllInboxMessages()
        let filtered = self.inboxMessagesss.filter { model in
            let user_id = UIFunction.getCurrentUserId()
            let unread_count = model.unread_count?.asDictionary()
            let read_count = Int(unread_count?.objectForKeyAsString(key: user_id) ?? "0") ?? 0
            return read_count == 0 ? false : true
        }
        if let tabItems = self.tabBarController?.tabBar.items {
            let tabItem = tabItems[3]
            
            if filtered.count == 0 {
                tabItem.badgeValue = nil
            } else {
                tabItem.badgeValue = "●"
                tabItem.badgeColor = .clear
                tabItem.setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .normal)
//                    tabItem.badgeValue = ""
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "LogoutCall"), object: nil)
    }
    
    // MARK:- View did load
    override func viewDidLoad(){
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedInvitationToContractor(notification:)), name: Notification.Name("ReceivedInvitationToContractor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.bidPlacedToHomeOwner(notification:)), name: Notification.Name("BidPlacedToHomeOwner"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.bidRejectToContractor(notification:)), name: Notification.Name("BidRejectToContractor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.bidAcceptToContractor(notification:)), name: Notification.Name("BidAcceptToContractor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.projectAcceptToContractor(notification:)), name: Notification.Name("ProjectAcceptToContractor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.projectRejectToContractor(notification:)), name: Notification.Name("ProjectRejectToContractor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.progressUpdateToHomeOwner(notification:)), name: Notification.Name("ProgressUpdateToHomeOwner"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.markCompletedToHomeOwner(notification:)), name: Notification.Name("MarkCompletedToHomeOwner"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.recallBidToHomeOwner(notification:)), name: Notification.Name("RecallBidToHomeOwner"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.projectUpdatedToContractor(notification:)), name: Notification.Name("ProjectUpdatedToContractor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.lostBidToContractor(notification:)), name: Notification.Name("LostBidToContractor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.projectAdminAcceptedToContractor(notification:)), name: Notification.Name("ProjectAdminAcceptedToContractor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.projectAdminAcceptedToHomeOwner(notification:)), name: Notification.Name("ProjectAdminAcceptedToHomeOwner"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.taskUpdatedToHomeOwner(notification:)), name: Notification.Name("TaskUpdatedToHomeOwner"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.sendTaskToSubContractor(notification:)), name: Notification.Name("SendTaskToSubContractor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.editSubTaskToContractor(notification:)), name: Notification.Name("EditSubTaskToContractor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.uploadAgreementTaskToSubContractor(notification:)), name: Notification.Name("UploadAgreementTaskToSubContractor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.lostTaskBidToSubContractor(notification:)), name: Notification.Name("LostTaskBidToSubContractor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.acceptTaskBidToSubContractor(notification:)), name: Notification.Name("AcceptTaskBidToSubContractor"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.rejectTaskBidToSubContractor(notification:)), name: Notification.Name("RejectTaskBidToSubContractor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.taskBidToContractor(notification:)), name: Notification.Name("TaskBidToContractor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.subContractorMarkCompleteToContractor(notification:)), name: Notification.Name("SubContractorMarkCompleteToContractor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.acceptTaskDeliveryToSubContractor(notification:)), name: Notification.Name("AcceptTaskDeliveryToSubContractor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.rejectTaskDeliveryToSubContractor(notification:)), name: Notification.Name("RejectTaskDeliveryToSubContractor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.vendorSendQuoteToContractor(notification:)), name: Notification.Name("VendorSendQuoteToContractor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.vendorDispatchQuoteToContractor(notification:)), name: Notification.Name("VendorDispatchQuoteToContractor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.paymentNotification(notification:)), name: Notification.Name("paymentNotification"), object: nil)
        
    }

    func randomString() -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return "TA_File_\(String((0..<5).map{ _ in letters.randomElement()! }))"
    }
    
    @objc func vendorDispatchQuoteToContractor(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name("VendorDispatchQuoteToContractorDetails"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func paymentNotification(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 0
//        NotificationCenter.default.post(name: Notification.Name("paymentNotification"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func vendorSendQuoteToContractor(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name("VendorSendQuoteToContractorDetails"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func rejectTaskDeliveryToSubContractor(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name("RejectTaskDeliveryToSubContractorPastProject"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func acceptTaskDeliveryToSubContractor(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name("AcceptTaskDeliveryToSubContractorPastProject"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func subContractorMarkCompleteToContractor(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name("SubContractorMarkCompleteToContractorOngoingProjects"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func taskBidToContractor(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name("TaskBidToContractorOngoingProjects"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func rejectTaskBidToSubContractor(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 2
        NotificationCenter.default.post(name: Notification.Name("RejectTaskBidToSubContractorInvitation"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func acceptTaskBidToSubContractor(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 2
        NotificationCenter.default.post(name: Notification.Name("AcceptTaskBidToSubContractorInvitation"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func lostTaskBidToSubContractor(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 2
        NotificationCenter.default.post(name: Notification.Name("LostTaskBidToSubContractorInvitation"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func uploadAgreementTaskToSubContractor(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 2
        NotificationCenter.default.post(name: Notification.Name("UploadAgreementTaskToSubContractorInvitation"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func editSubTaskToContractor(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 2
        NotificationCenter.default.post(name: Notification.Name("EditSubTaskToContractorInvitation"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func sendTaskToSubContractor(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 2
        NotificationCenter.default.post(name: Notification.Name("SendTaskToSubContractorInvitation"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func taskUpdatedToHomeOwner(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name("TaskUpdatedToHomeOwnerOngoingProjects"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func projectAdminAcceptedToHomeOwner(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name("ProjectAdminAcceptedToHomeOwnerOngoingProjects"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func projectAdminAcceptedToContractor(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name("ProjectAdminAcceptedToContractorOngoingProjects"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func lostBidToContractor(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 2
        NotificationCenter.default.post(name: Notification.Name("LostBidToContractorInvitation"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func projectUpdatedToContractor(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name("ProjectUpdatedToContractorOngoingProjects"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func recallBidToHomeOwner(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name("RecallBidToHomeOwnerNewProjects"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func markCompletedToHomeOwner(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name("MarkCompletedToHomeOwnerOngoingProjects"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func progressUpdateToHomeOwner(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name("ProgressUpdateToHomeOwnerOngoingProjects"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func projectRejectToContractor(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name("ProjectRejectToContractorProjects"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func projectAcceptToContractor(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name("ProjectAcceptToContractorProjects"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func bidAcceptToContractor(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 2
        NotificationCenter.default.post(name: Notification.Name("BidAcceptToContractorInvitation"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func bidRejectToContractor(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 2
        NotificationCenter.default.post(name: Notification.Name("BidRejectToContractorInvitation"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func bidPlacedToHomeOwner(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name("BidPlacedToHomeOwnerProjects"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func receivedInvitationToContractor(notification: Notification) {
        self.handleStackControllers()
        self.tabBarController?.selectedIndex = 2
        NotificationCenter.default.post(name: Notification.Name("ReceivedInvitationToContractorInvitation"), object: nil, userInfo: notification.userInfo!)
    }
    
    func handleStackControllers() {
        UIApplication.getTopViewController()?.dismiss(animated: false, completion: nil)
        UIApplication.getTopViewController()?.navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func backButtonAction(_ sender: Any?) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func showPhotoBrowser(image:String)
    {
        if (image.count > 0)
        {
            var photos = [SKPhoto]()
            var photo: SKPhoto!
            
            if (image.hasPrefix("http") || image.hasPrefix("https"))
            {
                // image from url
                photo = SKPhoto.photoWithImageURL(image)
                photos.append(photo)
            }
            else
            {
                let local_image = self.getImageFromPath(path: image) ?? UIImage()
                photo = SKPhoto.photoWithImage(local_image)
                photos.append(photo)
            }
            
            let browser = SKPhotoBrowser(photos: photos)
            browser.initializePageIndex(0)
            SKPhotoBrowserOptions.displayAction = false
            self.present(browser, animated: true, completion: nil)
        }
    }
    
    func changeRootController(storyboadrId: String, bundle: Bundle?, controllerId: String) {
        let storyboard = UIStoryboard(name: storyboadrId, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: controllerId)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationBar.isHidden = true
        navVC.navigationBar.tintColor = .white
        navVC.navigationBar.barStyle = .black
        navVC.navigationBar.barTintColor = .black
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navVC
        }
    }
    
    func popToRootController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func popToController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func endEditing(_ force: Bool) {
        self.view.endEditing(force)
    }
    @objc
    func keyboardWillChangeFrame(_ notification: Notification) {
        if UIApplication.shared.applicationState == .active {
            let endFrame = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            if endFrame.origin.y >= UIScreen.main.bounds.size.height {
                bottomConstraint?.constant = 0
            } else {
                bottomConstraint?.constant = view.bounds.height - endFrame.origin.y - bottomPadding
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func showAlert(with title: String = "Example App",
                   message: String,
                   style: UIAlertController.Style = .alert,
                   options: String...,
                   completion: @escaping (Int) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for (index, option) in options.enumerated() {
            alert.addAction(UIAlertAction(title: option, style: .default, handler: { action in
                completion(index)
            }))
        }
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithTextField(with title: String = "Example App",
                                message: String,
                                placeHolder:String,
                                keyBoardType:UIKeyboardType = .default,
                                options: String...,
                                completion: @escaping (Int, String) -> Void)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = placeHolder
        }
        
        
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction(title: option, style: .default, handler: { action in
                
                let textField = alertController.textFields![0] as UITextField
                let text = (textField.text ?? "")
                completion(index, text)
            }))
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showLocationPermissionAlert(with title:String, message:String) {
        let alertController: UIAlertController = UIAlertController(title: title as String, message: message as String, preferredStyle: .alert)
        
        let cancel_title = "Cancel"
        let cancelAction: UIAlertAction = UIAlertAction(title: cancel_title, style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        let settings_title = "Settings"
        let settingsAction = UIAlertAction(title: settings_title, style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                })
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }
}

// MARK:- Gesture Delegate
extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let navigationGR = self.navigationController?.interactivePopGestureRecognizer,
            gestureRecognizer == navigationGR {
            if self.isViewLoaded && self.view.window != nil {
                return false
            }
        }
        return true
    }
}

// MARK: - Get Image From Path
extension BaseViewController
{
    func getImageFromPath(path:String) -> UIImage?
    {
        if (path.count == 0)
        {
            return (UIImage())
        }
        else
        {
            if (path.hasPrefix("http"))
            {
                return (UIImage())
            }
            else
            {
                let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
                let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
                let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
                if let dirPath          = paths.first
                {
                    let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(path)
                    let image    = UIImage(contentsOfFile: imageURL.path)!
                    return (image)
                }
            }
        }
        
        return (UIImage())
    }
}

extension UINavigationController {

  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
      popToViewController(vc, animated: animated)
    }
  }

  func popViewControllers(viewsToPop: Int, animated: Bool = true) {
    if viewControllers.count > viewsToPop {
      let vc = viewControllers[viewControllers.count - viewsToPop - 1]
      popToViewController(vc, animated: animated)
    }
  }

}
