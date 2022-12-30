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
    
    @IBOutlet weak var varifyEmailBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var profileAddress: UILabel!
    @IBOutlet weak var verifiedUser: UIImageView!
    
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
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topview.layer.masksToBounds = false
        topview.layer.shadowColor = UIColor.lightGray.cgColor
        topview.layer.shadowOffset = CGSize(width: 0, height: 1)
        topview.layer.shadowRadius = 5.0
        topview.layer.shadowOpacity = 0.5
        topview.layer.shadowOffset = CGSize.zero
        topview.layer.cornerRadius = 5.0
        self.GetProfileApiHit()
    }
    
    // MARK: LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllInboxMessagesForRedDot()
        self.inboxMessagesss = fireBaseChatInbox().getAllInboxMessages()
        self.profileName.text = ""
        self.GetProfileApiHit()
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
                
//                self.profileAddress.text = "\(model?.data?.addressLine1 ?? "" ), \(model?.data?.addressLine2 ?? "" ) \(model?.data?.city ?? "" ), \(model?.data?.state ?? ""), \(model?.data?.zipCode ?? "")"
                    self.profileAddress.text = "\(model?.data?.addressLine1 ?? "" )"
//                    self.profileAddress.text = "\(model?.data?.addressLine1 ?? "" ) \(model?.data?.city ?? "" ), \(model?.data?.state ?? ""), \(model?.data?.zipCode ?? "")"
                
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
