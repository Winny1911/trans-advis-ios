//
//  PushNotificationHandler.swift
//
//  Created by Applify on 19/01/22.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

extension Notification.Name {
    static let notificationTapped = Notification.Name("notificationTapped")
    static let newNotification = Notification.Name("newNotification")

}

extension UNNotification {
    var userInfo: [AnyHashable : Any] {
        return self.request.content.userInfo
    }
}

extension UNNotificationResponse {
    var userInfo: [AnyHashable : Any] {
        return self.notification.request.content.userInfo
    }
}


enum PushNotificationType: Int {
    case broadcast = 0
    case chatMessage = 999
}

extension String {
    var intValue: Int? {
        let intValue = Int(self)
        return intValue
    }
}


class PushNotificationHandler: NSObject {
    
    static let shared: PushNotificationHandler = PushNotificationHandler()
    
    var notificationUserInfo: [AnyHashable : Any]?

    private override init() {
    }
    
    func configure() {
        UNUserNotificationCenter.current().delegate = self
        handleBadgeCount()
        Messaging.messaging().delegate = self
    }
    
    func handleBadgeCount() {
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    func askForPushNotifications(_ completionHandler: (() -> Void)?) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            completionHandler?()
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func showBroadcastPushAlert(userInfo: [AnyHashable: Any]) {
        let title = userInfo["title"] as? String
        let message = userInfo["message"] as? String
        
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in //Just dismiss the action sheet
        }
        
        alertController.addAction(okAction)
        
        var parentController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        while (parentController?.presentedViewController != nil &&
                parentController != parentController!.presentedViewController) {
            parentController = parentController!.presentedViewController
        }
        parentController?.present(alertController, animated:true, completion:nil)
        
        
        //KAPPDELEGATE.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    func handlePushNotification(_ response: UNNotificationResponse) {
        let userInfo = response.userInfo
        if let notificationType = (userInfo["pushType"] as? String ?? "").intValue {
            switch notificationType {
            
            case PushNotificationType.broadcast.rawValue:
                print("Broadcast push received")
            case PushNotificationType.chatMessage.rawValue:
                self.handleChatNotification(userInfo: userInfo)
            default:
                self.handleNotificationTypes(notificationType: notificationType, userInfo:userInfo )
            }
        }
    }
    
    func handleChatNotification(userInfo : [AnyHashable : Any]) {
        let chat_dialogue_id = userInfo["projectId"] as? String ?? ""
        let accessToken = TA_Storage.shared.apiAccessToken
        if !chat_dialogue_id.isEmpty && !accessToken.isEmpty {
            if appDelegate().chat_dialogue_id != chat_dialogue_id {
                self.openChatWindowController(chat_dialogue_id: chat_dialogue_id)
            }
        }
    }
    
    func openChatWindowController(chat_dialogue_id: String) {
        DispatchQueue.main.asyncAfter (deadline: .now() + 2.2) {
            if let chatController = Storyboard.messageHO.instantiateViewController(withIdentifier: "ChatWindowViewController") as? ChatWindowViewController {
                chatController.hidesBottomBarWhenPushed = true
                chatController.viewModel.chat_dialogue_id_for_user_profile = chat_dialogue_id
                let topMostViewController = UIApplication.getTopViewController()
                topMostViewController?.navigationController?.pushViewController(chatController, animated: true)
            }
        }
    }
    
