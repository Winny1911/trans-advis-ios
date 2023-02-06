//
//  NotificationVC.swift
//  TA
//
//  Created by applify on 25/02/22.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var noRecordLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var notificationVM : NotificationVM = NotificationVM()
    var notificationListing = [NotificationListing]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getNotificationData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.registerCells()
      //  noRecordLbl.isHidden = true
        self.readNotificationApi()
    }
    
    // MARK: RegisterXib file
    func registerCells() {
        tableView.register(UINib.init(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getNotificationData() {
        notificationVM.getNotificationApi([:]) { response in
            self.notificationListing = response?.data?.listing ?? []
            if self.notificationListing.count <= 0{
                self.tableView.isHidden = true
                self.noRecordLbl.isHidden = false
            }else{
                self.tableView.reloadData()
                self.noRecordLbl.isHidden = true
            }
        }
    }
    
    func readNotificationApi() {
        notificationVM.readNotificationApi() { response in
            isNotificationRead = true
            isInviteNotificationRead = true
        }
    }
    
    func handleStackControllers() {
//        UIApplication.getTopViewController()?.dismiss(animated: false, completion: nil)
//        UIApplication.getTopViewController()?.navigationController?.popToRootViewController(animated: false)
    }
    
}

extension NotificationVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationListing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath)as! NotificationTableViewCell

        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate =  dateFormatter.string(from: date)
        
        let previousDate = Date.yesterday
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let previousDayDate =  dateFormatter.string(from: previousDate)
        
        let notificationDate = self.notificationListing[indexPath.row].createdAt
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let newDate =  dateFormatter.date(from: notificationDate ?? "")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let updatedDate = dateFormatter.string(from: newDate!)
        
        if currentDate == updatedDate {
            cell.dayLbl.text = "Today"
            cell.timeLbl.text = DateHelper.convertDateString(dateString: self.notificationListing[indexPath.row].createdAt, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "hh:mm a")
        } else if previousDayDate == updatedDate {
            cell.dayLbl.text = "Yesterday"
            cell.timeLbl.text = DateHelper.convertDateString(dateString: self.notificationListing[indexPath.row].createdAt, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "hh:mm a")
        } else {
           cell.dayLbl.text = "Older"
            cell.timeLbl.text = DateHelper.convertDateString(dateString: self.notificationListing[indexPath.row].createdAt, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM, hh:mm a")
        }
        cell.titleLbl.text = notificationListing[indexPath.row].title ?? ""
        cell.messageLbl.text = notificationListing[indexPath.row].message ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if notificationListing[indexPath.row].notificationType ?? 0 == 52 {
            if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
                if obj.userType == UserType.contractor {
                    let destinationViewController = Storyboard.orderMaterial.instantiateViewController(withIdentifier: "OrderListDetailVC") as? OrderListDetailVC
                    destinationViewController?.projectId = notificationListing[indexPath.row].projectID ?? 0
                    destinationViewController?.cardId = notificationListing[indexPath.row].objectID ?? 0
                    destinationViewController?.isNotification = true
                    self.navigationController?.pushViewController(destinationViewController!, animated: true)
                } else {
                    print("HO")
                    let destinationViewController = Storyboard.ongoingDetailHO.instantiateViewController(withIdentifier: "OngoingDetailHOVC") as? OngoingDetailHOVC
                    destinationViewController?.id = notificationListing[indexPath.row].projectID ?? 0
                    self.navigationController?.pushViewController(destinationViewController!, animated: true)
                }
            }
            
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 53 {
            if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
                if obj.userType == UserType.contractor {
                    let destinationViewController = Storyboard.orderMaterial.instantiateViewController(withIdentifier: "OrderListDetailVC") as? OrderListDetailVC
                    destinationViewController?.projectId = notificationListing[indexPath.row].projectID ?? 0
                    destinationViewController?.cardId = notificationListing[indexPath.row].objectID ?? 0
                    destinationViewController?.isNotification = true
                    self.navigationController?.pushViewController(destinationViewController!, animated: true)
                } else {
                    print("HO")
                    let destinationViewController = Storyboard.ongoingDetailHO.instantiateViewController(withIdentifier: "OngoingDetailHOVC") as? OngoingDetailHOVC
                    destinationViewController?.id = notificationListing[indexPath.row].projectID ?? 0
                    self.navigationController?.pushViewController(destinationViewController!, animated: true)
                }
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 55 {
            let destinationViewController = Storyboard.orderMaterial.instantiateViewController(withIdentifier: "OrderListDetailVC") as? OrderListDetailVC
            destinationViewController?.projectId = notificationListing[indexPath.row].projectID ?? 0
            destinationViewController?.cardId = notificationListing[indexPath.row].objectID ?? 0
            destinationViewController?.isNotification = true
            self.navigationController?.pushViewController(destinationViewController!, animated: true)
            
//            let destinationViewController = Storyboard.project.instantiateViewController(withIdentifier: "OngoingProjectDetailVC") as? OngoingProjectDetailVC
//            destinationViewController?.selectedType = "Orderlist"
//            destinationViewController?.projectIdComplete = notificationListing[indexPath.row].projectID ?? 0
//            self.navigationController?.pushViewController(destinationViewController!, animated: true)
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 56 {
            if let projectType = notificationListing[indexPath.row].bidID {
                print(projectType)
                if projectType == 1 {
                    if let projectId = notificationListing[indexPath.row].subTaskID{
                        print(projectId)
                        if let ongoingProjectId = notificationListing[indexPath.row].ongoingProjectID {
                            print(ongoingProjectId)
                            let dict = ["projectType": projectType, "projectId":projectId, "ongoingProjectId":ongoingProjectId] as! NSDictionary
                            self.handleStackControllers()
                            self.tabBarController?.selectedIndex = 0
                            NotificationCenter.default.post(name: Notification.Name("paymentNotification"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                        }
                    }
                } else {
                    if let projectId = notificationListing[indexPath.row].projectID{
                        print(projectId)
                        if let ongoingProjectId = notificationListing[indexPath.row].ongoingProjectID {
                            print(ongoingProjectId)
                            let dict = ["projectType": projectType, "projectId":projectId, "ongoingProjectId":ongoingProjectId] as! NSDictionary
                            self.handleStackControllers()
                            self.tabBarController?.selectedIndex = 0
                            NotificationCenter.default.post(name: Notification.Name("paymentNotification"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                        }
                    }
                }
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 101 {
            self.handleStackControllers()
            self.tabBarController?.selectedIndex = 2
            let dict = ["projectId": notificationListing[indexPath.row].projectID ?? 0] as! NSDictionary
            NotificationCenter.default.post(name: Notification.Name("ReceivedInvitationToContractorInvitation"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 102 {
            let destinationViewController = Storyboard.newHO.instantiateViewController(withIdentifier: "NewDetailsHOVC") as? NewDetailsHOVC
            destinationViewController?.projectId = notificationListing[indexPath.row].projectID ?? 0
            self.navigationController?.pushViewController(destinationViewController!, animated: true)
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 103 {
            let dict = ["bidId":  notificationListing[indexPath.row].bidID ?? 0] as! NSDictionary
            self.handleStackControllers()
            self.tabBarController?.selectedIndex = 2
            NotificationCenter.default.post(name: Notification.Name("BidRejectToContractorInvitation"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 104 {
            let dict = ["bidId":  notificationListing[indexPath.row].bidID ?? 0] as! NSDictionary
            self.handleStackControllers()
            self.tabBarController?.selectedIndex = 2
            NotificationCenter.default.post(name: Notification.Name("BidAcceptToContractorInvitation"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 105 {
            if let ongoingProjectId = notificationListing[indexPath.row].ongoingProjectID {
                print(ongoingProjectId)
                if let projectId = notificationListing[indexPath.row].projectID {
                    print(projectId)
                    let dict = ["ongoingProjectId": ongoingProjectId, "projectId":projectId] as! NSDictionary
                    self.handleStackControllers()
                    self.tabBarController?.selectedIndex = 0
                    NotificationCenter.default.post(name: Notification.Name("ProjectAcceptToContractorProjects"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                }
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 106 {
            if let ongoingProjectId = notificationListing[indexPath.row].ongoingProjectID {
                print(ongoingProjectId)
                if let projectId = notificationListing[indexPath.row].projectID {
                    print(projectId)
                    let dict = ["ongoingProjectId": ongoingProjectId, "projectId":projectId] as! NSDictionary
                    self.handleStackControllers()
                    self.tabBarController?.selectedIndex = 0
                    NotificationCenter.default.post(name: Notification.Name("ProjectRejectToContractorProjects"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                }
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 108 {
            if let ongoingProjectId = notificationListing[indexPath.row].ongoingProjectID {
                print(ongoingProjectId)
                let dict = ["ongoingProjectId": ongoingProjectId] as! NSDictionary
                self.handleStackControllers()
                self.tabBarController?.selectedIndex = 0
                NotificationCenter.default.post(name: Notification.Name("ProgressUpdateToHomeOwnerOngoingProjects"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 109 {
            if let projectId = notificationListing[indexPath.row].projectID {
                print(projectId)
                let dict = ["projectId": projectId] as! NSDictionary
                self.handleStackControllers()
                self.tabBarController?.selectedIndex = 0
                NotificationCenter.default.post(name: Notification.Name("MarkCompletedToHomeOwnerOngoingProjects"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 110 {
            if let projectId = notificationListing[indexPath.row].projectID {
                print(projectId)
                if let bidId = notificationListing[indexPath.row].bidID{
                    let dict = ["projectId": projectId, "bidId": bidId] as! NSDictionary
                    self.handleStackControllers()
                    self.tabBarController?.selectedIndex = 0
                    NotificationCenter.default.post(name: Notification.Name("RecallBidToHomeOwnerNewProjects"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                }
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 111 {
            if let ongoingProjectId = notificationListing[indexPath.row].ongoingProjectID {
                print(ongoingProjectId)
                if let projectId = notificationListing[indexPath.row].projectID {
                    print(projectId)
                    let dict = ["ongoingProjectId": ongoingProjectId, "projectId":projectId] as! NSDictionary
                    self.handleStackControllers()
                    self.tabBarController?.selectedIndex = 0
                    NotificationCenter.default.post(name: Notification.Name("ProjectUpdatedToContractorOngoingProjects"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                }
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 112 {
            if let bidId = notificationListing[indexPath.row].bidID {
                print(bidId)
                let dict = ["bidId": bidId] as! NSDictionary
                self.handleStackControllers()
                self.tabBarController?.selectedIndex = 2
                NotificationCenter.default.post(name: Notification.Name("LostBidToContractorInvitation"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 113 {
            if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
                if obj.userType == UserType.contractor {
                    if let ongoingProjectId = notificationListing[indexPath.row].ongoingProjectID {
                        print(ongoingProjectId)
                        if let projectId = notificationListing[indexPath.row].projectID {
                            print(projectId)
                            let dict = ["ongoingProjectId": ongoingProjectId, "projectId":projectId] as! NSDictionary
                            self.handleStackControllers()
                            self.tabBarController?.selectedIndex = 0
                            NotificationCenter.default.post(name: Notification.Name("ProjectAdminAcceptedToContractorOngoingProjects"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                        }
                    }
                } else {
                    if let projectId = notificationListing[indexPath.row].projectID {
                        print(projectId)
                        let dict = ["projectId": projectId] as! NSDictionary
                        self.handleStackControllers()
                        self.tabBarController?.selectedIndex = 0
                        NotificationCenter.default.post(name: Notification.Name("ProjectAdminAcceptedToHomeOwnerOngoingProjects"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                    }
                }
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 116 {
            if let projectId = notificationListing[indexPath.row].projectID {
                print(projectId)
                let dict = ["projectId": projectId] as! NSDictionary
                self.handleStackControllers()
                self.tabBarController?.selectedIndex = 0
                NotificationCenter.default.post(name: Notification.Name("TaskUpdatedToHomeOwnerOngoingProjects"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 117 {
            if let projectId = notificationListing[indexPath.row].projectID {
                print(projectId)
                let dict = ["projectId": projectId] as! NSDictionary
                self.handleStackControllers()
                self.tabBarController?.selectedIndex = 2
                NotificationCenter.default.post(name: Notification.Name("SendTaskToSubContractorInvitation"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 118 {
            if let projectId = notificationListing[indexPath.row].projectID {
                print(projectId)
                let dict = ["projectId": projectId] as! NSDictionary
                self.handleStackControllers()
                self.tabBarController?.selectedIndex = 2
                NotificationCenter.default.post(name: Notification.Name("EditSubTaskToContractorInvitation"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 119 {
            if let projectId = notificationListing[indexPath.row].projectID {
                print(projectId)
                if let bidId = notificationListing[indexPath.row].bidID{
                    let dict = ["projectId": projectId, "bidId": bidId] as! NSDictionary
                    self.handleStackControllers()
                    self.tabBarController?.selectedIndex = 2
                    NotificationCenter.default.post(name: Notification.Name("UploadAgreementTaskToSubContractorInvitation"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                }
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 120 {
            if let projectId = notificationListing[indexPath.row].projectID {
                print(projectId)
                if let bidId = notificationListing[indexPath.row].bidID{
                    let dict = ["projectId": projectId, "bidId": bidId] as! NSDictionary
                    self.handleStackControllers()
                    self.tabBarController?.selectedIndex = 2
                    NotificationCenter.default.post(name: Notification.Name("LostTaskBidToSubContractorInvitation"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                }
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 121 {
            if let projectId = notificationListing[indexPath.row].projectID {
                print(projectId)
                if let bidId = notificationListing[indexPath.row].bidID{
                    let dict = ["projectId": projectId, "bidId": bidId] as! NSDictionary
                    self.handleStackControllers()
                    self.tabBarController?.selectedIndex = 2
                    NotificationCenter.default.post(name: Notification.Name("AcceptTaskBidToSubContractorInvitation"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                }
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 122 {
            if let projectId = notificationListing[indexPath.row].projectID {
                print(projectId)
                if let bidId = notificationListing[indexPath.row].bidID{
                    let dict = ["projectId": projectId, "bidId": bidId] as! NSDictionary
                    self.handleStackControllers()
                    self.tabBarController?.selectedIndex = 2
                    NotificationCenter.default.post(name: Notification.Name("RejectTaskBidToSubContractorInvitation"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                }
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 123 {
            if let projectId = notificationListing[indexPath.row].projectID {
                print(projectId)
                if let bidId = notificationListing[indexPath.row].bidID{
                    print(bidId)
                    if let ongoingProjectId = notificationListing[indexPath.row].ongoingProjectID {
                        let dict = ["projectId": projectId, "bidId": bidId, "ongoingProjectId": ongoingProjectId] as! NSDictionary
                        self.handleStackControllers()
                        self.tabBarController?.selectedIndex = 0
                        NotificationCenter.default.post(name: Notification.Name("TaskBidToContractorOngoingProjects"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                    }
                }
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 124 {
            if let projectId = notificationListing[indexPath.row].projectID {
                print(projectId)
                if let subTaskId = notificationListing[indexPath.row].subTaskID{
                    print(subTaskId)
                    if let ongoingProjectId = notificationListing[indexPath.row].ongoingProjectID {
                        let dict = ["projectId": projectId, "subTaskId": subTaskId, "ongoingProjectId": ongoingProjectId] as! NSDictionary
                        self.handleStackControllers()
                        self.tabBarController?.selectedIndex = 0
                        NotificationCenter.default.post(name: Notification.Name("SubContractorMarkCompleteToContractorOngoingProjects"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                    }
                }
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 125 {
            if let projectId = notificationListing[indexPath.row].projectID {
                print(projectId)
                if let ongoingProjectId = notificationListing[indexPath.row].ongoingProjectID {
                    let dict = ["projectId": projectId, "ongoingProjectId": ongoingProjectId] as! NSDictionary
                    self.handleStackControllers()
                    self.tabBarController?.selectedIndex = 0
                    NotificationCenter.default.post(name: Notification.Name("AcceptTaskDeliveryToSubContractorPastProject"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                }
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 126 {
            if let projectId = notificationListing[indexPath.row].projectID {
                print(projectId)
                if let ongoingProjectId = notificationListing[indexPath.row].ongoingProjectID {
                    let dict = ["projectId": projectId, "ongoingProjectId": ongoingProjectId] as! NSDictionary
                    self.handleStackControllers()
                    self.tabBarController?.selectedIndex = 0
                    NotificationCenter.default.post(name: Notification.Name("RejectTaskDeliveryToSubContractorPastProject"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                }
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 98 {
            if let projectType = notificationListing[indexPath.row].bidID {
                print(projectType)
                if projectType == 1 {
                    if let projectId = notificationListing[indexPath.row].subTaskID{
                        print(projectId)
                        if let ongoingProjectId = notificationListing[indexPath.row].ongoingProjectID {
                            print(ongoingProjectId)
                            let dict = ["projectType": projectType, "projectId":projectId, "ongoingProjectId":ongoingProjectId] as! NSDictionary
                            self.handleStackControllers()
                            self.tabBarController?.selectedIndex = 0
                            NotificationCenter.default.post(name: Notification.Name("VendorSendQuoteToContractorDetails"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                        }
                    }
                } else {
                    if let projectId = notificationListing[indexPath.row].projectID{
                        print(projectId)
                        if let ongoingProjectId = notificationListing[indexPath.row].ongoingProjectID {
                            print(ongoingProjectId)
                            let dict = ["projectType": projectType, "projectId":projectId, "ongoingProjectId":ongoingProjectId] as! NSDictionary
                            self.handleStackControllers()
                            self.tabBarController?.selectedIndex = 0
                            NotificationCenter.default.post(name: Notification.Name("VendorSendQuoteToContractorDetails"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                        }
                    }
                }
            }
        } else if notificationListing[indexPath.row].notificationType ?? 0 == 96 {
            if let projectType = notificationListing[indexPath.row].bidID {
                print(projectType)
                if projectType == 1 {
                    if let projectId = notificationListing[indexPath.row].subTaskID{
                        print(projectId)
                        if let ongoingProjectId = notificationListing[indexPath.row].ongoingProjectID {
                            print(ongoingProjectId)
                            let dict = ["projectType": projectType, "projectId":projectId, "ongoingProjectId":ongoingProjectId] as! NSDictionary
                            self.handleStackControllers()
                            self.tabBarController?.selectedIndex = 0
                            NotificationCenter.default.post(name: Notification.Name("VendorDispatchQuoteToContractorDetails"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                        }
                    }
                } else {
                    if let projectId = notificationListing[indexPath.row].projectID{
                        print(projectId)
                        if let ongoingProjectId = notificationListing[indexPath.row].ongoingProjectID {
                            print(ongoingProjectId)
                            let dict = ["projectType": projectType, "projectId":projectId, "ongoingProjectId":ongoingProjectId] as! NSDictionary
                            self.handleStackControllers()
                            self.tabBarController?.selectedIndex = 0
                            NotificationCenter.default.post(name: Notification.Name("VendorDispatchQuoteToContractorDetails"), object: nil, userInfo: (dict as! [AnyHashable : Any]))
                        }
                    }
                }
            }
        }
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
