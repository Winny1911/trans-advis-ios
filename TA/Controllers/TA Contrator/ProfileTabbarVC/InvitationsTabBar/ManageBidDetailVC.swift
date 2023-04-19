//
//  ManageBidDetailVC.swift
//  TA
//
//  Created by Applify  on 03/01/22.
//

import UIKit
import SDWebImage
import Alamofire
class ManageBidDetailVC: BaseViewController {

    @IBOutlet weak var projectDeliverable: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var projectDeliverableLabel: UILabel!
    @IBOutlet weak var projectTypeLabel: UILabel!
    @IBOutlet weak var btmVwheight: NSLayoutConstraint!
    @IBOutlet weak var topConstarintAttachedFiles: NSLayoutConstraint!
    @IBOutlet weak var vwEndsDateTwo: UIView!
    @IBOutlet weak var blurVww: UIView!
    @IBOutlet weak var lblDateEndsOnTwo: UILabel!
    @IBOutlet weak var lblStaticEndsOnTwo: UILabel!
    @IBOutlet weak var lblStaticNotableItems: UILabel!
    @IBOutlet weak var lblStaticEndsOn: UILabel!
    @IBOutlet weak var lblStaticStartedOn: UILabel!
    @IBOutlet weak var vwTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblAcceptedBidAmount: UILabel!
    @IBOutlet weak var lblAcceptedStartEndDate: UILabel!
    @IBOutlet weak var lblHomeOwner: UILabel!
    @IBOutlet weak var btnSendMsg: UIButton!
    @IBOutlet weak var imgHomeOwner: UIImageView!
    @IBOutlet weak var btnViewProfile: UIButton!
    @IBOutlet weak var vwAcceptedBid: UIView!
    
    @IBOutlet weak var lblAttachedFiles: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var btnRecallBid: UIButton!
    @IBOutlet weak var btnViewBidLog: UIButton!
    //@IBOutlet weak var bottomVw: UIView!
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var lblNotableItems: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblDateStart: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var llblTitle: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var vwStatus: UIView!
    @IBOutlet weak var topLeftTitle: UILabel!
    @IBOutlet weak var topLeftVw: UIView!
    @IBOutlet weak var lblTopTitle: UILabel!
    @IBOutlet weak var btnDownloadPDF: UIButton!
    
    var manageBidId = 0
    let manageBidDetailViewModel: ManageBidDetailViewModel = ManageBidDetailViewModel()
    var arrProjectFiles = [BidsDocumentsDetails]()
    var arrProjectUploadFiles = [ProjectFiles]()
    //var manageBids: ManageBidsResponseDetails?
    var manageBids: ManageBidsResponseDetailsV2?
    let placeBidViewModel: PlaceBidViewModel = PlaceBidViewModel()
    var bidStatus = 0
    var projectId = 0
    var projectTitle = ""
    var diverableData = [String]()
    var docController: UIDocumentInteractionController!
    var document_path: String! = ""
    var document_name: String! = ""
    var documentInteractionController: UIDocumentInteractionController!
    
    
    var inviteTask = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNotificationCenter()
        self.blurVww.isHidden = true
        self.lblStaticEndsOnTwo.isHidden = true
        self.lblDateEndsOnTwo.isHidden = true
        self.vwTopConstraint.constant = 24.0
        self.imgHomeOwner.setRoundCorners(radius: self.imgHomeOwner.frame.height / 2)
        self.btnViewProfile.setRoundCorners(radius: 5.0)
        self.btnSendMsg.setRoundCorners(radius: 5.0)
        self.vwAcceptedBid.isHidden = true
        topLeftVw.setRoundCorners(radius: 5.0)
        vwStatus.setRoundCorners(radius: vwStatus.frame.height / 2)
        btnViewBidLog.layer.borderColor = (UIColor( red: 78/255, green: 199/255, blue:41/255, alpha: 1.0 )).cgColor
        btnViewBidLog.layer.borderWidth = 1.5
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
        topView.layer.shadowRadius = 5.0
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize.zero
        
