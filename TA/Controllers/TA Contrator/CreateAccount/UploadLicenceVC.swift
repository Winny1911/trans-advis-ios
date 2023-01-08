//
//  UploadLicenceVC.swift
//  TA
//
//  Created by Designer on 08/12/21.
//

import UIKit
import Photos
import SDWebImage
import MobileCoreServices
import UniformTypeIdentifiers
import WebKit

class UploadLicenceVC: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var attachmentTableView: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageSelectedView: UIView!
    @IBOutlet weak var licenceNumberTextField: FloatingLabelInput!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var uploadLicenceView: UIView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    
    var fullViewImge = [String]()
    private var userImage: String?
    var createAccountModel = CreateAccountModel()
    var isLicenseImageSelected = false
    let viewModel: CreateAccountTACVM = CreateAccountTACVM()
    var docURL:URL?
    var editImage = [String]()
    var docUrlss = [String]()
    var doclName = [String]()
    var newImage = [UIImage]()
    var imageName = [String]()
    var selectedType = ""
    var imageArray = [String]()
    var imageNameArray = [String]()
    
    var isFromEdit = false
    var isUserImageChangedFromEdit = false
    var userImageNotChangedStringFromEdit = ""
    
    var isDocumentChangedFromEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        licenceNumberTextField.maxLength = 20
        attachmentTableView.delegate = self
        attachmentTableView.dataSource = self
        attachmentTableView.register(UINib.init(nibName: "AttachmentListTableViewCell", bundle: nil), forCellReuseIdentifier: "AttachmentListTableViewCell")
        self.attachmentTableView.isHidden = false
        self.licenceNumberTextField.delegate = self
        nextButton.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 16.0)
        previousButton.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 16.0)
        userImageView.setRoundCorners(radius: 5.0)
        imageSelectedView.addCustomShadow()
        imageSelectedView.isHidden = true
        previousButton.layer.borderColor = (UIColor( red: 78/255, green: 199/255, blue:41/255, alpha: 1.0 )).cgColor
        previousButton.layer.borderWidth = 1.5
        licenceNumberTextField.setLeftPadding(20)
        
        if self.isFromEdit == true {
            if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
                self.imageSelectedView.isHidden = true
                self.licenceNumberTextField.text = obj.licenceNumber
                self.licenceNumberTextField.resetFloatingLable()
                if obj.user_files?.count ?? 0 > 0 {
                    imageNameArray.removeAll()
                    imageArray.removeAll()
                    for i in 0..<(obj.user_files?.count ?? 0) {
                        self.isLicenseImageSelected = true
                        let dict = obj.user_files?[i]
                        doclName.append(dict?.title ?? "")
                        
                        self.imageNameArray.append(dict?.title ?? "")
                        let fileName = dict?.file ?? ""
                        let fileArray = fileName.components(separatedBy: "/")
                        let finalFileName = fileArray.last
                        self.imageArray.append(finalFileName ?? "") //dict?.file ?? ""
                        if dict?.type == "png" {
                            self.selectedType = "Image"
                            self.userImageView.sd_setImage(with: URL(string: dict?.file ?? ""), completed: nil)
//                            self.lblName.text = "\(dict?.title ?? "").png"
//                            self.editImage.append(dict?.file ?? "")
                            self.fullViewImge.append(dict?.file ?? "")
//                            self.imageArray.append(dict?.file ?? "")
                        } else {
                            self.selectedType = "Doc"
                            self.userImageView.image = UIImage(named: "doc")
//                            self.lblName.text = "\(dict?.title ?? "").doc"
                            self.fullViewImge.append(dict?.file ?? "")
//                            self.imageArray.append(dict?.file ?? "")
//                            self.editImage.append(dict?.file ?? "")
                        }
                    }
                    self.attachmentTableView.reloadData()
                    self.licenceNumberTextField.resetFloatingLable()
                }
            }
        }
        if self.isFromEdit == false {
            let licenseNumberss = UserDefaults.standard.string(forKey: "licenseNumberss")
            if licenseNumberss != "" && licenseNumberss != nil {
                licenceNumberTextField.text = licenseNumberss
                licenceNumberTextField.resetFloatingLable()
            }
            let defaults = UserDefaults.standard
            fullViewImge = defaults.stringArray(forKey: "licenceImage") ?? [String]()
            self.imageArray = fullViewImge
            if self.fullViewImge.count == 0 || self.fullViewImge == nil {
                self.isLicenseImageSelected = false
            } else {
                self.isLicenseImageSelected = true
            }
            let name = UserDefaults.standard
            doclName = defaults.stringArray(forKey: "licenceName") ?? [String]()
            self.imageNameArray = doclName
            self.attachmentTableView.reloadData()
        }
    }

    @IBAction func showImageAndPdfButtonAction(_ sender: UIButton) {
        if selectedType == "Image" {
            
        } else {
            guard let url = self.docURL //URL(string:  "https://file-examples.com/wp-content/uploads/2017/10/file-sample_150kB.pdf")
            else { return }
            UIApplication.shared.open(url)
        }
    }

    @IBAction func actionDeleteImage(_ sender: Any) {
        userImage = nil
        self.imageSelectedView.isHidden = true
        self.uploadLicenceView.isHidden = false
        self.selectedType = ""
        self.lblName.text! = ""
        self.userImageView.image = nil
        self.isLicenseImageSelected = false
    }
    
    @IBAction func actionChooseLicense(_ sender: Any) {
        if doclName.count >= 2 {
            showMessage(with: "You can upload only two images/files.")
        } else {
            handleCameraOptions()
        }
    }
    
    @IBAction func tapDidPreviousButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tapDidNextButton(_ sender: UIButton) {
        let licenseNumber = licenceNumberTextField.text?.trimmed ?? ""
        let createAccountLicenseModel  = CreateAccountLicenseModel(licenseNumber: licenseNumber, licenseImage: newImage, islicenseImageSelected: self.isLicenseImageSelected, licenseSelectedName: imageNameArray, licenseSelectedImage: imageArray)
        viewModel.modelLicense = createAccountLicenseModel
        if imageArray.count == 0 || imageArray == nil {
            showMessage(with: "Please upload a digital copy of the licence", theme: .error)
        } else {
            self.naviagteToNextScreen(licenseSelectedImage: imageArray, licenseSelectedName: imageNameArray)
        }
        
//        viewModel.validateLicenseModel {[weak self] (success, error) in
//            guard let strongSelf = self else { return }
//            if error == nil {
//                if self!.isLicenseImageSelected == true {
//                    if self!.selectedType == "Image" {
//                        if self?.isFromEdit == true {
//                            if self?.isDocumentChangedFromEdit == true {
////                                self!.imageSendAPI()
//                            } else {
////                                self!.naviagteToNextScreen(licenseSelectedImage: imageArray, licenseSelectedName: imageNameArray)
//                            }
//                        } else {
////                            self!.imageSendAPI()
//                        }
//                    } else {
//                        if self?.isFromEdit == true {
//                            if self?.isDocumentChangedFromEdit == true {
////                                self!.docSendAPI()
//                            } else {
////                                self!.naviagteToNextScreen(licenseSelectedImage: [""], licenseSelectedName: [""])
//                            }
//                        } else {
////                            self!.docSendAPI()
//                        }
//                    }
//                } else {
////                    self!.naviagteToNextScreen(licenseSelectedImage: [""], licenseSelectedName: [""])
//                }
////                UserDefaults.standard.set("\(self?.lblName.text ?? "")", forKey: "licenseImageName")
////                UserDefaults.standard.set("\(self?.licenceNumberTextField.text ?? "")", forKey: "licenseNumberss")
////
////                guard let data = userImageView.image?.jpegData(compressionQuality: 0.5) else { return }
////                let encoded = try! PropertyListEncoder().encode(data)
////                UserDefaults.standard.set(encoded, forKey: "licenseImage")
//            }
//            else {
//                if let errorMsg = strongSelf.viewModel.error {
//                    showMessage(with: errorMsg)
//                }
//            }
//        }
        
    }
    
    func imageSendAPI() {
        let imageData = self.userImageView.image?.jpegData(compressionQuality: 0.8)
        viewModel.addImageLicenseApi(keyToUploadData: "file", fileNames: "\(self.lblName.text ?? "")", dataToUpload: imageData!, param: [:]) { response in
            print(response!)
            if let a = response?["data"] as? [String: Any] {
                let url = a["url"] as? String
                self.fullViewImge.append(url ?? "")
            }
            self.setModelData(response: response!)
        }
    }
    
    func docSendAPI() {
        if self.docURL != nil {
            viewModel.addLicenseApi(localFileUrl: self.docURL!, keyToUploadData: "file", fileNames: "\(randomString() + (self.lblName.text ?? ""))") { response in
                print(response!)
                if let a = response?["data"] as? [String: Any] {
                    let url = a["url"] as? String
                    self.fullViewImge.append(url ?? "")
                }
                self.setModelData(response: response!)
            }
        }
    }
    
    func setModelData(response: [String:Any]) {
        let dataDict = response["data"] as! NSDictionary
        let randomName = "\(randomString())"
        imageArray.append(dataDict["name"] as! String)
        imageNameArray.append(randomName)
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        self.attachmentTableView.reloadData()
//        self.naviagteToNextScreen(licenseSelectedImage: imageArray, licenseSelectedName: imageNameArray)
//        self.naviagteToNextScreen(licenseSelectedImage: dataDict["name"] as! String, licenseSelectedName: randomName)
    }
    
    func naviagteToNextScreen(licenseSelectedImage: [String], licenseSelectedName: [String]) {
        let licenseNumber = licenceNumberTextField.text?.trimmed ?? ""
        let createAccountLicenseModel  = CreateAccountLicenseModel(licenseNumber: licenseNumber, licenseImage: newImage, islicenseImageSelected: self.isLicenseImageSelected, licenseSelectedName: licenseSelectedName, licenseSelectedImage: licenseSelectedImage)
        viewModel.modelLicense = createAccountLicenseModel
        viewModel.validateLicenseModel {[weak self] (success, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                if let model = success {
                    //-----
                    UserDefaults.standard.set("\(self?.licenceNumberTextField.text ?? "")", forKey: "licenseNumberss")
                    let defaults = UserDefaults.standard
                    defaults.set(fullViewImge, forKey: "licenceImage")
                    let name = UserDefaults.standard
                    name.set(doclName, forKey: "licenceName")
                    //-----
                    print("model: ", model)
                    let vc = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "AddBankAccountVC") as? AddBankAccountVC
                    vc!.createAccountModel = self!.createAccountModel
                    vc!.createAccountLicenseModel = model
                    
                    //vc!.userImageNotChangedStringFromEdit = self!.userImageNotChangedStringFromEdit
                    //vc!.isUserImageChangedFromEdit = self!.isUserImageChangedFromEdit
                    //vc!.isDocumentChangedFromEdit = self!.isDocumentChangedFromEdit
                    //vc!.isFromEdit = self!.isFromEdit
                    
                    self?.navigationController?.pushViewController(vc!, animated: true)
                }
            }
            else {
                if let errorMsg = strongSelf.viewModel.error {
                    showMessage(with: errorMsg)
                }
            }
        }
    }
    
