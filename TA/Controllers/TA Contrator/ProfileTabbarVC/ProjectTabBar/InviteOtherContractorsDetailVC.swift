//
//  InviteOtherContractorsDetailVC.swift
//  TA
//
//  Created by Applify  on 14/02/22.
//

import UIKit

class InviteOtherContractorsDetailVC: BaseViewController {

    @IBOutlet weak var attachedFilesLabel: UILabel!
    @IBOutlet weak var lblTopTitle: UILabel!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var tblVwOrderList: UITableView!
    @IBOutlet weak var btnViewBids: UIButton!
    @IBOutlet weak var btnFIndCOs: UIButton!
    @IBOutlet weak var collVwFiles: UICollectionView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblProjectBudget: UILabel!
    @IBOutlet weak var heightProjectTypeTblVw: NSLayoutConstraint!
    @IBOutlet weak var tblVwProejctType: UITableView!
    @IBOutlet weak var deliverablesTblVwHeight: NSLayoutConstraint!
    @IBOutlet weak var tblVwDeliverables: UITableView!
    @IBOutlet weak var lblTaskName: UILabel!
    @IBOutlet weak var viewSelectedOrderlist: UIView!
    @IBOutlet weak var btnOrderList: UIButton!
    @IBOutlet weak var viewSelectedSubtask: UIView!
    @IBOutlet weak var btnSubtask: UIButton!
    
    var ongoingProejctsCOViewModel:OngoingProejctsCOViewModel = OngoingProejctsCOViewModel()
    var projectId = 0
    var deliverableArray = [ProjectDeliverableDetail]()
    var projectTypeValue = 0
    var arrSkills = [SkillsResponseDetail]()
    var arrFiles = [ProjectTaskFilesOngoing]()
    var arrOfOrderList = [OrderListResponseModelDetails]()
    
    var selectedType = ""
    var idOfSubTask = 0
    var projectCategoriesId = 0
    var discriptionData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        handleTap(selectedBtn: btnSubtask, unselectedBtn: btnOrderList, selectedView: viewSelectedSubtask, unselectedView: viewSelectedOrderlist, tblVwHidden: true)
        
        self.lblNoData.isHidden = true
        registerCells()
        self.collVwFiles.delegate = self
        self.collVwFiles.dataSource = self
        
        self.tblVwDeliverables.delegate = self
        self.tblVwProejctType.delegate = self

        self.tblVwDeliverables.dataSource = self
        self.tblVwProejctType.dataSource = self
        
        self.tblVwOrderList.delegate = self
        self.tblVwOrderList.dataSource = self
        
        self.tblVwProejctType.separatorColor = UIColor.clear
        self.tblVwDeliverables.separatorColor = UIColor.clear
        
        self.tblVwOrderList.separatorColor = UIColor.clear
        self.selectedType = "Task"
        self.btnFIndCOs.backgroundColor = UIColor.white
        self.btnFIndCOs.borderColor = UIColor.appColorGreen
        self.btnFIndCOs.layer.borderWidth = 1.0
        self.btnFIndCOs.setTitleColor(UIColor.appColorGreen, for: .normal)
        self.btnFIndCOs.setRoundCorners(radius: 10.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.lblNoData.isHidden = true
        if self.selectedType == "Task" {
            getProjectType()
        } else {
            fetchOrderList()
        }
    }
    
    func fetchOrderList() {
        var params = [String:Any]()
        params = [ "projectId" : self.projectId ,"subtaskId": self.idOfSubTask] as [String : Any]
        self.selectedType = "OrderList"
        ongoingProejctsCOViewModel.getOrderListsApi(params) { [self] model in
            self.arrOfOrderList.removeAll()
            self.arrOfOrderList = model?.data ?? [OrderListResponseModelDetails]()
            if self.arrOfOrderList.count <= 0 {
                self.lblNoData.isHidden = false
            } else {
                self.lblNoData.isHidden = true
            }
            self.tblVwOrderList.reloadData()
        }
    }
    
