//
//  ProfileVC.swift
//  TA
//
//  Created by Designer on 16/12/21.
//

import UIKit
import GBFloatingTextField

class ProfileVC: BaseViewController {
    
    @IBOutlet weak var tableViewheight: NSLayoutConstraint!
    @IBOutlet var aboutMeVwBottom: NSLayoutConstraint!
    @IBOutlet weak var lineView: UIView!
  //  @IBOutlet  var aboutMeViewbottom: NSLayoutConstraint!
    @IBOutlet weak var confirmBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var aboutMeTxtVws: GBFloatingTextView!
    @IBOutlet weak var verifyEmailStackView: UIStackView!
    @IBOutlet weak var verifyEmailBtn: UIButton!
    @IBOutlet weak var lblNoreviews: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var portfolioCollectionView: UICollectionView!
    @IBOutlet weak var skillsCollectionView: UICollectionView!
    @IBOutlet weak var profilePicImg: UIImageView!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var projectCompleteLbl: UILabel!
    @IBOutlet weak var taIDLabel: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var keySkillBtn: UIButton!
    @IBOutlet weak var emojiVw1: UIView!
    @IBOutlet weak var emojiVw2: UIView!
    @IBOutlet weak var emojiVw3: UIView!
    @IBOutlet weak var emojiVw4: UIView!
    @IBOutlet weak var emojiVw5: UIView!
    @IBOutlet weak var verifiedUser: UIImageView!
    @IBOutlet weak var aboutMeVw: UIView!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    //@IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var aboutMeLbl: UILabel!
    var ReviewDataReload: (() -> ())?
    // MARK: Variable
    var profileViewModel = ContractorProfileVM()
    var getReviewCOVM: GetReviewCOVM = GetReviewCOVM()
    var verifyEmailVM: VerifyEmailVM = VerifyEmailVM()
//    var userDetail = ContractorProfileVM().userData
    var userDetail: ContractorUserData?
    var detail: [ContractorUserData]?
    var reviewData: [ReviewData]?
    
//    var keyskill: [UserSkills]?
    var selectedSkills = [String]()
    var arrListing: [PortfolioImage]?
    var projectId = 0
    var reviewViewModel = GetReviewVM()
    var indx = Int()
    var indexValue = Int()
    var position = Int()
    var positions = Int()
    var imageNo = 0
    var skillValue = 0
    var email = ""
    var contractorDeepLink = ""
    var vendorDeepLink = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.aboutMeVwBottom.isActive = false
//        aboutMeVw.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
//        aboutMeLbl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 22).isActive = true
        self.aboutMeTxtVws.text = ""
      
       // aboutMeTxtVws.setLeftPadding(14.0)
        aboutMeTxtVws.isFloatingLabel = true
        self.aboutMeTxtVws.placeholder = ""
        aboutMeTxtVws.placeholderColor = UIColor.appBtnColorGrey
        aboutMeTxtVws.topPlaceholderColor = UIColor.appFloatText
        aboutMeTxtVws.selectedColor = UIColor.appFloatText
        aboutMeTxtVws.setLeftPadding(9.0)
        
        self.portfolioCollectionView.delegate = self
        self.portfolioCollectionView.dataSource = self
        self.skillsCollectionView.delegate = self
        self.skillsCollectionView.dataSource = self
        self.tableView.delegate = self
        self.tableView .dataSource = self
        cancelBtn.setRoundCorners(radius: 6)
        confirmBtn.setRoundCorners(radius: 6)
        viewHeightConstraint.constant = 0
        confirmBtnHeight.constant = 0
        aboutMeLbl.text = UserDefaults.standard.value(forKey: "AboutMe") as? String
    