//    func naviagteToNextScreen(licenseSelectedImage:String, licenseSelectedName:String){
//        let licenseNumber = licenceNumberTextField.text?.trimmed ?? ""
//        let createAccountLicenseModel  = CreateAccountLicenseModel(licenseNumber: licenseNumber, licenseImage: self.userImageView.image ?? UIImage(), islicenseImageSelected: self.isLicenseImageSelected, licenseSelectedName: licenseSelectedName, licenseSelectedImage: licenseSelectedImage)
//        viewModel.modelLicense = createAccountLicenseModel
//        viewModel.validateLicenseModel {[weak self] (success, error) in
//            guard let strongSelf = self else { return }
//            if error == nil {
//                if let model = success {
//                    print("model: ", model)
//                    let vc = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "SetLocationVC") as? SetLocationVC
//                    vc!.createAccountModel = self!.createAccountModel
//                    vc!.createAccountLicenseModel = model
//
//                    vc!.userImageNotChangedStringFromEdit = self!.userImageNotChangedStringFromEdit
//                    vc!.isUserImageChangedFromEdit = self!.isUserImageChangedFromEdit
//                    vc!.isDocumentChangedFromEdit = self!.isDocumentChangedFromEdit
//                    vc!.isFromEdit = self!.isFromEdit
//
//                    self?.navigationController?.pushViewController(vc!, animated: true)
//                }
//            }
//            else {
//                if let errorMsg = strongSelf.viewModel.error {
//                    showMessage(with: errorMsg)
//                }
//            }
//        }
//    }
}

