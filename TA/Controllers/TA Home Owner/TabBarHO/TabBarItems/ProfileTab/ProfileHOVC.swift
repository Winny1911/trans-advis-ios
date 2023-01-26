//
//  ProfileHOVC.swift
//  TA
//
//  Created by Dev on 10/12/21.
//

import UIKit
import SDWebImage

class ProfileHOVC: BaseViewController {
    
    // MARK: OUTLET
    
    @IBOutlet weak var varifyEmailStackView: UIStackView!
    @IBOutlet weak var tableViewheight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var varifyEmailBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var profileAddress: UILabel!
    @IBOutlet weak var verifiedUser: UIImageView!
    
    @IBOutlet weak var lblNoReviews: UILabel!
    @IBOutlet weak var emojiView1: UIView!
    @IBOutlet weak var emojiView2: UIView!
    @IBOutlet weak var emojiView3: UIView!
    @IBOutlet weak var emojiView4: UIView!
    @IBOutlet weak var emojiView5: UIView!
    
    // MARK: Variable
    var profileViewModel = ProfileVM()
    var userDetail: profileUserDetail?
    var verifyEmailVM: VerifyEmailVM = VerifyEmailVM()
    var  email = ""
    
    // MARK: Review
    var reviewDataReload: (() -> ())?
    var getReviewCOVM: GetReviewCOVM = GetReviewCOVM()
    var getReviewVM: GetReviewVM = GetReviewVM()
    var reviewData: [ReviewData]?
    
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView .dataSource = self
        topview.layer.masksToBounds = false
        topview.layer.shadowColor = UIColor.lightGray.cgColor
        topview.layer.shadowOffset = CGSize(width: 0, height: 1)
        topview.layer.shadowRadius = 5.0
        topview.layer.shadowOpacity = 0.5
        topview.layer.shadowOffset = CGSize.zero
        topview.layer.cornerRadius = 5.0
        self.tableView.register(UINib.init(nibName: "AllReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "AllReviewTableViewCell")
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.tableView && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    //self.ReviewDataReload?()
                    self.reloadReviewData()
                }
            }
        }
    }
    
    func reloadReviewData() {
        self.tableView.layoutIfNeeded()
        //self.tableViewheight.constant = self.tableView.contentSize.height == 0 ? 100 : self.tableView.contentSize.height
    }
    
    // MARK: LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllInboxMessagesForRedDot()
        self.inboxMessagesss = fireBaseChatInbox().getAllInboxMessages()
        self.profileName.text = ""
        self.GetProfileApiHit()
        self.getReviewGetAPI()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func varifyBtnAction(_ sender: UIButton) {
        var param = [String:Any]()
        param ["email"] = email
        verifyEmailVM.verifyEmailApiCall(param){ model in
            print(model)
            showMessage(with: SucessMessage.VerifyEmailSuccessfully, theme: .success)
            
        }
    }
    
    
    // MARK: GetApi
    func getReviewGetAPI(){
        if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData)
        {
            getReviewVM.getReviewApiCall(obj.id ?? 0) { model in
            //getReviewCOVM.getReviewApiCall(obj.id ?? 0) { model in
                self.reviewData = model?.data?.reviews
                if self.reviewData?.count ?? 0 <= 0 {
                    self.tableView.isHidden = true
                    self.lblNoReviews.isHidden = false
                } else {
                    self.tableView.isHidden = false
                    self.lblNoReviews.isHidden = true
                }
                self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
                self.tableView.reloadData()
                self.reloadReviewData()
            }
        }
    }
    func GetProfileApiHit(){
        if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
            profileViewModel.getProfileApiCall(obj.id ?? 0) { model in
                self.userDetail = model?.data
                self.profileEmail.text = model?.data?.email ?? ""
                self.email = model?.data?.email ?? ""
                
                if model?.data?.emailVerified == 0{
                    self.verifiedUser.image = UIImage(named: "")
                    self.varifyEmailStackView.isHidden = false
                    
                }
                else if model?.data?.emailVerified == 1{
                    self.verifiedUser.image = UIImage(named: "ic_verified")
                    self.varifyEmailStackView.isHidden = false
                    self.varifyEmailBtn.isHidden = true
                    
                }
                
                self.profileAddress.text = "\(model?.data?.addressLine1 ?? "" )"
                self.profileName.text = "\(model?.data?.firstName ?? "") \(model?.data?.lastName ?? "")"
                
                self.profileImage.sd_setImage(with: URL(string: (model?.data?.profilePic ?? "")), placeholderImage: UIImage(named: "Ic_profile"), completed: nil)
                
                let rating = self.userDetail?.rating ?? "0.0"
                let ratingValue = Double(rating)
                self.emojiView1.isHidden = false
                self.emojiView2.isHidden = false
                self.emojiView3.isHidden = false
                self.emojiView4.isHidden = false
                self.emojiView5.isHidden = false
                
                if ratingValue == Double(5.0) {
                    self.emojiView5.isHidden = true
                }
                else if ratingValue ?? Double(0.0) <= Double(4.9) && ratingValue ?? Double(0.0) >= Double(4.0) {
                    self.emojiView4.isHidden = true
                }
                else if ratingValue ?? Double(0.0) <= Double(3.9) && ratingValue ?? Double(0.0) >= Double(3.0) {
                    self.emojiView3.isHidden = true
                }
                else if ratingValue ?? Double(0.0) <= Double(2.9) && ratingValue ?? Double(0.0) >= Double(2.0){
                    self.emojiView2.isHidden = true
                }
                else if ratingValue ?? Double(0.0) <= Double(1.9) && ratingValue ?? Double(0.0) >= Double(1.0){
                    self.emojiView1.isHidden = true
                }
            }
        }
    }
    
    // MARK: Setting Button Action
    @IBAction func tapDidSettingButtonAction(_ sender: UIButton) {
        let destinationViewController = Storyboard.profileHO.instantiateViewController(withIdentifier: "SettingHOVC") as? SettingHOVC
        destinationViewController!.settingDetail = userDetail
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
}

extension ProfileHOVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewData?.count ?? 0
    }
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllReviewTableViewCell", for: indexPath) as!AllReviewTableViewCell
        cell.descriptionLbl.text = reviewData?[indexPath.row].overAllFeedback
        cell.viewModel = getReviewVM
        
        var firstName = reviewData?[indexPath.row].userDetail?.firstName ?? ""
        var lastName = reviewData?[indexPath.row].userDetail?.lastName ?? ""
        cell.nameLbl.text = "\(firstName) \(lastName)"
        
        if let imgStr = reviewData?[indexPath.row].userDetail?.profilePic{
            
            cell.profileImages.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "Ic_profile"), completed: nil)
        }
        
        var rating = reviewData?[indexPath.row].rating
        var ratingValue = Double(rating ?? 0)
        print("rating--\(ratingValue)")
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
        
        if reviewData?[indexPath.row].ratingImage != nil {
            if (reviewData?[indexPath.row].ratingImage!.count)! > 0 {
                cell.index = indexPath.row
                cell.collectionView.isHidden = false
                cell.collectionView.reloadData()
            } else {
                cell.collectionView.isHidden = true
            }
        } else {
            cell.collectionView.isHidden = true
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