        self.collectionVw.register(UINib(nibName: "ProjectFileCollecrtionView", bundle: nil), forCellWithReuseIdentifier: "ProjectFileCollecrtionView")
        self.collectionVw.delegate = self
        self.collectionVw.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchManageBidDetal()
    }
    
    func setNotificationCenter() {
        NotificationCenter.default.addObserver(forName: Notification.Name("FILESAVED"), object: nil, queue: .main) { notification in
            if let fileURL = notification.object as? URL {
                print("Arquivo salvo em \(fileURL.absoluteString)")
                Progress.instance.hide()
                self.documentInteractionController = UIDocumentInteractionController(url: fileURL)
                self.documentInteractionController.delegate = self
                self.documentInteractionController.presentPreview(animated: true)
            }
        }
    }

    @IBAction func sentMessageButtonAction(_ sender: UIButton) {
        if let chatController = Storyboard.messageHO.instantiateViewController(withIdentifier: "ChatWindowViewController") as? ChatWindowViewController {
            let dictionary = self.manageBids
            let user_id = String("ID_\(self.manageBids?.project_details?.user_ProjectDetail?.id ?? 0)")
            let user_name = (self.manageBids?.project_details?.user_ProjectDetail?.firstName ?? "") + " " + (self.manageBids?.project_details?.user_ProjectDetail?.lastName ?? "")
            let user_image = self.manageBids?.project_details?.user_ProjectDetail?.profilePic ?? ""

            chatController.hidesBottomBarWhenPushed = true
            chatController.viewModel.user_id = user_id
            chatController.viewModel.user_name = user_name
            chatController.viewModel.user_image = user_image
            self.navigationController?.pushViewController(chatController, animated: true)
        }
    }

    func fetchManageBidDetal() {
        let params = ["id": manageBidId]
        
        manageBidDetailViewModel.getManageBidsDetailApiV2(params) { model in
            self.manageBids = model?.data
            self.lblTopTitle.text = "Bid Details" //model?.data?.project_details?.title ?? ""
            self.bidStatus = model?.data?.bidStatus ?? 0
            self.projectId = model?.data?.project_details?.id ?? 0
            self.projectTitle = model?.data?.project_details?.title ?? ""
            self.btnRecallBid.isUserInteractionEnabled = true
            
            self.topLeftVw.isHidden = false
            self.vwStatus.isHidden = false
            self.vwAcceptedBid.isHidden = true
            self.vwTopConstraint.constant = 24.0
            self.blurVww.isHidden = true
            self.lblStaticEndsOnTwo.isHidden = true
            self.lblDateEndsOnTwo.isHidden = true
            self.lblStaticEndsOn.isHidden = false
            self.lblEndDate.isHidden = false
            
            self.lblNotableItems.isHidden = false
            self.lblStaticNotableItems.isHidden = false
            self.vwEndsDateTwo.isHidden = false
            self.topConstarintAttachedFiles.constant = 18.0
            self.lblStaticStartedOn.text! = "Started On"
            self.lblStaticNotableItems.text! = "Notable Terms"
            self.lblStaticEndsOn.text = "Ends On"
            
            self.llblTitle.text = model?.data?.project_details?.title ?? ""
            self.lblDesc.text = model?.data?.description ?? ""
            self.addressLabel.text = "\(model?.data?.project_details?.addressLine1 ?? "" )"
//            if model?.data?.project_details?.addressLine1 ?? "" == model?.data?.project_details?.addressLine2 ?? "" {
//                self.addressLabel.text = "\(model?.data?.project_details?.addressLine2 ?? "" ), \(model?.data?.project_details?.zipCode ?? "")"
//            } else {
//                self.addressLabel.text = "\(model?.data?.project_details?.addressLine1 ?? "" ), \(model?.data?.project_details?.city ?? "" ), \(model?.data?.project_details?.state ?? ""), \(model?.data?.project_details?.zipCode ?? "")"
//            }
            
            self.projectTypeLabel.text = "\(model?.data?.project_details?.type ?? "" )"
            for i in 0..<(model?.data?.project_details?.project_deliverable?.count ?? 0) {
                self.diverableData.append("\(String(describing: model?.data?.project_details?.project_deliverable?[i].deliveralble ?? ""))")
            }
            self.diverableData.removingDuplicates()
            self.diverableData.removeDuplicates()
            var diverable = self.diverableData.map{String($0)}.joined(separator: ", ")
            self.projectDeliverableLabel.text = "\(diverable)"
            self.diverableData.removeAll()
//            self.lblAmount.text = "$ \(model?.data?.bidAmount ?? "")"
            
            var realAmount = "\(model?.data?.bidAmount ?? "")"
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal

            let amount = Double(realAmount)
            let formattedString = formatter.string(for: amount)
            self.lblAmount.text = "$ \(formattedString ?? "")"
            
            self.lblDateStart.text = DateHelper.convertDateString(dateString: model?.data?.proposedStartDate ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
            self.lblEndDate.text = DateHelper.convertDateString(dateString: model?.data?.proposedEndDate ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
            self.lblNotableItems.text = model?.data?.description ?? ""
            
            if model?.data?.project_details?.projectType == 1 {
                self.topLeftVw.backgroundColor = UIColor.appColorBlue
                self.topLeftTitle.text = "Sub Task"
                self.inviteTask = true
                self.projectDeliverable.text = "Description"
                self.projectDeliverableLabel.text = model?.data?.project_details?.taskDescription ?? ""
                self.projectTypeLabel.text = model?.data?.project_details?.projectCategory?.title ?? ""
            } else {
                self.inviteTask = false
                self.topLeftTitle.text = "Main Project"
                self.topLeftVw.backgroundColor = UIColor.appBtnColorOrange
                self.projectDeliverable.text = "Project deliverables"
            }
            self.btnRecallBid.backgroundColor = UIColor.appColorGreen
            self.btnRecallBid.setTitleColor(UIColor.appBtnColorWhite, for: .normal)
            //self.btmVwheight.constant = 96.0
            self.vwStatus.backgroundColor = UIColor.appBtnColorOrange
            if model?.data?.bidStatus == 1 {
                //self.bottomVw.addCustomShadow()
                self.lblStatus.text = "Active"
                self.btnViewBidLog.setTitle("View Bid Log", for: .normal)
                self.btnRecallBid.setTitle("Recall Bid", for: .normal)
            } else if model?.data?.bidStatus == 2 || model?.data?.bidStatus == 3 || model?.data?.bidStatus == 4  {
                if model?.data?.bidStatus == 2 {
                    //self.bottomVw.addCustomShadow()
                    self.lblStatus.text = "Recalled"
                    self.btnViewBidLog.setTitle("Edit Bid", for: .normal)
                    self.btnRecallBid.setTitle("View Bid Log", for: .normal)
                } else if model?.data?.bidStatus == 3 {
                    self.lblStatus.text = "Lost"
                    self.btnViewBidLog.isHidden = true
                    self.btnRecallBid.backgroundColor = UIColor.appBtnColorWhite
                    self.btnRecallBid.isUserInteractionEnabled = false
                    self.btnRecallBid.setTitleColor(UIColor.appColorGreen, for: .normal)
//                    self.btmVwheight.constant = 80.0
                    self.btnRecallBid.setTitle("Bid Lost", for: .normal)
                } else if model?.data?.bidStatus == 4 {
                    //self.bottomVw.addCustomShadow()
                    self.lblStatus.text = "Rejected"
                    self.btnViewBidLog.setTitle("Edit Bid", for: .normal)
                    self.btnRecallBid.setTitle("View Bid Log", for: .normal)
                }
            } else {
                
                self.blurVww.isHidden = false
                self.vwAcceptedBid.isHidden = false
                self.vwStatus.backgroundColor = UIColor.appColorGreen
                self.lblStatus.text = "Accepted"
                self.btnViewBidLog.setTitle("Save Agreement", for: .normal)
                self.btnRecallBid.setTitle("Next", for: .normal)
                
                
                self.lblAcceptedStartEndDate.text = "\(DateHelper.convertDateString(dateString: model?.data?.proposedStartDate ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM"))-\(DateHelper.convertDateString(dateString: model?.data?.proposedEndDate ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM"))"
                
//                self.lblAcceptedBidAmount.text = "$ \(model?.data?.bidAmount ?? "0.0")"
                
                var realAmount = "\(model?.data?.bidAmount ?? "0.0")"
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.decimal

                let amount = Double(realAmount)
                let formattedString = formatter.string(for: amount)
                self.lblAcceptedBidAmount.text = "$ \(formattedString ?? "")"
                
                self.imgHomeOwner.sd_setImage(with: URL(string: model?.data?.project_details?.user_ProjectDetail?.profilePic ?? ""), placeholderImage: UIImage(named: "ic_HO_profile"), completed:nil)
                self.lblHomeOwner.text = "\(model?.data?.project_details?.user_ProjectDetail?.firstName ?? "") \(model?.data?.project_details?.user_ProjectDetail?.lastName ?? "" )"
                self.topLeftVw.isHidden = true
                self.vwStatus.isHidden = false
                self.vwTopConstraint.constant = 44.0
                
                self.lblStaticEndsOnTwo.isHidden = false
                self.lblDateEndsOnTwo.isHidden = false
                self.lblStaticEndsOn.isHidden = true
                self.lblEndDate.isHidden = true
                
                self.lblStaticStartedOn.text! = "Notable Terms"
                //self.lblStaticNotableItems.text! = "Started On"
                //self.lblStaticEndsOnTwo.text! = "Ends On"
                
                self.lblDateStart.isHidden = false
                self.lblDateStart.text = model?.data?.description ?? ""
                
                //self.lblDateEndsOnTwo.text = DateHelper.convertDateString(dateString: model?.data?.proposedEndDate ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
                //self.lblNotableItems.text = DateHelper.convertDateString(dateString: model?.data?.proposedStartDate ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
                
                self.lblStaticNotableItems.isHidden = true
                self.lblNotableItems.isHidden = true
                self.lblDateEndsOnTwo.isHidden = true
                self.lblStaticEndsOnTwo.isHidden = true
                self.vwEndsDateTwo.isHidden = true
                self.topConstarintAttachedFiles.constant = -65.0
                
                self.btnViewBidLog.isHidden = false
                if model?.data?.project_agreement?.count ?? 0 >= 3 {
                    self.btnViewBidLog.isHidden = true
                    self.blurVww.isHidden = true
                    self.btnRecallBid.backgroundColor = UIColor.appBtnColorWhite
                    self.btnRecallBid.isUserInteractionEnabled = false
                    self.btnRecallBid.setTitleColor(UIColor.appColorGreen, for: .normal)
                    self.btmVwheight.constant = 80.0
                    self.btnRecallBid.setTitle("Waiting for Admin Approval", for: .normal)
                } else {
                    //self.bottomVw.addCustomShadow()
                }
            }
            self.arrProjectFiles = model?.data?.bids_documents ?? [BidsDocumentsDetails]()
            self.arrProjectUploadFiles = model?.data?.project_details?.project_files ?? [ProjectFiles]()
            var count = self.arrProjectFiles.count + self.arrProjectUploadFiles.count
            if count == 0 || count == nil {
                self.lblAttachedFiles.text = "Attached Files"
            } else {
                self.lblAttachedFiles.text = "Attached Files (\(count))"
            }
//
//            if model?.data?.project_details?.project_files?.count ?? 0 > 0 {
//                self.lblAttachedFiles.isHidden = false
//            } else {
//                self.lblAttachedFiles.isHidden = false
//            }
            self.collectionVw.reloadData()
        }
    }
    
    //MARK: ACTION VIEW BID LOG
    @IBAction func actionViewBidLog(_ sender: Any) {
        if self.bidStatus == 1 {
            let params = ["projectId": "\(self.projectId)"]
            manageBidDetailViewModel.viewBidLogApi(params) { model in
                let vc = Storyboard.invitation.instantiateViewController(withIdentifier: "ViewBidLogVC") as? ViewBidLogVC
                vc!.projectTitle = self.projectTitle
                vc!.arrBidLog = model?.data?.getBidLog ?? [GetBidLoglDetail]()
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        } else if self.bidStatus == 2 || self.bidStatus == 3 || self.bidStatus == 4 {
            let vc = Storyboard.invitation.instantiateViewController(withIdentifier: "PlaceBidVC") as? PlaceBidVC
            vc!.bidId = self.manageBidId
            vc!.projectId = self.projectId
            vc!.fetchHomeOwner = manageBids?.homeOwner1 ?? ""
            vc!.fetchHomeOwnerB = manageBids?.homeOwner2 ?? ""
            vc!.fetchStreetAddress = self.manageBids?.streetAddress ?? ""
            vc!.fetchCellPhone = self.manageBids?.cellPhone ?? ""
            vc!.fetchMailingAddress = self.manageBids?.mailingAddress ?? ""
            vc!.fetchEmail = self.manageBids?.email ?? ""
            vc!.manageBidDetailViewModel = self.manageBidDetailViewModel
            vc!.arrProjectFiles = self.arrProjectFiles
            vc!.arrProjectUploadFiles = self.arrProjectUploadFiles
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            self.getAgreement()
        }
    }
    
    func getAgreement() {
        let params = ["bidId": self.manageBidId, "projectId":self.projectId]
        
        manageBidDetailViewModel.getAgreementGeneratetApi(params) { model in
            if model?.data?.app?.downloadUrl != nil {
                self.downloadAgreementFromUrl(strUrl: model?.data?.app?.downloadUrl ?? "", fileName: model?.data?.app?.filename ?? "")
            }
        }
    }
    
    func downloadAgreementFromUrl(strUrl:String, fileName: String) {
        DispatchQueue.main.async {
            self.downLoadImagesAndSave(url: strUrl, fileName: fileName)
        }
    }
    
    func downLoadImagesAndSave(url:String, fileName:String) {
        DispatchQueue.main.async {
            Progress.instance.show()
        }
        let urlString = url
        //let url = URL(string: urlString)
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let destinationFileUrl = documentsUrl.appendingPathComponent("TA_\(fileName)")
        //Create URL to the source file you want to download
        let fileURL = URL(string: urlString)
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url:fileURL!)
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            DispatchQueue.main.async {
                Progress.instance.hide()
            }
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    do {
                        //Show UIActivityViewController to save the downloaded file
                        let contents  = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                        
                        for indexx in 0..<contents.count {
                            if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
                                DispatchQueue.main.async {
                                    let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
                                    self.present(activityViewController, animated: true, completion: nil)
                                    self.blurVww.isHidden = true
                                }
                            }
                        }
                    }
                    catch (let err) {
                        print("error: \(err)")
                    }
                } catch (let writeError) {
                    DispatchQueue.main.async {
                        showMessage(with: "File already exists", theme: .success)
                    }
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
            } else {
                DispatchQueue.main.async {
                    Progress.instance.hide()
                }
                print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
            }
        }
        task.resume()
    }
    
    
    
    //MARK: ACTION RECALL BID
    @IBAction func actionRecallBid(_ sender: Any) {
        if self.bidStatus == 1 {
            let vc = Storyboard.invitation.instantiateViewController(withIdentifier: "RecallBidVC") as? RecallBidVC
            vc!.bidId = self.manageBidId
            vc!.modalPresentationStyle = .overFullScreen
            vc!.completionHandlerManageBids = { [weak self] in
                self?.fetchManageBidDetal()
            }
            self.present(vc!, animated: true)
        } else if self.bidStatus == 2 || self.bidStatus == 3 || self.bidStatus == 4{
            let params = ["projectId": "\(self.projectId)"]
            manageBidDetailViewModel.viewBidLogApi(params) { model in
                let vc = Storyboard.invitation.instantiateViewController(withIdentifier: "ViewBidLogVC") as? ViewBidLogVC
                vc!.projectTitle = self.projectTitle
                vc!.arrBidLog = model?.data?.getBidLog ?? [GetBidLoglDetail]()
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        } else {
            let vc = Storyboard.invitation.instantiateViewController(withIdentifier: "EVerificationVC") as? EVerificationVC
            vc!.projectId = self.projectId
            vc!.inviteTask = self.inviteTask
            vc!.completionHandlerGoToManageBids = { [weak self] in
                self!.navigationController?.popViewController(animated: true)
            }
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    //MARK: ACTION BACK
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getBidDetailsById() {
        let params = ["id": self.manageBidId]
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
                "id": "\(self.manageBidId)",
                "projectId": "\(self.projectId)",
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
        DispatchQueue.main.async {
            Progress.instance.show()
        }
        manageBidDetailViewModel.downloadPDF(params)
    }
    
    @IBAction func actionDownloadPDF(_ sender: Any) {
        getBidDetailsById()
    }
    
    func openDocument(document_path:String, document_name:String) {
        if NetworkReachabilityManager()?.isReachable == false {
            showMessage(with: GenericErrorMessages.noInternet)
            return
        }
        if let controller = Storyboard.messageHO.instantiateViewController(withIdentifier: "DocumentViewController") as? DocumentViewController {
            controller.document_path = document_path
            controller.document_name = document_name
            self.present(controller, animated: true, completion: nil)
        }
    }
}



extension ManageBidDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func getWidth(title:String) -> CGFloat{
        let font = UIFont(name: PoppinsFont.medium, size: 14)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let myText = title
        let size = (myText as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size.width + 25 + 45
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ((self.arrProjectFiles.count) + (self.arrProjectUploadFiles.count))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectFileCollecrtionView", for: indexPath) as? ProjectFileCollecrtionView
//        SDWebImage.clearCaches()
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        if indexPath.row < (self.arrProjectFiles.count) {

            if (((self.arrProjectFiles[indexPath.row].title ?? "").contains(".png")) || ((self.arrProjectFiles[indexPath.row].title ?? "").contains(".jpg")) || ((self.arrProjectFiles[indexPath.row].title ?? "").contains(".jpeg")) || ((self.arrProjectFiles[indexPath.row].title ?? "").contains(".pdf")) || ((self.arrProjectFiles[indexPath.row].title ?? "").contains(".doc"))){
                cell!.projectTitleLabel.text = "\(self.arrProjectFiles[indexPath.row].title ?? "")"
            } else {
                cell!.projectTitleLabel.text = "\(self.arrProjectFiles[indexPath.row].title ?? "").\(self.arrProjectFiles[indexPath.row].type ?? "")"
            }
            cell!.projectImageView.image = nil
            if self.arrProjectFiles[indexPath.row].type == "png" || self.arrProjectFiles[indexPath.row].type == "jpg" || self.arrProjectFiles[indexPath.row].type == "jpeg" {
                if var imgStr = self.arrProjectFiles[indexPath.row].file {
                    imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    cell!.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed:nil)
                }
            } else {
                cell!.projectImageView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "doc"), completed:nil)
//                if var imgStr = self.arrProjectFiles[indexPath.row].file {
//                    imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//                    cell!.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed:nil)
//                }
//                cell!.projectImageView.image = UIImage(named: "doc")
            }

        } else {

            if (((self.arrProjectUploadFiles[indexPath.row - self.arrProjectFiles.count].title ?? "").contains(".png")) || ((self.arrProjectUploadFiles[indexPath.row - self.arrProjectFiles.count].title ?? "").contains(".jpg")) || ((self.arrProjectUploadFiles[indexPath.row - self.arrProjectFiles.count].title ?? "").contains(".jpeg")) || ((self.arrProjectUploadFiles[indexPath.row - self.arrProjectFiles.count].title ?? "").contains(".pdf")) || ((self.arrProjectUploadFiles[indexPath.row - self.arrProjectFiles.count].title ?? "").contains(".doc"))){
                cell!.projectTitleLabel.text = "\(self.arrProjectUploadFiles[indexPath.row - self.arrProjectFiles.count].title ?? "")"
            } else {
                cell!.projectTitleLabel.text = "\(self.arrProjectUploadFiles[indexPath.row - self.arrProjectFiles.count].title ?? "").\(self.arrProjectUploadFiles[indexPath.row - self.arrProjectFiles.count].type ?? "")"
            }
            cell!.projectImageView.image = nil
            if self.arrProjectUploadFiles[indexPath.row - self.arrProjectFiles.count].type == "png" || self.arrProjectUploadFiles[indexPath.row - self.arrProjectFiles.count].type == "jpg" || self.arrProjectUploadFiles[indexPath.row - self.arrProjectFiles.count].type == "jpeg" {
                if var imgStr = self.arrProjectUploadFiles[indexPath.row - self.arrProjectFiles.count].file {
                    imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    cell!.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed:nil)
                }
            } else {
                cell!.projectImageView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "doc"), completed:nil)
