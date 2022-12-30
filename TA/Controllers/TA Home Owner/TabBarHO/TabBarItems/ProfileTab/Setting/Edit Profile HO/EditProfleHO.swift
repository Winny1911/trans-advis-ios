//
//  EditProfleHO.swift
//  TA
//
//  Created by Designer on 31/12/21.
//

import UIKit
import CoreLocation
import Photos
import SDWebImage

class EditProfleHO: BaseViewController, UITextFieldDelegate {

    // MARK: Outlet
    @IBOutlet weak var attachMentTableView: UITableView!
    @IBOutlet weak var licenseImage: UIImageView!
    @IBOutlet weak var uploadLicenseViewHeight: NSLayoutConstraint!
    @IBOutlet weak var uploadLicenseView: CustomeDasboardView!
    @IBOutlet weak var txtFldLicenseNumber: FloatingLabelInput!
    @IBOutlet weak var stckVwTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblStaticSkill: UILabel!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var smallpopUpView: UIView!
    @IBOutlet weak var tblVwSkills: UITableView!
    @IBOutlet weak var tblVwHeight: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var editIcone: UIImageView!
    @IBOutlet weak var txtFldFindLocation: FloatingLabelInput!
    @IBOutlet weak var firstName: FloatingLabelInput!
    @IBOutlet weak var lastName: FloatingLabelInput!
    @IBOutlet weak var phoneNumber: FloatingLabelInput!
    @IBOutlet weak var street: FloatingLabelInput!
    @IBOutlet weak var city: FloatingLabelInput!
    @IBOutlet weak var state: FloatingLabelInput!
    @IBOutlet weak var zipcode: FloatingLabelInput!
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var profileImage: UIImageView!{
        didSet {
            profileImage.layer.cornerRadius = profileImage.frame.width / 2
            profileImage.clipsToBounds = true
        }
    }

    let viewModel: CreateAccountTACVM = CreateAccountTACVM()
    var createAccountModel = CreateAccountModel()
    var ProfileHOModel: ProfileHOModel?
    var editProfileViewModel = EditProfileVM()
    
    // MARK: Variable
    var settingDetail: profileUserDetail?
    var settingDetails: ContractorUserData?
    let locationManager = CLLocationManager()
    var arrSkills = [SkillsResponseDetail]()
    
    var selectedSkills = [String]()
    var selectedSkillsId = [Int]()
    var phoneNo = ""
    var skill = ""
    var isImageSelected = false
    var isFromEdit = false
    var isUserImageChangedFromEdit = false
    var userImageNotChangedStringFromEdit = ""
    
    var isFrom  = ""
    var longitude = ""
    var latitude = ""
    var selectedType = ""
    var docURL:URL?
    var attachmentImage = UIImage()
    var attachmentName = ""
    var docName = ""
    var newAttachmentImage = [String]()
    var newAttachmentLabel = [String]()
    var isProfile = false
    
    private var userImage: String?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.zipcode.delegate = self
        self.phoneNumber.delegate = self
        
        self.smallpopUpView.isHidden = true
        self.smallpopUpView.setRoundCorners(radius: 10.0)
        self.popUpView.isHidden = true
        self.smallpopUpView.isHidden = true
        self.tblVwSkills.separatorColor = UIColor.clear
        self.tblVwSkills.tableFooterView = UIView()
        self.tblVwSkills.rowHeight = UITableView.automaticDimension
        self.tblVwSkills.estimatedRowHeight = 50
        tblVwSkills.delegate = self
        tblVwSkills.dataSource = self
        attachMentTableView.delegate = self
        attachMentTableView.dataSource = self
        
        txtFldFindLocation.delegate = self
        txtFldFindLocation.setLeftPadding(14)
        txtFldFindLocation.isUserInteractionEnabled = false
        txtFldFindLocation.setRightPaddingIconLocation(icon: UIImage(named: "ic_find_location")!)
        firstName.setLeftPadding(14)
        lastName.setLeftPadding(14)
        txtFldLicenseNumber.setLeftPadding(14)
        phoneNumber.setLeftPadding(14)
        street.setLeftPadding(14)
        city.setLeftPadding(14)
        state.setLeftPadding(14)
        zipcode.setLeftPadding(14)
        
        self.city.isUserInteractionEnabled = false
        self.state.isUserInteractionEnabled = false
        
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
        topView.layer.shadowRadius = 5.0
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize.zero
        