    func registerCells() {
        self.collVwFiles.register(UINib(nibName: "ProjectFileCollecrtionView", bundle: nil), forCellWithReuseIdentifier: "ProjectFileCollecrtionView")
        tblVwDeliverables.register(UINib.init(nibName: "InviteOtherContractorsDetailDeliverablesTblVwCell", bundle: nil), forCellReuseIdentifier: "InviteOtherContractorsDetailDeliverablesTblVwCell")
        tblVwProejctType.register(UINib.init(nibName: "ProjectTypeTableViewCellHO", bundle: nil), forCellReuseIdentifier: "ProjectTypeTableViewCellHO")
        tblVwOrderList.register(UINib.init(nibName: "OrderListItemTbllVwCell", bundle: nil), forCellReuseIdentifier: "OrderListItemTbllVwCell")
    }
    
    //MARK: FETCH PROJECT TYPE API
    func getProjectType() {
        ongoingProejctsCOViewModel.getSkillListApiCall { response in
            self.arrSkills.removeAll()
            self.arrSkills = response?.data?.listing ?? [SkillsResponseDetail]()
            self.heightProjectTypeTblVw.constant = 40.0
//            self.heightProjectTypeTblVw.constant = CGFloat((self.arrSkills.count) * 40)
            self.tblVwProejctType.reloadData()
            self.fetchOngoingTaskDetails()
        }
    }
    
    func fetchOngoingTaskDetails() {
        ongoingProejctsCOViewModel.getAllOngoingTaskDetailsApi(["projectId":self.projectId]) { [self] model in
            self.selectedType = "Task"
            self.lblTaskName.text = model?.data?.projectDetails?.title ?? ""
            self.discriptionData = model?.data?.projectDetails?.tasks?[0].taskDescription ?? ""
            self.deliverableArray.removeAll()
            self.deliverableArray = model?.data?.projectDetails?.project_deliverable ?? [ProjectDeliverableDetail]()
//            self.deliverablesTblVwHeight.constant = 20.0
            self.tblVwDeliverables.reloadData()
            self.tblVwDeliverables.layoutIfNeeded()
            self.deliverablesTblVwHeight.constant = self.tblVwDeliverables.contentSize.height + CGFloat(20)
//            self.deliverablesTblVwHeight.constant = self.tblVwDeliverables.contentSize.height + CGFloat((self.deliverableArray.count * 20))
            self.projectCategoriesId = 0
            self.projectCategoriesId = model?.data?.projectDetails?.projectCategoriesId ?? 0
            if model?.data?.projectDetails?.bids?.count ?? 0 > 0 {
                var bidCount = 0
                for i in 0 ..< (model?.data?.projectDetails?.bids!.count)! {
                    if model?.data?.projectDetails?.bids?[i].bidStatus == 1 {
                        bidCount = bidCount + 1
                    }
                }
                self.btnViewBids.setTitle("View Bids (\(bidCount))", for: .normal)
            } else {
                self.btnViewBids.setTitle("View Bids (0)", for: .normal)
            }
            self.idOfSubTask = 0
            if model?.data?.projectDetails?.tasks?.count ?? 0 > 0 {
                self.idOfSubTask = model?.data?.projectDetails?.tasks?[0].id ?? 0
                self.lblTopTitle.text = "Task Details"//model?.data?.projectDetails?.title ?? ""
            }
            self.projectTypeValue = model?.data?.projectDetails?.projectCategoriesId ?? 0
//             = "$\(model?.data?.projectDetails?.price ?? Double(0.0))"
            
            var realAmount = "\(model?.data?.projectDetails?.price ?? Double(0.0))"
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal

            let amount = Double(realAmount)
            let formattedString = formatter.string(for: amount)
            self.lblProjectBudget.text =  "$ \(formattedString ?? "")"
            
            self.lblLocation.text = "\(model?.data?.projectDetails?.addressLine1 ?? ""), \(model?.data?.projectDetails?.city ?? "")"
            
            self.arrFiles.removeAll()
            self.arrFiles = model?.data?.projectDetails?.project_files ?? [ProjectTaskFilesOngoing]()
            if self.arrFiles.count == 0 || self.arrFiles == nil {
                attachedFilesLabel.text = "Attached Files"
            } else {
                attachedFilesLabel.text = "Attached Files (\(self.arrFiles.count))"
            }
            attachedFilesLabel
            self.tblVwProejctType.reloadData()
            self.collVwFiles.reloadData()
            
        }
    }
    
