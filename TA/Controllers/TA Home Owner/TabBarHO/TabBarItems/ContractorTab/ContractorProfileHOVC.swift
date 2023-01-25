//
//  ContractorProfileHOVC.swift
//  TA
//
//  Created by Dev on 15/12/21.
//

import UIKit

class ContractorProfileHOVC: BaseViewController {

    @IBOutlet weak var btnSendProject: UIButton!
    @IBOutlet weak var blurVww: UIView!
    
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblNoDataReview: UILabel!
    @IBOutlet weak var lblNoDataPortfolio: UILabel!
    @IBOutlet weak var stckVwBtns: UIStackView!
    @IBOutlet weak var bottomVwHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var portfolioCollectionView: UICollectionView!
    @IBOutlet weak var skillsCollectionView: UICollectionView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var profilePicImg: UIImageView!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var projectCompleteLbl: UILabel!
    @IBOutlet weak var taIDLabel: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var emojiVw1: UIView!
    @IBOutlet weak var emojiVw2: UIView!
    @IBOutlet weak var emojiVw3: UIView!
    @IBOutlet weak var emojiVw4: UIView!
    @IBOutlet weak var emojiVw5: UIView!
    
    var viewModel = ContractorVM()
    var projectId = 0
    var reviewViewModel = GetReviewVM()
    //var id = 0
    var contractorID = 0
    var userDetail: ContractorUserData?
    var selectedSkills = [String]()
    var skills = [UserSkills]()
    var arrListing = [PortfolioImage]()
    var isFrom = ""
    
    var showBlurVw = false
    var subTaskId = 0
    var indexNo = 0
    var completionHandlerGoToCOListing: (() -> Void)?
    var contractorDeepLink = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        portfolioCollectionView.delegate = self
        portfolioCollectionView.dataSource = self
        skillsCollectionView.delegate = self
        skillsCollectionView.dataSource = self
        self.tableView.delegate = self
        self.tableView .dataSource = self
        navigationItem.hidesBackButton = true
        
        //Bottom View Shadow
        bottomView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomView.layer.shadowOpacity = 0.5
        bottomView.layer.shadowOffset = CGSize.zero
        bottomView.layer.shadowRadius = 5
        self.bottomView.layer.borderColor = UIColor.clear.cgColor
        self.bottomView.layer.borderWidth = 0
        
