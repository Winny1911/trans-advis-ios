//
//  BidDetailVc.swift
//  TA
//
//  Created by applify on 05/01/22.
//

import UIKit
import SDWebImage

class BidDetailVc: BaseViewController {

    @IBOutlet weak var attachedFilesLabel: UILabel!
    @IBOutlet weak var sendMessage: UIButton!
    @IBOutlet weak var viewProfile: UIButton!
    @IBOutlet weak var rejectBid: UIButton!
    @IBOutlet weak var acceptBid: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    
    @IBOutlet weak var bidAmt: UILabel!
    @IBOutlet weak var startEndDate: UILabel!
    @IBOutlet weak var notableTerms: UILabel!
    @IBOutlet weak var startOnLbl: UILabel!
    @IBOutlet weak var endsOnLbl: UILabel!
    
    var id = Int()
    var bidDetailModel : BidDetailVM = BidDetailVM()
    var name = String()
    var bidAmount = String()
    var completionHandlerGoToViewBidsScreen: (() -> Void)?
    var contractorId = 0
    var isFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ProjectFileCollecrtionView", bundle: nil), forCellWithReuseIdentifier: "ProjectFileCollecrtionView")
        
        sendMessage.setRoundCorners(radius: 6.0)
        viewProfile.setRoundCorners(radius: 6.0)
        
        rejectBid.setRoundCorners(radius: 6.0)
        acceptBid.setRoundCorners(radius: 6.0)
        
