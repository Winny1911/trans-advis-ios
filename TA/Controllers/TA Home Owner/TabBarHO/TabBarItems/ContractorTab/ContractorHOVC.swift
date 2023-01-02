//
//  ContractorHOVC.swift
//  TA
//
//  Created by Dev on 10/12/21.
//

import UIKit

class ContractorHOVC: BaseViewController {
    
    @IBOutlet weak var topConstraintTableView: NSLayoutConstraint!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblContractorCenter: UILabel!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var lblSideContractor: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var projectId = 0
    var createTask = 0
    var isFrom = ""
    let viewModel: ContractorVM = ContractorVM()
    let applyFilterviewModel : ApplifyFilterVM = ApplifyFilterVM()
    var arrFilter = [Listing]()
    var skillValue = 0
    var userskill : [UserSkill] = [UserSkill]()
    var projectCity = ""
    var selectedCoForTasks = [Int]()
    var inviteSubtaskIdToContractor = 0
    var projectCategoriesId = 0
    var completionHandlerGoToTaskListing: (() -> Void)?
    var newSelectedSkills = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.txtFldSearch.delegate = self
        self.registerCell()
        btnCross.isHidden = true
        filterView.setRoundCorners(radius: 12.0)
        viewSearch.setRoundCorners(radius: 6.0)
    
