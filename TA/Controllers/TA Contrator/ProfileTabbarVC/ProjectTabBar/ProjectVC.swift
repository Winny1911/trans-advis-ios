//
//  ProjectVC.swift
//  TA
//
//  Created by Designer on 09/12/21.
//

import UIKit

class ProjectVC: BaseViewController {

    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var btnCrsoss: UIButton!
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var vwSeacrh: UIView!
    @IBOutlet weak var vwFilter: UIView!
    @IBOutlet weak var tblvwProjects: UITableView!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var viewBottomArchieve: UIView!
    @IBOutlet weak var btnArchieve: UIButton!
    @IBOutlet weak var viewBottomPast: UIView!
    @IBOutlet weak var btnPast: UIButton!
    @IBOutlet weak var viewBottomOngoing: UIView!
    @IBOutlet weak var btnOngoing: UIButton!
    
    var projectType = "1"
    var ongoingProejctsCOViewModel:OngoingProejctsCOViewModel = OngoingProejctsCOViewModel()
    var pastProjectCOViewModel: PastProjectCOViewModel = PastProjectCOViewModel()
    var archiveProjectViewModel: ArchiveProjectCOViewModel = ArchiveProjectCOViewModel()
    var arrOfOngoingProjects = [OngoingProjectsDetail]()
    var arrofPastProjects = [PastProjectCOProjectDetail]()
    var arrofArchiveProject = [ArchiveProjectAllProjectDetail]()
    
    var isFromNotificationAcceptProject = false
    var isFromNotificationAcceptProjectId = 0
    var isFromNotificationAcceptOngoingProjectId = 0
    var isFromNotificationBidId = 0
    var isFromNotificationTaskId = 0
    var isFromNotificationOrderList = false
    var notificationProjectType = ""
    var isPaymentNotification = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNoRecord.isHidden = true
        btnCrsoss.isHidden = true
        self.txtFldSearch.delegate = self
        vwFilter.setRoundCorners(radius: 12.0)
        vwFilter.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        vwSeacrh.setRoundCorners(radius: 6.0)
        self.registerCell()
        self.tblvwProjects.separatorColor = UIColor.clear
        self.tblvwProjects.rowHeight = UITableView.automaticDimension
        self.tblvwProjects.estimatedRowHeight = 100.0
        self.tblvwProjects.tableFooterView = UIView()
        self.tblvwProjects.separatorStyle = .none
        self.tblvwProjects.delegate = self
        self.tblvwProjects.dataSource = self
        