        //Register Cells
        self.portfolioCollectionView.register(UINib(nibName: "PorfolioImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PorfolioImagesCollectionViewCell")
        self.skillsCollectionView.register(UINib(nibName: "SkillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SkillCollectionViewCell")
        self.tableView.register(UINib.init(nibName: "AllReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "AllReviewTableViewCell")
        
//        self.GetProfileApiHit()
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
        self.tableViewheight.constant = self.tableView.contentSize.height == 0 ? 100 : self.tableView.contentSize.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getAllInboxMessagesForRedDot()
        tabBarController?.selectedIndex = 4
        lblNoreviews.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.GetProfileApiHit()
        self.getReviewGetAPI()
    }
    
    // MARK: GetApi
    func GetProfileApiHit(){
        if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
            profileViewModel.getProfileApiCall(obj.id ?? 0) { model in
                self.userDetail = model?.data
                self.profilePicImg.sd_setImage(with: URL(string: (model?.data?.profilePic) ?? ""), placeholderImage: UIImage(named: "Ic_profile"), completed: nil)
                self.firstNameLbl.text = "\(model?.data?.firstName ?? "") \(model?.data?.lastName ?? "")"
                self.emailLbl.text = model?.data?.email ?? ""
                self.email = self.emailLbl.text ?? ""
                
                
                    self.addressLbl.text = "\(model?.data?.addressLine1 ?? "" )"
                    
//                    self.addressLbl.text = "\(model?.data?.addressLine1 ?? "" ) \(model?.data?.city ?? "" ), \(model?.data?.state ?? ""), \(model?.data?.zipCode ?? "")"
//                self.addressLbl.text = "\(model?.data?.addressLine1 ?? "" ), \(model?.data?.addressLine2 ?? "" ) \(model?.data?.city ?? "" ), \(model?.data?.state ?? ""), \(model?.data?.zipCode ?? "")"
                if model?.data?.emailVerified == 1{
                    self.verifiedUser.isHidden = false
                    self.verifyEmailBtn.isHidden = true
                    self.verifyEmailStackView.isHidden = true
                } else {
                    //0
                    self.verifyEmailBtn.isHidden = false
                    self.verifiedUser.isHidden = true
                    self.verifyEmailStackView.isHidden = false
                    
                }
                self.contractorDeepLink = ""
                self.vendorDeepLink = ""
                self.vendorDeepLink = model?.data?.venderDeepLink ?? ""
                self.contractorDeepLink = model?.data?.contractorDeepLink ?? ""
                self.arrListing = model?.data?.portfolioImages
                self.selectedSkills.removeAll()
                let skillArr = model?.data?.userSkills
//                let skillArr = skillStr?.components(separatedBy: ",")
                if skillArr?.count ?? 0 > 0 {
                    for i in 0 ..< skillArr!.count{
                        if skillArr![i].projectCategory != nil {
                            self.selectedSkills.append(skillArr![i].projectCategory?.title ?? "")
                            self.taIDLabel.text = "\(skillArr![i].userId ?? 0)"
                        }
                    }
                }
                self.review()
                self.tableView.reloadData()
                self.portfolioCollectionView.reloadData()
                self.skillsCollectionView.reloadData()
                self.reloadReviewData()
            }
        }
    }
    
    func review(){
        let rating = userDetail?.rating ?? "0.0"
        let ratingValue = Double(rating)
        emojiVw1.isHidden = false
        emojiVw2.isHidden = false
        emojiVw3.isHidden = false
        emojiVw4.isHidden = false
        emojiVw5.isHidden = false
        
        if ratingValue == Double(5.0) {
            emojiVw5.isHidden = true
        }
        else if ratingValue ?? Double(0.0) <= Double(4.9) && ratingValue ?? Double(0.0) >= Double(4.0) {
            emojiVw4.isHidden = true
        }
        else if ratingValue ?? Double(0.0) <= Double(3.9) && ratingValue ?? Double(0.0) >= Double(3.0) {
            emojiVw3.isHidden = true
        }
        else if ratingValue ?? Double(0.0) <= Double(2.9) && ratingValue ?? Double(0.0) >= Double(2.0){
            emojiVw2.isHidden = true
        }
        else if ratingValue ?? Double(0.0) <= Double(1.9) && ratingValue ?? Double(0.0) >= Double(1.0){
            emojiVw1.isHidden = true
        }
    }
    
    func getReviewGetAPI(){
        if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData)
        {
            getReviewCOVM.getReviewApiCall(obj.id ?? 0) { model in
                self.reviewData = model?.data?.reviews
                if self.reviewData?.count ?? 0 <= 0 {
                    self.tableView.isHidden = true
                    self.lblNoreviews.isHidden = false
                } else {
                    self.tableView.isHidden = false
                    self.lblNoreviews.isHidden = true
                }
                self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
                self.tableView.reloadData()
                self.reloadReviewData()
            }
        }
    }
    
    @IBAction func verifyEmailBtnAction(_ sender: Any) {
        var param = [String:Any]()
        param ["email"] = email
        verifyEmailVM.verifyEmailApiCall(param){ model in
            print(model)
            showMessage(with: SucessMessage.VerifyEmailSuccessfully, theme: .success)
        }
    }
    @IBAction func aboutMeEditBtnAction(_ sender: Any) {
        self.aboutMeVwBottom.isActive = true
        self.aboutMeTxtVws.placeholder = "About me"
        self.aboutMeLbl.isHidden = true
        self.viewHeightConstraint.constant = 180
        confirmBtnHeight.constant = 40
     }
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.aboutMeTxtVws.placeholder = ""
        aboutMeLbl.isHidden = false
        aboutMeLbl.text = UserDefaults.standard.value(forKey: "AboutMe") as? String
        viewHeightConstraint.constant = 0
        confirmBtnHeight.constant = 0
        self.aboutMeVwBottom.isActive = false
        self.aboutMeTxtVws.isFloatingLabel  = false
    }
    @IBAction func confirmBtnAction(_ sender: Any) {
        self.aboutMeTxtVws.placeholder = ""
        if aboutMeTxtVws.text == ""{
            showMessage(with: ValidationError.enteryourBio, theme: .error)
        }else if aboutMeTxtVws.text.count <= 10  {
            showMessage(with: ValidationError.characterCount, theme: .error)
        }
        else if aboutMeTxtVws.text == aboutMeTxtVws.text {
            UserDefaults.standard.set(self.aboutMeTxtVws.text, forKey: "AboutMe")
            aboutMeLbl.text = aboutMeTxtVws.text
            viewHeightConstraint.constant = 0
            confirmBtnHeight.constant = 0
            aboutMeLbl.isHidden = false
            self.aboutMeVwBottom.isActive = false
            self.aboutMeTxtVws.isFloatingLabel  = true
        }
     }
    