        self.filterView.isHidden = false
        self.viewSearch.isHidden = false
        self.topConstraintTableView.constant = 5.0
        tableView.reloadData()
        if self.isFrom == "NewProjectDetails" {
            self.topConstraintTableView.constant = -51.0
            self.btnBack.isHidden = false
            self.filterView.isHidden = true
            self.viewSearch.isHidden = true
            self.lblContractorCenter.isHidden = false
            self.btnNotification.isHidden = true
            self.lblSideContractor.isHidden = true
        } else if self.isFrom == "InviteContractorsToBid" {
            self.selectedCoForTasks.removeAll()
            self.topConstraintTableView.constant = 5.0
            self.btnBack.isHidden = false
            self.filterView.isHidden = true
            self.viewSearch.isHidden = false
            self.lblContractorCenter.isHidden = false
            self.btnNotification.isHidden = true
            self.lblSideContractor.isHidden = true
        } else {
            self.topConstraintTableView.constant = 5.0
            self.btnBack.isHidden = true
            self.filterView.isHidden = false
            self.viewSearch.isHidden = false
            self.lblContractorCenter.isHidden = true
            self.btnNotification.isHidden = false
            self.lblSideContractor.isHidden = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllInboxMessagesForRedDot()
        self.inboxMessagesss = fireBaseChatInbox().getAllInboxMessages()
        self.txtFldSearch.resignFirstResponder()
        self.view.endEditing(true)
        txtFldSearch.text = ""
        if self.isFrom == "NewProjectDetails" {
            GetContractorNewApiHit()
        } else if self.isFrom == "InviteContractorsToBid" {
            fetchFilterContractorForBids()
        } else {
            fetchFilterInvitations()
            //GetContractorApiHit()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.txtFldSearch.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func GetContractorNewApiHit(){
        var arrayOfFilterWorks = [Int]()
        arrayOfFilterWorks.removeAll()
        arrayOfFilterWorks.append(self.projectCategoriesId)
        let filterDict = ["work":arrayOfFilterWorks]
        let param = ["projectId":projectId , "filter":filterDict] as [String : Any]
        self.viewModel.contractorUserApiCall(param){ model in
            self.arrFilter.removeAll()
            self.arrFilter = model?.data?.listing ?? []
            if self.arrFilter.count <= 0 {
                self.lblNoData.isHidden = false
            } else {
                self.lblNoData.isHidden = true
            }
            self.tableView.reloadData()
        }
    }
    
    func sendTaskAPI(projectId:Int, contractorId:Int, indexRow:Int){
        let param = ["projectId":projectId, "contractorId":contractorId] as [String : Any]
        self.viewModel.sendTaskToCOApi(param){ model in
            self.selectedCoForTasks.append(indexRow)
            showMessage(with: model?.data?.customMessage ?? "", theme: .success)
            self.tableView.reloadData()
        }
    }
    
    func GetContractorApiHit(){
       // let param = [:]
        self.viewModel.contractorUserApiCall([:]){ model in
            self.arrFilter.removeAll()
            self.arrFilter = model?.data?.listing ?? []
        }
    }
    
    @IBAction func searchCrossButtonAction(_ sender: Any) {
        self.txtFldSearch.text = ""
        self.btnCross.isHidden = true
        self.txtFldSearch.resignFirstResponder()
        if self.isFrom == "InviteContractorsToBid" {
            fetchFilterContractorForBids()
        } else {
            fetchFilterInvitations()
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        if self.isFrom == "InviteContractorsToBid" {
            self.completionHandlerGoToTaskListing?()
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: Fetch FilterI nvitations
    func fetchFilterContractorForBids() {
        let searchedString = self.txtFldSearch.text?.trimmed ?? ""
//        var arrayOfFilterWorks = [Int]()
//        var arrayOfFilterLocation = [String]()
//        var filterDict = [String:Any]()
//        var filterArray = [[String:Any]]()
//
//        if let workArr = UserDefaults.standard.value(forKey: "FilterWorkCOInviteBids") as? [Int] {
//            if workArr.count > 0 {
//                arrayOfFilterWorks = workArr
//            }
//        }
//
//        if let locationArr = UserDefaults.standard.value(forKey: "FilterLocationCOInviteBids") as? [String] {
//            if locationArr.count > 0 {
//                arrayOfFilterLocation = locationArr
//            }
//        }
//
//        if arrayOfFilterWorks.count > 0 && arrayOfFilterLocation.count > 0 {
//            filterDict = ["work":arrayOfFilterWorks, "location":arrayOfFilterLocation] as [String : Any]
//        } else if arrayOfFilterWorks.count > 0 && arrayOfFilterLocation.count == 0 {
//            filterDict = ["work":arrayOfFilterWorks] as [String : Any]
//        } else if arrayOfFilterWorks.count == 0 && arrayOfFilterLocation.count > 0 {
//            filterDict = ["location":arrayOfFilterLocation] as [String : Any]
//        } else {
//            filterDict = [String:Any]()
//        }
//        filterArray.removeAll()
//        filterArray.append(filterDict)
        
        var arrayOfFilterWorks = [Int]()
        arrayOfFilterWorks.removeAll()
        arrayOfFilterWorks.append(self.projectCategoriesId)
        let filterDict = ["work":arrayOfFilterWorks]
        applyFilterviewModel.fetchContractorForBidsFilterApiCall(["filter":filterDict, "search": searchedString , "projectId": inviteSubtaskIdToContractor]) { model in
            self.arrFilter.removeAll()
            self.arrFilter = model?.data?.listing ?? [Listing]()
            self.tableView.reloadData()
            if self.arrFilter.count <= 0 {
                self.lblNoData.isHidden = false
                self.tableView.isHidden = true
            } else {
                self.lblNoData.isHidden = true
                self.tableView.isHidden = false
            }
        }
    }
    
    
    //MARK: Fetch FilterI nvitations
    func fetchFilterInvitations() {
        let searchedString = self.txtFldSearch.text?.trimmed ?? ""
        var arrayOfFilterWorks = [Int]()
        var arrayOfFilterLocation = [String]()
        var filterDict = [String:Any]()
        var filterArray = [[String:Any]]()
        
        if let workArr = UserDefaults.standard.value(forKey: "FilterWorkHO") as? [Int] {
            if workArr.count > 0 {
                arrayOfFilterWorks = workArr
            }
        }
        
        if let locationArr = UserDefaults.standard.value(forKey: "FilterLocationHO") as? [String] {
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
        applyFilterviewModel.applifyFilterApiCall(["filter":filterDict, "search": searchedString]) { model in
            self.arrFilter.removeAll()
            self.arrFilter = model?.data?.listing ?? [Listing]()
            self.tableView.reloadData()
            if self.arrFilter.count <= 0 {
                self.lblNoData.isHidden = false
                self.tableView.isHidden = true
            } else {
                self.lblNoData.isHidden = true
                self.tableView.isHidden = false
            }
        }
    }
  
    func registerCell(){
        if self.isFrom == "InviteContractorsToBid" {
            tableView.register(UINib.init(nibName: "ContractorInviteBidTableViewCellCO", bundle: nil), forCellReuseIdentifier: "ContractorInviteBidTableViewCellCO")
        } else {
            tableView.register(UINib.init(nibName: "ContractorTableViewCellHO", bundle: nil), forCellReuseIdentifier: "ContractorTableViewCellHO")
        }
        
    }
    
    @IBAction func actionNotification(_ sender: Any) {
        let vc = Storyboard.projectHO.instantiateViewController(withIdentifier: "NotificationVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   @IBAction func tapDidFilterButtonAction(_ sender: UIButton) {
        let destinationViewController = Storyboard.contractorHO.instantiateViewController(withIdentifier: "ContractorFilterVC") as? ContractorFilterVC
       if self.isFrom == "InviteContractorsToBid" {
           destinationViewController!.isFrom = "InviteContractorsToBid"
       }
       destinationViewController!.completionHandlerGoToContractorScreen = { [weak self] in
           if self!.isFrom == "InviteContractorsToBid" {
               self!.fetchFilterContractorForBids()
           } else {
               self!.fetchFilterInvitations()
           }
       }
        self.present(destinationViewController!, animated: true)
    }
}

//MARK:- UITableviewDelegate and DataSource
extension ContractorHOVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isFrom == "InviteContractorsToBid" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContractorInviteBidTableViewCellCO", for: indexPath) as! ContractorInviteBidTableViewCellCO
            if self.selectedCoForTasks.contains(indexPath.row) {
                cell.blurBtn.isHidden = false
            } else {
                cell.blurBtn.isHidden = true
            }
           // cell.viewReviewsButton.tag = indexPath.row
            cell.sendProjectBtn.tag = indexPath.row
           // cell.viewReviewsButton.addTarget(self, action: #selector(self.navigationReview), for: .touchUpInside)
            cell.nameLbl.text = "\(self.arrFilter[indexPath.row].firstName ?? "") \(self.arrFilter[indexPath.row].lastName ?? "")"
            cell.lblAllProjects.text = "\(arrFilter[indexPath.row].completedProjectCount!)"

            if indexPath.row < 4 {
                cell.recomdedVwHeight.constant = 21.0
                cell.topLabel.text = "Recommended - #\(indexPath.row + 1) In \(arrFilter[indexPath.row].state ?? "")"
            } else {
                cell.recomdedVwHeight.constant = 0.0
                cell.topLabel.text = ""
            }
            cell.descriptionLbl.isHidden = true
            
            if self.arrFilter[indexPath.row].profilePic?.count ?? 0 > 0{
                if let imgStr = self.arrFilter[indexPath.row].profilePic{
                    cell.profileImage.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed: nil)
                }
            }
                
            let rating = arrFilter[indexPath.row].rating
                        let ratingValue = Double(rating ?? "")
                        cell.emojiView1.isHidden = false
                        cell.emojiView2.isHidden = false
                        cell.emojiView3.isHidden = false
                        cell.emojiView4.isHidden = false
                        cell.emojiView5.isHidden = false
            
            if ratingValue == Double(5.0) {
                cell.emojiView5.isHidden = true
            }
            else if ratingValue ?? Double(0.0) <= Double(4.9) && ratingValue ?? Double(0.0) >= Double(4.0) {
                cell.emojiView4.isHidden = true
            }
            else if ratingValue ?? Double(0.0) <= Double(3.9) && ratingValue ?? Double(0.0) >= Double(3.0) {
                cell.emojiView3.isHidden = true
            }
            else if ratingValue ?? Double(0.0) <= Double(2.9) && ratingValue ?? Double(0.0) >= Double(2.0){
                cell.emojiView2.isHidden = true
            }
            else if ratingValue ?? Double(0.0) <= Double(1.9) && ratingValue ?? Double(0.0) >= Double(1.0){
                cell.emojiView1.isHidden = true
            }
//                            if ratingValue == 5 {
//                                cell.emojiView1.isHidden = true
//                            } else if ratingValue! >= 4 {
//                                cell.emojiView2.isHidden = true
//                            } else if ratingValue! >= 3{
//                                cell.emojiView3.isHidden = true
//                            } else if ratingValue! >= 2{
//                                cell.emojiView4.isHidden = true
//                            } else if ratingValue! >= 0{
//                                cell.emojiView5.isHidden = true
//                            }
                        //Mark:-SendProject Button Action
                        cell.sendProjectBtn.tag = indexPath.row
                        cell.sendProjectBtn.setTitle("Send Task", for: .normal)
                        cell.sendProjectBtn.addTarget(self, action: #selector(sendTask(sender:)), for: .touchUpInside)
                        
                        //cell.userSkillArr = arrFilter[indexPath.row].userSkills ?? [UserSkills]()
//                        var skills = arrFilter[indexPath.row].userSkills ?? [UserSkills]()
//                        if skills.count ?? 0 > 0{
//                            self.newSelectedSkills.removeAll()
//                            for i in 0 ..< skills.count{
//                                if skills[i].projectCategory?.title != nil{
//                                    self.newSelectedSkills.append(skills[i].projectCategory?.title ?? "")
//                                }
//                            }
//                        }
            
                        cell.userSkills = self.arrFilter[indexPath.row].userSkills
                        cell.userSkill()
                        cell.initiateChatAction = {
                                self.initiateChatButtonAction(for: indexPath)
                        }
            
//                        self.newSelectedSkills.removeDuplicates()
//                        self.newSelectedSkills.removingDuplicates()
//                        cell.selectedSkills = self.newSelectedSkills
                        cell.KeySkillcollectionView.reloadData()
                        
                        return cell
            
        } else if self.isFrom == "NewProjectDetails" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContractorTableViewCellHO", for: indexPath) as! ContractorTableViewCellHO
            
           // cell.viewReviewsButton.tag = indexPath.row
            cell.sendProjectBtn.tag = indexPath.row
           // cell.viewReviewsButton.addTarget(self, action: #selector(self.navigationReview), for: .touchUpInside)
            cell.nameLbl.text = "\(self.arrFilter[indexPath.row].firstName ?? "") \(self.arrFilter[indexPath.row].lastName ?? "")"
            cell.lblAllProjects.text = "\(arrFilter[indexPath.row].completedProjectCount!)"
            if indexPath.row < 4 {
                cell.recmdVwHt.constant = 21.0
                cell.topLabel.text = "Recommended - #\(indexPath.row + 1) In \(arrFilter[indexPath.row].state ?? "")"
            } else {
                cell.recmdVwHt.constant = 0.0
                cell.topLabel.text = ""
            }
            
            cell.descriptionLbl.isHidden = true
            
            if self.arrFilter[indexPath.row].profilePic?.count ?? 0 > 0{
                if let imgStr = self.arrFilter[indexPath.row].profilePic{
                    cell.profileImage.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed: nil)
                }
            }
                
            let rating = arrFilter[indexPath.row].rating
            let ratingValue = Double(rating ?? "")
                
            cell.emojiView1.isHidden = false
            cell.emojiView2.isHidden = false
            cell.emojiView3.isHidden = false
            cell.emojiView4.isHidden = false
            cell.emojiView5.isHidden = false
            
            if ratingValue == Double(5.0) {
                cell.emojiView5.isHidden = true
            }
            else if ratingValue ?? Double(0.0) <= Double(4.9) && ratingValue ?? Double(0.0) >= Double(4.0) {
                cell.emojiView4.isHidden = true
            }
            else if ratingValue ?? Double(0.0) <= Double(3.9) && ratingValue ?? Double(0.0) >= Double(3.0) {
                cell.emojiView3.isHidden = true
            }
            else if ratingValue ?? Double(0.0) <= Double(2.9) && ratingValue ?? Double(0.0) >= Double(2.0){
                cell.emojiView2.isHidden = true
            }
            else if ratingValue ?? Double(0.0) <= Double(1.9) && ratingValue ?? Double(0.0) >= Double(1.0){
                cell.emojiView1.isHidden = true
            }
//                if ratingValue == 5 {
//                    cell.emojiView1.isHidden = true
//                } else if ratingValue! >= 4 {
//                    cell.emojiView2.isHidden = true
//                } else if ratingValue! >= 3{
//                    cell.emojiView3.isHidden = true
//                } else if ratingValue! >= 2{
//                    cell.emojiView4.isHidden = true
//                } else if ratingValue! >= 0{
//                    cell.emojiView5.isHidden = true
//                }
            
            //Mark:-SendProject Button Action
                cell.sendBtn = {
                    () in
                    let destinationViewController = Storyboard.contractorHO.instantiateViewController(withIdentifier: "SelectProjectToSendHOVC") as? SelectProjectToSendHOVC
                    destinationViewController?.projectId = self.projectId
                    destinationViewController?.constID = self.arrFilter[indexPath.row].id ?? 0
                    self.present(destinationViewController!, animated: true)
                }
            
            //cell.userSkillArr = arrFilter[indexPath.row].userSkills ?? [UserSkills]()
//            var skills = arrFilter[indexPath.row].userSkills ?? [UserSkills]()
//            if skills.count ?? 0 > 0{
//                for i in 0 ..< skills.count{
//                    if skills[i].projectCategory?.title != nil{
//                        self.newSelectedSkills.append(skills[i].projectCategory?.title ?? "")
////                        cell.selectedSkills.append(skills[i].projectCategory?.title ?? "")
//                    }
//                }
//                self.newSelectedSkills.removeDuplicates()
//                self.newSelectedSkills.removingDuplicates()
//                cell.selectedSkills = self.newSelectedSkills
//            }
            
            cell.userSkills = self.arrFilter[indexPath.row].userSkills
            cell.userSkill()
            
            if arrFilter.count != 0 {
                    cell.KeySkillcollectionView.reloadData()
                }
            
            cell.initiateChatAction = {
                self.initiateChatButtonAction(for: indexPath)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContractorTableViewCellHO", for: indexPath) as! ContractorTableViewCellHO
            cell.selectedSkills.removeAll()
            cell.recmdVwHt.constant = 0.0
           // cell.viewReviewsButton.tag = indexPath.row
            cell.sendProjectBtn.tag = indexPath.row
           // cell.viewReviewsButton.addTarget(self, action: #selector(self.navigationReview), for: .touchUpInside)
            cell.nameLbl.text = "\(self.arrFilter[indexPath.row].firstName ?? "") \(self.arrFilter[indexPath.row].lastName ?? "")"
            cell.lblAllProjects.text = "\(arrFilter[indexPath.row].completedProjectCount!)"
            cell.topLabel.text = ""
            cell.descriptionLbl.isHidden = true
            
            if self.arrFilter[indexPath.row].profilePic?.count ?? 0 > 0{
                if let imgStr = self.arrFilter[indexPath.row].profilePic{
                    cell.profileImage.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed: nil)
                }
            }
                
            let rating = arrFilter[indexPath.row].rating
            let ratingValue = Double(rating ?? "")
            cell.emojiView1.isHidden = false
            cell.emojiView2.isHidden = false
            cell.emojiView3.isHidden = false
            cell.emojiView4.isHidden = false
            cell.emojiView5.isHidden = false
            
            if ratingValue == Double(5.0) {
                cell.emojiView5.isHidden = true
            }
            else if ratingValue ?? Double(0.0) <= Double(4.9) && ratingValue ?? Double(0.0) >= Double(4.0) {
                cell.emojiView4.isHidden = true
            }
            else if ratingValue ?? Double(0.0) <= Double(3.9) && ratingValue ?? Double(0.0) >= Double(3.0) {
                cell.emojiView3.isHidden = true
            }
            else if ratingValue ?? Double(0.0) <= Double(2.9) && ratingValue ?? Double(0.0) >= Double(2.0){
                cell.emojiView2.isHidden = true
            }
            else if ratingValue ?? Double(0.0) <= Double(1.9) && ratingValue ?? Double(0.0) >= Double(1.0){
                cell.emojiView1.isHidden = true
            }
//                if ratingValue == 5 {
//                    cell.emojiView1.isHidden = true
//                } else if ratingValue! >= 4 {
//                    cell.emojiView2.isHidden = true
//                } else if ratingValue! >= 3{
//                    cell.emojiView3.isHidden = true
//                } else if ratingValue! >= 2{
//                    cell.emojiView4.isHidden = true
//                } else if ratingValue! >= 0{
//                    cell.emojiView5.isHidden = true
//                }
            //Mark:-SendProject Button Action
                cell.sendBtn = {
                    () in
                    let destinationViewController = Storyboard.contractorHO.instantiateViewController(withIdentifier: "SelectProjectToSendHOVC") as? SelectProjectToSendHOVC
                    destinationViewController?.projectId = self.projectId
                    destinationViewController?.constID = self.arrFilter[indexPath.row].id ?? 0
                    self.present(destinationViewController!, animated: true)
                }
            //cell.userSkillArr = arrFilter[indexPath.row].userSkills ?? [UserSkills]()
//            var skills = arrFilter[indexPath.row].userSkills ?? [UserSkills]()
//            if skills.count ?? 0 > 0{
//                for i in 0 ..< skills.count{
//                    if skills[i].projectCategory?.title != nil{
//                        self.newSelectedSkills.append(skills[i].projectCategory?.title ?? "")
//                    }
//                }
//            }
            cell.userSkills = self.arrFilter[indexPath.row].userSkills
            cell.userSkill()
//            self.newSelectedSkills.removeDuplicates()
//            self.newSelectedSkills.removingDuplicates()
//            cell.selectedSkills = self.newSelectedSkills
            if arrFilter.count != 0{
                    cell.KeySkillcollectionView.reloadData()
                }
            
            cell.initiateChatAction = {
                self.initiateChatButtonAction(for: indexPath)
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationViewController = Storyboard.contractorHO.instantiateViewController(withIdentifier: "ContractorProfileHOVC") as? ContractorProfileHOVC
        if self.isFrom == "InviteContractorsToBid" {
            destinationViewController!.isFrom = "InviteContractorsToBid"
            destinationViewController!.subTaskId = self.inviteSubtaskIdToContractor
            if self.selectedCoForTasks.contains(indexPath.row) {
                destinationViewController!.showBlurVw = false
            } else {
                destinationViewController!.showBlurVw = true
            }
            destinationViewController!.completionHandlerGoToCOListing =  { [weak self] in
                self!.selectedCoForTasks.append(indexPath.row)
                self!.tableView.reloadData()
            }
        }
        destinationViewController!.contractorID = self.arrFilter[indexPath.row].id ?? 0
        destinationViewController?.projectId = self.projectId
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
     }
    
    @objc func sendTask(sender: UIButton) {
        self.sendTaskAPI(projectId: self.inviteSubtaskIdToContractor, contractorId: self.arrFilter[sender.tag].id ?? 0, indexRow: sender.tag)
    }
    
    //MARK: ViewReview Button Action
    @objc func navigationReview(sender: UIButton){
        let destinationViewController = Storyboard.contractorHO.instantiateViewController(withIdentifier: "ContractorProfileHOVC") as? ContractorProfileHOVC
        destinationViewController!.contractorID = self.arrFilter[sender.tag].id ?? 0
        destinationViewController?.projectId = self.projectId
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
    
    @objc func initiateChatButtonAction(for indexPath: IndexPath) {
        print("ContractorHOVC: initiateChatButtonAction")
        if let chatController = Storyboard.messageHO.instantiateViewController(withIdentifier: "ChatWindowViewController") as? ChatWindowViewController {
            let dictionary = self.arrFilter[indexPath.row]
            let user_id = String("ID_\(dictionary.id ?? 0)")
            let user_name = (dictionary.firstName ?? "") + " " + (dictionary.lastName ?? "")
            let user_image = dictionary.profilePic ?? ""
            
            chatController.hidesBottomBarWhenPushed = true
            chatController.viewModel.user_id = user_id
            chatController.viewModel.user_name = user_name
            chatController.viewModel.user_image = user_image
            self.navigationController?.pushViewController(chatController, animated: true)
        }
    }
}
extension ContractorHOVC:UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.btnCross.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtFldSearch {
            self.btnCross.isHidden = true
            if self.isFrom == "InviteContractorsToBid" {
                fetchFilterContractorForBids()
            } else {
                self.fetchFilterInvitations()
            }
            
//            self.GetApiHit(searchText: textField.text!)
        }
    }
}
