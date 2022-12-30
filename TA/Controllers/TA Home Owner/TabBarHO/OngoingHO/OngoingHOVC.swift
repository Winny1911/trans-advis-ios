//
//  OngoingHOVC.swift
//  TA
//
//  Created by Dev on 10/12/21.
//

import UIKit

class OngoingHOVC: BaseViewController {

    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var searchVw: UIView!
    @IBOutlet weak var filterVw: UIView!
    @IBOutlet weak var ongoingTableView: UITableView!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var txtFldSearch: UITextField!
    
    let ongoingProjectsHOViewModel: OngoingProjectHOVM = OngoingProjectHOVM()
    var newProjectsListing = [AllProject]()
    
    var isfromNotificationProgressUpdate = false
    var isfromNotificationProgressUpdateOngoingId = 0
    
    var isfromNotificationMarkCompleted = false
    var isfromNotificationMarkCompletedId = 0
    
    var isfromNotificationProjectAccepted = false
    var isfromNotificationProjectAccepteddId = 0
    
    var isfromNotificationTaskUpdated = false
    var isfromNotificationTaskUpdatedId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNoRecord.isHidden = true
        btnCross.isHidden = true
        self.txtFldSearch.delegate = self
        filterVw.setRoundCorners(radius: 12.0)
        searchVw.setRoundCorners(radius: 6.0)
        