        navigationController?.navigationBar.isHidden = false
        if self.isFrom == "InvitedTaskCO" {
            getInvitedTasksBidsDetailApiHit()
        } else {
            getBidsDetailApiHit()
        }
    }
    
    @IBAction func sentMessageBtnAction(_ sender: UIButton) {
        print("ContractorHOVC: initiateChatButtonAction")
        let dictionary = bidDetailModel.bidDetailData //self.arrOfOngoingProjects[indexPath.row]
        let user_id = String("ID_\(dictionary?.user?.id ?? 0)")
        let user_name = (dictionary?.user?.firstName ?? "") + " " + (dictionary?.user?.lastName ?? "")
        let user_image = dictionary?.user?.profilePic ?? ""
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
    
    func getInvitedTasksBidsDetailApiHit(){
        let param = ["id": id]
        self.bidDetailModel.BidsInvitedDetailApiCall(param){_ in
            self.startEndDate.text = "\(DateHelper.convertDateString(dateString: self.bidDetailModel.bidDetailData?.proposedStartDate, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "MMM dd"))th - \(DateHelper.convertDateString(dateString: self.bidDetailModel.bidDetailData?.proposedEndDate, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: " MMM dd"))th"
            
            self.contractorId = self.bidDetailModel.bidDetailData?.user?.id ?? 0
            self.firstName.text = "\(self.bidDetailModel.bidDetailData?.user?.firstName ?? "") \(self.bidDetailModel.bidDetailData?.user?.lastName ?? "")"
//            self.bidAmt.text =  "$\(self.bidDetailModel.bidDetailData?.bidAmount ?? "0")"
            
            var realAmount = "\(self.bidDetailModel.bidDetailData?.bidAmount ?? "0")"
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal

            let amount = Double(realAmount)
            let formattedString = formatter.string(for: amount)
            self.bidAmt.text =  "$ \(formattedString ?? "")"
            
            self.startOnLbl.text = DateHelper.convertDateString(dateString: self.bidDetailModel.bidDetailData?.proposedStartDate, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: " dd MMM YYY  ")
            self.endsOnLbl.text = DateHelper.convertDateString(dateString: self.bidDetailModel.bidDetailData?.proposedEndDate, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: " dd MMM YYY ")
            self.notableTerms.text = self.bidDetailModel.bidDetailData?.datumDescription
          
            if let imgStr = self.bidDetailModel.bidDetailData?.user?.profilePic{
                self.profileImg.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "ic_HO_profile"), completed: nil)
            }
            self.collectionView.reloadData()
        }
    }
    
    func getBidsDetailApiHit(){
        let param = ["id": id]
        let proposedStartDate = self.bidDetailModel.bidDetailData?.proposedStartDate ?? Date().stringValue
        let proposedEndDate = self.bidDetailModel.bidDetailData?.proposedEndDate ?? Date().stringValue
        
        guard proposedStartDate != nil || proposedStartDate != nil else { return }
        
        self.bidDetailModel.BidsDetailApiCall(param){_ in
            self.startEndDate.text = "\(DateHelper.convertDateString(dateString: proposedStartDate, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "MMM dd"))th - \(DateHelper.convertDateString(dateString: proposedEndDate, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: " MMM dd"))th"
            
            self.contractorId = self.bidDetailModel.bidDetailData?.user?.id ?? 0
            self.firstName.text = "\(self.bidDetailModel.bidDetailData?.user?.firstName ?? "") \(self.bidDetailModel.bidDetailData?.user?.lastName ?? "")"
//            self.bidAmt.text =  "$\(self.bidDetailModel.bidDetailData?.bidAmount ?? "0")"
            
            var realAmount = "\(self.bidDetailModel.bidDetailData?.bidAmount ?? "0")"
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal

            let amount = Double(realAmount)
            let formattedString = formatter.string(for: amount)
            self.bidAmt.text =  "$ \(formattedString ?? "")"
            
            self.startOnLbl.text = DateHelper.convertDateString(dateString: proposedStartDate, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: " dd MMM YYY  ")
            self.endsOnLbl.text = DateHelper.convertDateString(dateString: proposedEndDate, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: " dd MMM YYY ")
            self.notableTerms.text = self.bidDetailModel.bidDetailData?.datumDescription
          
            if let imgStr = self.bidDetailModel.bidDetailData?.user?.profilePic{
                self.profileImg.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "ic_HO_profile"), completed: nil)
            }
            if self.bidDetailModel.bidDetailData?.bidsDocuments?.count == 0 || self.bidDetailModel.bidDetailData?.bidsDocuments == nil {
                self.attachedFilesLabel.text = "Attached Files"
            } else {
                self.attachedFilesLabel.text = "Attached Files (\(self.bidDetailModel.bidDetailData?.bidsDocuments?.count ?? 0))"
            }
            self.collectionView.reloadData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func viewProfileButtonTap(_ sender: Any) {
        let destinationViewController = Storyboard.contractorHO.instantiateViewController(withIdentifier: "ContractorProfileHOVC") as? ContractorProfileHOVC
        destinationViewController!.contractorID = self.contractorId
        destinationViewController!.isFrom = "BidDetail"
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
    
    @IBAction func rejectBidButtonTap(_ sender: Any) {
        let destinationViewController = Storyboard.newHO.instantiateViewController(withIdentifier: "RejectBidVC") as? RejectBidVC
        destinationViewController!.projectId = bidDetailModel.bidDetailData?.projectID ?? 0
        if self.isFrom == "InvitedTaskCO" {
            destinationViewController!.isFrom = "InvitedTaskCO"
        }
        destinationViewController!.bidId = bidDetailModel.bidDetailData?.id ?? 0
        destinationViewController!.completionHandlerGoToViewBids = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        self.present(destinationViewController!, animated: true, completion: nil)
    }
    
    @IBAction func acceptBidButtonTap(_ sender: Any) {
        let destinationViewController = Storyboard.newHO.instantiateViewController(withIdentifier: "AcceptBidVc") as? AcceptBidVc
        if self.isFrom == "InvitedTaskCO" {
            destinationViewController!.isFrom = "InvitedTaskCO"
        }
        destinationViewController!.projectId = bidDetailModel.bidDetailData?.projectID ?? 0
        destinationViewController!.bidId = bidDetailModel.bidDetailData?.id ?? 0
        destinationViewController!.budget = bidDetailModel.bidDetailData?.bidAmount ?? "0"
        
        destinationViewController!.completionHandlerGoToAgreementScreen = { [weak self] in
//            let vc = Storyboard.newHO.instantiateViewController(withIdentifier: "AgreementVC") as? AgreementVC
//            if self!.isFrom == "InvitedTaskCO" {
//                vc!.isFrom = "InvitedTaskCO"
//            }
//            vc!.completionHandlerGoToBidDetailScreen = { [weak self] in
//                self!.completionHandlerGoToViewBidsScreen?()
//                self!.navigationController?.popViewController(animated: true)
//            }
            
//            vc!.userId = self?.bidDetailModel.bidDetailData?.user?.id ?? 0
//            self?.navigationController?.pushViewController(vc!, animated: true)
            let vc = Storyboard.invitation.instantiateViewController(withIdentifier: "PlaceBidVC") as? PlaceBidVC
            vc!.projectId = self?.bidDetailModel.bidDetailData?.projectID ?? 0
            vc!.bidId = self?.bidDetailModel.bidDetailData?.id ?? 0
            //vc!.fetchHomeOwner = self.lblHomeOwner.text ?? ""
            //vc!.fetchHomeOwnerB = self.lblHomeOwner.text ?? ""
            //vc!.fetchStreetAddress = self.manageBids?.user?.addressLine1 ?? ""
            //vc!.fetchCellPhone = self.manageBids?.user?.phoneNumber ?? ""
            //vc!.fetchMailingAddress = self.manageBids?.user?.addressLine2 ?? ""
            //vc!.fetchEmail = self.manageBids?.user?.email ?? ""
            //vc!.manageBidDetailViewModel = self.manageBidDetailViewModel
            //vc!.arrProjectFiles = self.arrProjectFiles
            //vc!.arrProjectUploadFiles = self.arrProjectUploadFiles
            self?.navigationController?.pushViewController(vc!, animated: true)
        }
        self.present(destinationViewController!, animated: true, completion: nil)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: Extension CollectionDelegateFlowLayout
extension BidDetailVc: UICollectionViewDelegateFlowLayout{
    
    func getWidth(title:String) -> CGFloat{
        let font = UIFont(name: PoppinsFont.medium, size: 14)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let myText = title
        let size = (myText as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size.width + 25 + 45
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: getWidth(title: bidDetailModel.bidDetailData?.bidsDocuments?[indexPath.row].title ?? ""), height:61)
    }
}
extension BidDetailVc: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bidDetailModel.bidDetailData?.bidsDocuments?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectFileCollecrtionView", for: indexPath)as? ProjectFileCollecrtionView {
            SDImageCache.shared.clearMemory()
            SDImageCache.shared.clearDisk()
            cell.projectTitleLabel.text = bidDetailModel.bidDetailData?.bidsDocuments?[indexPath.row].title
            if self.bidDetailModel.bidDetailData?.bidsDocuments?.count ?? 0 > 0 {
                if self.bidDetailModel.bidDetailData?.bidsDocuments?[indexPath.row].type == "png" || self.bidDetailModel.bidDetailData?.bidsDocuments?[indexPath.row].type == "jpg" || self.bidDetailModel.bidDetailData?.bidsDocuments?[indexPath.row].type == "jpeg" {
                    if let imgStr = self.bidDetailModel.bidDetailData?.bidsDocuments?[indexPath.row].file {
                        cell.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed:nil)
                    }
                } else {
                    if var imgStr = self.bidDetailModel.bidDetailData?.bidsDocuments?[indexPath.row].file {
                        imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        cell.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed:nil)
                    }
//                    cell.projectImageView.image = UIImage(named: "doc")
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.bidDetailModel.bidDetailData?.bidsDocuments?.count ?? 0 > 0 {
                if self.bidDetailModel.bidDetailData?.bidsDocuments?[indexPath.row].type == "png" || self.bidDetailModel.bidDetailData?.bidsDocuments?[indexPath.row].type == "jpg" || self.bidDetailModel.bidDetailData?.bidsDocuments?[indexPath.row].type == "jpeg" {
                    if let imgStr = self.bidDetailModel.bidDetailData?.bidsDocuments?[indexPath.row].file {
                        
                        let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
                        destinationViewController!.isImage = false
                        destinationViewController?.imsgeStrURL = imgStr
                        destinationViewController?.img = UIImage()
                        self.navigationController?.pushViewController(destinationViewController!, animated: true)
                        
                    }
                } else {
                    if let imgStr = self.bidDetailModel.bidDetailData?.bidsDocuments?[indexPath.row].file {
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