        buttomView.layer.masksToBounds = false
        buttomView.layer.shadowColor = UIColor.lightGray.cgColor
        buttomView.layer.shadowOffset = CGSize(width: 0, height: 1)
        buttomView.layer.shadowRadius = 5.0
        buttomView.layer.shadowOpacity = 0.5
        buttomView.layer.shadowOffset = CGSize.zero

        attachMentTableView.register(UINib.init(nibName: "AttachmentListTableViewCell", bundle: nil), forCellReuseIdentifier: "AttachmentListTableViewCell")
        if settingDetail != nil{
            self.hODataFetch()
            self.lblStaticSkill.isHidden = true
            self.tblVwHeight.constant = 0.0
            self.stckVwTopConstraint.constant = -40.0
        } else if (settingDetails != nil){
            self.fetchSkills()
        }
    }
    
    // MARK: TextField delegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if textField == zipcode {
            let currentText = zipcode.text ?? ""
            guard let stringRange = Range(range, in: currentText) else {
                return false
            }
            let updateText = currentText.replacingCharacters(in: stringRange, with: string)
            return updateText.count < 11
        }
        if textField == phoneNumber {
            if string.count > 0 {
                self.phoneNumber.resetFloatingLable()
            }
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = textField.format(with: "(XXX) XXX-XXXX", phone: newString)
            return false
        }
        return true
    }
    
    func setContractorDetails() {
        constractorDataFetch()
        let skillArr = settingDetails?.userSkills
        self.selectedSkills.removeAll()
        self.selectedSkillsId.removeAll()
        if skillArr?.count ?? 0 > 0 {
            for i in 0 ..< skillArr!.count {
                if skillArr?[i].projectCategory?.id != nil && skillArr?[i].projectCategory?.id != 0 {
                    self.selectedSkillsId.append(skillArr![i].projectCategory?.id ?? 0)
                    self.selectedSkills.append(skillArr![i].projectCategory?.title ?? "")
                }
            }
            self.lblStaticSkill.isHidden = false
            self.stckVwTopConstraint.constant = 24.0
            self.tblVwHeight.constant = CGFloat((self.arrSkills.count) * 50)
            
            // ------
            if settingDetail != nil{
                print("n")
            } else if (settingDetails != nil) {
                for i in 0..<(settingDetails?.userDocuments.count ?? 0) {
                    self.newAttachmentImage.append(settingDetails?.userDocuments[i].file ?? "")
                    self.newAttachmentLabel.append("\(settingDetails?.userDocuments[i].title ?? "")")
                }
//                self.newAttachmentImage.append(settingDetails?.userDocuments[0].file ?? "")
//                self.newAttachmentLabel.append("\(settingDetails?.userDocuments[0].title ?? "")")
            }
            self.tblVwSkills.reloadData()
            self.attachMentTableView.reloadData()
        }
    }
    
    func fetchSkills() {
        let viewModel: CreateAccountTACVM = CreateAccountTACVM()
        viewModel.getSkillListApiCall { response in
            self.arrSkills = response?.data?.listing ?? [SkillsResponseDetail]()
            self.setContractorDetails()
        }
    }
    
    func setLocationData() {
        if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
            self.street.text = obj.addressLine1
            self.street.resetFloatingLable()
            
            self.city.text = obj.city
            self.city.resetFloatingLable()
            
            self.state.text = obj.state
            self.state.resetFloatingLable()
            
            self.zipcode.text = obj.zipCode
            self.zipcode.resetFloatingLable()
            
            self.longitude = obj.longitude ?? "0.0"
            self.latitude = obj.latitude ?? "0.0"
        }
    }
    
    func hODataFetch() {
        self.uploadLicenseViewHeight.constant = 0
        self.uploadLicenseView.isHidden = true
        self.txtFldLicenseNumber.isHidden = true
        if settingDetail?.profilePic != ""{
            profileImage.sd_setImage(with: URL(string: (settingDetail?.profilePic) ?? ""), placeholderImage: UIImage(named: "doc"), completed: nil)
        }
        if settingDetail?.firstName != ""{
            self.firstName.text = settingDetail?.firstName
            self.firstName.resetFloatingLable()
        }
        if settingDetail?.lastName != ""{
            self.lastName.text = settingDetail?.lastName
            self.lastName.resetFloatingLable()
        }
        if settingDetail?.phoneNumber != ""{
            self.phoneNumber.text = self.phoneNumber.format(with: "(XXX) XXX-XXXX", phone: (settingDetail?.phoneNumber)!)
//            self.phoneNumber.text = settingDetail?.phoneNumber
            self.phoneNumber.resetFloatingLable()
        }
        if settingDetail?.addressLine1 != ""{
            self.street.text = settingDetail?.addressLine1
            self.street.resetFloatingLable()
        }
        if settingDetail?.city != ""{
            self.city.text = settingDetail?.city
            self.city.resetFloatingLable()
        }
        if settingDetail?.state != ""{
            self.state.text = settingDetail?.state
            self.state.resetFloatingLable()
        }
        if settingDetail?.zipCode != ""{
            self.zipcode.text = settingDetail?.zipCode
            self.zipcode.resetFloatingLable()
        }
        
        self.latitude = settingDetail?.latitude ?? "0.0"
        self.longitude = settingDetail?.longitude ?? "0.0"
        
    }
    
    func constractorDataFetch(){
        self.txtFldLicenseNumber.isHidden = false
        if settingDetails?.profilePic != ""{
            profileImage.sd_setImage(with: URL(string: (settingDetails?.profilePic) ?? ""), placeholderImage: UIImage(named: "doc"), completed: nil)
        }
        if settingDetails?.firstName != ""{
            self.firstName.text = settingDetails?.firstName
            self.firstName.resetFloatingLable()
        }
        if settingDetails?.lastName != ""{
            self.lastName.text = settingDetails?.lastName
            self.lastName.resetFloatingLable()
        }
        if settingDetails?.phoneNumber != ""{
            self.phoneNumber.text = self.phoneNumber.format(with: "(XXX) XXX-XXXX", phone: (settingDetails?.phoneNumber)!)
//            self.phoneNumber.text = settingDetails?.phoneNumber
            self.phoneNumber.resetFloatingLable()
        }
        if settingDetails?.addressLine1 != ""{
            self.street.text = settingDetails?.addressLine1
            self.street.resetFloatingLable()
        }
        if settingDetails?.city != ""{
            self.city.text = settingDetails?.city
            self.city.resetFloatingLable()
        }
        if settingDetails?.state != ""{
            self.state.text = settingDetails?.state
            self.state.resetFloatingLable()
        }
        if settingDetails?.zipCode != ""{
            self.zipcode.text = settingDetails?.zipCode
            self.zipcode.resetFloatingLable()
        }
        if settingDetails?.licenceNumber != ""{
            self.txtFldLicenseNumber.text = settingDetails?.licenceNumber
            self.txtFldLicenseNumber.resetFloatingLable()
        }

        self.latitude = settingDetails?.latitude ?? "0.0"
        self.longitude = settingDetails?.longitude ?? "0.0"
    }
    
    
    @IBAction func upoadLicenseBnAction(_ sender: Any) {
        if newAttachmentImage.count > 1 {
           print("No")
        } else {
            handleCameraOptions()
        }
    }
    
    @IBAction func actinFindLocation(_ sender: UIButton) {
        let destinationViewController = (Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController)
        destinationViewController?.btnTapAction3 = {
            () in
            
            self.street.text = destinationViewController?.addressLine1
            self.street.resetFloatingLable()
            
            self.city.text = destinationViewController?.city ?? ""
            self.city.resetFloatingLable()
            
            self.state.text = destinationViewController?.state ?? ""
            self.state.resetFloatingLable()
            
            self.zipcode.text = destinationViewController?.zipcode
            self.zipcode.resetFloatingLable()
            
            self.longitude = ""
            self.latitude = ""
            self.longitude = "\(destinationViewController?.lng ?? Double(0.0))"
            self.latitude = "\(destinationViewController?.lat ?? Double(0.0))"
        }
        self.navigationController?.present(destinationViewController!, animated: true)
    }
    
    // MARK: Back Button Action
    @IBAction func tapDidBackButtonAction(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    // MARK: Save Change Button
    @IBAction func tapDidSaveChangeButtonAction(_ sender: Any) {
        if self.isFrom == "CO" {
            self.popUpView.isHidden = false
            self.smallpopUpView.isHidden = false
        } else {
            self.checkValidations()
        }
    }

    func checkValidations() {
        let firstName = firstName.text?.trimmed ?? ""
        let lastName = lastName.text?.trimmed ?? ""
        let phoneNumber = phoneNumber.text?.trimmed ?? ""
        let phoneString2 = phoneNumber.replacingOccurrences(of: "-", with: "")
        let phoneString3 = phoneString2.replacingOccurrences(of: "(", with: "")
        let phoneString4 = phoneString3.replacingOccurrences(of: ")", with: "")
        let phoneString5 = phoneString4.replacingOccurrences(of: " ", with: "")
        let street = street.text?.trimmed ?? ""
        let city = city.text?.trimmed ?? ""
        let state = state.text?.trimmed ?? ""
        let zipcode = zipcode.text?.trimmed ?? ""
        let licenseNumber = txtFldLicenseNumber.text?.trimmed ?? ""

        if settingDetail != nil{
            skill = settingDetail?.skillSet ?? ""
        } else if settingDetails != nil{
            skill = settingDetails?.skillSet ?? ""
        }

        let loginModel = EditModel(firstName: firstName, lastName: lastName, phoneNumber: phoneString5, skillSet: skill, street: street, city: city, state: state, zipCode: zipcode,licenceNumber: licenseNumber)
        editProfileViewModel.model = loginModel
        editProfileViewModel.validateEditProfileModel(isFromEdit: true) {[weak self] (success, error) in
                    guard let strongSelf = self else { return }
                    if error == nil {
                        if let model = success {
                            self?.editProfileApiHit()
                        }
                    }
                    else {
                        if let errorMsg = strongSelf.editProfileViewModel.error {
                            showMessage(with: errorMsg)
                        }
                    }
                }
    }
    
    @IBAction func tapDidImageUpload(_ sender: UIButton) {
        self.isProfile = true
        handleCameraOptions()
    }
    
    // MARK: GetApi
    func editProfileApiHit(){
        let phoneNumber = phoneNumber.text?.trimmed ?? ""
        let phoneString2 = phoneNumber.replacingOccurrences(of: "-", with: "")
        let phoneString3 = phoneString2.replacingOccurrences(of: "(", with: "")
        let phoneString4 = phoneString3.replacingOccurrences(of: ")", with: "")
        let phoneString5 = phoneString4.replacingOccurrences(of: " ", with: "")
        var param = [String: Any]()
        if settingDetail != nil{
            param = [
                "firstName": firstName.text ?? "",
                "lastName" : lastName.text ?? "",
                "phoneNumber" : phoneString5, //phoneNumber.text ?? "",
                "addressLine1" : street.text ?? "",
                "addressLine2" : settingDetail?.addressLine2 ?? "",
                "licenceNumber" : settingDetail?.licenceNumber ?? "",
                //"skills"  : selectedSkillsId,
                "city"    : city.text ?? "",
                "state"   : state.text ?? "",
                "zipCode" : zipcode.text ?? "",
                "longitude": self.longitude,
                "latitude": self.longitude
            ] as [String : Any]
        } else if settingDetails != nil{
            var skillArray = [[String:Any]]()
            skillArray.removeAll()
            for i in 0 ..< self.selectedSkillsId.count {
                let dict = ["skillId": selectedSkillsId[i]]
                skillArray.append(dict as [String : Any])
            }
            var attachmentArray = [[String:Any]]()
            attachmentArray.removeAll()
            for i in 0 ..< self.newAttachmentLabel.count {
                var dictss = [String: Any]()
                dictss["name"] = newAttachmentLabel[i]
                dictss["image"] = newAttachmentImage[i]
                attachmentArray.append(dictss as [String: Any])
            }
            
            param = [
                "firstName": firstName.text ?? "",
                "lastName" : lastName.text ?? "",
                "phoneNumber" : phoneString5, //phoneNumber.text ?? "",
                "addressLine1" : street.text ?? "",
                "addressLine2" : settingDetails?.addressLine2 ?? "",
                "licenceNumber" : settingDetails?.licenceNumber ?? "",
                "skills"  : (skillArray.toJSONString()),
                "city"    : city.text ?? "",
                "state"   : state.text ?? "",
                "zipCode" : zipcode.text ?? "",
                "longitude": self.longitude ,
                "latitude": self.longitude,
                "userFiles": (attachmentArray.toJSONString())
            ] as [String : Any]
        }
        if settingDetail != nil{
            let img = profileImage.image
            let url = URL(string: img?.toPngString() ?? "")
            let image: UIImage = profileImage.image!
            let imageData = image.jpegData(compressionQuality: 0.8)
            editProfileViewModel.updateProfileApi(keyToUploadData: "image", fileNames: (settingDetail?.profilePic)!, dataToUpload: imageData!, param: param) { model in
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else if settingDetails != nil {
            let img = profileImage.image
            let imd1 = settingDetails?.profilePic ?? ""
            var a = imd1.toImage
            let url = URL(string: img?.toPngString() ?? "")
            let image: UIImage = profileImage.image!
            let imageData = image.jpegData(compressionQuality: 0.8)
            editProfileViewModel.updateProfileApi(keyToUploadData: "image", fileNames: (settingDetails?.profilePic)!, dataToUpload: imageData!, param: param) { model in
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    
    @IBAction func tapDidYesButtonAction(_ sender: UIButton) {
        self.popUpView.isHidden = true
        self.smallpopUpView.isHidden = true
        self.checkValidations()
    }
    
    
    @IBAction func tapDidCancelButtonAction(_ sender: UIButton) {
        self.popUpView.isHidden = true
        self.smallpopUpView.isHidden = true
    }
    
    func imageSendAPI() {
        let imageData = attachmentImage.jpegData(compressionQuality: 0.8)
        viewModel.addImageLicenseApi(keyToUploadData: "file", fileNames: attachmentName, dataToUpload: imageData!, param: [:]) { response in
            print(response!)
            if let a = response?["data"] as? [String: Any] {
                let name = a["name"] as? String
                let url = a["url"] as? String
                self.newAttachmentImage.append(url ?? "")
                self.newAttachmentLabel.append(name ?? "")
            }
            self.attachMentTableView.reloadData()
        }
    }
    
    func docSendAPI() {
        if self.docURL != nil {
            viewModel.addLicenseApi(localFileUrl: self.docURL!, keyToUploadData: "file", fileNames: "\(randomString() + docName)") { response in
                print(response!)
                self.attachMentTableView.reloadData()
            }
        }
    }
}

extension EditProfleHO: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)

                if placemark.subLocality != nil {
                    self.street.text = placemark.subLocality!
                    self.street.resetFloatingLable()
                }
                if placemark.locality != nil {
                    self.city.text = placemark.locality!
                    self.city.resetFloatingLable()
                }
                if placemark.administrativeArea != nil {
                    self.state.text = placemark.administrativeArea!
                    self.state.resetFloatingLable()
                }
                if placemark.postalCode != nil {
                    self.zipcode.text = placemark.postalCode!
                    self.zipcode.resetFloatingLable()
                }
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension EditProfleHO: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
                self.profileImage.image = #imageLiteral(resourceName: "ic_upload_image")
                self.editIcone.isHidden = true
                self.isImageSelected = false
                self.profileImage.contentMode = .scaleToFill
                self.profileImage.setNeedsDisplay()
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
    {// Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

                picker.dismiss(animated: true, completion: nil)
                
                
                let imageName: String = UIFunction.getRandomImageName()
                let fileManager = FileManager.default
                do
                {
                    let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
                    let fileURL = documentDirectory.appendingPathComponent(imageName)
//                    portfilioImage.contentMode = .scaleAspectFill
                        if let imageData = (info[convertFromUIImagePickerControllerInfoKey((UIDevice.current.userInterfaceIdiom == .phone) ? UIImagePickerController.InfoKey.editedImage : UIImagePickerController.InfoKey.originalImage)] as! UIImage).jpegData(compressionQuality: 1.0)
                        {
                            
                            let imageData1 =  (imageData.count > 2000000) ? (info[convertFromUIImagePickerControllerInfoKey((UIDevice.current.userInterfaceIdiom == .phone) ? UIImagePickerController.InfoKey.editedImage : UIImagePickerController.InfoKey.originalImage)] as! UIImage).jpegData(compressionQuality: 0.5) : imageData
                            
                            try imageData1?.write(to: fileURL)
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
            self.profileImage.image = nil
//            self.editIcone.isHidden = true
            self.isImageSelected = false
            return
        }

//        self.buttonAddImage .setTitle(nil, for: .normal)

        if (userImage as String).count == 0
        {
           // let add_photo = UIFunction.getLocalizationString(text: "add_photo_title")
//            self.buttonAddImage .setTitle(add_photo, for: .normal)
            self.profileImage.image = nil
            self.editIcone.isHidden = true
            self.isImageSelected = false
        }
        else if ((userImage as String).hasPrefix("http") || (userImage as String).hasPrefix("https"))
        {
            // image from url
            profileImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            profileImage.sd_setImage(with: URL(string: userImage), placeholderImage: nil)
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
                if isProfile == true {
                    profileImage.image = image
                    self.isProfile = false
                } else {
                    attachmentImage = image!
                    attachmentName = "\(randomString()).png"
                    self.imageSendAPI()
                }
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

extension EditProfleHO: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        self.docURL = myURL
        self.selectedType = "Doc"
        if let name = urls.first?.lastPathComponent {
            self.docName = "\(name)"
        } else {
            self.docName = "\(randomString()).pdf"
        }
        self.docSendAPI()
       // viewModel.attachDocuments(at: urls)
    }

     func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}

extension UIImage {
    func toPngString() -> String? {
        let data = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
  
    func toJpegString(compressionQuality cq: CGFloat) -> String? {
        let data = self.jpegData(compressionQuality: cq)
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}

extension EditProfleHO: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == attachMentTableView {
            if settingDetail != nil {
                return settingDetail?.userDocuments?.count ?? 0 + newAttachmentImage.count
            } else if (settingDetails != nil) {
                return newAttachmentImage.count
            }
        } else {
            return arrSkills.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == attachMentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentListTableViewCell", for: indexPath) as! AttachmentListTableViewCell
            if settingDetail != nil {
            } else if (settingDetails != nil) {
                var imsgeStrURL = newAttachmentImage[indexPath.row].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                var a = self.newAttachmentImage[indexPath.row]
                a = a.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                let last4 = String(a.suffix(4))
                if last4 == ".png" || last4 == ".jpg" || last4 == "jpeg" {
                    cell.attachmentImageView.sd_setImage(with: URL(string: (imsgeStrURL)), placeholderImage: UIImage(named: "doc"), completed: nil)
                } else {
                    cell.attachmentImageView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "doc"), completed: nil)
                }
                
                cell.attachmentLabel.text = newAttachmentLabel[indexPath.row]
                cell.showImageOnFullView = {
                    let a = self.newAttachmentImage[indexPath.row]
                    let last4 = String(a.suffix(4))
                    if last4 == ".png" || last4 == ".jpg" || last4 == "jpeg" {
                        let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
                        destinationViewController!.isImage = false
                        destinationViewController?.imsgeStrURL = self.newAttachmentImage[indexPath.row]
                        destinationViewController?.img = UIImage()
                        self.navigationController?.pushViewController(destinationViewController!, animated: true)
                    } else {
                        if let url = URL(string: self.newAttachmentImage[indexPath.row]) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
                cell.deleteAttachment = {
                    self.newAttachmentLabel.remove(at: indexPath.row)
                    self.newAttachmentImage.remove(at: indexPath.row)
                    self.attachMentTableView.reloadData()
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectSkillsTblVwCell
            cell.lblTile.text = arrSkills[indexPath.row].title ?? ""
            cell.selectBtn.tag = indexPath.row
            cell.selectBtn.addTarget(self, action: #selector(selectedSkills(sender:)), for: .touchUpInside)
            if selectedSkills.contains(self.arrSkills[indexPath.row].title ?? "") {
                cell.imgCheck.image = UIImage(named: "ic_checkbox_filled")
            } else {
                cell.imgCheck.image = UIImage(named: "ic_check_box")
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == attachMentTableView {
            return 60.0
        } else {
            return 50.0
        }
    }
    
    @objc func selectedSkills(sender: UIButton) {
        if (self.selectedSkills.contains(self.arrSkills[sender.tag].title ?? "")) {
            let indx = self.selectedSkills.firstIndex(of: (self.arrSkills[sender.tag].title ?? "")) ?? 0
            self.selectedSkillsId.remove(at: indx)
            self.selectedSkills.remove(at: indx)
        } else {
            self.selectedSkillsId.append((self.arrSkills[sender.tag].id ?? 0))
            self.selectedSkills.append(self.arrSkills[sender.tag].title ?? "")
        }
        self.tblVwSkills.reloadData()
    }
}