//                if var imgStr = self.arrProjectUploadFiles[indexPath.row - self.arrProjectFiles.count].file {
//                    imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//                    cell!.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed:nil)
//                }
//                cell!.projectImageView.image = UIImage(named: "doc")
            }
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < (self.arrProjectFiles.count) {
            
            if self.arrProjectFiles[indexPath.row].type == "png" || self.arrProjectFiles[indexPath.row].type == "jpg" || self.arrProjectFiles[indexPath.row].type == "jpeg" {
                if let imgStr = self.arrProjectFiles[indexPath.row].file {
                    let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
                    destinationViewController!.isImage = false
                    destinationViewController?.imsgeStrURL = imgStr
                    destinationViewController?.img = UIImage()
                    self.navigationController?.pushViewController(destinationViewController!, animated: true)
                }
            } else {
                if let imgStr = self.arrProjectFiles[indexPath.row].file {
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
            
        } else {
            if self.arrProjectUploadFiles[indexPath.row - self.arrProjectFiles.count].type == "png" || self.arrProjectUploadFiles[indexPath.row - self.arrProjectFiles.count].type == "jpg" || self.arrProjectUploadFiles[indexPath.row - self.arrProjectFiles.count].type == "jpeg" {
                if let imgStr = self.arrProjectUploadFiles[indexPath.row - self.arrProjectFiles.count].file {
                    let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
                    destinationViewController!.isImage = false
                    destinationViewController?.imsgeStrURL = imgStr
                    destinationViewController?.img = UIImage()
                    self.navigationController?.pushViewController(destinationViewController!, animated: true)
                }
            } else {
                if let imgStr = self.arrProjectUploadFiles[indexPath.row - self.arrProjectFiles.count].file {
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

extension ManageBidDetailVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row < (self.arrProjectFiles.count) {
            return CGSize(width: getWidth(title:"\(self.arrProjectFiles[indexPath.row].title ?? "").\(self.arrProjectFiles[indexPath.row].type ?? "")"), height:70)
        } else {
            return CGSize(width: getWidth(title:"\(self.arrProjectUploadFiles[indexPath.row - self.arrProjectFiles.count].title ?? "").\(self.arrProjectUploadFiles[indexPath.row - self.arrProjectFiles.count].type ?? "")"), height:70)
        }
    }
}

extension ManageBidDetailVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