        //Register Cells
        self.portfolioCollectionView.register(UINib(nibName: "PorfolioImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PorfolioImagesCollectionViewCell")
        self.skillsCollectionView.register(UINib(nibName: "SkillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SkillCollectionViewCell")
        self.tableView.register(UINib.init(nibName: "AllReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "AllReviewTableViewCell")
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
         if let obj = object as? UITableView {
             if obj == self.tableView && keyPath == "contentSize" {
                 if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                     //do stuff here
//                     self.ReviewDataReload?()
                     self.reloadReviewData()
                 }
             }
         }
     }
    
    func reloadReviewData() {
        self.tableView.layoutIfNeeded()
        self.tableViewHeight.constant = self.tableView.contentSize.height == 0 ? 100 : self.tableView.contentSize.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lblNoDataPortfolio.isHidden = true
        lblNoDataReview.isHidden = true
        GetContractorApiHit()
        GetReviewApiHit()
        if self.isFrom == "BidDetail" {
            self.blurVww.isHidden = true
            self.bottomVwHeight.constant = 0.0
            self.stckVwBtns.isHidden = true
        } else if self.isFrom == "InviteContractorsToBid" {
            self.blurVww.isHidden = showBlurVw
            if showBlurVw == true {
                self.btnSendProject.setTitle("Send Task", for: .normal)
            } else {
                self.btnSendProject.setTitle("Task Sent", for: .normal)
            }
            self.bottomVwHeight.constant = 94.0
            self.stckVwBtns.isHidden = false
        } else {
            self.blurVww.isHidden = true
            self.bottomVwHeight.constant = 94.0
            self.stckVwBtns.isHidden = false
        }
    }
    
    // Review Data Api
    func GetReviewApiHit(){
        self.reviewViewModel.getReviewApiCall(self.contractorID){_ in
            if self.reviewViewModel.reviewData.count <= 0 {
                self.lblNoDataReview.isHidden = false
            } else{
                self.lblNoDataReview.isHidden = true
            }
            self.tableView.reloadData()
        }
    }
    
    func GetContractorApiHit(){
        self.viewModel.getProfileApiCall(self.contractorID){ [self] model in
            self.userDetail = model?.data
            self.firstNameLbl.text = "\(self.userDetail?.firstName ?? "") \(self.userDetail?.lastName ?? "")"
            self.projectCompleteLbl.text = "\(self.userDetail?.projectCount! ?? 0)"
            self.taIDLabel.text = "\(self.userDetail?.id! ?? 0)"
            self.emailLbl.text = self.userDetail?.email
            self.addressLbl.text = self.userDetail?.addressLine1
            self.contractorDeepLink = ""
            self.contractorDeepLink = model?.data?.contractorDeepLink ?? ""
            
            if self.userDetail?.profilePic?.count ?? 0 > 0{
                if let imgStr = self.userDetail?.profilePic{
                    self.profilePicImg.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed: nil)
                }
            }
            let rating = self.userDetail?.rating
            let ratingValue = Double(rating  ?? "")
            
            self.emojiVw1.isHidden = false
            self.emojiVw2.isHidden = false
            self.emojiVw3.isHidden = false
            self.emojiVw4.isHidden = false
            self.emojiVw5.isHidden = false
            
            if ratingValue == Double(5.0) {
                self.emojiVw5.isHidden = true
            }
            else if ratingValue ?? Double(0.0) <= Double(4.9) && ratingValue ?? Double(0.0) >= Double(4.0) {
                self.emojiVw4.isHidden = true
            }
            else if ratingValue ?? Double(0.0) <= Double(3.9) && ratingValue ?? Double(0.0) >= Double(3.0) {
                self.emojiVw3.isHidden = true
            }
            else if ratingValue ?? Double(0.0) <= Double(2.9) && ratingValue ?? Double(0.0) >= Double(2.0){
                self.emojiVw2.isHidden = true
            }
            else if ratingValue ?? Double(0.0) <= Double(1.9) && ratingValue ?? Double(0.0) >= Double(1.0){
                self.emojiVw1.isHidden = true
            }
//            if ratingValue == 5 {
//                self.emojiVw1.isHidden = true
//                self.emojiVw2.isHidden = false
//                self.emojiVw3.isHidden = false
//                self.emojiVw4.isHidden = false
//                self.emojiVw5.isHidden = false
//            } else if ratingValue! >= 4 {
//                self.emojiVw1.isHidden = false
//                self.emojiVw2.isHidden = true
//                self.emojiVw3.isHidden = false
//                self.emojiVw4.isHidden = false
//                self.emojiVw5.isHidden = false
//            } else if ratingValue! >= 3 {
//                self.emojiVw1.isHidden = false
//                self.emojiVw2.isHidden = false
//                self.emojiVw3.isHidden = true
//                self.emojiVw4.isHidden = false
//                self.emojiVw5.isHidden = false
//            } else if ratingValue! >= 2 {
//                self.emojiVw1.isHidden = false
//                self.emojiVw2.isHidden = false
//                self.emojiVw3.isHidden = false
//                self.emojiVw4.isHidden = true
//                self.emojiVw5.isHidden = false
//            } else if ratingValue! >= 0 {
//                self.emojiVw1.isHidden = false
//                self.emojiVw2.isHidden = false
//                self.emojiVw3.isHidden = false
//                self.emojiVw4.isHidden = false
//                self.emojiVw5.isHidden = true
//            }
            self.selectedSkills.removeAll()
            self.arrListing.removeAll()
            self.arrListing = model?.data?.portfolioImages ?? [PortfolioImage]()
            let skillStr = model?.data?.skillSet
            self.skills = model?.data?.userSkills ?? [UserSkills]()
            
            if skills.count ?? 0 > 0 {
                for i in 0 ..< skills.count{
                    if skills[i].projectCategory?.title != nil {
                        self.selectedSkills.append(skills[i].projectCategory?.title ?? "")
                       
                    }
                }
            }
            self.selectedSkills.removingDuplicates()
            self.selectedSkills.removeDuplicates()
            //let skillArr = skillStr?.components(separatedBy: ",")
//            if skillArr?.count ?? 0 > 0 {
//                for i in 0 ..< skillArr!.count{
//                    self.selectedSkills.append(skillArr![i])
//                }
//            }
           
            if self.arrListing.count <= 0 {
                self.lblNoDataPortfolio.isHidden = false
            } else{
                self.lblNoDataPortfolio.isHidden = true
            }
            self.portfolioCollectionView.reloadData()
            self.skillsCollectionView.reloadData()
            self.reloadReviewData()
      }
    }
    
    func sendTaskAPI(projectId:Int, contractorId:Int, indexRow:Int){
        let param = ["projectId":projectId, "contractorId":contractorId] as [String : Any]
        self.viewModel.sendTaskToCOApi(param){ model in
            self.completionHandlerGoToCOListing?()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func actionShareProfile(_ sender: Any) {
        let items = ["Hey! Check out this contractor I found on the Transaction Advisor platform that might be useful for you. \(self.contractorDeepLink)"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @IBAction func goToSendProjects(_ sender: Any) {
        if self.isFrom == "InviteContractorsToBid" {
            sendTaskAPI(projectId: self.subTaskId, contractorId: self.contractorID, indexRow: indexNo)
        } else {
            let destinationViewController = Storyboard.contractorHO.instantiateViewController(withIdentifier: "SelectProjectToSendHOVC") as? SelectProjectToSendHOVC
            if self.projectId != 0 {
                destinationViewController?.projectId = self.projectId
            }
            destinationViewController?.constID = userDetail?.id ?? 0
            self.present(destinationViewController!, animated: true)
        }
    }
    
    @IBAction func sendMessageBtnAction(_ sender: Any) {
        let user_id = String("ID_\(self.userDetail?.id! ?? 0)")
        let user_name = "\(self.userDetail?.firstName ?? "") \(self.userDetail?.lastName ?? "")"
        let user_image = self.userDetail?.profilePic
        openChatWindow(user_id: user_id, user_image: user_image, user_name: user_name)
        
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
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
    
//MARK:  - Extension CollectionDelegateFlowLayout,delegate and DataSource
extension ContractorProfileHOVC: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == portfolioCollectionView{
            return CGSize(width:100 , height:64)
        }
        else if collectionView == skillsCollectionView{
            return CGSize(width: getWidth(title: self.selectedSkills[indexPath.row]), height:30)
            //return CGSize(width:100, height:30)
        }
        return CGSize()
    }
    
    func getWidth(title:String) -> CGFloat{
        let font = UIFont(name: PoppinsFont.medium, size: 14)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let myText = title
        let size = (myText as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size.width + 25
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == portfolioCollectionView{
            return arrListing.count
        } else if collectionView == skillsCollectionView{
            return self.selectedSkills.count
            //return skills.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == portfolioCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PorfolioImagesCollectionViewCell", for: indexPath) as! PorfolioImagesCollectionViewCell
            if let imgStr = userDetail?.portfolioImages?[indexPath.row].file{
                cell.portfolioImage.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed: nil)
            }
            return cell
        }
       else if collectionView == skillsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillCollectionViewCell", for: indexPath)as! SkillCollectionViewCell
          cell.skillLabel.text = self.selectedSkills[indexPath.row]
           //cell.skillLabel.text = self.skills[indexPath.row].projectCategory?.title ?? ""
           return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == portfolioCollectionView {
            let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
            let imgStr = userDetail?.portfolioImages?[indexPath.row].file ?? ""
            destinationViewController!.isImage = false
            destinationViewController?.imsgeStrURL = imgStr
            
//            destinationViewController?.img = UIImage(named: "\(imgStr)") ?? im //UIImage()
            self.navigationController?.pushViewController(destinationViewController!, animated: true)
        }
    }
}

//MARK:- TableViewDelagate and DataSource
extension ContractorProfileHOVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewViewModel.reviewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllReviewTableViewCell", for: indexPath) as!AllReviewTableViewCell
        cell.conID = contractorID
        cell.isContractor = true
        cell.GetApiHit()
        cell.descriptionLbl.text = reviewViewModel.reviewData[indexPath.row].overAllFeedback
        cell.nameLbl.text = reviewViewModel.reviewData[indexPath.row].userDetail?.firstName
        
        if let imgStr = self.reviewViewModel.reviewData[indexPath.row].userDetail?.profilePic{
            
            cell.profileImages.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "Ic_profile"), completed: nil)
            
            let rating = reviewViewModel.reviewData[indexPath.row].rating
            let ratingValue = Double(rating ?? 0)
            print("rating--\(ratingValue)")
            
//            let ratingValue = Double(rating)
            cell.emojiVw1.isHidden = false
            cell.emojiVw2.isHidden = false
            cell.emojiVw3.isHidden = false
            cell.emojiVw4.isHidden = false
            cell.emojiVw5.isHidden = false
            
            if ratingValue == Double(5.0) {
                cell.emojiVw5.isHidden = true
            }
            else if ratingValue ?? Double(0.0) <= Double(4.9) && ratingValue ?? Double(0.0) >= Double(4.0) {
                cell.emojiVw4.isHidden = true
            }
            else if ratingValue ?? Double(0.0) <= Double(3.9) && ratingValue ?? Double(0.0) >= Double(3.0) {
                cell.emojiVw3.isHidden = true
            }
            else if ratingValue ?? Double(0.0) <= Double(2.9) && ratingValue ?? Double(0.0) >= Double(2.0){
                cell.emojiVw2.isHidden = true
            }
            else if ratingValue ?? Double(0.0) <= Double(1.9) && ratingValue ?? Double(0.0) >= Double(1.0){
                cell.emojiVw1.isHidden = true
            }
            
//            if ratingValue == 5 {
//                cell.emojiVw1.isHidden = true
//            }
//            else if ratingValue >= 4 {
//
//                cell.emojiVw2.isHidden = true
//            }
//            else if ratingValue == 3{
//
//                cell.emojiVw3.isHidden = true
//
//            }
//            else if ratingValue == 2{
//
//                cell.emojiVw4.isHidden = true
//            }
//            else if ratingValue == 0{
//
//                cell.emojiVw5.isHidden = true
//            }
        }
        //}
        
        if reviewViewModel.reviewData[indexPath.row].ratingImage?.count != 0{
           
            cell.collectionView.reloadData()
           
        }

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if reviewViewModel.reviewData[indexPath.row].ratingImage?.count != 0{
        return 320
         }
        return 200
    }
    
}


extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
