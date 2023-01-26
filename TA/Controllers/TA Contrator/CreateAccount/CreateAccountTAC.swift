//
//  CreateAccountTAC.swift
//  TA
//
//  Created by Designer on 07/12/21.
//

import UIKit
import Photos
import SDWebImage

class CreateAccountTAC: BaseViewController {

    @IBOutlet weak var lblSelectSkills: UILabel!
    @IBOutlet weak var lblStep: UILabel!
    @IBOutlet weak var tblVwHeight: NSLayoutConstraint!
    @IBOutlet weak var tblVwSkills: UITableView!
    @IBOutlet weak var txtFldPhoneNumber: FloatingLabelInput!
    @IBOutlet weak var editIcone: UIImageView!
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = userImageView.frame.width / 2
            userImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var firstName: FloatingLabelInput!
    @IBOutlet weak var lastName: FloatingLabelInput!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var isFromEdit = false
    var isUserImageChangedFromEdit = false
    var userImageNotChangedStringFromEdit = ""
    
    private var userImage: String?
    let viewModel: CreateAccountTACVM = CreateAccountTACVM()
    var isImageSelected = false
    var arrSkills = [SkillsResponseDetail]()
    var selectedSkills = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblVwSkills.separatorColor = UIColor.clear
        self.tblVwSkills.tableFooterView = UIView()
        self.tblVwSkills.rowHeight = UITableView.automaticDimension
        self.tblVwSkills.estimatedRowHeight = 50
        tblVwSkills.delegate = self
        tblVwSkills.dataSource = self
        txtFldPhoneNumber.delegate = self
        self.firstName.delegate = self
        self.lastName.delegate = self
        editIcone.isHidden = true
        firstName.setLeftPadding(14)
        lastName.setLeftPadding(14)
        
