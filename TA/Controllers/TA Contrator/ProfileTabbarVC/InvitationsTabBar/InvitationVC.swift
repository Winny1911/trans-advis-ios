//
//  InvitationVC.swift
//  TA
//
//  Created by Designer on 16/12/21.
//

import UIKit

class InvitationVC: BaseViewController {
    
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var searchFieldTrailingSpace: NSLayoutConstraint!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var tblVwInvitations: UITableView!
    @IBOutlet weak var bottomViewManageBids: UIView!
    @IBOutlet weak var btnManageBids: UIButton!
    @IBOutlet weak var bottomVwInvitation: UIView!
    @IBOutlet weak var btnInvitation: UIButton!
    
    
    var arrInvitation = [InvitationsDetails]()
    var arrManageBids = [ManageBidsResponseDetails]()
    
    var isManageBids = false
    var invitationViewModel:InvitationViewModel = InvitationViewModel()
    
    var isFromInvitationNotification = false
    var isFromInvitationNotificationProjectID = 0
    
    var isFromManageBidNotification = false
    var isFromManageBidNotificationBidID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCross.isHidden = true
        self.txtFldSearch.delegate = self
        viewFilter.setRoundCorners(radius: 12.0)
        viewSearch.setRoundCorners(radius: 6.0)
        self.registerCell()
        self.tblVwInvitations.separatorColor = UIColor.clear
        self.tblVwInvitations.rowHeight = UITableView.automaticDimension
        self.tblVwInvitations.estimatedRowHeight = 100.0
        self.tblVwInvitations.tableFooterView = UIView()
        self.tblVwInvitations.separatorStyle = .none
        self.tblVwInvitations.delegate = self
        self.tblVwInvitations.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setNotificationIcon), name: Notification.Name.newNotification, object: nil)
    }
    
    @objc func setNotificationIcon() {
        self.setNotification(notificationBtn: self.notificationBtn)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.getAllInboxMessagesForRedDot()
//        if let tabItems = self.tabBarController?.tabBar.items {
//            let tabItem = tabItems[2]
//            tabItem.image = UIImage(named: "ic_Invitations_active")
//        }
        self.setNotification(notificationBtn: self.notificationBtn)
        
        if self.isManageBids == true {
            self.searchFieldTrailingSpace.constant = -(self.viewFilter.frame.width)
            handleSelection(selectedBtn: btnManageBids, unselectedButton: btnInvitation, selectedView: bottomViewManageBids, unselectedView: bottomVwInvitation)
            self.fetchManagedBids(serchedText: txtFldSearch.text!)
        } else {
            self.searchFieldTrailingSpace.constant = 13.0
            txtFldSearch.text = ""
            handleSelection(selectedBtn: btnInvitation, unselectedButton: btnManageBids, selectedView: bottomVwInvitation, unselectedView: bottomViewManageBids)
            self.fetchFilterInvitations(serchedText: "")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedInvitationToContractorInvitation(notification:)), name: Notification.Name("ReceivedInvitationToContractorInvitation"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.bidRejectToContractorInvitation(notification:)), name: Notification.Name("BidRejectToContractorInvitation"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.bidAcceptToContractorInvitation(notification:)), name: Notification.Name("BidAcceptToContractorInvitation"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.lostBidToContractorInvitation(notification:)), name: Notification.Name("LostBidToContractorInvitation"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.sendTaskToSubContractorInvitation(notification:)), name: Notification.Name("SendTaskToSubContractorInvitation"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.editSubTaskToContractorInvitation(notification:)), name: Notification.Name("EditSubTaskToContractorInvitation"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.uploadAgreementTaskToSubContractorInvitation(notification:)), name: Notification.Name("UploadAgreementTaskToSubContractorInvitation"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.lostTaskBidToSubContractorInvitation(notification:)), name: Notification.Name("LostTaskBidToSubContractorInvitation"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.acceptTaskBidToSubContractorInvitation(notification:)), name: Notification.Name("AcceptTaskBidToSubContractorInvitation"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.rejectTaskBidToSubContractorInvitation(notification:)), name: Notification.Name("RejectTaskBidToSubContractorInvitation"), object: nil)
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
//    }
    
    @objc func rejectTaskBidToSubContractorInvitation(notification: Notification) {
        self.searchFieldTrailingSpace.constant = -(self.viewFilter.frame.width)
        isManageBids = true
        handleSelection(selectedBtn: btnManageBids, unselectedButton: btnInvitation, selectedView: bottomViewManageBids, unselectedView: bottomVwInvitation)
        let notiDict = notification.userInfo! as NSDictionary
        self.isFromManageBidNotification = true
        self.isFromManageBidNotificationBidID = notiDict["bidId"] as! Int
        self.fetchManagedBids(serchedText: txtFldSearch.text!)
    }
    
    @objc func acceptTaskBidToSubContractorInvitation(notification: Notification) {
        self.searchFieldTrailingSpace.constant = -(self.viewFilter.frame.width)
        isManageBids = true
        handleSelection(selectedBtn: btnManageBids, unselectedButton: btnInvitation, selectedView: bottomViewManageBids, unselectedView: bottomVwInvitation)
        let notiDict = notification.userInfo! as NSDictionary
        self.isFromManageBidNotification = true
        self.isFromManageBidNotificationBidID = notiDict["bidId"] as! Int
        self.fetchManagedBids(serchedText: txtFldSearch.text!)
    }
    
    @objc func lostTaskBidToSubContractorInvitation(notification: Notification) {
        self.searchFieldTrailingSpace.constant = -(self.viewFilter.frame.width)
        isManageBids = true
        handleSelection(selectedBtn: btnManageBids, unselectedButton: btnInvitation, selectedView: bottomViewManageBids, unselectedView: bottomVwInvitation)
        let notiDict = notification.userInfo! as NSDictionary
        self.isFromManageBidNotification = true
        self.isFromManageBidNotificationBidID = notiDict["bidId"] as! Int
        self.fetchManagedBids(serchedText: txtFldSearch.text!)
    }
    
    @objc func uploadAgreementTaskToSubContractorInvitation(notification: Notification) {
        self.searchFieldTrailingSpace.constant = -(self.viewFilter.frame.width)
        isManageBids = true
        handleSelection(selectedBtn: btnManageBids, unselectedButton: btnInvitation, selectedView: bottomViewManageBids, unselectedView: bottomVwInvitation)
        let notiDict = notification.userInfo! as NSDictionary
        self.isFromManageBidNotification = true
        self.isFromManageBidNotificationBidID = notiDict["bidId"] as! Int
        self.fetchManagedBids(serchedText: txtFldSearch.text!)        
    }
    
    @objc func editSubTaskToContractorInvitation(notification: Notification) {
        let notiDict = notification.userInfo! as NSDictionary
        isManageBids = false
        isFromInvitationNotification = true
        self.searchFieldTrailingSpace.constant = 13
        handleSelection(selectedBtn: btnInvitation, unselectedButton: btnManageBids, selectedView: bottomVwInvitation, unselectedView: bottomViewManageBids)
        self.isFromInvitationNotificationProjectID = notiDict["projectId"] as! Int
        self.fetchFilterInvitations(serchedText: txtFldSearch.text!)
    }
    
    @objc func sendTaskToSubContractorInvitation(notification: Notification) {
        let notiDict = notification.userInfo! as NSDictionary
        isManageBids = false
        isFromInvitationNotification = true
        self.searchFieldTrailingSpace.constant = 13
        handleSelection(selectedBtn: btnInvitation, unselectedButton: btnManageBids, selectedView: bottomVwInvitation, unselectedView: bottomViewManageBids)
        self.isFromInvitationNotificationProjectID = notiDict["projectId"] as! Int
        self.fetchFilterInvitations(serchedText: txtFldSearch.text!)
    }
    
    @objc func lostBidToContractorInvitation(notification: Notification) {
        self.searchFieldTrailingSpace.constant = -(self.viewFilter.frame.width)
        isManageBids = true
        handleSelection(selectedBtn: btnManageBids, unselectedButton: btnInvitation, selectedView: bottomViewManageBids, unselectedView: bottomVwInvitation)
        let notiDict = notification.userInfo! as NSDictionary
        self.isFromManageBidNotification = true
        self.isFromManageBidNotificationBidID = notiDict["bidId"] as! Int
        self.fetchManagedBids(serchedText: txtFldSearch.text!)
    }
    
    @objc func receivedInvitationToContractorInvitation(notification: Notification) {
        let notiDict = notification.userInfo! as NSDictionary
        isManageBids = false
        isFromInvitationNotification = true
        self.searchFieldTrailingSpace.constant = 13
        handleSelection(selectedBtn: btnInvitation, unselectedButton: btnManageBids, selectedView: bottomVwInvitation, unselectedView: bottomViewManageBids)
        self.isFromInvitationNotificationProjectID = notiDict["projectId"] as! Int
        self.fetchFilterInvitations(serchedText: txtFldSearch.text!)
    }
    
    @objc func bidAcceptToContractorInvitation(notification: Notification) {
        self.searchFieldTrailingSpace.constant = -(self.viewFilter.frame.width)
        isManageBids = true
        handleSelection(selectedBtn: btnManageBids, unselectedButton: btnInvitation, selectedView: bottomViewManageBids, unselectedView: bottomVwInvitation)
        let notiDict = notification.userInfo! as NSDictionary
        self.isFromManageBidNotification = true
        self.isFromManageBidNotificationBidID = notiDict["bidId"] as! Int
        self.fetchManagedBids(serchedText: txtFldSearch.text!)
    }
    
    @objc func bidRejectToContractorInvitation(notification: Notification) {
        self.searchFieldTrailingSpace.constant = -(self.viewFilter.frame.width)
        isManageBids = true
        handleSelection(selectedBtn: btnManageBids, unselectedButton: btnInvitation, selectedView: bottomViewManageBids, unselectedView: bottomVwInvitation)
        let notiDict = notification.userInfo! as NSDictionary
        self.isFromManageBidNotification = true
        self.isFromManageBidNotificationBidID = notiDict["bidId"] as! Int
        self.fetchManagedBids(serchedText: txtFldSearch.text!)
    }
     
    func handleSelection(selectedBtn:UIButton, unselectedButton:UIButton, selectedView:UIView, unselectedView:UIView) {
        selectedBtn.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 14.0)
        unselectedButton.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 14.0)
        
        selectedBtn.setTitleColor(UIColor.appSelectedBlack, for: .normal)
        unselectedButton.setTitleColor(UIColor.appUnSelectedBlack, for: .normal)
        
        selectedView.backgroundColor = UIColor.appColorGreen
        unselectedView.backgroundColor = UIColor.appUnSelectedgrey
    }
    
    func fetchAllInvitations(serachText:String) {
        var params = [String:String]()
        if serachText == "" {
            params = [:]
        } else {
            params = ["search": serachText]
        }
        invitationViewModel.getAllInvitationsApi(params) { model in
            self.arrInvitation = model?.data?.listing ?? [InvitationsDetails]()
            self.tblVwInvitations.reloadData()
            if self.arrInvitation.count <= 0 {
                self.lblNoData.isHidden = false
            } else {
                self.lblNoData.isHidden = true
            }
        }
    }
    @IBAction func actionCross(_ sender: Any) {
        self.txtFldSearch.text = ""
        self.btnCross.isHidden = true
        self.txtFldSearch.resignFirstResponder()
        if isManageBids == true {
            self.fetchManagedBids(serchedText: "")
        } else {
            self.fetchFilterInvitations(serchedText: "")
        }
    }
    
    @IBAction func actionSearch(_ sender: Any) {
    }
    
    //MARK:- Register Cell
    func registerCell() {
        tblVwInvitations.register(UINib.init(nibName: "InvitationsTableViewCell", bundle: nil), forCellReuseIdentifier: "InvitationsTableViewCell")
     }
    
    //MARK: ACTION FILTER
    @IBAction func actionFilter(_ sender: Any) {
        let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "InvitationFilterVC") as? InvitationFilterVC
        destinationViewController!.completionHandlerGoToInvitationScreen = { [weak self] in
            self?.fetchFilterInvitations(serchedText: self?.txtFldSearch.text?.trimmed ?? "")
        }
        destinationViewController!.completionHandlerGoToInvitationScreenClearFilter = { [weak self] in
            self?.fetchFilterInvitations(serchedText: self?.txtFldSearch.text?.trimmed ?? "")
        }
        self.present(destinationViewController!, animated: true)
    }
    
    //MARK: Fetch FilterI nvitations
    func fetchManagedBids(serchedText:String) {
        let params = ["search":serchedText]
        invitationViewModel.getAllManagedBidsApi(params) { model in
            self.arrManageBids.removeAll()
            self.arrManageBids = model?.data ?? [ManageBidsResponseDetails]()
            self.tblVwInvitations.reloadData()
            if self.arrManageBids.count <= 0 {
                self.lblNoData.isHidden = false
            } else {
                self.lblNoData.isHidden = true
            }
            
            if self.isFromManageBidNotification == true {
                self.isFromManageBidNotification = false
                if self.isFromManageBidNotificationBidID != 0 {
                    let vc = Storyboard.invitation.instantiateViewController(withIdentifier: "ManageBidDetailVC") as? ManageBidDetailVC
                    vc!.manageBidId = self.isFromManageBidNotificationBidID
                    self.isFromManageBidNotificationBidID = 0
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
        }
    }
    
    //MARK: Fetch FilterI nvitations
    func fetchFilterInvitations(serchedText:String) {
        var arrayOfFilterWorks = [Int]()
        var arrayOfFilterLocation = [String]()
        var filterDict = [String:Any]()
        var filterArray = [[String:Any]]()
        
        if let workArr = UserDefaults.standard.value(forKey: "FilterWork") as? [Int] {
            if workArr.count > 0 {
                arrayOfFilterWorks = workArr
            }
        }
        
        if let locationArr = UserDefaults.standard.value(forKey: "FilterLocation") as? [String] {
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

        invitationViewModel.getAllInvitationsApi(["filter":filterDict, "search": serchedText]) { model in
            self.arrInvitation = model?.data?.listing ?? [InvitationsDetails]()
            self.tblVwInvitations.reloadData()
            if self.arrInvitation.count <= 0 {
                self.lblNoData.isHidden = false
            } else {
                self.lblNoData.isHidden = true
            }
            
            if self.isFromInvitationNotification == true {
                self.isFromInvitationNotification = false
                if let projctId = self.isFromInvitationNotificationProjectID as? Int {
                    if self.isFromInvitationNotificationProjectID != 0 {
                        for i in 0 ..< self.arrInvitation.count {
                            if self.arrInvitation[i].project_data?.id == projctId {
                                self.isFromInvitationNotificationProjectID = 0
                                let vc = Storyboard.invitation.instantiateViewController(withIdentifier: "InvitationDetailsVC") as? InvitationDetailsVC
                                vc?.invitationDetail = self.arrInvitation[i]
                                vc?.completionHandlerGoToInvitationScreenFromPlaceBid = { [weak self] in
                                    self!.isManageBids = true
                                }
                                self.navigationController?.pushViewController(vc!, animated: true)
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: ACTION INVITATIONS
    @IBAction func actionInvitation(_ sender: Any) {
        isManageBids = false
        self.searchFieldTrailingSpace.constant = 13
        handleSelection(selectedBtn: btnInvitation, unselectedButton: btnManageBids, selectedView: bottomVwInvitation, unselectedView: bottomViewManageBids)
        self.fetchFilterInvitations(serchedText: txtFldSearch.text!)
    }
    
    //MARK: ACTION MANAGE BIDS
    @IBAction func actionManageBids(_ sender: Any) {
        self.searchFieldTrailingSpace.constant = -(self.viewFilter.frame.width)
        isManageBids = true
        handleSelection(selectedBtn: btnManageBids, unselectedButton: btnInvitation, selectedView: bottomViewManageBids, unselectedView: bottomVwInvitation)
        self.fetchManagedBids(serchedText: txtFldSearch.text!)
    }
    
    //MARK: ACTION NOTIFICATIONS
    @IBAction func actionNotification(_ sender: Any) {
        let vc = Storyboard.projectHO.instantiateViewController(withIdentifier: "NotificationVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension InvitationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isManageBids == true {
            return self.arrManageBids.count
        } else {
            return self.arrInvitation.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvitationsTableViewCell", for: indexPath) as! InvitationsTableViewCell
         
        if isManageBids == true {
            if self.arrManageBids[indexPath.row].project_details?.projectType == 1 {
                cell.viewDesc.backgroundColor = UIColor.appColorBlue
                cell.lblDesc.text = "Sub Task"
            } else {
                cell.viewDesc.backgroundColor = UIColor.appBtnColorOrange
                cell.lblDesc.text = "Main Project"
            }
            cell.lblTitle.text = self.arrManageBids[indexPath.row].project_details?.title ?? ""
        } else {
            if self.arrInvitation[indexPath.row].project_data?.projectType == 1 {
                cell.viewDesc.backgroundColor = UIColor.appColorBlue
                cell.lblDesc.text = "Sub Task"
            } else {
                cell.viewDesc.backgroundColor = UIColor.appBtnColorOrange
                cell.lblDesc.text = "Main Project"
            }
            cell.lblTitle.text = self.arrInvitation[indexPath.row].project_data?.title ?? ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isManageBids == true {
            let vc = Storyboard.invitation.instantiateViewController(withIdentifier: "ManageBidDetailVC") as? ManageBidDetailVC
            vc!.manageBidId = self.arrManageBids[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            let vc = Storyboard.invitation.instantiateViewController(withIdentifier: "InvitationDetailsVC") as? InvitationDetailsVC
            vc?.invitationDetail = self.arrInvitation[indexPath.row]
            vc?.completionHandlerGoToInvitationScreenFromPlaceBid = { [weak self] in
                self!.isManageBids = true
            }
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

extension InvitationVC:UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.btnCross.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.btnCross.isHidden = true
        if textField == txtFldSearch {
            if self.isManageBids {
                self.fetchManagedBids(serchedText: textField.text!)
            } else {
                self.fetchFilterInvitations(serchedText: textField.text!)
            }
        }
    }
}