extension UploadLicenceVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doclName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentListTableViewCell", for: indexPath) as! AttachmentListTableViewCell
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        if self.isFromEdit == true {
            let a = self.fullViewImge[indexPath.row]
            let last4 = String(a.suffix(4))
            if last4 == ".png" || last4 == ".jpg" || last4 == "jpeg" {
                cell.attachmentImageView.sd_setImage(with: URL(string: fullViewImge[indexPath.row]), placeholderImage: UIImage(named: "doc"), completed: nil)
            } else {
                cell.attachmentImageView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "doc"), completed: nil)
            }
            cell.attachmentLabel.text = doclName[indexPath.row]
        } else {
            let a = self.fullViewImge[indexPath.row]
            let last4 = String(a.suffix(4))
            if last4 == ".png" || last4 == ".jpg" || last4 == "jpeg" {
                cell.attachmentImageView.sd_setImage(with: URL(string: fullViewImge[indexPath.row]), placeholderImage: UIImage(named: "doc"), completed: nil)
            } else {
                cell.attachmentImageView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "doc"), completed: nil)
            }
//            cell.attachmentImageView.image = fullViewImge[indexPath.row]
            cell.attachmentLabel.text = doclName[indexPath.row]
        }
        cell.deleteAttachment = {
            self.doclName.remove(at: indexPath.row)
            self.fullViewImge.remove(at: indexPath.row)
            if self.isFromEdit == true {
                self.imageArray.remove(at: indexPath.row)
                self.imageNameArray.remove(at: indexPath.row)
                //                self.editImage.remove(at: indexPath.row)
            } else {
                self.imageArray.remove(at: indexPath.row)
                self.imageNameArray.remove(at: indexPath.row)
            }
            self.attachmentTableView.reloadData()
        }
        cell.showImageOnFullView = {
            let a = self.fullViewImge[indexPath.row]
            let last4 = String(a.suffix(4))
            if last4 == ".png" || last4 == ".jpg" || last4 == "jpeg" {
                let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
                destinationViewController!.isImage = false
                destinationViewController?.imsgeStrURL = self.fullViewImge[indexPath.row]
                destinationViewController?.img = UIImage()
                self.navigationController?.pushViewController(destinationViewController!, animated: true)
            } else {
                if let url = URL(string: self.fullViewImge[indexPath.row]) {
                    UIApplication.shared.open(url)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension UploadLicenceVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func handleCameraOptions() {
        
        self.view.endEditing(true)
        
        let actionSheetController: UIAlertController = UIAlertController(title: UIFunction.getLocalizationString(text: "User Image"), message: nil, preferredStyle: .actionSheet)
        
        let actionCamera: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Take photo"), style: .default) { action -> Void in
            
            self.choosePhotoFromCameraAction()
        }
        
        let actionGallery: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Choose from gallery"), style: .default) { action -> Void in
            
            self.choosePhotoFromGalleryAction()
        }
        
        let actionDocuments: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Choose Docs"), style: .default) { action -> Void in
            
            self.chooseFromDocs()
        }
        
        let viewPhoto: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "View photo"), style: .default) { action -> Void in
            
            if let _userImage = self.userImage, _userImage.count > 0 {
                self.showPhotoBrowser(image: _userImage)
            }
        }
        
        let removePhoto: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Remove photo"), style: .default) { action -> Void in
            DispatchQueue.main.async {
                self.userImageView.image = #imageLiteral(resourceName: "ic_upload_image")
                self.isLicenseImageSelected = false
                self.userImageView.contentMode = .scaleToFill
                self.userImageView.setNeedsDisplay()
            }
            self.userImage = nil
            self.showImageInUserPhotoImageView()
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Cancel"), style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        
        actionCamera.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
        actionGallery.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
        actionDocuments.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
        viewPhoto.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
        removePhoto.setValue(UIColor.rbg(r: 255, g: 0, b: 0), forKey: "titleTextColor")
        cancelAction.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
        
        if userImage == nil || userImage?.count == 0
        {
            actionSheetController.addAction(actionCamera)
            actionSheetController.addAction(actionGallery)
            actionSheetController.addAction(actionDocuments)
            actionSheetController.addAction(cancelAction)
        }
        else
        {
         //   actionSheetController.addAction(removePhoto)
        //    actionSheetController.addAction(viewPhoto)
            actionSheetController.addAction(actionCamera)
            actionSheetController.addAction(actionGallery)
            actionSheetController.addAction(actionDocuments)
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
    
    func chooseFromDocs() {
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData),String(kUTTypeSpreadsheet),String(kUTTypeImage), String(kUTTypeRTF), String(kUTTypePDF)], in: .import)
        