    func handleNotificationTypes(notificationType: Int, userInfo : [AnyHashable : Any]) {
        if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
            if obj.userType == UserType.contractor {
                if let accessToken = TA_Storage.shared.apiAccessToken as? String {
                    if accessToken.count > 10 {
                        self.handleContractorNotifications(notificationType: notificationType, userInfo: userInfo)
                    }
                }
            } else {
                if let accessToken = TA_Storage.shared.apiAccessToken as? String {
                    if accessToken.count > 10 {
                        self.handleHomeOwnerNotifications(notificationType: notificationType, userInfo: userInfo)
                    }
                }
            }
        }
    }
    
    func handleContractorNotifications(notificationType: Int, userInfo : [AnyHashable : Any]) {
        let timeIntrval = 0.0 //4.0
        
        if notificationType == 101 { // PROJECT_INVITATION
            if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                print(projectId)
                let dict = ["projectId": projectId] as! NSDictionary
                if UIApplication.getTopViewController() is SplashVC {
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                        NotificationCenter.default.post(name: Notification.Name("ReceivedInvitationToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                    }
                } else {
                    NotificationCenter.default.post(name: Notification.Name("ReceivedInvitationToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                }
            }
        } else if notificationType == 103 { // BID_REJECT
            if let bidId = (userInfo["bidId"] as? String ?? "").intValue {
                print(bidId)
                let dict = ["bidId": bidId] as! NSDictionary
                if UIApplication.getTopViewController() is SplashVC {
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                        NotificationCenter.default.post(name: Notification.Name("BidRejectToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                    }
                } else {
                    NotificationCenter.default.post(name: Notification.Name("BidRejectToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                }
            }
        } else if notificationType == 104 { // BID_ACCEPED
            if let bidId = (userInfo["bidId"] as? String ?? "").intValue {
                print(bidId)
                let dict = ["bidId": bidId] as! NSDictionary
                if UIApplication.getTopViewController() is SplashVC {
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                        NotificationCenter.default.post(name: Notification.Name("BidAcceptToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                    }
                } else {
                    NotificationCenter.default.post(name: Notification.Name("BidAcceptToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                }
            }
        } else if notificationType == 105 { // PROJECT_ACCEPTED
            if let ongoingProjectId = (userInfo["ongoingProjectId"] as? String ?? "").intValue {
                print(ongoingProjectId)
                if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                    print(projectId)
                    let dict = ["ongoingProjectId": ongoingProjectId, "projectId":projectId] as! NSDictionary
                    if UIApplication.getTopViewController() is SplashVC {
                        DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                            NotificationCenter.default.post(name: Notification.Name("ProjectAcceptToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                        }
                    } else {
                        NotificationCenter.default.post(name: Notification.Name("ProjectAcceptToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                    }
                }
            }
        } else if notificationType == 106 { // PROJECT_REJECTED
            if let ongoingProjectId = (userInfo["ongoingProjectId"] as? String ?? "").intValue {
                print(ongoingProjectId)
                if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                    print(projectId)
                    let dict = ["ongoingProjectId": ongoingProjectId, "projectId":projectId] as! NSDictionary
                    if UIApplication.getTopViewController() is SplashVC {
                        DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                            NotificationCenter.default.post(name: Notification.Name("ProjectRejectToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                        }
                    } else {
                        NotificationCenter.default.post(name: Notification.Name("ProjectRejectToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                    }
                }
            }
        } else if notificationType == 111 { // PROJECT_UPDATED
            if let ongoingProjectId = (userInfo["ongoingProjectId"] as? String ?? "").intValue {
                print(ongoingProjectId)
                if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                    print(projectId)
                    let dict = ["ongoingProjectId": ongoingProjectId, "projectId":projectId] as! NSDictionary
                    if UIApplication.getTopViewController() is SplashVC {
                        DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                            NotificationCenter.default.post(name: Notification.Name("ProjectUpdatedToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                        }
                    } else {
                        NotificationCenter.default.post(name: Notification.Name("ProjectUpdatedToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                    }
                }
            }
        } else if notificationType == 112 { // LOST_BID
            if let bidId = (userInfo["bidId"] as? String ?? "").intValue {
                print(bidId)
                let dict = ["bidId": bidId] as! NSDictionary
                if UIApplication.getTopViewController() is SplashVC {
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                        NotificationCenter.default.post(name: Notification.Name("LostBidToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                    }
                } else {
                    NotificationCenter.default.post(name: Notification.Name("LostBidToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                }
            }
        } else if notificationType == 113 { // PROJECT_ADMIN_ACCEPTED
            if let ongoingProjectId = (userInfo["ongoingProjectId"] as? String ?? "").intValue {
                print(ongoingProjectId)
                if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                    print(projectId)
                    let dict = ["ongoingProjectId": ongoingProjectId, "projectId":projectId] as! NSDictionary
                    if UIApplication.getTopViewController() is SplashVC {
                        DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                            NotificationCenter.default.post(name: Notification.Name("ProjectAdminAcceptedToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                        }
                    } else {
                        NotificationCenter.default.post(name: Notification.Name("ProjectAdminAcceptedToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                    }
                }
            }
        } else if notificationType == 117 { // SEND_TASK
            if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                print(projectId)
                let dict = ["projectId":projectId] as! NSDictionary
                if UIApplication.getTopViewController() is SplashVC {
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                        NotificationCenter.default.post(name: Notification.Name("SendTaskToSubContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                    }
                } else {
                    NotificationCenter.default.post(name: Notification.Name("SendTaskToSubContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                }
            }
        } else if notificationType == 118 { // EDIT_SUBTASK
            
            if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                print(projectId)
                let dict = ["projectId":projectId] as! NSDictionary
                if UIApplication.getTopViewController() is SplashVC {
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                        NotificationCenter.default.post(name: Notification.Name("EditSubTaskToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                    }
                } else {
                    NotificationCenter.default.post(name: Notification.Name("EditSubTaskToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                }
            }
        } else if notificationType == 119 { // UPLOAD_AGREEMENT_TASK
            if let bidId = (userInfo["bidId"] as? String ?? "").intValue {
                print(bidId)
                if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                    print(projectId)
                    let dict = ["bidId": bidId, "projectId":projectId] as! NSDictionary
                    if UIApplication.getTopViewController() is SplashVC {
                        DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                            NotificationCenter.default.post(name: Notification.Name("UploadAgreementTaskToSubContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                        }
                    } else {
                        NotificationCenter.default.post(name: Notification.Name("UploadAgreementTaskToSubContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                    }
                }
            }
        } else if notificationType == 120 { // LOST_TASK_BID
            
            if let bidId = (userInfo["bidId"] as? String ?? "").intValue {
                print(bidId)
                if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                    print(projectId)
                    let dict = ["bidId": bidId, "projectId":projectId] as! NSDictionary
                    if UIApplication.getTopViewController() is SplashVC {
                        DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                            NotificationCenter.default.post(name: Notification.Name("LostTaskBidToSubContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                        }
                    } else {
                        NotificationCenter.default.post(name: Notification.Name("LostTaskBidToSubContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                    }
                }
            }
        } else if notificationType == 121 { // ACCEPT_TASK_BID
            if let bidId = (userInfo["bidId"] as? String ?? "").intValue {
                print(bidId)
                if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                    print(projectId)
                    let dict = ["bidId": bidId, "projectId":projectId] as! NSDictionary
                    if UIApplication.getTopViewController() is SplashVC {
                        DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                            NotificationCenter.default.post(name: Notification.Name("AcceptTaskBidToSubContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                        }
                    } else {
                        NotificationCenter.default.post(name: Notification.Name("AcceptTaskBidToSubContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                    }
                }
            }
        } else if notificationType == 122 { // REJECT_TASK_BID
            if let bidId = (userInfo["bidId"] as? String ?? "").intValue {
                print(bidId)
                if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                    print(projectId)
                    let dict = ["bidId": bidId, "projectId":projectId] as! NSDictionary
                    if UIApplication.getTopViewController() is SplashVC {
                        DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                            NotificationCenter.default.post(name: Notification.Name("RejectTaskBidToSubContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                        }
                    } else {
                        NotificationCenter.default.post(name: Notification.Name("RejectTaskBidToSubContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                    }
                }
            }
        } else if notificationType == 123 { // TASK_BID
            if let bidId = (userInfo["bidId"] as? String ?? "").intValue {
                print(bidId)
                if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                    print(projectId)
                    if let ongoingProjectId = (userInfo["ongoingProjectId"] as? String ?? "").intValue {
                        print(ongoingProjectId)
                        let dict = ["bidId": bidId, "projectId":projectId, "ongoingProjectId": ongoingProjectId] as! NSDictionary
                        if UIApplication.getTopViewController() is SplashVC {
                            DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                                NotificationCenter.default.post(name: Notification.Name("TaskBidToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                            }
                        } else {
                            NotificationCenter.default.post(name: Notification.Name("TaskBidToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                        }
                    }
                }
            }
        } else if notificationType == 124 { // SUBCONTRACTOR_MARK_COMPLETE
            if let subTaskId = (userInfo["subTaskId"] as? String ?? "").intValue {
                print(subTaskId)
                if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                    print(projectId)
                    if let ongoingProjectId = (userInfo["ongoingProjectId"] as? String ?? "").intValue {
                        print(ongoingProjectId)
                        let dict = ["subTaskId": subTaskId, "projectId":projectId, "ongoingProjectId":ongoingProjectId] as! NSDictionary
                        if UIApplication.getTopViewController() is SplashVC {
                            DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                                NotificationCenter.default.post(name: Notification.Name("SubContractorMarkCompleteToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                            }
                        } else {
                            NotificationCenter.default.post(name: Notification.Name("SubContractorMarkCompleteToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                        }
                    }
                }
            }
        } else if notificationType == 125 { // ACCEPT_TASK_DELIVERY
            if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                print(projectId)
                if let ongoingProjectId = (userInfo["ongoingProjectId"] as? String ?? "").intValue {
                    print(ongoingProjectId)
                    let dict = ["projectId":projectId, "ongoingProjectId":ongoingProjectId] as! NSDictionary
                    if UIApplication.getTopViewController() is SplashVC {
                        DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                            NotificationCenter.default.post(name: Notification.Name("AcceptTaskDeliveryToSubContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                        }
                    } else {
                        NotificationCenter.default.post(name: Notification.Name("AcceptTaskDeliveryToSubContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                    }
                }
            }
        } else if notificationType == 126 { // REJECT_TASK_DELIVERY
            if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                print(projectId)
                if let ongoingProjectId = (userInfo["ongoingProjectId"] as? String ?? "").intValue {
                    print(ongoingProjectId)
                    let dict = ["projectId":projectId, "ongoingProjectId":ongoingProjectId] as! NSDictionary
                    if UIApplication.getTopViewController() is SplashVC {
                        DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                            NotificationCenter.default.post(name: Notification.Name("RejectTaskDeliveryToSubContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                        }
                    } else {
                        NotificationCenter.default.post(name: Notification.Name("RejectTaskDeliveryToSubContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                    }
                }
            }
        } else if notificationType == 98 { // VENDOR_SEND_QUOTE
            if let projectType = (userInfo["bidId"] as? String ?? "").intValue {
                print(projectType)
                if projectType == 1 {
                        if let projectId = (userInfo["subTaskId"] as? String ?? "").intValue {
                            print(projectId)
                            if let ongoingProjectId = (userInfo["ongoingProjectId"] as? String ?? "").intValue {
                                print(ongoingProjectId)
                                let dict = ["projectType": projectType, "projectId":projectId, "ongoingProjectId":ongoingProjectId] as! NSDictionary
                                if UIApplication.getTopViewController() is SplashVC {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                                        NotificationCenter.default.post(name: Notification.Name("VendorSendQuoteToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                                    }
                                } else {
                                    NotificationCenter.default.post(name: Notification.Name("VendorSendQuoteToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                                }
                            }
                        }
                } else {
                    if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                        print(projectId)
                        if let ongoingProjectId = (userInfo["ongoingProjectId"] as? String ?? "").intValue {
                            print(ongoingProjectId)
                            let dict = ["projectType": projectType, "projectId":projectId, "ongoingProjectId":ongoingProjectId] as! NSDictionary
                            if UIApplication.getTopViewController() is SplashVC {
                                DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                                    NotificationCenter.default.post(name: Notification.Name("VendorSendQuoteToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                                }
                            } else {
                                NotificationCenter.default.post(name: Notification.Name("VendorSendQuoteToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                            }
                        }
                    }
                }
            }
        } else if notificationType == 96 { // VENDOR_DISPATCH_ORDER
            if let projectType = (userInfo["bidId"] as? String ?? "").intValue {
                print(projectType)
                if projectType == 1 {
                        if let projectId = (userInfo["subTaskId"] as? String ?? "").intValue {
                            print(projectId)
                            if let ongoingProjectId = (userInfo["ongoingProjectId"] as? String ?? "").intValue {
                                print(ongoingProjectId)
                                let dict = ["projectType": projectType, "projectId":projectId, "ongoingProjectId":ongoingProjectId] as! NSDictionary
                                if UIApplication.getTopViewController() is SplashVC {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                                        NotificationCenter.default.post(name: Notification.Name("VendorDispatchQuoteToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                                    }
                                } else {
                                    NotificationCenter.default.post(name: Notification.Name("VendorDispatchQuoteToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                                }
                            }
                        }
                } else {
                    if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                        print(projectId)
                        if let ongoingProjectId = (userInfo["ongoingProjectId"] as? String ?? "").intValue {
                            print(ongoingProjectId)
                            let dict = ["projectType": projectType, "projectId":projectId, "ongoingProjectId":ongoingProjectId] as! NSDictionary
                            if UIApplication.getTopViewController() is SplashVC {
                                DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                                    NotificationCenter.default.post(name: Notification.Name("VendorDispatchQuoteToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                                }
                            } else {
                                NotificationCenter.default.post(name: Notification.Name("VendorDispatchQuoteToContractor"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                            }
                        }
                    }
                }
            }
        }
    }
    
    func handleHomeOwnerNotifications(notificationType: Int, userInfo : [AnyHashable : Any]) {
        let timeIntrval = 0.0
        if notificationType == 102 { //BID_PLACED
            if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                print(projectId)
                let dict = ["projectId": projectId] as! NSDictionary
                if UIApplication.getTopViewController() is SplashVC {
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                        NotificationCenter.default.post(name: Notification.Name("BidPlacedToHomeOwner"), object: nil, userInfo: dict as? [AnyHashable : Any])
                    }
                } else {
                    NotificationCenter.default.post(name: Notification.Name("BidPlacedToHomeOwner"), object: nil, userInfo: dict as? [AnyHashable : Any])
                }
            }
        } else if notificationType == 108 { //PROGRESS_UPDATE
            if let ongoingProjectId = (userInfo["ongoingProjectId"] as? String ?? "").intValue {
                print(ongoingProjectId)
                let dict = ["ongoingProjectId": ongoingProjectId] as! NSDictionary
                if UIApplication.getTopViewController() is SplashVC {
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                        NotificationCenter.default.post(name: Notification.Name("ProgressUpdateToHomeOwner"), object: nil, userInfo: dict as? [AnyHashable : Any])
                    }
                } else {
                    NotificationCenter.default.post(name: Notification.Name("ProgressUpdateToHomeOwner"), object: nil, userInfo: dict as? [AnyHashable : Any])
                }
            }
        } else if notificationType == 109 { //MARK_COMPLETED
            if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                print(projectId)
                let dict = ["projectId": projectId] as! NSDictionary
                if UIApplication.getTopViewController() is SplashVC {
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                        NotificationCenter.default.post(name: Notification.Name("MarkCompletedToHomeOwner"), object: nil, userInfo: dict as? [AnyHashable : Any])
                    }
                } else {
                    NotificationCenter.default.post(name: Notification.Name("MarkCompletedToHomeOwner"), object: nil, userInfo: dict as? [AnyHashable : Any])
                }
            }
        } else if notificationType == 110 { //RECALL_BID
            if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                print(projectId)
                if let bidId = (userInfo["bidId"] as? String ?? "").intValue {
                    let dict = ["projectId": projectId, "bidId": bidId] as! NSDictionary
                    if UIApplication.getTopViewController() is SplashVC {
                        DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                            NotificationCenter.default.post(name: Notification.Name("RecallBidToHomeOwner"), object: nil, userInfo: dict as? [AnyHashable : Any])
                        }
                    } else {
                        NotificationCenter.default.post(name: Notification.Name("RecallBidToHomeOwner"), object: nil, userInfo: dict as? [AnyHashable : Any])
                    }
                }
            }
        } else if notificationType == 113 { // PROJECT_ADMIN_ACCEPTED
            if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                print(projectId)
                let dict = ["projectId": projectId] as! NSDictionary
                if UIApplication.getTopViewController() is SplashVC {
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                        NotificationCenter.default.post(name: Notification.Name("ProjectAdminAcceptedToHomeOwner"), object: nil, userInfo: dict as? [AnyHashable : Any])
                    }
                } else {
                    NotificationCenter.default.post(name: Notification.Name("ProjectAdminAcceptedToHomeOwner"), object: nil, userInfo: dict as? [AnyHashable : Any])
                }
            }
        } else if notificationType == 116 { // TASK_UPDATED
            if let projectId = (userInfo["projectId"] as? String ?? "").intValue {
                print(projectId)
                let dict = ["projectId": projectId] as! NSDictionary
                if UIApplication.getTopViewController() is SplashVC {
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeIntrval) {
                        NotificationCenter.default.post(name: Notification.Name("TaskUpdatedToHomeOwner"), object: nil, userInfo: dict as? [AnyHashable : Any])
                    }
                } else {
                    NotificationCenter.default.post(name: Notification.Name("TaskUpdatedToHomeOwner"), object: nil, userInfo: dict as? [AnyHashable : Any])
                }
            }
        }
    }
    
    func shouldPresentNotificationBanner(_ response: UNNotification) -> Bool {
        let userInfo = response.userInfo
        if let notificationType = (userInfo["pushType"] as? String ?? "").intValue {
            switch notificationType {
            
            case PushNotificationType.broadcast.rawValue:
                return true
            default:
                return true
            }
        }
        return true
    }
}

extension PushNotificationHandler: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        handleBadgeCount()
//        if self.shouldPresentNotificationBanner(notification) {
//            completionHandler([.list, .banner, .sound, .badge])
//        } else {
//            completionHandler([])
//        }
        isNotificationRead = false

        if let notificationType = (notification.request.content.userInfo["pushType"] as? String ?? "").intValue {
            if notificationType == 101 || notificationType == 117 {
                isInviteNotificationRead = false
                NotificationCenter.default.post(name: Notification.Name.newNotification, object: nil, userInfo: nil)
            }
        }
        
        if #available(iOS 14.0, *) {
            completionHandler([[.sound, .badge, .banner]])
        } else {
            completionHandler([.sound, .badge])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        handleBadgeCount()
        self.notificationUserInfo = response.userInfo
        NotificationCenter.default.post(name: .notificationTapped, object: nil)
        self.handlePushNotification(response)
        completionHandler()
    }
    
}

extension PushNotificationHandler: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        if let fcmValue = UserDefaults.standard.value(forKey: "DeviceToken") as? String {
//            if fcmValue.count <= 10 {
//                print("fcmToken: " + fcmToken!)
//                UserDefaults.standard.removeObject(forKey: "DeviceToken")
//                UserDefaults.standard.setValue(fcmToken!, forKey: "DeviceToken")
//                UserDefaults.standard.synchronize()
//            } else {
//
//            }
//        } else {
            print("fcmToken: " + fcmToken!)
            UserDefaults.standard.removeObject(forKey: "DeviceToken")
            UserDefaults.standard.setValue(fcmToken!, forKey: "DeviceToken")
            UserDefaults.standard.synchronize()
//        }
        
    }
}



extension UIApplication {

    class func getTopViewController(base: UIViewController? = (((UIApplication.shared.connectedScenes.first) as? UIWindowScene)?.delegate as? SceneDelegate)?.window?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