    @IBAction func tapDidAddPortfilioButtonAction(_ sender: UIButton) {
        let destinationViewController = Storyboard.profile.instantiateViewController(withIdentifier: "AddPortfolioImageVC") as? AddPortfolioImageVC
        destinationViewController?.id  = userDetail?.id ?? 0
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
    
    @IBAction func tapDidSettingButtonAction(_ sender: UIButton) {
        let destinationViewController = Storyboard.profileHO.instantiateViewController(withIdentifier: "SettingHOVC") as? SettingHOVC
        destinationViewController!.settingDetails = userDetail
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
    
    
    @IBAction func tapDidShareButtonAction(_ sender: UIButton) {
//        if let name = URL(string: "https://itunes.apple.com/us/app/myapp/idxxxxxxxx?ls=1&mt=8"), !name.absoluteString.isEmpty {
//          let objectsToShare = [name]
//          let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//          self.present(activityVC, animated: true, completion: nil)
//        } else {
//          // show alert for not available
//        }
        let items = ["Hey! Check out this contractor I found on the Transaction Advisor platform that might be useful for you. \(self.contractorDeepLink)"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
}

//MARK:  - Extension CollectionDelegateFlowLayout,delegate and DataSource
extension ProfileVC: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == portfolioCollectionView{
            return CGSize(width:100 , height:64)
        }
        else if collectionView == skillsCollectionView{
            print(CGSize(width: getWidth(title: selectedSkills[indexPath.row]), height: 30))
            return CGSize(width: getWidth(title: selectedSkills[indexPath.row]), height: 30)
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
            return userDetail?.portfolioImages?.count ?? 0
        }
        else if collectionView == skillsCollectionView{
            return selectedSkills.count ?? 0
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
        } else if collectionView == skillsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillCollectionViewCell", for: indexPath)as! SkillCollectionViewCell
            cell.skillLabel.text = selectedSkills[indexPath.row] ?? ""
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == portfolioCollectionView {
            if let image = userDetail?.portfolioImages?[indexPath.row].file {
                let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
                destinationViewController!.isImage = false
                destinationViewController?.imsgeStrURL = image
                destinationViewController?.img = UIImage()
                self.navigationController?.pushViewController(destinationViewController!, animated: true)
            }
        }
    }
}

//MARK:- TableViewDelagate and DataSource
extension ProfileVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return reviewViewModel.reviewData.count
//        return userDetail?.userDocuments.count ?? 0
        return reviewData?.count ?? 0
    }
//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllReviewTableViewCell", for: indexPath) as!AllReviewTableViewCell
        cell.descriptionLbl.text = reviewData?[indexPath.row].overAllFeedback
        
        var firstName = reviewData?[indexPath.row].userDetail?.firstName ?? ""
        var lastName = reviewData?[indexPath.row].userDetail?.lastName ?? ""
        cell.nameLbl.text = "\(firstName) \(lastName)"

        if let imgStr = reviewData?[indexPath.row].userDetail?.profilePic{

            cell.profileImages.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "Ic_profile"), completed: nil)
            }

            var rating = reviewData?[indexPath.row].rating
            var ratingValue = Double(rating ?? 0)
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
//            else if ratingValue == 4 {
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

        if reviewData?[indexPath.row].ratingImages?.count != 0{
            cell.collectionView.reloadData()
        }

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