//            if #available(iOS 11.0, *) {
//                importMenu.allowsMultipleSelection = true
//            }
            importMenu.delegate = self
            importMenu.modalPresentationStyle = .formSheet
            present(importMenu, animated: true)
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
        
        let cancel_title = UIFunction.getLocalizationString(text: "Cancel")
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
            self.userImageView.image = nil
            self.isLicenseImageSelected = false
            return
        }

//        self.buttonAddImage .setTitle(nil, for: .normal)

        if (userImage as String).count == 0
        {
           // let add_photo = UIFunction.getLocalizationString(text: "add_photo_title")
//            self.buttonAddImage .setTitle(add_photo, for: .normal)
            self.userImageView.image = nil
            self.isLicenseImageSelected = false
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
                newImage.append(image!)
                
                self.imageSelectedView.isHidden = true
                self.uploadLicenceView.isHidden = false
                self.attachmentTableView.isHidden = false
                self.selectedType = "Image"
                if self.isFromEdit == true {
                    self.isDocumentChangedFromEdit = true
                }
                self.lblName.text! = "\(randomString()).png"
                self.doclName.append("\(randomString()).png")
                self.isLicenseImageSelected = true
                self.imageSendAPI()
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

extension UploadLicenceVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        self.docURL = myURL
        self.attachmentTableView.isHidden = false
        self.imageSelectedView.isHidden = true
        self.uploadLicenceView.isHidden = false
        self.selectedType = "Doc"
        if self.isFromEdit == true {
            self.isDocumentChangedFromEdit = true
        }
        if let name = urls.first?.lastPathComponent {
            self.lblName.text = "\(name)"
        } else {
            self.lblName.text! = "\(randomString()).pdf"
            self.doclName.append("\(randomString()).doc")
        }
        self.doclName.append("\(randomString()).doc")
        self.userImageView.image = UIImage(named: "doc")
        self.newImage.append(UIImage(named: "doc")!)
        self.isLicenseImageSelected = true
        self.docSendAPI()
       // viewModel.attachDocuments(at: urls)
    }

     func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
