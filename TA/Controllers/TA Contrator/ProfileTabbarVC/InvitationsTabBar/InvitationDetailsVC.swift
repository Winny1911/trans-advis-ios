//
//  InvitationDetails.swift
//  TA
//
//  Created by Applify  on 22/12/21.
//

import UIKit
import SDWebImage

class InvitationDetailsVC: BaseViewController {
    
    @IBOutlet weak var projectDilevrableLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var projectDeliverableLabel: UILabel!
    @IBOutlet weak var projectTypeLabel: UILabel!
    @IBOutlet weak var homeOwnerTopConstarint: NSLayoutConstraint!
    @IBOutlet weak var vwProjectFiles: UIView!
    
    @IBOutlet weak var bottomVw: UIView!
    @IBOutlet weak var topViewOne: UIView!
    @IBOutlet weak var topViewTwo: UIView!
    @IBOutlet weak var topViewThree: UIView!
    @IBOutlet weak var topViewFour: UIView!
    @IBOutlet weak var topViewFive: UIView!
    
    @IBOutlet weak var lblHomeOwnerName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTopTitle: UILabel!
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAMount: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSendMessage: UIButton!
    
    var invitationDetail = InvitationsDetails()
    let manageBidDetailViewModel: ManageBidDetailViewModel = ManageBidDetailViewModel()
    var completionHandlerGoToInvitationScreenFromPlaceBid: (() -> Void)?
    var diverableData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.invitationDetail.project_data?.project_files?.count)
        userImage.setRoundCorners(radius: userImage.frame.height / 2)
        btnSendMessage.layer.borderColor = (UIColor( red: 78/255, green: 199/255, blue:41/255, alpha: 1.0 )).cgColor
        btnSendMessage.layer.borderWidth = 1.5
        bottomVw.addCustomShadow()
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
        topView.layer.shadowRadius = 5.0
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize.zero
        
        self.collectionVw.register(UINib(nibName: "ProjectFileCollecrtionView", bundle: nil), forCellWithReuseIdentifier: "ProjectFileCollecrtionView")
        self.collectionVw.delegate = self
        self.collectionVw.dataSource = self
        
        self.readNotificationApi()
    }

    override func viewWillAppear(_ animated: Bool) {
//
//        if invitationDetail.project_details?.projectType == 1 {
//            self.topLeftVw.backgroundColor = UIColor.appColorBlue
//            self.topLeftTitle.text = "Main Project"
//        } else {
//            self.topLeftTitle.text = "Sub Task"
//            self.topLeftVw.backgroundColor = UIColor.appBtnColorOrange
//        }
//
        lblTopTitle.text = "Invitation Details" //invitationDetail.project_data?.title
        lblTitle.text = invitationDetail.project_data?.title
        lblDesc.text = invitationDetail.project_data?.description
        lblAMount.text = "$ \(invitationDetail.project_data?.price ?? 0)"
        if invitationDetail.project_data?.projectType == 1 {
            self.reviewLabel.text = "Contractor"
            self.projectDilevrableLabel.text = "Description"
            
        } else if invitationDetail.project_data?.projectType == 0 {
            self.reviewLabel.text = "Homeowner"
            self.projectDilevrableLabel.text = "Project Deliverable"
        }
        var realAmount = "\(invitationDetail.project_data?.price ?? 0)"
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal

        let amount = Double(realAmount)
        let formattedString = formatter.string(for: amount)
        lblAMount.text =  "$ \(formattedString ?? "")"
        
        self.lblDate.text = DateHelper.convertDateString(dateString: invitationDetail.createdAt, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
        self.userImage.sd_setImage(with: URL(string: invitationDetail.project_data?.user_data?.profilePic ?? ""), placeholderImage: UIImage(named: "Ic_profile"), completed:nil)
        self.lblHomeOwnerName.text = "\(invitationDetail.project_data?.user_data?.firstName ?? "") \(invitationDetail.project_data?.user_data?.lastName ?? "")"
//        let rating = invitationDetail.project_data?.user_data?.rating
//        let ratingValue = Double(rating ?? "")
//        if ratingValue! <= 5 && ratingValue! > 4 {
//            self.topViewFive.isHidden = true
//        } else if ratingValue! <= 4 && ratingValue! > 3 {
//            self.topViewFour.isHidden = true
//        } else if ratingValue! <= 3 && ratingValue! > 2 {
//            self.topViewThree.isHidden = true
//        } else if ratingValue! <= 2 && ratingValue! > 1 {
//            self.topViewTwo.isHidden = true
//        } else if ratingValue! <= 1 || ratingValue! > 0 {
//            self.topViewOne.isHidden = true
//        }
        
        let ratingss = invitationDetail.project_data?.user_data?.rating
        let ratingValuess = Double(ratingss ?? "")
        self.topViewFive.isHidden = false
        self.topViewFour.isHidden = false
        self.topViewThree.isHidden = false
        self.topViewTwo.isHidden = false
        self.topViewOne.isHidden = false
        
        if ratingValuess == Double(5.0) {
            self.topViewOne.isHidden = true
        }
        else if ratingValuess ?? Double(0.0) <= Double(4.9) && ratingValuess ?? Double(0.0) >= Double(4.0) {
            self.topViewTwo.isHidden = true
        }
        else if ratingValuess ?? Double(0.0) <= Double(3.9) && ratingValuess ?? Double(0.0) >= Double(3.0) {
            self.topViewThree.isHidden = true
        }
        else if ratingValuess ?? Double(0.0) <= Double(2.9) && ratingValuess ?? Double(0.0) >= Double(2.0){
            self.topViewFour.isHidden = true
        }
        else if ratingValuess ?? Double(0.0) <= Double(1.9) && ratingValuess ?? Double(0.0) >= Double(1.0){
            self.topViewFive.isHidden = true
        }
        if self.invitationDetail.project_data?.project_files?.count ?? 0 <= 0{
            self.vwProjectFiles.isHidden = true
            self.homeOwnerTopConstarint.constant = -120
        } else {
            self.vwProjectFiles.isHidden = false
            self.homeOwnerTopConstarint.constant = 23
        }
        self.addressLabel.text = "\(self.invitationDetail.project_data?.addressLine1 ?? "" )"
//        if self.invitationDetail.project_data?.addressLine1 ?? "" == self.invitationDetail.project_data?.addressLine2 ?? "" {
//            self.addressLabel.text = "\(self.invitationDetail.project_data?.addressLine2 ?? "" ), \(self.invitationDetail.project_data?.zipCode ?? "")"
//        } else {
//            self.addressLabel.text = "\(self.invitationDetail.project_data?.addressLine1 ?? "" ), \(self.invitationDetail.project_data?.city ?? "" ), \(self.invitationDetail.project_data?.state ?? ""), \(self.invitationDetail.project_data?.zipCode ?? "")"
//        }
        
        self.projectTypeLabel.text = self.invitationDetail.project_data?.projectCategories?.title ?? "" //"\(self.invitationDetail.project_data?.type ?? "" )"
        for i in 0..<(self.invitationDetail.project_data?.project_deliverable?.count ?? 0) {
            diverableData.append("\(String(describing: self.invitationDetail.project_data?.project_deliverable?[i].deliveralble ?? ""))")
        }
        diverableData.removingDuplicates()
        diverableData.removeDuplicates()
        var diverable = diverableData.map{String($0)}.joined(separator: ", ")
        self.projectDeliverableLabel.text = "\(diverable)"
        self.diverableData.removeAll()
        if invitationDetail.project_data?.projectType == 1 {
            self.projectDeliverableLabel.text = self.invitationDetail.project_data?.taskDescription ?? ""
        }
    }
    
    //MARK: ACTION PLACE BID
    @IBAction func actionPlaceBid(_ sender: Any) {
        let vc = Storyboard.invitation.instantiateViewController(withIdentifier: "PlaceBidVC") as? PlaceBidVC
        vc!.projectId = self.invitationDetail.project_data?.id ?? 0
        vc!.projectTitle = self.invitationDetail.project_data?.title ?? ""
        vc!.projectDesc = self.invitationDetail.project_data?.description ?? ""
        vc!.fetchHomeOwner = self.lblHomeOwnerName.text ?? ""
        vc!.fetchHomeOwnerB = self.lblHomeOwnerName.text ?? ""
        vc!.fetchStreetAddress = self.addressLabel.text ?? ""
        vc!.fetchCellPhone = self.invitationDetail.project_data?.user_data?.phoneNumber ?? ""
        vc!.fetchMailingAddress = self.addressLabel.text ?? ""
        vc!.fetchEmail = self.invitationDetail.project_data?.user_data?.email ?? ""
        vc!.invitationDetail = self.invitationDetail
        //vc?.arrProjectFiles = [self.invitationDetail.project_data?.project_files]
        vc!.fromInvitation = true
//        if self.invitationDetail.project_data?.project_files?.count ?? 0 > 0 {
//            vc!.arrProjectUploadFiles = self.invitationDetail.project_data?.project_files as [ProjectFiles]
//        } else {
//            vc!.imageUrl = ""
//        }
        vc!.completionHandlerGoToInvitationDetailScreenFromPlaceBid = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
            self!.completionHandlerGoToInvitationScreenFromPlaceBid?()
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func sentMessageButtonAction(_ sender: UIButton) {
        if let chatController = Storyboard.messageHO.instantiateViewController(withIdentifier: "ChatWindowViewController") as? ChatWindowViewController {
            let user_id = String("ID_\(self.invitationDetail.project_data?.userId ?? 0)")
            let user_name = (self.invitationDetail.project_data?.user_data?.firstName ?? "") + " " + (self.invitationDetail.project_data?.user_data?.lastName ?? "")
            let user_image = self.invitationDetail.project_data?.user_data?.profilePic ?? ""
            
            chatController.hidesBottomBarWhenPushed = true
            chatController.viewModel.user_id = user_id
            chatController.viewModel.user_name = user_name
            chatController.viewModel.user_image = user_image
            
            self.navigationController?.pushViewController(chatController, animated: true)
        }
    }
    
    //MARK: ACTION BACK
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //    self.invitationDetail.project_data?.id
    
    func getBidDetailsById() {
        let params = ["id": self.invitationDetail.project_data?.id ?? 0]
        self.manageBidDetailViewModel.getManageBidsDetailApiV2(params) { modelPDF in
            guard let model = modelPDF?.data else { return }
            let paramsPDF : [String: Any] = [
                "date": model.date!,
                "homeOwner1":  model.homeOwner1!,
                "homeOwner2": model.homeOwner2!,
                "streetAddress": model.streetAddress!,
                "mailingAddress": model.mailingAddress!,
                "cellPhone": model.cellPhone!,
                "email": model.email!,
                "hoa": model.hoa!,
                "permit": "\(model.permit! == 1 ? "true" : "false")",
                "insurance": model.insurance!,
                "claimNumber": model.claimNumber!,
                "insFullyApproved": "\(model.insFullyApproved! == 1 ? "true" : "false")",
                "insPartialApproved": "\(model.insPartialApproved!)",
                "retail1": "\(model.retail1! == 1 ? "true" : "false")",
                "retailDepreciation": "\(model.retailDepreciation! == 1 ? "true" : "false")",
                "mainDwellingRoofSQ": model.mainDwellingRoofSQ!,
                "detachedGarageSQ": model.detachedGarageSQ!,
                "shedSQ": model.shedSQ!,
                "decking": model.decking!,
                "flatRoofSQ": model.flatRoofSQ!,
                "totalSQ": model.totalSQ!,
                "total": model.total!,
                "deducible": model.deducible!,
                "fe": model.fe!,
                "retail2": model.retail2!,
                "be": model.be!,
                "brand": model.brand!,
                "style": model.style!,
                "color1": model.color1!,
                "dripEdgeF55": model.dripEdgeF55!,
                "counterFlashing": model.counterFlashing!,
                "syntheticUnderlayment": model.syntheticUnderlayment!,
                "ridgeVent": model.ridgeVent!,
                "cutInstallRidgeVent": "\(model.cutInstallRidgeVent! == 1 ? "true" : "false")",
                "chimneyFlashing": model.chimneyFlashing!,
                "sprayPaint": model.sprayPaint!,
                "turtleVents": model.turtleVents!,
                "permaBoot123": model.permaBoot123!,
                "permaBoot34": model.permaBoot34!,
                "pipeJack123": model.pipeJack123!,
                "pipeJack34": model.pipeJack34!,
                "atticFan": model.atticFan!,
                "color2": model.color2!,
                "satelliteDish": "\(model.satelliteDish! == 1 ? "true" : "false")",
                "antenna": "\(model.antenna! == 1 ? "true" : "false")",
                "lightningRod": model.lightningRod!,
                "materialLocation": model.materialLocation!,
                "dumpsterLocation": model.dumpsterLocation!,
                "specialInstructions": model.specialInstructions!,
                "notes": model.notes!,
                "roofing1": model.roofing1!,
                "roofing2": model.roofing2!,
                "debrisRemoval1": model.debrisRemoval1!,
                "debrisRemoval2": model.debrisRemoval2!,
                "overheadProfit1": model.overheadProfit1!,
                "overheadProfit2": "",
                "codeUpgrades": model.codeUpgrades!,
                "paymentTerms1": "\(model.paymentTerms1! == 1 ? "true" : "false")",
                "paymentTerms2": "\(model.paymentTerms2! == 1 ? "true" : "false")",
                "homeOwnerSign1": model.homeOwnerSign1!,
                "homeOwnerSign2": model.homeOwnerSign2!,
                "homeOwnerSignDate1": model.homeOwnerSignDate1!,
                "homeOwnerSignDate2": model.homeOwnerSignDate2!,
                "aegcRepresentativeDate": model.aegcRepresentativeDate!,
                "homeOwnerInitial1": model.homeOwnerInitial1!,
                "homeOwnerInitial2": model.homeOwnerInitial2!,
                "id": "\(self.invitationDetail.id ?? 0)",
                "projectId": "\(self.invitationDetail.project_data?.id ?? 0)",
                "bidStatus": "\(model.bidStatus! == 1 ? "true" : "false")",
                "createdAt":model.createdAt!,
                "updatedAt":model.updatedAt!,
                "isBlocked":"\(model.isBlocked! == 1 ? "true" : "false")",
                "isDeleted":"\(model.isDeleted! == 1 ? "true" : "false")",
                "project_agreement":""] as [String : Any]
            self.doDownloadPDF(params: paramsPDF)
        }
    }
    
    func doDownloadPDF(params: [String:Any]) {
        manageBidDetailViewModel.downloadPDF(params, context: self)
    }
    
    @IBAction func actionDownloadPDF(_ sender: Any) {
        getBidDetailsById()
    }
    
    
    func readNotificationApi() {

        let param = ["id": "\(invitationDetail.notification?.id ?? 0)", "isRead": 1] as [String : Any]
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<NotificationResponseModel>.makeApiCall(APIUrl.UserApis.notificationHO, params: param, headers: headers, method: .put) { (response, resultModel) in

            if resultModel?.statusCode != 200 {
                showMessage(with: response?["message"] as? String ?? "")
            } else {
                self.getNotificationApi()
            }
        }
    }
    
    func getNotificationApi() {
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<NotificationResponseModel>.makeApiCall(APIUrl.UserApis.notificationHO, params: [:], headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200 {
                if let unreadList = resultModel?.data?.listing?.filter({ $0.isRead == 0}), !unreadList.isEmpty {
                    isNotificationRead = false
                    
                    for notificationItem in unreadList {
                        if (notificationItem.type == 101 || notificationItem.type == 117) {
                            isInviteNotificationRead = false
                            break
                        } else {
                            isInviteNotificationRead = true
                        }
                    }
                } else {
                    isInviteNotificationRead = true
                    isNotificationRead = true
                }
            } else {
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
}

extension InvitationDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func getWidth(title:String) -> CGFloat{
        let font = UIFont(name: PoppinsFont.medium, size: 14)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let myText = title
        let size = (myText as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size.width + 25 + 45
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.invitationDetail.project_data?.project_files?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectFileCollecrtionView", for: indexPath) as? ProjectFileCollecrtionView
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        cell!.projectTitleLabel.text = self.invitationDetail.project_data?.project_files?[indexPath.row].title ?? ""
        cell!.projectImageView.image = nil
        if self.invitationDetail.project_data?.project_files?.count ?? 0 > 0 {
            if var imgStr = self.invitationDetail.project_data?.project_files?[indexPath.row].file {
                imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                cell!.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed:nil)
            }
        }
        return cell!
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.invitationDetail.project_data?.project_files?.count ?? 0 > 0  {
            if self.invitationDetail.project_data?.project_files?[indexPath.row].type == "png" || self.invitationDetail.project_data?.project_files?[indexPath.row].type == "jpg" || self.invitationDetail.project_data?.project_files?[indexPath.row].type == "jpeg" {
                if let imgStr = self.invitationDetail.project_data?.project_files?[indexPath.row].file {
                    
                    let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
                    destinationViewController!.isImage = false
                    destinationViewController?.imsgeStrURL = imgStr
                    destinationViewController?.img = UIImage()
                    self.navigationController?.pushViewController(destinationViewController!, animated: true)
                    
                }
            } else {
                if let imgStr = self.invitationDetail.project_data?.project_files?[indexPath.row].file {
                    if let url = URL(string: imgStr) {
                        UIApplication.shared.open(url)
                    }
                }
                //                    let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
                //                    destinationViewController!.isImage = true
                //                    destinationViewController?.imsgeStrURL = ""
                //                    destinationViewController?.img = UIImage(named: "doc") ?? UIImage()
                //                    self.navigationController?.pushViewController(destinationViewController!, animated: true)
            }
        }
    }
}

extension InvitationDetailsVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: getWidth(title: self.invitationDetail.project_data?.project_files?[indexPath.row].title ?? ""), height:70)
//        return CGSize(width: 150.0, height:61)
    }
}

extension InvitationDetailsVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