        ongoingTableView.delegate = self
        ongoingTableView.dataSource = self
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        fetchOngoingProjectsHO()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.progressUpdateToHomeOwnerOngoingProjectsDetails(notification:)), name: Notification.Name("ProgressUpdateToHomeOwnerOngoingProjectsDetails"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.markCompletedToHomeOwnerOngoingProjectsDetails(notification:)), name: Notification.Name("MarkCompletedToHomeOwnerOngoingProjectsDetails"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.projectAdminAcceptedToHomeOwnerOngoingProjectsDetails(notification:)), name: Notification.Name("ProjectAdminAcceptedToHomeOwnerOngoingProjectsDetails"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.taskUpdatedToHomeOwnerOngoingProjectsDetails(notification:)), name: Notification.Name("TaskUpdatedToHomeOwnerOngoingProjectsDetails"), object: nil)
    }
    
    // MARK: RegisterXib file
    func registerCells() {
        ongoingTableView.register(UINib.init(nibName: "ProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "ProjectTableViewCell")
    }
    
    @objc func taskUpdatedToHomeOwnerOngoingProjectsDetails(notification: Notification) {
        let notiDict = notification.userInfo! as NSDictionary
        isfromNotificationTaskUpdated = true
        self.isfromNotificationTaskUpdatedId = notiDict["projectId"] as! Int
        isfromNotificationProjectAccepted = false
        self.isfromNotificationProjectAccepteddId = 0
        isfromNotificationProgressUpdate = false
        self.isfromNotificationProgressUpdateOngoingId = 0
        isfromNotificationMarkCompleted = false
        self.isfromNotificationMarkCompletedId = 0
        self.fetchOngoingProjectsHO()
    }
    
    @objc func projectAdminAcceptedToHomeOwnerOngoingProjectsDetails(notification: Notification) {
        let notiDict = notification.userInfo! as NSDictionary
        isfromNotificationProjectAccepted = true
        self.isfromNotificationProjectAccepteddId = notiDict["projectId"] as! Int
        isfromNotificationProgressUpdate = false
        self.isfromNotificationProgressUpdateOngoingId = 0
        isfromNotificationMarkCompleted = false
        self.isfromNotificationMarkCompletedId = 0
        isfromNotificationTaskUpdated = false
        self.isfromNotificationTaskUpdatedId = 0
        self.fetchOngoingProjectsHO()
    }
    
    @objc func markCompletedToHomeOwnerOngoingProjectsDetails(notification: Notification) {
        let notiDict = notification.userInfo! as NSDictionary
        isfromNotificationMarkCompleted = true
        self.isfromNotificationMarkCompletedId = notiDict["projectId"] as! Int
        isfromNotificationProgressUpdate = false
        self.isfromNotificationProgressUpdateOngoingId = 0
        isfromNotificationProjectAccepted = false
        self.isfromNotificationProjectAccepteddId = 0
        isfromNotificationTaskUpdated = false
        self.isfromNotificationTaskUpdatedId = 0
        self.fetchOngoingProjectsHO()
    }
    
    @objc func progressUpdateToHomeOwnerOngoingProjectsDetails(notification: Notification) {
        let notiDict = notification.userInfo! as NSDictionary
        isfromNotificationMarkCompleted = false
        self.isfromNotificationMarkCompletedId = 0
        isfromNotificationProjectAccepted = false
        self.isfromNotificationProjectAccepteddId = 0
        isfromNotificationProgressUpdate = true
        self.isfromNotificationProgressUpdateOngoingId = notiDict["ongoingProjectId"] as! Int
        isfromNotificationTaskUpdated = false
        self.isfromNotificationTaskUpdatedId = 0
        self.fetchOngoingProjectsHO()
    }
    
    //MARK: Fetch FilterI nvitations
    func fetchOngoingProjectsHO() {
        var arrayOfFilterWorks = [Int]()
        var arrayOfFilterLocation = [String]()
        var filterDict = [String:Any]()
        var filterArray = [[String:Any]]()
        
        if let workArr = UserDefaults.standard.value(forKey: "FilterWorkOngoingProjectHO") as? [Int] {
            if workArr.count > 0 {
                arrayOfFilterWorks = workArr
            }
        }
        
        if let locationArr = UserDefaults.standard.value(forKey: "FilterLocationOngoingProjectHO") as? [String] {
            if locationArr.count > 0 {
                arrayOfFilterLocation = locationArr
            }
        }
        
        if arrayOfFilterWorks.count > 0 && arrayOfFilterLocation.count > 0 {
            filterDict = ["work":arrayOfFilterWorks, "location":arrayOfFilterLocation] as [String : Any]
        } else if arrayOfFilterWorks.count > 0 && arrayOfFilterLocation.count == 0 {
            filterDict = ["work":arrayOfFilterWorks] as [String : Any]
        } else if arrayOfFilterWorks.count == 0 && arrayOfFilterLocation.count > 0 {
            filterDict = ["location":arrayOfFilterLocation] as [String : Any]
        } else {
            filterDict = [String:Any]()
        }
        filterArray.removeAll()
        filterArray.append(filterDict)

        ongoingProjectsHOViewModel.getOngoingProjectApi(["filter":filterDict, "search": self.txtFldSearch.text!]) { model in
            self.newProjectsListing = model?.data?.allProjects ?? []
            if self.newProjectsListing.count <= 0 {
                self.lblNoRecord.isHidden = false
            } else {
                self.lblNoRecord.isHidden = true
            }
            self.ongoingTableView.isHidden = false
            if self.newProjectsListing.count <= 0 {
                self.ongoingTableView.isHidden = true
            } else {
                self.ongoingTableView.reloadData()
            }
            
            if self.isfromNotificationProgressUpdate == true {
                self.isfromNotificationProgressUpdate = false
                for i in 0 ..< self.newProjectsListing.count {
                    if self.newProjectsListing[i].id == self.isfromNotificationProgressUpdateOngoingId {
                        let destinationViewController = Storyboard.ongoingDetailHO.instantiateViewController(withIdentifier: "OngoingDetailHOVC") as? OngoingDetailHOVC
                        destinationViewController!.newProjectsListing = self.newProjectsListing[i]
                        destinationViewController!.id = self.newProjectsListing[i].id ?? 0
                        destinationViewController!.ongoingtitle = self.newProjectsListing[i].title ?? ""
                        self.isfromNotificationProgressUpdateOngoingId = 0
                        self.navigationController?.pushViewController(destinationViewController!, animated: true)
                        break
                    }
                }
            }
            
            if self.isfromNotificationMarkCompleted == true {
                self.isfromNotificationMarkCompleted = false
                for i in 0 ..< self.newProjectsListing.count {
                    if self.newProjectsListing[i].id == self.isfromNotificationMarkCompletedId {
                        let destinationViewController = Storyboard.ongoingDetailHO.instantiateViewController(withIdentifier: "OngoingDetailHOVC") as? OngoingDetailHOVC
                        destinationViewController!.newProjectsListing = self.newProjectsListing[i]
                        destinationViewController!.id = self.newProjectsListing[i].id ?? 0
                        destinationViewController!.ongoingtitle = self.newProjectsListing[i].title ?? ""
                        self.isfromNotificationMarkCompletedId = 0
                        self.navigationController?.pushViewController(destinationViewController!, animated: true)
                        break
                    }
                }
            }
            
            if self.isfromNotificationProjectAccepted == true {
                self.isfromNotificationProjectAccepted = false
                for i in 0 ..< self.newProjectsListing.count {
                    if self.newProjectsListing[i].id == self.isfromNotificationProjectAccepteddId {
                        let destinationViewController = Storyboard.ongoingDetailHO.instantiateViewController(withIdentifier: "OngoingDetailHOVC") as? OngoingDetailHOVC
                        destinationViewController!.newProjectsListing = self.newProjectsListing[i]
                        destinationViewController!.id = self.newProjectsListing[i].id ?? 0
                        destinationViewController!.ongoingtitle = self.newProjectsListing[i].title ?? ""
                        self.isfromNotificationProjectAccepteddId = 0
                        self.navigationController?.pushViewController(destinationViewController!, animated: true)
                        break
                    }
                }
            }
            
            if self.isfromNotificationTaskUpdated == true {
                self.isfromNotificationTaskUpdated = false
                for i in 0 ..< self.newProjectsListing.count {
                    if self.newProjectsListing[i].id == self.isfromNotificationTaskUpdatedId {
                        let destinationViewController = Storyboard.ongoingDetailHO.instantiateViewController(withIdentifier: "OngoingDetailHOVC") as? OngoingDetailHOVC
                        destinationViewController!.newProjectsListing = self.newProjectsListing[i]
                        destinationViewController!.id = self.newProjectsListing[i].id ?? 0
                        destinationViewController!.ongoingtitle = self.newProjectsListing[i].title ?? ""
                        self.isfromNotificationTaskUpdatedId = 0
                        self.navigationController?.pushViewController(destinationViewController!, animated: true)
                        break
                    }
                }
            }
        }
    }
    
    //MARK: ACTION FILTER
    @IBAction func actionFilter(_ sender: Any) {
        let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "InvitationFilterVC") as? InvitationFilterVC
        destinationViewController!.isFrom = "OngoingProjectHO"
        destinationViewController!.completionHandlerGoToOnGoingProjectsHO = { [weak self] in
            self?.fetchOngoingProjectsHO()
        }
        destinationViewController!.completionHandlerGoToOnGoingProjectsHOClearFilter = { [weak self] in
            self?.fetchOngoingProjectsHO()
        }
        
        self.present(destinationViewController!, animated: true)
    }
    
    @IBAction func actionCross(_ sender: Any) {
        self.txtFldSearch.text = ""
        self.btnCross.isHidden = true
        self.txtFldSearch.resignFirstResponder()
        self.fetchOngoingProjectsHO()
    }
    
}
extension OngoingHOVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newProjectsListing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell", for: indexPath) as? ProjectTableViewCell
        {
            cell.blurVwww.isHidden = true
            cell.markCompletedButton.setTitle("Approve Delivery", for: .normal)
            cell.mainProjectLbl.isHidden = true
            cell.vwMainProject.isHidden = true
            
            if newProjectsListing[indexPath.row].contractorProject?.count ?? 0 > 0 {
                cell.ongoingHONameLbl.text = "\(newProjectsListing[indexPath.row].contractorProject?[0].contractorDetails?.firstName ?? "") \(newProjectsListing[indexPath.row].contractorProject?[0].contractorDetails?.lastName ?? "")"
                cell.ongoingHOImageView.sd_setImage(with: URL(string: (newProjectsListing[indexPath.row].contractorProject?[0].contractorDetails?.profilePic ?? "")), placeholderImage: UIImage(named: "Ic_profile"), completed: nil)
            }
            
            cell.ongoingHODescriptionLbl.text = newProjectsListing[indexPath.row].allProjectDescription
            cell.ongoingHOTittleLbl.text = newProjectsListing[indexPath.row].title
            
            cell.sentButton.isHidden = false
            cell.sentButton.setTitle("Send Message", for: .normal)
            cell.sentButton.isUserInteractionEnabled = true
            cell.markButtonView.isHidden = false
            let progressData = newProjectsListing[indexPath.row].progress ?? Double(0.0)
            let data = Float(progressData)
            let currentProgress: Float = (data/100)
            cell.progressVw.setProgressWithAnimation(duration: 1.0, value: currentProgress)
            
            cell.lblPercentage.text = "\(Int(Double(newProjectsListing[indexPath.row].progress ?? Double(0.0)) ))%"
            
//            if newProjectsListing[indexPath.row].status == 10 {
//                cell.blurVwww.isHidden = true
//                cell.sentButton.isHidden = false
//                cell.sentButton.isUserInteractionEnabled = false
//                cell.markButtonView.isHidden = true
//            } else if let progress = newProjectsListing[indexPath.row].progress {
//                let  floatProgress = (Double(progress) / Double(100.0))
//                if newProjectsListing[indexPath.row].status == 9 && floatProgress >= 1 {
//                    cell.blurVwww.isHidden = true
//                } else {
//                    cell.blurVwww.isHidden = false
//                }
//            } else {
//                cell.blurVwww.isHidden = false
//            }
            
            cell.blurVwww.isHidden = true
            cell.sentButton.isHidden = false
            cell.sentButton.isUserInteractionEnabled = true
            cell.markButtonView.isHidden = false
            
            if let progress = newProjectsListing[indexPath.row].progress {
                let  floatProgress = (Double(progress) / Double(100.0))
                if newProjectsListing[indexPath.row].status == 9 && floatProgress >= 1 {
                    cell.blurVwww.isHidden = true
                } else {
                    cell.blurVwww.isHidden = false
                }
            } else {
                if newProjectsListing[indexPath.row].status == 9 {
                    cell.blurVwww.isHidden = true
                } else {
                    cell.blurVwww.isHidden = false
                }
            }
            
            if newProjectsListing[indexPath.row].status == 10 {
                cell.blurVwww.isHidden = true
                cell.sentButton.isHidden = false
                cell.sentButton.isUserInteractionEnabled = true
                cell.markButtonView.isHidden = true
            }
            
            // MARK: clourse call
            cell.viewTransactionTapAction = {
                () in
                guard let destinationViewController = Controllers.TransactionHistory else{
                    print("Error: Controller not found!!!")
                    return
                }
                destinationViewController.isFrom = "HO"
                destinationViewController.projectId = self.newProjectsListing[indexPath.row].id ?? 0
                self.navigationController?.pushViewController(destinationViewController, animated: true)
            }
            
            cell.approveDeliveryTapAction = {
                () in
                let destinationViewController = Storyboard.ongoingDetailHO.instantiateViewController(withIdentifier: "ConfirmVC") as? ConfirmVC
                destinationViewController!.completionHandlerGoToOngoingProjectList = { [weak self] in
                    self!.fetchOngoingProjectsHO()
                }
                destinationViewController?.isFrom = "OngoingDetail"
                destinationViewController!.projectId = self.newProjectsListing[indexPath.row].id ?? 0
                destinationViewController?.callBackToFeedBackScreen = {
                    () in
                    let vc = Storyboard.feedBackHO.instantiateViewController(withIdentifier: "FeedBackHOVC") as? FeedBackHOVC
                    vc!.projectID = self.newProjectsListing[indexPath.row].id ?? 0
                    vc!.contractorID  = self.newProjectsListing[indexPath.row].contractorProject?[0].userID ?? 0
                    vc!.firstName = self.newProjectsListing[indexPath.row].contractorProject?[0].contractorDetails?.firstName ?? ""
                    vc!.lastNmae = self.newProjectsListing[indexPath.row].contractorProject?[0].contractorDetails?.lastName ?? ""
                    vc!.completionHandlerGoToOnPastListing = { [weak self] in
                        self?.navigationController?.popViewController(animated: true)
//                        self?.completionHandlerGoToOnPastListing?()
                    }
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
                
                destinationViewController?.callBackToReject = {
                    let destinationViewController = Storyboard.newHO.instantiateViewController(withIdentifier: "RejectBidVC") as? RejectBidVC
                    destinationViewController?.isFrom = "OngoingHo"
                    destinationViewController?.projectId = self.newProjectsListing[indexPath.row].id ?? 0
                    destinationViewController?.completionHandlerGoToViewBids = {
                        self.fetchOngoingProjectsHO()
                    }
                    self.present(destinationViewController!, animated: true, completion: nil)
                }
                self.present(destinationViewController!, animated: true, completion: nil)
            }
            cell.sendMessageTapAction = {
                self.initiateChatButtonAction(for: indexPath)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func initiateChatButtonAction(for indexPath: IndexPath) {
        print("ContractorHOVC: initiateChatButtonAction")
        if let chatController = Storyboard.messageHO.instantiateViewController(withIdentifier: "ChatWindowViewController") as? ChatWindowViewController {
            let dictionary = self.newProjectsListing[indexPath.row]
            let user_id = String("ID_\(dictionary.contractorProject?[0].contractorDetails?.id ?? 0)")
            let user_name = (dictionary.contractorProject?[0].contractorDetails?.firstName ?? "") + " " + (dictionary.contractorProject?[0].contractorDetails?.lastName ?? "")
            let user_image = dictionary.contractorProject?[0].contractorDetails?.profilePic ?? ""
            
            chatController.hidesBottomBarWhenPushed = true
            chatController.viewModel.user_id = user_id
            chatController.viewModel.user_name = user_name
            chatController.viewModel.user_image = user_image
            self.navigationController?.pushViewController(chatController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationViewController = Storyboard.ongoingDetailHO.instantiateViewController(withIdentifier: "OngoingDetailHOVC") as? OngoingDetailHOVC
        destinationViewController!.newProjectsListing = self.newProjectsListing[indexPath.row]
        destinationViewController!.id = self.newProjectsListing[indexPath.row].id ?? 0
        destinationViewController!.ongoingtitle = self.newProjectsListing[indexPath.row].title ?? ""
        destinationViewController!.completionHandlerGoToOnPastListing = { [weak self] in
//            let vc = Storyboard.pastHO.instantiateViewController(withIdentifier: "PastHOVC") as? PastHOVC
//            self?.navigationController?.pushViewController(vc!, animated: true)
            
        }
        destinationViewController?.callBackToOngoingList = {
            self.fetchOngoingProjectsHO()
        }
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension OngoingHOVC:UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.btnCross.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.btnCross.isHidden = true
        if textField == txtFldSearch {
            self.fetchOngoingProjectsHO()
        }
    }
}
