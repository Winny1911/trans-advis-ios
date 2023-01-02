//
//  EVerificationHO.swift
//  TA
//
//  Created by Applify  on 18/01/22.
//

import UIKit
import Photos
import SDWebImage
import MobileCoreServices
import UniformTypeIdentifiers

class EVerificationHOVC: BaseViewController {

    
    @IBOutlet weak var progressVw: UIProgressView!
    @IBOutlet weak var lblStage: UILabel!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageSelectedView: UIView!
    @IBOutlet weak var uploadLicenceView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    
    var projectId = Int()
    var bidId = Int()
    var userId = Int()
    var completionHandlerGoToAgreementScreen: (() -> Void)?
    private var userImage: String?
    var isLicenseImageSelected = false
    var docURL:URL?
    var selectedType = ""
    let eVerificationViewModel: EVerificationHOViewModel = EVerificationHOViewModel()
    var isFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnback.setRoundCorners(radius: 10.0)
        nextButton.setRoundCorners(radius: 10.0)
        nextButton.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 16.0)
        userImageView.setRoundCorners(radius: 5.0)
        imageSelectedView.addCustomShadow()
        imageSelectedView.isHidden = true
        if self.isFrom == "InvitedTaskCO" {
            self.progressVw.progress = 1.0
            self.lblStage.text = "Step 1/1"
            self.nextButton.setTitle("Done", for: .normal)
        } else {
            self.progressVw.progress = 0.5
            self.lblStage.text = "Step 1/2"
            self.nextButton.setTitle("Next", for: .normal)
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        handleCameraOptions()
    }
    
    @IBAction func tapDidNextButton(_ sender: UIButton) {
        
        let selectedType = self.selectedType
        let eVerificationModel  = EVerificationHOModel(selectedType: selectedType)
        eVerificationViewModel.model = eVerificationModel
        eVerificationViewModel.validateEVerificationModel {[weak self] (success, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                if self?.isLicenseImageSelected == true {
                    if self?.selectedType == "Image" {
                        if self?.isFrom == "InvitedTaskCO" {
                            imageInvitedSendAPI()
                        } else {
                            self?.imageSendAPI()
                        }
                    } else {
                        if self?.isFrom == "InvitedTaskCO" {
                            docInvitedSendAPI()
                        } else {
                            self?.docSendAPI()
                        }
                    }
                }
            }
            else {
                if let errorMsg = strongSelf.eVerificationViewModel.error {
                    showMessage(with: errorMsg)
                }
            }
        }
    }
    
    
    func imageInvitedSendAPI() {
        let imageData = self.userImageView.image?.jpegData(compressionQuality: 0.8)
        eVerificationViewModel.addInvitedAgreementImageApi(keyToUploadData: "file", fileNames: "\(self.lblName.text ?? "")", dataToUpload: imageData!, param: [:]) { response in
            print(response!)
            self.setModelData(response: response!)
        }
    }
    
    func docInvitedSendAPI() {
        if self.docURL != nil {
            eVerificationViewModel.addInvitedAgreementDocApi(localFileUrl: self.docURL!, keyToUploadData: "file", fileNames: "\(self.lblName.text ?? "")") { response in
                print(response!)
                self.setModelData(response: response!)
            }
        }
    }
    
    
    func imageSendAPI() {
        let imageData = self.userImageView.image?.jpegData(compressionQuality: 0.8)
        eVerificationViewModel.addAgreementImageApi(keyToUploadData: "file", fileNames: "\(self.lblName.text ?? "")", dataToUpload: imageData!, param: [:]) { response in
            print(response!)
            self.setModelData(response: response!)
        }
    }
    
    func docSendAPI() {
        if self.docURL != nil {
            eVerificationViewModel.addAgreementDocApi(localFileUrl: self.docURL!, keyToUploadData: "file", fileNames: "\(self.lblName.text ?? "")") { response in
                print(response!)
                self.setModelData(response: response!)
            }
        }
    }
    
    func setModelData(response: [String:Any]) {
        let dataDict = response["data"] as! NSDictionary
        let randomName = "\(randomString())"
        if self.isFrom == "InvitedTaskCO" {
            self.submitInvitedAgreement(strFile: dataDict["url"] as! String, title: randomName)
        } else {
            self.submitAgreement(strFile: dataDict["url"] as! String, title: randomName)
        }
    }
    
    func submitInvitedAgreement(strFile:String, title:String) {
        if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
            var agreementarr = [[String:Any]]()
            let dict = ["userId":"\(obj.id ?? 0)",
                          "projectId":"\(self.projectId)",
                          "type":"Agreement",
                          "title":title,
                          "file":strFile,
                          "userType":"CO"
                         ]
            agreementarr.append(dict)
            eVerificationViewModel.submitInvitedAgreementApi(["agreementarr":agreementarr.toJSONString()]) { response in
                self.acceptInvitedBidApiHit()
            }
        }
    }
    
    
    func acceptInvitedBidApiHit(){
        let params = ["projectId":"\(self.projectId)","bidId": "\(self.bidId)","status": "1" ]
        self.eVerificationViewModel.rejectOrAcceptInvitedBidApiCall(params){ model in
            showMessage(with: SucessMessage.bidAcceptSuccessfully, theme: .success)
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: OngoingProjectDetailVC.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
    
    
    func submitAgreement(strFile:String, title:String) {
        if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
            var agreementarr = [[String:Any]]()
            let dict = ["userId":"\(obj.id ?? 0)",
                          "projectId":"\(self.projectId)",
                          "type":"Agreement",
                          "title":title,
                          "file":strFile,
                          "userType":"HO"
                         ]
            agreementarr.append(dict)
            eVerificationViewModel.submitAgreementApi(["agreementarr":agreementarr.toJSONString()]) { response in
                let vc = Storyboard.newHO.instantiateViewController(withIdentifier: "ProofOfPaymentVC") as? ProofOfPaymentVC
                vc!.completionHandlerGoToVerificationScreen = { [weak self] in
                    self!.navigationController?.popViewController(animated: true)
                    self!.completionHandlerGoToAgreementScreen?()
                }
                vc!.projectId = self.projectId
                vc!.bidId = self.bidId
                vc!.userId = self.userId
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension EVerificationHOVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        
            if #available(iOS 11.0, *) {
                importMenu.allowsMultipleSelection = true
            }
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
    {// Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        picker.dismiss(animated: true, completion: nil)
        
        
        let imageName: String = UIFunction.getRandomImageName()
        let fileManager = FileManager.default
        do
        {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(imageName)
//            portfilioImage.contentMode = .scaleAspectFill
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
            userImageView.sd_setImage(with: URL(string: userImage), placeholderImage: UIImage(named: "doc"), completed: nil)
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
                
                self.imageSelectedView.isHidden = false
                self.uploadLicenceView.isHidden = true
                self.selectedType = "Image"
                self.lblName.text! = "\(randomString()).png"
                self.isLicenseImageSelected = true
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

extension EVerificationHOVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        self.docURL = myURL
        self.imageSelectedView.isHidden = false
        self.uploadLicenceView.isHidden = true
        self.selectedType = "Doc"
        self.lblName.text! = "\(randomString()).pdf"
        self.userImageView.image = UIImage(named: "doc")
        self.isLicenseImageSelected = true
       // viewModel.attachDocuments(at: urls)
    }

     func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