        self.getNotificationData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setNotificationIcon), name: Notification.Name.newNotification, object: nil)
    }
    
    @objc func setNotificationIcon() {
        self.setNotification(notificationBtn: self.notificationBtn)
    }
    
    func getNotificationData() {
        ongoingProejctsCOViewModel.getNotificationApi([:]) { response in
            
            if let unreadList = response?.data?.listing?.filter({ $0.isRead == 0}), !unreadList.isEmpty {
                isNotificationRead = false
                isInviteNotificationRead = true
                
                for notificationItem in unreadList {
                    if (notificationItem.notificationType == 101 || notificationItem.notificationType == 117) {
                        isInviteNotificationRead = false
                        break
                    } else {
                        isInviteNotificationRead = true
                    }
                }
            } else {
//                isInviteNotificationRead = true
                isNotificationRead = true
            }
            
            self.setNotification(notificationBtn: self.notificationBtn)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNotification(notificationBtn: notificationBtn)
        self.getAllInboxMessagesForRedDot()
        if self.projectType == "1" {
            handleSelection(selectedBtn: btnOngoing, unselectedButton1: btnPast, unselectedButton2: btnArchieve, selectedView:  viewBottomOngoing, unselectedView1: viewBottomPast, unselectedView2: viewBottomArchieve)
            self.fetchFilterOngoingProjects()
        } else if self.projectType == "2" {
            handleSelection(selectedBtn: btnPast, unselectedButton1: btnOngoing, unselectedButton2: btnArchieve, selectedView:  viewBottomPast, unselectedView1: viewBottomOngoing, unselectedView2: viewBottomArchieve)
            //self.fetchManagedBids()
            self.fetchFilterPastProjects()
        } else if self.projectType == "3" {
            handleSelection(selectedBtn: btnArchieve, unselectedButton1: btnPast, unselectedButton2: btnOngoing, selectedView:  viewBottomArchieve, unselectedView1: viewBottomPast, unselectedView2: viewBottomOngoing)
            self.fetchFilterArchiveProjects()
            //self.fetchManagedBids()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.projectRejectToContractorProjects(notification:)), name: Notification.Name("ProjectRejectToContractorProjects"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.projectAcceptToContractorProjects(notification:)), name: Notification.Name("ProjectAcceptToContractorProjects"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.projectUpdatedToContractorOngoingProjects(notification:)), name: Notification.Name("ProjectUpdatedToContractorOngoingProjects"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.projectAdminAcceptedToContractorOngoingProjects(notification:)), name: Notification.Name("ProjectAdminAcceptedToContractorOngoingProjects"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.taskBidToContractorOngoingProjects(notification:)), name: Notification.Name("TaskBidToContractorOngoingProjects"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.subContractorMarkCompleteToContractorOngoingProjects(notification:)), name: Notification.Name("SubContractorMarkCompleteToContractorOngoingProjects"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.acceptTaskDeliveryToSubContractorPastProject(notification:)), name: Notification.Name("AcceptTaskDeliveryToSubContractorPastProject"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.rejectTaskDeliveryToSubContractorPastProject(notification:)), name: Notification.Name("RejectTaskDeliveryToSubContractorPastProject"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.vendorSendQuoteToContractorDetails(notification:)), name: Notification.Name("VendorSendQuoteToContractorDetails"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.vendorDispatchQuoteToContractorDetails(notification:)), name: Notification.Name("VendorDispatchQuoteToContractorDetails"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.paymentss(notification:)), name: Notification.Name("paymentNotification"), object: nil)
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
//    }
    
    @objc func paymentss(notification: Notification) {
        print("Hello")
        let notiDict = notification.userInfo! as NSDictionary
        self.notificationProjectType = "SubTask"
        isFromNotificationBidId = 0
        isFromNotificationAcceptProject = true
        isFromNotificationAcceptProjectId = notiDict["ongoingProjectId"] as! Int
        isFromNotificationAcceptOngoingProjectId = notiDict["projectId"] as! Int
        self.isPaymentNotification = true
        self.goToOngoingProjectsList()
    }
    
    @objc func vendorDispatchQuoteToContractorDetails(notification: Notification) {
        let notiDict = notification.userInfo! as NSDictionary
        isFromNotificationOrderList = true
        isFromNotificationBidId = 0
        isFromNotificationTaskId = 0
        isFromNotificationAcceptProject = true
        let type = notiDict["projectType"]
        let newType = "\(type ?? "")"
        if newType == "1" {
            self.notificationProjectType = "SubTask"
        } else {
            self.notificationProjectType = "MainProject"
        }
        isFromNotificationAcceptProjectId = notiDict["projectId"] as! Int
        isFromNotificationAcceptOngoingProjectId = notiDict["ongoingProjectId"] as! Int
        self.goToOngoingProjectsList()
    }
    
    @objc func vendorSendQuoteToContractorDetails(notification: Notification) {
        let notiDict = notification.userInfo! as NSDictionary
        print(notification)
        isFromNotificationBidId = 0
        isFromNotificationTaskId = 0
        let type = notiDict["projectType"]
        let newType = "\(type ?? "")"
        if newType == "1" {
            self.notificationProjectType = "SubTask"
        } else {
            self.notificationProjectType = "MainProject"
        }
        isFromNotificationOrderList = true
        isFromNotificationAcceptProject = true
        isFromNotificationAcceptProjectId = notiDict["projectId"] as! Int
        isFromNotificationAcceptOngoingProjectId = notiDict["ongoingProjectId"] as! Int
        self.goToOngoingProjectsList()
    }
    
    @objc func rejectTaskDeliveryToSubContractorPastProject(notification: Notification) {
        let notiDict = notification.userInfo! as NSDictionary
        print(notification)
        isFromNotificationAcceptProjectId = notiDict["projectId"] as! Int
        isFromNotificationAcceptOngoingProjectId = notiDict["ongoingProjectId"] as! Int
        self.projectType = "1"
        isFromNotificationAcceptProject = true
        isFromNotificationOrderList = false
        self.notificationProjectType = "SubTask"
        handleSelection(selectedBtn: btnPast, unselectedButton1: btnOngoing, unselectedButton2: btnArchieve, selectedView:  viewBottomPast, unselectedView1: viewBottomOngoing, unselectedView2: viewBottomArchieve)
//        self.fetchFilterPastProjects()
        self.fetchFilterOngoingProjects()
        
        if arrofPastProjects.count == 0{
            self.tblvwProjects.isHidden = true
            self.vwFilter.isHidden = false
            self.vwSeacrh.isHidden = false
        }else{
            self.tblvwProjects.isHidden = false
            self.vwFilter.isHidden = false
            self.vwSeacrh.isHidden = false
        }
    }
    
    @objc func acceptTaskDeliveryToSubContractorPastProject(notification: Notification) {
        self.projectType = "2"
        isFromNotificationOrderList = false
        self.notificationProjectType = "SubTask"
        handleSelection(selectedBtn: btnPast, unselectedButton1: btnOngoing, unselectedButton2: btnArchieve, selectedView:  viewBottomPast, unselectedView1: viewBottomOngoing, unselectedView2: viewBottomArchieve)
        self.fetchFilterPastProjects()
        if arrofPastProjects.count == 0{
            self.tblvwProjects.isHidden = true
            self.vwFilter.isHidden = false
            self.vwSeacrh.isHidden = false
        }else{
            self.tblvwProjects.isHidden = false
            self.vwFilter.isHidden = false
            self.vwSeacrh.isHidden = false
        }
    }
    
    @objc func subContractorMarkCompleteToContractorOngoingProjects(notification: Notification) {
        let notiDict = notification.userInfo! as NSDictionary
        isFromNotificationOrderList = false
        isFromNotificationAcceptProject = true
        self.notificationProjectType = "MainProject"
        isFromNotificationBidId = 0
        isFromNotificationTaskId = notiDict["subTaskId"] as! Int
        isFromNotificationAcceptProjectId = notiDict["projectId"] as! Int
        isFromNotificationAcceptOngoingProjectId = notiDict["ongoingProjectId"] as! Int
        self.goToOngoingProjectsList()
    }
    
    @objc func taskBidToContractorOngoingProjects(notification: Notification) {
        let notiDict = notification.userInfo! as NSDictionary
        isFromNotificationOrderList = false
        isFromNotificationTaskId = 0
        self.notificationProjectType = "MainProject"
        isFromNotificationAcceptProject = true
        isFromNotificationBidId = notiDict["bidId"] as! Int
        isFromNotificationAcceptProjectId = notiDict["projectId"] as! Int
        isFromNotificationAcceptOngoingProjectId = notiDict["ongoingProjectId"] as! Int
        self.goToOngoingProjectsList()
    }
    
    @objc func projectAdminAcceptedToContractorOngoingProjects(notification: Notification) {
        let notiDict = notification.userInfo! as NSDictionary
        isFromNotificationOrderList = false
        isFromNotificationBidId = 0
        isFromNotificationTaskId = 0
        self.notificationProjectType = "MainProject"
        isFromNotificationAcceptProject = true
        isFromNotificationAcceptProjectId = notiDict["projectId"] as! Int
        isFromNotificationAcceptOngoingProjectId = notiDict["ongoingProjectId"] as! Int
        self.goToOngoingProjectsList()
    }
    
    @objc func projectUpdatedToContractorOngoingProjects(notification: Notification) {
        let notiDict = notification.userInfo! as NSDictionary
        isFromNotificationOrderList = false
        isFromNotificationAcceptProject = true
        isFromNotificationBidId = 0
        isFromNotificationTaskId = 0
        self.notificationProjectType = "MainProject"
        isFromNotificationAcceptProjectId = notiDict["projectId"] as! Int
        isFromNotificationAcceptOngoingProjectId = notiDict["ongoingProjectId"] as! Int
        self.goToOngoingProjectsList()
    }
    
    @objc func projectAcceptToContractorProjects(notification: Notification)  {
        let notiDict = notification.userInfo! as NSDictionary
        isFromNotificationOrderList = false
        isFromNotificationAcceptProject = true
        isFromNotificationBidId = 0
        self.notificationProjectType = "MainProject"
        isFromNotificationTaskId = 0
        isFromNotificationAcceptProjectId = notiDict["projectId"] as! Int
        isFromNotificationAcceptOngoingProjectId = notiDict["ongoingProjectId"] as! Int
        self.goToOngoingProjectsList()
    }
    
    @objc func projectRejectToContractorProjects(notification: Notification)  {
        let notiDict = notification.userInfo! as NSDictionary
        isFromNotificationOrderList = false
        isFromNotificationAcceptProject = true
        self.notificationProjectType = "MainProject"
        isFromNotificationBidId = 0
        isFromNotificationTaskId = 0
        isFromNotificationAcceptProjectId = notiDict["projectId"] as! Int
        isFromNotificationAcceptOngoingProjectId = notiDict["ongoingProjectId"] as! Int
        self.goToOngoingProjectsList()
    }
    
    func goToOngoingProjectsList() {
        self.projectType = "1"
        handleSelection(selectedBtn: btnOngoing, unselectedButton1: btnPast, unselectedButton2: btnArchieve, selectedView:  viewBottomOngoing, unselectedView1: viewBottomPast, unselectedView2: viewBottomArchieve)
        self.tblvwProjects.isHidden = false
        self.vwFilter.isHidden = false
        self.vwSeacrh.isHidden = false
        self.fetchFilterOngoingProjects()
    }
    
    //MARK:- Register Cell
    func registerCell() {
        tblvwProjects.register(UINib.init(nibName: "ProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "ProjectTableViewCell")
     }
    
    func handleSelection(selectedBtn:UIButton, unselectedButton1:UIButton, unselectedButton2:UIButton, selectedView:UIView, unselectedView1:UIView, unselectedView2:UIView) {
        selectedBtn.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 14.0)
        unselectedButton1.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 14.0)
        unselectedButton2.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 14.0)
        
        selectedBtn.setTitleColor(UIColor.appSelectedBlack, for: .normal)
        unselectedButton1.setTitleColor(UIColor.appUnSelectedBlack, for: .normal)
        unselectedButton2.setTitleColor(UIColor.appUnSelectedBlack, for: .normal)
        
        selectedView.backgroundColor = UIColor.appColorGreen
        unselectedView1.backgroundColor = UIColor.appUnSelectedgrey
        unselectedView2.backgroundColor = UIColor.appUnSelectedgrey
    }
    
    //MARK: FETCH ONGOING PROJECTS
    func fetchFilterOngoingProjects() {
        let serchedText = self.txtFldSearch.text!
        var arrayOfFilterWorks = [Int]()
        var arrayOfFilterLocation = [String]()
        var filterDict = [String:Any]()
        var filterArray = [[String:Any]]()
        
        if let workArr = UserDefaults.standard.value(forKey: "FilterWorkOngoingProjects") as? [Int] {
            if workArr.count > 0 {
                arrayOfFilterWorks = workArr
            }
        }

        if let locationArr = UserDefaults.standard.value(forKey: "FilterLocationOngoingProjects") as? [String] {
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

        ongoingProejctsCOViewModel.getAllOngoingProjectssApi(["filter":filterDict, "search": serchedText]) { model in
            self.arrOfOngoingProjects = model?.data?.allProjects ?? [OngoingProjectsDetail]()
            self.tblvwProjects.reloadData()
            if self.arrOfOngoingProjects.count <= 0 {
                self.lblNoRecord.isHidden = false
            } else {
                self.lblNoRecord.isHidden = true
            }
        
            if self.isFromNotificationAcceptProject == true {
//                self.isFromNotificationAcceptProject = false
                if self.isFromNotificationTaskId != 0 {
                    let destinationVC = Storyboard.project.instantiateViewController(withIdentifier: "InviteOtherContractorsDetailVC") as!  InviteOtherContractorsDetailVC
                    destinationVC.projectId = self.isFromNotificationTaskId
                    self.isFromNotificationTaskId = 0
                    self.isFromNotificationAcceptProjectId = 0
                    self.isFromNotificationAcceptOngoingProjectId = 0
                    self.navigationController?.pushViewController(destinationVC, animated: true)
                } else if self.isFromNotificationBidId != 0 {
                    let destinationViewController = Storyboard.newHO.instantiateViewController(withIdentifier: "BidDetailVc") as? BidDetailVc
                    destinationViewController!.id = self.isFromNotificationBidId
                    destinationViewController!.isFrom = "InvitedTaskCO"
                    self.isFromNotificationBidId = 0
                    self.isFromNotificationAcceptProjectId = 0
                    self.isFromNotificationAcceptOngoingProjectId = 0
                    self.navigationController?.pushViewController(destinationViewController!, animated: true)
                } else if self.isFromNotificationBidId == 0 {
                    if self.isFromNotificationAcceptProjectId != 0 && self.isFromNotificationAcceptOngoingProjectId != 0 {
                        let vc = Storyboard.project.instantiateViewController(withIdentifier: "OngoingProjectDetailVC") as? OngoingProjectDetailVC

                        vc!.isFrom = self.notificationProjectType
                        if self.isFromNotificationOrderList == true {
                            vc!.selectedType = "Orderlist"
                        }
                        vc!.isFromNotificationAcceptProject = self.isFromNotificationAcceptProject
                        self.isFromNotificationOrderList = false
                        vc!.projectId = self.isFromNotificationAcceptOngoingProjectId
                        vc!.projectIdComplete =  self.isFromNotificationAcceptProjectId
                        if self.notificationProjectType == "SubTask" {
                            vc!.subTaskOrderId = self.isFromNotificationAcceptProjectId
                            vc!.isFrom = self.notificationProjectType
                            if self.isPaymentNotification == true {
                                vc!.projectId = self.isFromNotificationAcceptProjectId
                                vc!.projectIdComplete =  self.isFromNotificationAcceptOngoingProjectId
                                vc!.isFrom = self.notificationProjectType
                            }
                        }
                        self.isFromNotificationAcceptProjectId = 0
                        self.isFromNotificationAcceptOngoingProjectId = 0
                        self.isFromNotificationBidId = 0
                        self.isFromNotificationAcceptProject = false
                        
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }
                }
            }
        }
    }
    
    //MARK: FETCH PAST PROJECTS
    func fetchFilterPastProjects() {
        let serchedText = self.txtFldSearch.text!
        var arrayOfFilterWorks = [Int]()
        var arrayOfFilterLocation = [String]()
        var fromDate = String()
        var toDate = String()
        var filterDict = [String:Any]()
        var filterArray = [[String:Any]]()
        
        if let workArr = UserDefaults.standard.value(forKey: "FilterWorkPastProjectCO") as? [Int] {
            if workArr.count > 0 {
                arrayOfFilterWorks = workArr
               
            }
        }

        if let locationArr = UserDefaults.standard.value(forKey: "FilterLocationPastProjectCO") as? [String] {
            if locationArr.count > 0 {
                arrayOfFilterLocation = locationArr
            }
        }
        
        if let fromDateArr = UserDefaults.standard.value(forKey: "FilterFromDatePastProjectCO") as? String {
            if fromDateArr.count > 0 {
                fromDate = fromDateArr
                
            }
        }
        
        if let toDateArr = UserDefaults.standard.value(forKey: "FilterToDatePastProjectCO") as? String {
            if toDateArr.count > 0 {
                toDate = toDateArr
                
            }
        }
        
        if arrayOfFilterWorks.count > 0 && arrayOfFilterLocation.count > 0 && fromDate.count > 0 && toDate.count > 0{
            filterDict = ["work":arrayOfFilterWorks, "location":arrayOfFilterLocation, "from":fromDate, "to":toDate] as [String : Any]
        } else if arrayOfFilterWorks.count > 0 && arrayOfFilterLocation.count == 0 && fromDate.count == 0 && toDate.count == 0 {
            filterDict = ["work":arrayOfFilterWorks] as [String : Any]
        } else if arrayOfFilterWorks.count == 0 && arrayOfFilterLocation.count > 0 && fromDate.count == 0 && toDate.count == 0 {
            filterDict = ["location":arrayOfFilterLocation] as [String : Any]
        } else if arrayOfFilterWorks.count == 0 && arrayOfFilterLocation.count == 0 && fromDate.count > 0 && toDate.count == 0{
            filterDict = ["from":fromDate] as [String : Any]
        } else if arrayOfFilterWorks.count == 0 && arrayOfFilterLocation.count == 0 && fromDate.count == 0 && toDate.count > 0{
            filterDict = ["to":toDate] as [String : Any]
            
        }else if arrayOfFilterWorks.count == 0 && arrayOfFilterLocation.count > 0 && fromDate.count > 0 &&  toDate.count > 0{
            filterDict = ["location":arrayOfFilterLocation, "from":fromDate, "to":toDate] as [String : Any]
        }
        else if arrayOfFilterWorks.count == 0 && arrayOfFilterLocation.count == 0 && fromDate.count > 0 &&  toDate.count > 0{
            let isoDate = fromDate
            var a = Date()

            let dateFormatter = DateFormatter()
            //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from:fromDate) ?? a
            let now = date
            print(date)

            let dateFormatters = DateFormatter()
            dateFormatters.dateStyle = .short
            dateFormatters.timeStyle = .none
//            dateFormatters.timeStyle =  // DateFormatterStyle.NoStyle
//            dateFormatters.dateStyle = DateFormatterStyle.MediumStyle
            var updatedFromDate = dateFormatters.string(from: now)
            
           
            
            let isoDates = toDate
            let newDateFormatter = DateFormatter()
            newDateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            newDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let dates = newDateFormatter.date(from:isoDates) ?? a
            let now1 = dates

            let newdateFormatters = DateFormatter()
            newdateFormatters.dateStyle = .short
            newdateFormatters.timeStyle = .none
//            dateFormatters.timeStyle =  // DateFormatterStyle.NoStyle
//            dateFormatters.dateStyle = DateFormatterStyle.MediumStyle
            var updatedToDate = newdateFormatters.string(from: now1)
           // print(dateFormatters.string(from: now ?? a)
//            var aa = Int(fromDate)
//            var b = Int(toDate)
            filterDict = ["from": updatedToDate, "to": updatedToDate] as [String : Any]
            
            
            
        }else {
            filterDict = [String:Any]()
        }
        filterArray.removeAll()
        filterArray.append(filterDict)
        print("filterArray\(filterArray)")
        
        pastProjectCOViewModel.getAllPastProjectssApi(["filter":filterDict, "search": serchedText]) { model in
            self.arrofPastProjects = model?.data?.allProjects ?? [PastProjectCOProjectDetail]()
            self.tblvwProjects.reloadData()
            if self.arrofPastProjects.count <= 0 {
                self.lblNoRecord.isHidden = false
            } else {
                self.lblNoRecord.isHidden = true
            }
            if self.arrofPastProjects.count == 0{
                self.tblvwProjects.isHidden = true
                self.vwFilter.isHidden = false
                self.vwSeacrh.isHidden = false
            }else{
                self.tblvwProjects.isHidden = false
                self.vwFilter.isHidden = false
                self.vwSeacrh.isHidden = false
            }
        }
    }
    
    //MARK: FETCH ARCHIVE PROJECTS
    func fetchFilterArchiveProjects() {
        let serchedText = self.txtFldSearch.text!
        var arrayOfFilterWorks = [Int]()
        var arrayOfFilterLocation = [String]()
        var arrayOfFilterDate = [String]()
        var filterDict = [String:Any]()
        var filterArray = [[String:Any]]()
        
        if let workArr = UserDefaults.standard.value(forKey: "FilterWorkArchiveProjectCO") as? [Int] {
            if workArr.count > 0 {
                arrayOfFilterWorks = workArr
            }
        }

        if let locationArr = UserDefaults.standard.value(forKey: "FilterLocationArchiveProjectCO") as? [String] {
            if locationArr.count > 0 {
                arrayOfFilterLocation = locationArr
            }
        }
        if let dateArr = UserDefaults.standard.value(forKey: "FilterDateArchivetProjectCO") as? [String] {
            if dateArr.count > 0 {
                arrayOfFilterDate = dateArr
                
            }
        }
        
        if arrayOfFilterWorks.count > 0 && arrayOfFilterLocation.count > 0 {
            filterDict = ["work":arrayOfFilterWorks, "location":arrayOfFilterLocation] as [String : Any]
        } else if arrayOfFilterWorks.count > 0 && arrayOfFilterLocation.count == 0{
            filterDict = ["work":arrayOfFilterWorks] as [String : Any]
        } else if arrayOfFilterWorks.count == 0 && arrayOfFilterLocation.count > 0 {
            filterDict = ["location":arrayOfFilterLocation] as [String : Any]
        } else {
            filterDict = [String:Any]()
        }
        filterArray.removeAll()
        filterArray.append(filterDict)
        print("filterArray\(filterArray)")
        
        archiveProjectViewModel.getAllArchiveProjectssApi(["filter":filterDict, "search": serchedText]) { model in
            self.arrofArchiveProject = model?.data?.allProjects ?? [ArchiveProjectAllProjectDetail]()
            self.tblvwProjects.reloadData()
            if self.arrofArchiveProject.count <= 0 {
                self.lblNoRecord.isHidden = false
            } else {
                self.lblNoRecord.isHidden = true
            }
            if self.arrofArchiveProject.count == 0 {
                self.tblvwProjects.isHidden = true
                self.vwFilter.isHidden = false
                self.vwSeacrh.isHidden = false
            }else{
                self.tblvwProjects.isHidden = false
                self.vwFilter.isHidden = false
                self.vwSeacrh.isHidden = false
            }
        }
    }
    
    @IBAction func actionOngoing(_ sender: Any) {
        self.projectType = "1"
        handleSelection(selectedBtn: btnOngoing, unselectedButton1: btnPast, unselectedButton2: btnArchieve, selectedView:  viewBottomOngoing, unselectedView1: viewBottomPast, unselectedView2: viewBottomArchieve)
        self.fetchFilterOngoingProjects()
        if arrOfOngoingProjects.count == 0 {
            self.tblvwProjects.isHidden = true
            self.vwFilter.isHidden = false
            self.vwSeacrh.isHidden = false
        }else{
            self.tblvwProjects.isHidden = false
            self.vwFilter.isHidden = false
            self.vwSeacrh.isHidden = false
        }
        
    }
    
    @IBAction func actionPast(_ sender: Any) {
        self.projectType = "2"
        handleSelection(selectedBtn: btnPast, unselectedButton1: btnOngoing, unselectedButton2: btnArchieve, selectedView:  viewBottomPast, unselectedView1: viewBottomOngoing, unselectedView2: viewBottomArchieve)
//        if arrofPastProjects.count == 0{
//            self.tblvwProjects.isHidden = true
//            self.vwFilter.isHidden = false
//            self.vwSeacrh.isHidden = false
//        }else{
//            self.tblvwProjects.isHidden = false
//            self.vwFilter.isHidden = false
//            self.vwSeacrh.isHidden = false
//        }
        self.fetchFilterPastProjects()
    }
    
    @IBAction func actionArchieve(_ sender: Any) {
        self.projectType = "3"
        handleSelection(selectedBtn: btnArchieve, unselectedButton1: btnPast, unselectedButton2: btnOngoing, selectedView:  viewBottomArchieve, unselectedView1: viewBottomPast, unselectedView2: viewBottomOngoing)
        self.fetchFilterArchiveProjects()
        if arrofArchiveProject.count == 0 {
            self.tblvwProjects.isHidden = true
            self.vwFilter.isHidden = false
            self.vwSeacrh.isHidden = false
        }else{
            self.tblvwProjects.isHidden = false
            self.vwFilter.isHidden = false
            self.vwSeacrh.isHidden = false
        }
        
    }
    
    @IBAction func actionFilter(_ sender: Any) {
        
        let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "InvitationFilterVC") as? InvitationFilterVC
//        destinationViewController!.isFrom = "OnGoingProjectsCO"
        if projectType == "1"{
            destinationViewController!.isFrom = "OnGoingProjectsCO"
        }
        if projectType == "2"{
            destinationViewController!.isFrom = "PastProjectsCO"
        }
        if projectType == "3"{
            destinationViewController!.isFrom = "ArchiveProjectsCO"
        }
        destinationViewController!.completionHandlerGoToOnGoingProjectsCO = { [weak self] in
            self?.fetchFilterOngoingProjects()
        }
        destinationViewController!.completionHandlerGoToPastProjectsCO = { [weak self] in
            self?.fetchFilterPastProjects()
        }
        destinationViewController!.completionHandlerGoToArchiveProjectsCO = { [weak self] in
            self?.fetchFilterArchiveProjects()
        }
        destinationViewController!.completionHandlerGoToOnGoingProjectsCOClearFilter = { [weak self] in
            self?.fetchFilterOngoingProjects()
        }
        destinationViewController!.completionHandlerGoToPastProjectsCOClearFilter = { [weak self] in
            self?.fetchFilterPastProjects()
        }
        destinationViewController!.completionHandlerGoToArchiveProjectsCOClearFilter = { [weak self] in
            self?.fetchFilterArchiveProjects()
        }
        self.present(destinationViewController!, animated: true)
    }
    
    @IBAction func actionNotifications(_ sender: Any) {
        let vc = Storyboard.projectHO.instantiateViewController(withIdentifier: "NotificationVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionSearch(_ sender: Any) {
    }
    
    @IBAction func ctionCross(_ sender: Any) {
        self.txtFldSearch.text = ""
        self.btnCrsoss.isHidden = true
        self.txtFldSearch.resignFirstResponder()
        if projectType == "1"{
            self.fetchFilterOngoingProjects()
        }
        if projectType == "2"{
            self.fetchFilterPastProjects()
        }
        if projectType == "3"{
            self.fetchFilterArchiveProjects()
        }
    }
}

extension ProjectVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return self.arrOfOngoingProjects.count
        if self.projectType == "1"{
            return self.arrOfOngoingProjects.count
        } else if self.projectType == "2"{
            return self.arrofPastProjects.count
        } else if self.projectType == "3"{
            return self.arrofArchiveProject.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.projectType == "1"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell", for: indexPath) as! ProjectTableViewCell
            cell.sendMessageTapAction = {
                self.initiateOngoingChatButtonAction(for: indexPath)
            }
            cell.ongoingHOImageView.sd_setImage(with: URL(string: self.arrOfOngoingProjects[indexPath.row].project_details?.user_data?.profilePic ?? ""), placeholderImage: UIImage(named: "Ic_profile"), completed:nil)
            cell.ongoingHONameLbl.text! = "\(self.arrOfOngoingProjects[indexPath.row].project_details?.user_data?.firstName ?? "") \(self.arrOfOngoingProjects[indexPath.row].project_details?.user_data?.lastName ?? "")"
            cell.ongoingHOTittleLbl.text! = "\(self.arrOfOngoingProjects[indexPath.row].project_details?.title ?? "")"
            cell.markButtonView.isHidden = false
            cell.blurVwww.isHidden = false
            
            cell.ongoingHODescriptionLbl.text! = "\(self.arrOfOngoingProjects[indexPath.row].project_details?.description ?? "")"
            cell.markCompletedButton.tag = indexPath.row
            cell.markCompletedButton.addTarget(self, action: #selector(self.completeAction), for: .touchUpInside)
            
            if self.arrOfOngoingProjects[indexPath.row].project_details?.projectType == 1 {
                DispatchQueue.main.asyncAfter (deadline: .now() + 0.3) {
                    cell.vwMainProject.backgroundColor = UIColor.appColorBlue
                    cell.mainProjectLbl.text = " Sub Task "
                    cell.lblPercentage.isHidden = true
                    cell.progressVw.isHidden = true
                }
            } else {
                DispatchQueue.main.asyncAfter (deadline: .now() + 0.3) {
                    cell.vwMainProject.backgroundColor = UIColor.appBtnColorOrange
                    cell.mainProjectLbl.text = " Main Project "
                    cell.lblPercentage.isHidden = false
                    cell.progressVw.isHidden = false
                }
            }
            cell.viewTransactionButton.tag = indexPath.row
            cell.viewTransactionButton.addTarget(self, action: #selector(self.transactionAction), for: .touchUpInside)
            
            cell.lblPercentage.text = "\(Int(Double(self.arrOfOngoingProjects[indexPath.row].progress ?? "0") ?? Double(0.0)))%"
            if let progress = self.arrOfOngoingProjects[indexPath.row].progress {
                let  floatProgress = (Double(progress)! / Double(100.0))
                cell.progressVw.setProgressWithAnimation(duration: 1.0, value: Float(floatProgress))
            } else {
                cell.progressVw.setProgressWithAnimation(duration: 1.0, value: 0.0)
            }

            if self.arrOfOngoingProjects[indexPath.row].project_details?.status == 2 {
                if self.arrOfOngoingProjects[indexPath.row].progress == "100.0" {
                    cell.markCompletedButton.setTitle("Mark Complete", for: .normal)
                    cell.blurVwww.isHidden = true
                } else {
                    cell.markCompletedButton.setTitle("Mark Complete", for: .normal)
                    cell.blurVwww.isHidden = false
                }
            } else if self.arrOfOngoingProjects[indexPath.row].project_details?.status == 9 {
                cell.markCompletedButton.setTitle("Completed", for: .normal)
                cell.blurVwww.isHidden = false
            } else if self.arrOfOngoingProjects[indexPath.row].project_details?.status == 10 {
                cell.markCompletedButton.setTitle("Accepted", for: .normal)
                cell.blurVwww.isHidden = false
            } else if self.arrOfOngoingProjects[indexPath.row].project_details?.status == 11 {
                if self.arrOfOngoingProjects[indexPath.row].progress == "100.0" {
                    cell.markCompletedButton.setTitle("Mark Complete", for: .normal)
                    cell.blurVwww.isHidden = true
                } else {
                    cell.markCompletedButton.setTitle("Mark Complete", for: .normal)
                    cell.blurVwww.isHidden = false
                }
//                cell.markCompletedButton.setTitle("Mark Complete", for: .normal)
//                cell.blurVwww.isHidden = false
            } else {
                cell.markCompletedButton.setTitle("Mark Complete", for: .normal)
                cell.blurVwww.isHidden = true
                if let progressFloat = self.arrOfOngoingProjects[indexPath.row].progress {
                    let  progressF = (Double(progressFloat)! / Double(100.0))
                    if progressF >= 1.0 {
                        cell.blurVwww.isHidden = true
                    } else {
                        cell.blurVwww.isHidden = true
                    }
                } else {
                    cell.blurVwww.isHidden = true
                }
            }            
            if self.arrOfOngoingProjects[indexPath.row].project_details?.projectType == 1 {
                if self.arrOfOngoingProjects[indexPath.row].project_details?.status == 9 || self.arrOfOngoingProjects[indexPath.row].project_details?.status == 10 {
                    cell.markCompletedButton.setTitle("Completed", for: .normal)
                    cell.blurVwww.isHidden = false
                } else {
                    cell.markCompletedButton.setTitle("Mark Complete", for: .normal)
                    cell.blurVwww.isHidden = true
                }
                
            }
//            if self.arrOfOngoingProjects[indexPath.row].project_details?.projectType == 1 {
//                cell.blurVwww.isHidden = true
//            } else {
//                if let progressFloat = self.arrOfOngoingProjects[indexPath.row].progress {
//                    let  progressF = (Double(progressFloat)! / Double(100.0))
//                    if progressF >= 1.0 {
//                        cell.blurVwww.isHidden = true
//                    } else {
//                        cell.blurVwww.isHidden = false
//                    }
//                }
//            }
            
            return cell
        } else if self.projectType == "2"{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell", for: indexPath) as! ProjectTableViewCell
            cell.sendMessageTapAction = {
                self.initiatePastChatButtonAction(for: indexPath)
            }
            cell.ongoingHOImageView.sd_setImage(with: URL(string: self.arrofPastProjects[indexPath.row].projectDetails?.userData?.profilePic ?? ""), placeholderImage: UIImage(named: "Ic_profile"), completed:nil)
            cell.ongoingHONameLbl.text! = "\(self.arrofPastProjects[indexPath.row].projectDetails?.userData?.firstName ?? "") \(self.arrofPastProjects[indexPath.row].projectDetails?.userData?.lastName ?? "")"
            cell.ongoingHOTittleLbl.text! = "\(self.arrofPastProjects[indexPath.row].projectDetails?.title ?? "")"
            cell.ongoingHODescriptionLbl.text! = "\(self.arrofPastProjects[indexPath.row].projectDetails?.projectDetailsDescription ?? "")"
            cell.markButtonView.isHidden = true
            cell.progressVw.isHidden = true
            cell.lblPercentage.isHidden = true
            
            if arrofPastProjects[indexPath.row].projectDetails?.projectType == 0{
                cell.progressVw.isHidden = false
                cell.progressVw.setProgressWithAnimation(duration: 1.0, value: 1.0)
                cell.viewTransactionButton.tag = indexPath.row
                cell.viewTransactionButton.addTarget(self, action: #selector(self.pastTransactionAction), for: .touchUpInside)
                cell.lblPercentage.isHidden = false
                DispatchQueue.main.asyncAfter (deadline: .now() + 0.3) {
                    cell.mainProjectLbl.text = " Main Project "
                    cell.vwMainProject.backgroundColor = UIColor(hex: "#FA9365")
                }
            }
            
            if arrofPastProjects[indexPath.row].projectDetails?.projectType == 1{
                DispatchQueue.main.asyncAfter (deadline: .now() + 0.3) {
                cell.mainProjectLbl.text = " Sub Task "
                cell.vwMainProject.backgroundColor = UIColor(hex: "#499CDE")
                }
            }
            return cell
        } else if self.projectType == "3"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell", for: indexPath) as! ProjectTableViewCell
            cell.sendMessageTapAction = {
                self.initiateArchiveChatButtonAction(for: indexPath)
            }
            cell.ongoingHOImageView.sd_setImage(with: URL(string: arrofArchiveProject[indexPath.row].projectDetails?.userData?.profilePic ?? ""), placeholderImage: UIImage(named: "Ic_profile"), completed:nil)
            cell.ongoingHONameLbl.text! = "\(self.arrofArchiveProject[indexPath.row].projectDetails?.userData?.firstName ?? "") \(self.arrofArchiveProject[indexPath.row].projectDetails?.userData?.lastName ?? "")"
            cell.ongoingHOTittleLbl.text! = "\(self.arrofArchiveProject[indexPath.row].projectDetails?.title ?? "")"
            cell.ongoingHODescriptionLbl.text! = "\(self.arrofArchiveProject[indexPath.row].projectDetails?.projectDetailsDescription ?? "")"
            cell.markButtonView.isHidden = true
            cell.viewTransactionButton.tag = indexPath.row
            cell.viewTransactionButton.addTarget(self, action: #selector(self.archiveTransactionAction), for: .touchUpInside)
            
            cell.lblPercentage.text = "\(Int(Double(self.arrofArchiveProject[indexPath.row].progress ?? "0") ?? Double(0.0)))%"
            if let progress = self.arrofArchiveProject[indexPath.row].progress {
                let  floatProgress = (Double(progress)! / Double(100.0))
                cell.progressVw.setProgressWithAnimation(duration: 1.0, value: Float(floatProgress))
            } else {
                cell.progressVw.setProgressWithAnimation(duration: 1.0, value: 0.0)
            }
            if let progressFloat = self.arrofArchiveProject[indexPath.row].progress {
                let  progressF = (Double(progressFloat)! / Double(100.0))
                if progressF >= 1.0 {
                    cell.blurVwww.isHidden = true
                } else {
                    cell.blurVwww.isHidden = false
                }
            }
            if arrofArchiveProject[indexPath.row].projectDetails?.projectType == 0{
                cell.progressVw.isHidden = false
                cell.lblPercentage.isHidden = false
                cell.mainProjectLbl.text = " Main Project "
                cell.vwMainProject.backgroundColor = UIColor(hex: "#FA9365")
            }
            
            
            if arrofArchiveProject[indexPath.row].projectDetails?.projectType == 1{
                cell.mainProjectLbl.text = " Sub Task "
                cell.vwMainProject.backgroundColor = UIColor(hex: "#499CDE")
            }
            return cell
        }
        
        return UITableViewCell()
    }
    @objc func initiateOngoingChatButtonAction(for indexPath: IndexPath) {
        print("ContractorHOVC: initiateChatButtonAction")
        let dictionary = self.arrOfOngoingProjects[indexPath.row]
        let user_id = String("ID_\(dictionary.project_details?.user_data?.id ?? 0)")
        let user_name = (dictionary.project_details?.user_data?.firstName ?? "") + " " + (dictionary.project_details?.user_data?.lastName ?? "")
        let user_image = dictionary.project_details?.user_data?.profilePic ?? ""
        self.openChatWindow(user_id: user_id, user_image: user_image, user_name: user_name)
    }
    @objc func initiatePastChatButtonAction(for indexPath: IndexPath) {
        print("ContractorHOVC: initiateChatButtonAction")
        let dictionary = self.arrofPastProjects[indexPath.row]
        let user_id = String("ID_\(dictionary.projectDetails?.userData?.id ?? 0)")
        let user_name = (dictionary.projectDetails?.userData?.firstName ?? "") + " " + (dictionary.projectDetails?.userData?.lastName ?? "")
        let user_image = dictionary.projectDetails?.userData?.profilePic ?? ""
        self.openChatWindow(user_id: user_id, user_image: user_image, user_name: user_name)
    }

    @objc func initiateArchiveChatButtonAction(for indexPath: IndexPath) {
        print("ContractorHOVC: initiateChatButtonAction")
        let dictionary = self.arrofArchiveProject[indexPath.row]
        let user_id = String("ID_\(dictionary.projectDetails?.userData?.id ?? 0)")
        let user_name = (dictionary.projectDetails?.userData?.firstName ?? "") + " " + (dictionary.projectDetails?.userData?.lastName ?? "")
        let user_image = dictionary.projectDetails?.userData?.profilePic ?? ""
        self.openChatWindow(user_id: user_id, user_image: user_image, user_name: user_name)
    }
    
    func openChatWindow(user_id: String?, user_image: String?, user_name: String?) {
        DispatchQueue.main.async {
            if let chatController = Storyboard.messageHO.instantiateViewController(withIdentifier: "ChatWindowViewController") as? ChatWindowViewController {
                chatController.hidesBottomBarWhenPushed = true
                chatController.viewModel.user_id = user_id
                chatController.viewModel.user_name = user_name
                chatController.viewModel.user_image = user_image
                self.navigationController?.pushViewController(chatController, animated: true)
            }
        }
    }
   
    
    
    @objc func transactionAction(sender: UIButton) {
        let destinationViewController = Storyboard.ongoingHO.instantiateViewController(withIdentifier: "TransactionHistoryVC") as? TransactionHistoryVC
        destinationViewController!.isFrom = "CO"
        if self.arrOfOngoingProjects[sender.tag].project_details?.projectType == 1 {
            destinationViewController!.isType = "SubTask"
        } else {
            destinationViewController!.isType = "MainProject"
        }
        destinationViewController!.projectId = self.arrOfOngoingProjects[sender.tag].projectId ?? 0
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
    
    @objc func archiveTransactionAction(sender: UIButton) {
        let destinationViewController = Storyboard.ongoingHO.instantiateViewController(withIdentifier: "TransactionHistoryVC") as? TransactionHistoryVC
        destinationViewController!.isFrom = "CO"
        destinationViewController!.projectId = self.arrofArchiveProject[sender.tag].projectID ?? 0
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
    
    @objc func pastTransactionAction(sender: UIButton) {
        let destinationViewController = Storyboard.ongoingHO.instantiateViewController(withIdentifier: "TransactionHistoryVC") as? TransactionHistoryVC
        destinationViewController!.isFrom = "CO"
        destinationViewController!.projectId = self.arrofPastProjects[sender.tag].projectID ?? 0
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
    
    @objc func completeAction(sender: UIButton) {
        let vc = Storyboard.project.instantiateViewController(withIdentifier: "OngoingProjectDetailVC") as? OngoingProjectDetailVC
        vc!.projectId = self.arrOfOngoingProjects[sender.tag].id ?? 0
        
        if self.arrOfOngoingProjects[sender.tag].project_details?.projectType == 1 {
            vc!.isFrom = "SubTask"
        } else {
            vc!.isFrom = "MainProject"
        }
        
        vc!.projectIdComplete = self.arrOfOngoingProjects[sender.tag].projectId ?? 0
        vc!.completionHandlerGoToOnPastListing = { [weak self] in
            //            self!.projectType = "2"
            //            self!.handleSelection(selectedBtn: self!.btnPast, unselectedButton1: self!.btnOngoing, unselectedButton2: self!.btnArchieve, selectedView:  self!.viewBottomPast, unselectedView1: self!.viewBottomOngoing, unselectedView2: self!.viewBottomArchieve)
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.projectType == "1"{
            let vc = Storyboard.project.instantiateViewController(withIdentifier: "OngoingProjectDetailVC") as? OngoingProjectDetailVC
            vc!.projectId = self.arrOfOngoingProjects[indexPath.row].id ?? 0
            vc!.projectIdComplete = self.arrOfOngoingProjects[indexPath.row].projectId ?? 0
            
            if self.arrOfOngoingProjects[indexPath.row].project_details?.projectType == 1 {
                vc!.isFrom = "SubTask"
            } else {
                vc!.isFrom = "MainProject"
            }
            
            vc!.completionHandlerGoToOnPastListing = { [weak self] in
                
            }

            self.navigationController?.pushViewController(vc!, animated: true)
        }
        if self.projectType == "2"{
            
            if arrofPastProjects[indexPath.row].projectDetails?.projectType == 0 {
                let vc = Storyboard.project.instantiateViewController(withIdentifier: "PastProjectCODetailVC") as? PastProjectCODetailVC
                vc!.id = arrofPastProjects[indexPath.row].id ?? 0
                vc!.projectID = arrofPastProjects[indexPath.row].projectID ?? 0
                vc!.arrofPastProjects = arrofPastProjects[indexPath.row]
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            else{
                let vc = Controllers.pastProjectSubTaskCOVC
                vc!.id = arrofPastProjects[indexPath.row].id ?? 0
                vc!.projectID = arrofPastProjects[indexPath.row].projectID ?? 0
                vc!.arrofPastProjects = arrofPastProjects[indexPath.row]
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
        }
        
        if self.projectType == "3"{
            
            if arrofArchiveProject[indexPath.row].projectDetails?.projectType == 0{
                let vc = Storyboard.archiveProjectCOMainTask.instantiateViewController(withIdentifier: "ArchiveProjectCOMainTask") as? ArchiveProjectCOMainTask
                vc!.id = arrofArchiveProject[indexPath.row].id ?? 0
                vc!.projectID = arrofArchiveProject[indexPath.row].projectID ?? 0
                vc!.arrofArchiveProjectCO = arrofArchiveProject[indexPath.row]
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            else{
                let vc = Storyboard.archiveProjectSubTaskCOVC.instantiateViewController(withIdentifier: "ArchiveProjectSubTaskCOVC") as? ArchiveProjectSubTaskCOVC
                vc!.id = arrofArchiveProject[indexPath.row].id ?? 0
                vc!.projectID = arrofArchiveProject[indexPath.row].projectID ?? 0
                vc!.arrofArchiveProjectCO = arrofArchiveProject[indexPath.row]
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            

    }
}
}

extension ProjectVC:UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.btnCrsoss.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.btnCrsoss.isHidden = true
        if textField == txtFldSearch {
            if self.projectType == "1"{
                self.fetchFilterOngoingProjects()
            }
            if self.projectType == "2"{
                self.fetchFilterPastProjects()
            }
            if self.projectType == "3"{
                self.fetchFilterArchiveProjects()
            }
        }
    }
}