        btnNext.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 16.0)
        preFilledDetails()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.isFromEditProfile(notification:)), name: Notification.Name("IsFromEdit"), object: nil)
    }
    
    @objc func isFromEditProfile(notification: Notification) {
        self.isFromEdit = true
        preFilledDetails()
    }

    func preFilledDetails() {
        if isFromEdit == true {
            if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
                self.fetchUserProfileData(userId: obj.id ?? 0)
                self.firstName.text = obj.firstName
                self.lastName.text = obj.lastName
                self.txtFldPhoneNumber.text = self.txtFldPhoneNumber.format(with: "(XXX)-XXX-XXXX", phone: obj.phoneNumber!)
                
                self.firstName.resetFloatingLable()
                self.lastName.resetFloatingLable()
                self.txtFldPhoneNumber.resetFloatingLable()
//                self.selectedSkills.removeAll()
//                let skillStr = obj.skillSet
//                let skillArr = skillStr?.components(separatedBy: ",")
//                if skillArr?.count ?? 0 > 0 {
//                    for i in 0 ..< skillArr!.count {
//                        self.selectedSkills.append(skillArr![i])
//                    }
//                }
                if let userImageStr = obj.profilePic {
                    self.userImageView.sd_setImage(with: URL(string: userImageStr), completed: nil)
                    self.isImageSelected = true
                    self.editIcone.isHidden = false
                    self.userImage = "\(randomString()).png"
                }
                viewModel.getSkillListApiCall { response in
                    self.arrSkills = response?.data?.listing ?? [SkillsResponseDetail]()
                    self.tblVwHeight.constant = CGFloat((self.arrSkills.count) * 50)
                    self.tblVwSkills.reloadData()
                }
                
            }
        }
    }
    
    func fetchUserProfileData(userId:Int) {
        viewModel.getUserProfileApi(params: ["id":userId]) { model in
            self.selectedSkills.removeAll()
            if model?.data?.userSkills?.count ?? 0 > 0 {
                for i in 0 ..<  (model?.data?.userSkills!.count)! {
                    self.selectedSkills.append("\(model?.data?.userSkills?[i].skillId ?? 0)")
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isFromEdit == true {
            
        } else {
            if let obj = UserDefaults.standard.retrieve(object: signupDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                if obj.userType == UserType.homeOwner {
                    self.progressBar.progress = 0.5
                    self.lblStep.text = "Step 1/2"
                    self.lblSelectSkills.isHidden = true
                    self.tblVwSkills.isHidden = true
                } else {
                    viewModel.getSkillListApiCall { response in
                        self.arrSkills = response?.data?.listing ?? [SkillsResponseDetail]()
                        self.tblVwHeight.constant = CGFloat((self.arrSkills.count) * 50)
                        self.tblVwSkills.reloadData()
                    }
                }
            } else if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                if obj.userType == UserType.homeOwner {
                    self.progressBar.progress = 0.5
                    self.lblStep.text = "Step 1/2"
                    self.lblSelectSkills.isHidden = true
                    self.tblVwSkills.isHidden = true
                } else {
                    viewModel.getSkillListApiCall { response in
                        self.arrSkills = response?.data?.listing ?? [SkillsResponseDetail]()
                        self.tblVwHeight.constant = CGFloat((self.arrSkills.count) * 50)
                        self.tblVwSkills.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: ACTION SELECT IMAGE
    @IBAction func actionSelectImage(_ sender: Any) {
        handleCameraOptions()
    }
    
    //MARK: ACTION NEXT
    @IBAction func nextButtonTapAction(_ sender: UIButton) {
        let firstName = firstName.text?.trimmed ?? ""
        let lastName = lastName.text?.trimmed ?? ""
        let phoneString = txtFldPhoneNumber.text?.trimmed ?? ""
        let phoneString2 = phoneString.replacingOccurrences(of: "-", with: "")
        let phoneString3 = phoneString2.replacingOccurrences(of: "(", with: "")
        let phoneString4 = phoneString3.replacingOccurrences(of: ")", with: "")
        let phoneString5 = phoneString4.replacingOccurrences(of: " ", with: "")
        
        if isFromEdit == true {
            if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                if obj.userType == UserType.homeOwner {
                    self.selectedSkills = ["0"]
                }
            }
        } else {
            if let obj = UserDefaults.standard.retrieve(object: signupDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                if obj.userType == UserType.homeOwner {
                    self.selectedSkills = ["0"]
                }
            } else if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                if obj.userType == UserType.homeOwner {
                    self.selectedSkills = ["0"]
                }
            }
        }
        
        let createAccountModel  = CreateAccountModel(firstName: firstName, lastName: lastName, userImage: self.userImageView.image ?? UIImage(), isImageSelected: self.isImageSelected, phoneNumber: phoneString5, skillSet: self.selectedSkills, userImageName: self.userImage ?? "123456")
        viewModel.model = createAccountModel
        viewModel.validateCreateAccountModel (isFromEdit: self.isFromEdit){[weak self] (success, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                if let model = success {
                    
                    self?.viewModel.checkPhoneNumber(["phoneNumber": createAccountModel.phoneNumber]) {
                        if self!.isFromEdit == true {
                            if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                                if obj.userType == UserType.homeOwner {
                                    let vc = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "SetLocationVC") as? SetLocationVC
                                    vc!.createAccountModel = model
                                    self?.navigationController?.pushViewController(vc!, animated: true)
                                } else {
                                    let vc = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "UploadLicenceVC") as? UploadLicenceVC
                                    if self?.isFromEdit == true {
                                        vc!.isFromEdit = self!.isFromEdit
                                        vc!.isUserImageChangedFromEdit = self!.isUserImageChangedFromEdit
                                        if self!.isUserImageChangedFromEdit == false {
                                            let imgStr = obj.profilePic
                                            self!.userImageNotChangedStringFromEdit = (imgStr?.replacingOccurrences(of: "https://transadvisor-dev.s3.amazonaws.com/users/", with: ""))!
                                            vc!.userImageNotChangedStringFromEdit = self!.userImageNotChangedStringFromEdit
                                        }
                                    }
                                    vc!.createAccountModel = model
                                    self?.navigationController?.pushViewController(vc!, animated: true)
                                }
                            }
                        } else {
                            if let obj = UserDefaults.standard.retrieve(object: signupDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                                if obj.userType == UserType.homeOwner {
                                    let vc = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "SetLocationVC") as? SetLocationVC
                                    vc!.createAccountModel = model
                                    self?.navigationController?.pushViewController(vc!, animated: true)
                                } else {
                                    let vc = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "UploadLicenceVC") as? UploadLicenceVC
                                    vc!.createAccountModel = model
                                    self?.navigationController?.pushViewController(vc!, animated: true)
                                }
                            } else if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                                if obj.userType == UserType.homeOwner {
                                    let vc = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "SetLocationVC") as? SetLocationVC
                                    vc!.createAccountModel = model
                                    self?.navigationController?.pushViewController(vc!, animated: true)
                                } else {
                                    let vc = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "UploadLicenceVC") as? UploadLicenceVC
                                    vc!.createAccountModel = model
                                    self?.navigationController?.pushViewController(vc!, animated: true)
                                }
                            }
                        }
                    }
                    print("model: ", model)
                }
            }
            else {
                if let errorMsg = strongSelf.viewModel.error {
                    showMessage(with: errorMsg)
                }
            }
        }
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension CreateAccountTAC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func handleCameraOptions() {
        
        self.view.endEditing(true)
        
        let actionSheetController: UIAlertController = UIAlertController(title: UIFunction.getLocalizationString(text: "User Image"), message: nil, preferredStyle: .actionSheet)
        
        let actionCamera: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Take photo"), style: .default) { action -> Void in
            
            self.choosePhotoFromCameraAction()
        }
        
        let actionGallery: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Choose from gallery"), style: .default) { action -> Void in
            
            self.choosePhotoFromGalleryAction()
        }
        
        let viewPhoto: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "View photo"), style: .default) { action -> Void in
            
            if self.isFromEdit == true {
                if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
                    if let _userImage = obj.profilePic, _userImage.count > 0 {
                        self.showPhotoBrowser(image: _userImage)
                    }
                }
                
            } else {
                if let _userImage = self.userImage, _userImage.count > 0 {
                    self.showPhotoBrowser(image: _userImage)
                }
            }
            
        }
        
        let removePhoto: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Remove photo"), style: .default) { action -> Void in
            DispatchQueue.main.async {
                self.userImageView.image = #imageLiteral(resourceName: "ic_upload_image")
                self.editIcone.isHidden = true
                self.isImageSelected = false
                self.userImageView.contentMode = .scaleToFill
                self.userImageView.setNeedsDisplay()
            }
            self.userImage = nil
            self.showImageInUserPhotoImageView()
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Cancel title"), style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        
        actionCamera.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
        actionGallery.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
        viewPhoto.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
        removePhoto.setValue(UIColor.rbg(r: 255, g: 0, b: 0), forKey: "titleTextColor")
        cancelAction.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
        
        if userImage == nil || userImage?.count == 0
        {
            actionSheetController.addAction(actionCamera)
            actionSheetController.addAction(actionGallery)
            actionSheetController.addAction(cancelAction)
        }
        else
        {
            actionSheetController.addAction(removePhoto)
            actionSheetController.addAction(viewPhoto)
            actionSheetController.addAction(actionCamera)
            actionSheetController.addAction(actionGallery)
            actionSheetController.addAction(cancelAction)
        }
        
        actionSheetController.popoverPresentationController?.sourceView = self.view
        actionSheetController.popoverPresentationController?.sourceRect = CGRect(x: 20, y: self.view.bounds.size.height - 150, width: 1.0, height: 1.0)
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    // MARK:-
    // MARK:- -------- Permissions ---------
    func choosePhotoFromCameraAction()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            self.perform(#selector(showCamera), with: nil, afterDelay: 0.3)
        }
        else
        {
            let alertController: UIAlertController = UIAlertController(title: "Error", message: "Device has no camera.", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in
            }

            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func showCamera()
    {
        let status  = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .authorized
        {
            DispatchQueue.main.async {
                self.openCamera()
            }
        }
        else if status == .notDetermined
        {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (status) in
                if status == true
                {
                    DispatchQueue.main.async {
                        self.openCamera()
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                    self.showAlertOfPermissionsNotAvailable()
                    }
                }
            })
        }
        else if status == .restricted || status == .denied
        {
            DispatchQueue.main.async {
            self.showAlertOfPermissionsNotAvailable()
            }
        }
    }
    
    func openCamera()
    {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromGalleryAction()
    {
        let status = PHPhotoLibrary.authorizationStatus()
        if(status == .notDetermined)
        {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized
                {
                    DispatchQueue.main.async {
                        self.openGallery()
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                    self.showAlertOfPermissionsNotAvailable()
                    }
                }
            })
            
        }
        else if (status == .authorized)
        {
            DispatchQueue.main.async {
                self.openGallery()
            }
        }
        else if (status == .restricted || status == .denied)
        {
            DispatchQueue.main.async {
            self.showAlertOfPermissionsNotAvailable()
            }
        }
    }
    
    // MARK:-
    // MARK:- Open Gallery
    func openGallery()
    {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK:-
    // MARK:- Show Alert With No Permissions Message
    func showAlertOfPermissionsNotAvailable()
    {
        let message = UIFunction.getLocalizationString(text: "Camera permission not available")
        let alertController: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let cancel_title = UIFunction.getLocalizationString(text: "Cancel title")
        let cancelAction = UIAlertAction(title: cancel_title, style: .destructive) { (_) -> Void in
        }
        
        let settings_title = UIFunction.getLocalizationString(text: "Settings title")
        let settingsAction = UIAlertAction(title: settings_title, style: .default) { (_) -> Void in
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK:-
    // MARK:- -------- Image Picker Delegates --------------
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        picker.dismiss(animated: true, completion: nil)
        
        
        let imageName: String = UIFunction.getRandomImageName()
        let fileManager = FileManager.default
        do
        {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(imageName)
            userImageView.contentMode = .scaleAspectFill
            if  UIDevice.current.userInterfaceIdiom == .phone
            {
                if let imageData = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as! UIImage).jpegData(compressionQuality: 0.0)
                {
                    try imageData.write(to: fileURL)
                }
            }
            else
            {
                if let imageData = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage).jpegData(compressionQuality: 0.0)
                {
                    try imageData.write(to: fileURL)
                }
            }
            
            userImage = NSString(format:"%@",imageName as CVarArg) as String
            self.showImageInUserPhotoImageView()
        }
        catch
        {}
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK:-
    // MARK:- Show Image in User Image View
    func showImageInUserPhotoImageView()
    {
        self.view.endEditing(true)
        guard let userImage = userImage else
        {
//            let add_photo = UIFunction.getLocalizationString(text: "add_photo_title")
//            self.buttonAddImage .setTitle(add_photo, for: .normal)
            self.userImageView.image = nil
            self.editIcone.isHidden = true
            self.isImageSelected = false
            return
        }

//        self.buttonAddImage .setTitle(nil, for: .normal)

        if (userImage as String).count == 0
        {
           // let add_photo = UIFunction.getLocalizationString(text: "add_photo_title")
//            self.buttonAddImage .setTitle(add_photo, for: .normal)
            self.userImageView.image = nil
            self.editIcone.isHidden = true
            self.isImageSelected = false
        }
        else if ((userImage as String).hasPrefix("http") || (userImage as String).hasPrefix("https"))
        {
            // image from url
            userImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            userImageView.sd_setImage(with: URL(string: userImage), placeholderImage: nil)
        }
        else
        {
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
            let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            if let dirPath          = paths.first
            {
                let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(userImage)
                let image    = UIImage(contentsOfFile: imageURL.path)
                userImageView.image = image
                if self.isFromEdit == true {
                    self.isUserImageChangedFromEdit = true
                }
                self.editIcone.isHidden = false
                self.isImageSelected = true
            }
        }
    }
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

extension CreateAccountTAC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFldPhoneNumber {
            if string.count > 0 {
                self.txtFldPhoneNumber.resetFloatingLable()
            }
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = textField.format(with: "(XXX) XXX-XXXX", phone: newString)
            return false
        }
        return true
    }
}
extension CreateAccountTAC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSkills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectSkillsTblVwCell
        cell.lblTile.text = self.arrSkills[indexPath.row].title ?? ""
        cell.selectBtn.tag = indexPath.row
        cell.selectBtn.addTarget(self, action: #selector(selectSkill(sender:)), for: .touchUpInside)
        if selectedSkills.contains("\(self.arrSkills[indexPath.row].id ?? 0)") {
            cell.imgCheck.image = UIImage(named: "ic_checkbox_filled")
        } else {
            cell.imgCheck.image = UIImage(named: "ic_check_box")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    @objc func selectSkill(sender: UIButton) {
        let id = self.arrSkills[sender.tag].id ?? 0
        var newId = String(id)
        if (self.selectedSkills.contains(newId)) {
//        if (self.selectedSkills.contains(self.arrSkills[sender.tag].title ?? "")) {
            let indx = self.selectedSkills.firstIndex(of: ("\(self.arrSkills[sender.tag].id ?? 0)")) ?? 0
            self.selectedSkills.remove(at: indx)
        } else {
            self.selectedSkills.append("\(self.arrSkills[sender.tag].id ?? 0)")
        }
        self.tblVwSkills.reloadData()
    }
}