    func handleTap(selectedBtn:UIButton, unselectedBtn: UIButton, selectedView: UIView, unselectedView: UIView, tblVwHidden:Bool) {
        selectedBtn.tintColor = UIColor.appSelectedBlack
        unselectedBtn.tintColor = UIColor.appUnSelectedBlack
        selectedView.backgroundColor = UIColor.appColorGreen
        unselectedView.backgroundColor = UIColor.appColorGrey
        tblVwOrderList.isHidden = tblVwHidden
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSubtask(_ sender: Any) {
        lblNoData.isHidden = true
        self.selectedType = "Task"
        handleTap(selectedBtn: btnSubtask, unselectedBtn: btnOrderList, selectedView: viewSelectedSubtask, unselectedView: viewSelectedOrderlist, tblVwHidden: true)
    }
    
    @IBAction func actionorderlist(_ sender: Any) {
        self.selectedType = "OrderList"
        handleTap(selectedBtn: btnOrderList, unselectedBtn: btnSubtask, selectedView: viewSelectedOrderlist, unselectedView: viewSelectedSubtask, tblVwHidden: false)
        fetchOrderList()
    }
    
    @IBAction func actionFindContractors(_ sender: Any) {
        let vc = Storyboard.contractorHO.instantiateViewController(withIdentifier: "ContractorHOVC") as? ContractorHOVC
        vc!.projectId = self.projectId
        vc!.inviteSubtaskIdToContractor = self.projectId
        vc!.isFrom = "InviteContractorsToBid"
        vc!.projectCategoriesId = self.projectCategoriesId
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func actionViewBids(_ sender: Any) {
        let destinationViewController = Storyboard.newHO.instantiateViewController(withIdentifier: "ViewBidsVC") as? ViewBidsVC
        destinationViewController!.id = self.projectId
        destinationViewController!.isFrom = "InvitedTaskCO"
        destinationViewController!.completionHandlerGoToNewProjectDetailScreen = { [weak self] in
            self!.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
}


// MARK: Extension CollectionDelegateFlowLayout

extension InviteOtherContractorsDetailVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: getWidth(title: self.arrFiles[indexPath.row].title ?? ""), height:70)
    }
}

extension InviteOtherContractorsDetailVC:UICollectionViewDelegate{
    
}

extension InviteOtherContractorsDetailVC:UICollectionViewDataSource{
    
    func getWidth(title:String) -> CGFloat{
        let font = UIFont(name: PoppinsFont.medium, size: 14)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let myText = title
        let size = (myText as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size.width + 25 + 45
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectFileCollecrtionView", for: indexPath) as? ProjectFileCollecrtionView
        cell!.projectTitleLabel.text = self.arrFiles[indexPath.row].title ?? ""
            if self.arrFiles.count > 0 {
                cell!.projectTitleLabel.text = "\(self.arrFiles[indexPath.row].title ?? "")"
                if (((self.arrFiles[indexPath.row].title ?? "").contains(".png")) || ((self.arrFiles[indexPath.row].title ?? "").contains(".jpg")) || ((self.arrFiles[indexPath.row].title ?? "").contains(".jpeg"))){
                    if let imgStr = self.arrFiles[indexPath.row].file {
                        cell!.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed: nil)
                    }
                } else {
                    cell!.projectImageView.image = UIImage(named: "doc")
                }
            }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.arrFiles.count > 0 {
            let a = self.arrFiles[indexPath.row].file ?? ""
            let last4 = String(a.suffix(4))
            if last4 == ".png" || last4 == ".jpg" || last4 == "jpeg" {
                let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
                destinationViewController!.isImage = false
                destinationViewController?.imsgeStrURL = a
                destinationViewController?.img = UIImage()
                self.navigationController?.pushViewController(destinationViewController!, animated: true)
            }
//            if (((self.arrFiles[indexPath.row].title ?? "").contains(".png")) || ((self.arrFiles[indexPath.row].title ?? "").contains(".jpg")) || ((self.arrFiles[indexPath.row].title ?? "").contains(".jpeg"))){
//                if let imgStr = self.arrFiles[indexPath.row].file {
//                    let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
//                    destinationViewController!.isImage = false
//                    destinationViewController?.imsgeStrURL = imgStr
//                    destinationViewController?.img = UIImage()
//                    self.navigationController?.pushViewController(destinationViewController!, animated: true)
//                }
//            }
            else {
                if let imgStr = self.arrFiles[indexPath.row].file {
                    if let url = URL(string: imgStr) {
                        UIApplication.shared.open(url)
                    }
                }
//                let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
//                destinationViewController!.isImage = true
//                destinationViewController?.imsgeStrURL = ""
//                destinationViewController?.img = UIImage(named: "doc") ?? UIImage()
//                self.navigationController?.pushViewController(destinationViewController!, animated: true)
            }
        }
    }
    
}

//MARK: TABLE VIEW DELEGATES
extension InviteOtherContractorsDetailVC: UITableViewDelegate,UITableViewDataSource{

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if tableView == tblVwDeliverables{
           return 1 //deliverableArray.count
       } else if tableView == tblVwProejctType{
           return 1 //self.arrSkills.count
       } else if tableView == tblVwOrderList{
           return self.arrOfOrderList.count
       }
     return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblVwDeliverables {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InviteOtherContractorsDetailDeliverablesTblVwCell", for: indexPath) as! InviteOtherContractorsDetailDeliverablesTblVwCell
            cell.lblDeliverableCount.text = "Description"
//            cell.lblDeliverableCount.text = "Description \(indexPath.row + 1)"
            cell.lblDeliverableDesc.text = discriptionData //self.deliverableArray[indexPath.row].deliveralble
            return cell
        } else if tableView == tblVwProejctType {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTypeTableViewCellHO", for: indexPath) as! ProjectTypeTableViewCellHO
//            for i in 0..<self.arrSkills.count {
//                cell.lblTitle.text = self.arrSkills[i].title ?? ""
//                cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled")
//            }
//            cell.lblTitle.text = self.arrSkills[indexPath.row].title ?? ""
//            if self.projectTypeValue == (self.arrSkills[indexPath.row].title ?? "") {
//                cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled")
//            } else {
//                cell.imgCheckBox.image = UIImage(named: "ic_check_box")
//            }
            // ------
            for i in 0..<self.arrSkills.count {
                cell.lblTitle.text = "\(self.projectTypeValue)"
                if self.projectTypeValue == self.arrSkills[i].id ?? 0 {
                    cell.lblTitle.text = "\(self.arrSkills[i].title ?? "")"
                    cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled")
                    break
                } else {
                    cell.imgCheckBox.image = UIImage(named: "ic_check_box")
//                    cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled")
                }
            }
            // -------
            return cell
        }
        else if tableView == tblVwOrderList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListItemTbllVwCell", for: indexPath) as! OrderListItemTbllVwCell
            cell.venderName.text = "\(self.arrOfOrderList[indexPath.row].vendor_detail?.firstName ?? "") \(self.arrOfOrderList[indexPath.row].vendor_detail?.lastName ?? "")"
            cell.itemLbl.text = "\(self.arrOfOrderList[indexPath.row].TotalItem ?? 0)"
            cell.categoryLbl.text = self.arrOfOrderList[indexPath.row].Cart_Item?[0].productsss?.category ?? ""
//            cell.PriceLbl.text = "$\(self.arrOfOrderList[indexPath.row].TotalPrice ?? Double(0.0))"
            
            var realAmount = "\(self.arrOfOrderList[indexPath.row].TotalPrice ?? Double(0.0))"
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal

            let amount = Double(realAmount)
            let formattedString = formatter.string(for: amount)
            cell.PriceLbl.text =  "$ \(formattedString ?? "")"
            
            cell.orderByLbl.text = "\(self.arrOfOrderList[indexPath.row].cart_contractor?.firstName ?? "") \((self.arrOfOrderList[indexPath.row].cart_contractor?.lastName ?? ""))"
            cell.dateLbl.text = DateHelper.convertDateString(dateString: "\(self.arrOfOrderList[indexPath.row].createdAt ?? "2024-04-08T00:00:00.000Z")", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
            
            cell.btnComplete.tag = indexPath.row
            cell.btnCancel.tag = indexPath.row
            
            cell.btnComplete.addTarget(self, action: #selector(updateComplete(sender:)), for: .touchUpInside)
            cell.btnCancel.addTarget(self, action: #selector(updateCancel(sender:)), for: .touchUpInside)
            cell.vwStatus.backgroundColor = UIColor.appBtnColorOrange
            cell.disputesStackView.isHidden = true
            
            if self.arrOfOrderList[indexPath.row].dispute?.count ?? 0 > 0 {
                if self.arrOfOrderList[indexPath.row].dispute?[0].isAdminResolved == 0 {
                    if self.arrOfOrderList[indexPath.row].isContractor == 1 {
                        cell.btnStckVw.isHidden = true
                        cell.lblStatus.text = "Disputed"
                    } else {
                        cell.btnStckVw.isHidden = false
                        if self.arrOfOrderList[indexPath.row].status == 0 {
                            cell.btnComplete.isHidden = true
                            cell.btnCancel.isHidden = false
                            cell.btnCancel.setTitle("Cancel", for: .normal)
                            cell.lblStatus.text = "Request Sent"
                        } else if self.arrOfOrderList[indexPath.row].status == 1 {
                            cell.btnCancel.isHidden = false
                            cell.btnComplete.isHidden = false
                            cell.btnComplete.setTitle("Accept Order", for: .normal)
                            cell.btnCancel.setTitle("Decline", for: .normal)
                            cell.lblStatus.text = "Quote Received"
                        } else if self.arrOfOrderList[indexPath.row].status == 2 {
                            cell.btnCancel.isHidden = false
                            cell.btnComplete.isHidden = true
                            cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
                            cell.lblStatus.text = "Accepted"
                        } else if self.arrOfOrderList[indexPath.row].status == 3 {
                            cell.btnCancel.isHidden = true
                            cell.btnComplete.isHidden = true
                            cell.lblStatus.text = "Declined"
                        } else if self.arrOfOrderList[indexPath.row].status == 4 {
                            cell.btnCancel.isHidden = false
                            cell.btnComplete.isHidden = false
                            cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
                            cell.btnComplete.setTitle("Mark As Received", for: .normal)
                            cell.lblStatus.text = "Dispatch"
                        } else if self.arrOfOrderList[indexPath.row].status == 5 {
                            cell.btnCancel.isHidden = false
                            cell.btnComplete.isHidden = true
                            cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
                            cell.vwStatus.backgroundColor = UIColor.appColorGreen
                            cell.lblStatus.text = "Delivered"
                        }
                    }
                } else {
                    cell.btnStckVw.isHidden = false
                    if self.arrOfOrderList[indexPath.row].status == 0 {
                        cell.btnComplete.isHidden = true
                        cell.btnCancel.isHidden = false
                        cell.btnCancel.setTitle("Cancel", for: .normal)
                        cell.lblStatus.text = "Request Sent"
                    } else if self.arrOfOrderList[indexPath.row].status == 1 {
                        cell.btnCancel.isHidden = false
                        cell.btnComplete.isHidden = false
                        cell.btnComplete.setTitle("Accept Order", for: .normal)
                        cell.btnCancel.setTitle("Decline", for: .normal)
                        cell.lblStatus.text = "Quote Received"
                    } else if self.arrOfOrderList[indexPath.row].status == 2 {
                        cell.btnCancel.isHidden = false
                        cell.btnComplete.isHidden = true
                        cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
                        cell.lblStatus.text = "Accepted"
                    } else if self.arrOfOrderList[indexPath.row].status == 3 {
                        cell.btnCancel.isHidden = true
                        cell.btnComplete.isHidden = true
                        cell.lblStatus.text = "Declined"
                    } else if self.arrOfOrderList[indexPath.row].status == 4 {
                        cell.btnCancel.isHidden = false
                        cell.btnComplete.isHidden = false
                        cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
                        cell.btnComplete.setTitle("Mark As Received", for: .normal)
                        cell.lblStatus.text = "Dispatch"
                    } else if self.arrOfOrderList[indexPath.row].status == 5 {
                        cell.btnCancel.isHidden = false
                        cell.btnComplete.isHidden = true
                        cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
                        cell.vwStatus.backgroundColor = UIColor.appColorGreen
                        cell.lblStatus.text = "Delivered"
                    }
                }
                
            } else {
                cell.btnStckVw.isHidden = false
                if self.arrOfOrderList[indexPath.row].status == 0 {
                    cell.btnComplete.isHidden = true
                    cell.btnCancel.isHidden = false
                    cell.btnCancel.setTitle("Cancel", for: .normal)
                    cell.lblStatus.text = "Request Sent"
                } else if self.arrOfOrderList[indexPath.row].status == 1 {
                    cell.btnCancel.isHidden = false
                    cell.btnComplete.isHidden = false
                    cell.btnComplete.setTitle("Accept Order", for: .normal)
                    cell.btnCancel.setTitle("Decline", for: .normal)
                    cell.lblStatus.text = "Quote Received"
                } else if self.arrOfOrderList[indexPath.row].status == 2 {
                    cell.btnCancel.isHidden = false
                    cell.btnComplete.isHidden = true
                    cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
                    cell.lblStatus.text = "Accepted"
                } else if self.arrOfOrderList[indexPath.row].status == 3 {
                    cell.btnCancel.isHidden = true
                    cell.btnComplete.isHidden = true
                    cell.lblStatus.text = "Declined"
                } else if self.arrOfOrderList[indexPath.row].status == 4 {
                    cell.btnCancel.isHidden = false
                    cell.btnComplete.isHidden = false
                    cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
                    cell.btnComplete.setTitle("Mark As Received", for: .normal)
                    cell.lblStatus.text = "Dispatch"
                } else if self.arrOfOrderList[indexPath.row].status == 5 {
                    cell.btnCancel.isHidden = false
                    cell.btnComplete.isHidden = true
                    cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
                    cell.vwStatus.backgroundColor = UIColor.appColorGreen
                    cell.lblStatus.text = "Delivered"
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }

    @objc func updateComplete(sender: UIButton) {
        if self.arrOfOrderList[sender.tag].status == 1 {
            self.updateStatus(cardStatus: 2, cartId: self.arrOfOrderList[sender.tag].id  ?? 0)
        } else if self.arrOfOrderList[sender.tag].status == 4 {
            self.updateStatus(cardStatus: 5, cartId: self.arrOfOrderList[sender.tag].id  ?? 0)
        }
    }
    
    @objc func updateCancel(sender: UIButton) {
        if self.arrOfOrderList[sender.tag].status == 0 {
            self.updateStatus(cardStatus: 6, cartId: self.arrOfOrderList[sender.tag].id  ?? 0)
        } else if self.arrOfOrderList[sender.tag].status == 1 {
            self.updateStatus(cardStatus: 3, cartId: self.arrOfOrderList[sender.tag].id  ?? 0)
        } else if self.arrOfOrderList[sender.tag].status == 2 {
            //raise dispute
            self.goToRaiseDispute(indx: sender.tag)
        } else if self.arrOfOrderList[sender.tag].status == 4 {
            //raise dispute
            self.goToRaiseDispute(indx: sender.tag)
        } else if self.arrOfOrderList[sender.tag].status == 5 {
            //raise dispute
            self.goToRaiseDispute(indx: sender.tag)
        }
    }
    
    func goToRaiseDispute(indx:Int) {
        let destinationViewController = Storyboard.orderMaterial.instantiateViewController(withIdentifier: "RaiseADisputeVC") as? RaiseADisputeVC
        
        destinationViewController?.projectId = self.projectId
        destinationViewController?.subTaskId = self.idOfSubTask
        destinationViewController?.price = self.arrOfOrderList[indx].TotalPrice ?? Double(0.0)
        destinationViewController?.cartId = self.arrOfOrderList[indx].id ?? 0
        destinationViewController?.completionHandlerGoToOrderListing = { [weak self] in
            self?.fetchOrderList()
        }
        self.present(destinationViewController!, animated: true)
    }
    
    func updateStatus(cardStatus:Int, cartId:Int) {
        let params = ["cartId":"\(cartId)" , "cardStatus":"\(cardStatus)"]
        ongoingProejctsCOViewModel.updatecartStatusApi(params) { [self] model in
            self.fetchOrderList()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblVwDeliverables {
            return UITableView.automaticDimension
        } else if tableView == tblVwProejctType{
            return 40.0
        } else if tableView == tblVwOrderList{
            return UITableView.automaticDimension
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblVwOrderList {
            let destinationVC = Storyboard.orderMaterial.instantiateViewController(withIdentifier: "OrderListDetailVC") as? OrderListDetailVC
            destinationVC?.orderListItem = self.arrOfOrderList[indexPath.row]
            destinationVC?.projectId = self.projectId
            destinationVC?.subTaskId = self.idOfSubTask
            self.navigationController?.pushViewController(destinationVC!, animated: true)
        }
    }
}
