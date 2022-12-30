//
//  ProofOfPaymentVC.swift
//  TA
//
//  Created by Applify  on 18/01/22.
//

import UIKit
import Photos
import SDWebImage
import MobileCoreServices
import UniformTypeIdentifiers

class ProofOfPaymentVC: BaseViewController {

    @IBOutlet weak var paymentTableView: UITableView!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageSelectedView: UIView!
    @IBOutlet weak var uploadLicenceView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!

    var completionHandlerGoToVerificationScreen: (() -> Void)?
    var projectId = Int()
    var bidId = Int()
    var userId = Int()
    var viewModel : RejectBidVM = RejectBidVM()
    private var userImage: String?
    var isLicenseImageSelected = false
    var docURL:URL?
    var selectedType = ""
    let eVerificationViewModel: EVerificationHOViewModel = EVerificationHOViewModel()
    var paymentImageArray = [String]()
    var paymentImageNameRaay = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        paymentTableView.delegate = self
        paymentTableView.dataSource = self
        paymentTableView.register(UINib.init(nibName: "AttachmentListTableViewCell", bundle: nil), forCellReuseIdentifier: "AttachmentListTableViewCell")
        btnback.setRoundCorners(radius: 10.0)
        nextButton.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 16.0)
        userImageView.setRoundCorners(radius: 5.0)
        imageSelectedView.addCustomShadow()
        imageSelectedView.isHidden = true
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
        if paymentImageArray.count >= 2 {
            showMessage(with: "You can upload only two images/files")
        } else {
            handleCameraOptions()
        }
    }
    
    @IBAction func tapDidNextButton(_ sender: UIButton) {
        
        let selectedType = self.selectedType
        let eVerificationModel  = EVerificationHOModel(selectedType: selectedType)
        eVerificationViewModel.model = eVerificationModel
        eVerificationViewModel.validateEVerificationModelPayment {[weak self] (success, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                if self?.isLicenseImageSelected == true {
                    if self?.selectedType == "Image" {
                        if paymentImageArray.count == 0 || paymentImageArray == nil {
                            showMessage(with: "Please select Payment Proof", theme: .error)
                        } else {
                            self?.submitAgreement(strFile: paymentImageArray, title: paymentImageNameRaay)
                        }
                        
//                        self?.imageSendAPI()
//                        self?.navigationController?.popToRootViewController(animated: true)
                    } else {
                        if paymentImageArray.count == 0 || paymentImageArray == nil {
                            showMessage(with: "Please select Payment Proof", theme: .error)
                        } else {
                            self?.submitAgreement(strFile: paymentImageArray, title: paymentImageNameRaay)
                        }
//                        self?.navigationController?.popToRootViewController(animated: true)
//                        self?.docSendAPI()
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
    
    func imageSendAPI() {
        let imageData = self.userImageView.image?.jpegData(compressionQuality: 0.8)
        eVerificationViewModel.addAgreementImageApi(keyToUploadData: "file", fileNames: "\(self.lblName.text ?? "")", dataToUpload: imageData!, param: [:]) { response in
            print(response!)
            if let a = response?["data"] as? [String: Any] {
                let url = a["url"] as? String
                let name = a["name"] as? String
//                self.paymentImageArray.append(url ?? "")
//                self.paymentImageNameRaay.append(name ?? "")
                self.paymentTableView.reloadData()
            }
            self.setModelData(response: response!)
        }
    }
    
    func docSendAPI() {
        if self.docURL != nil {
            eVerificationViewModel.addAgreementDocApi(localFileUrl: self.docURL!, keyToUploadData: "file", fileNames: "\(self.lblName.text ?? "")") { response in
                print(response!)
                if let a = response?["data"] as? [String: Any] {
                    let url = a["url"] as? String
                    let name = a["name"] as? String
//                    self.paymentImageNameRaay.append(name ?? "")
//                    self.paymentImageArray.append(url ?? "")
                    self.paymentTableView.reloadData()
                }
                self.setModelData(response: response!)
            }
        }
    }
    
    func setModelData(response: [String:Any]) {
        let dataDict = response["data"] as! NSDictionary
        let randomName = "\(randomString())"
        self.paymentImageArray.append(dataDict["url"] as! String)
        self.paymentImageNameRaay.append(randomName)
        self.paymentTableView.reloadData()
//        self.submitAgreement(strFile: dataDict["url"] as! String, title: randomName)
    }
    
    func submitAgreement(strFile: [String], title: [String]) {
        if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
            var agreementarr = [[String:Any]]()
            for i in 0..<strFile.count {
                let dict = ["userId":"\(obj.id ?? 0)",
                              "projectId":"\(self.projectId)",
                              "type":"Payment",
                              "title":title[i],
                              "file":strFile[i],
                              "userType":"HO"
                ] as [String : Any]
                agreementarr.append(dict)
            }
//            let dict = ["userId":"\(obj.id ?? 0)",
//                          "projectId":"\(self.projectId)",
//                          "type":"Payment",
//                          "title":title,
//                          "file":strFile,
//                          "userType":"HO"
//            ] as [String : Any]
//            agreementarr.append(dict)
            eVerificationViewModel.submitAgreementApi(["agreementarr":agreementarr.toJSONString()]) { response in
                self.acceptBidApiHit()
            }
        }
    }
    
    
    func acceptBidApiHit(){
        let params = ["projectId":"\(self.projectId)","bidId": "\(self.bidId)","status": "1" ]
        self.viewModel.rejectOrAcceptBidApiCall(params){ model in
            showMessage(with: SucessMessage.bidAcceptSuccessfully, theme: .success)
//            self.navigationController?.popViewController(animated: true)
           // NotificationCenter.default.post(name: Notification.Name("GoToOngoingProjectListScreen"), object: nil)
            self.navigationController?.popToRootViewController(animated: true)
//            self.completionHandlerGoToVerificationScreen?()
        }
    }
    
}

extension ProofOfPaymentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentImageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentListTableViewCell", for: indexPath) as! AttachmentListTableViewCell
            cell.attachmentImageView.sd_setImage(with: URL(string: paymentImageArray[indexPath.row]), placeholderImage: UIImage(named: "doc"), completed: nil)
            cell.attachmentLabel.text = paymentImageNameRaay[indexPath.row]
        
        cell.deleteAttachment = {
            self.paymentImageNameRaay.remove(at: indexPath.row)
            self.paymentImageArray.remove(at: indexPath.row)
            self.paymentTableView.reloadData()
        }
        cell.showImageOnFullView = {
            let a = self.paymentImageArray[indexPath.row]
            let last4 = String(a.suffix(4))
            if last4 == ".png" || last4 == ".jpg" || last4 == "jpeg" {
                let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
                destinationViewController!.isImage = false
                destinationViewController?.imsgeStrURL = self.paymentImageArray[indexPath.row]
                destinationViewController?.img = UIImage()
                self.navigationController?.pushViewController(destinationViewController!, animated: true)
            } else {
                if let url = URL(string: self.paymentImageArray[indexPath.row]) {
                    UIApplication.shared.open(url)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProofOfPaymentVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
                
                self.imageSelectedView.isHidden = true
                self.uploadLicenceView.isHidden = false
                self.selectedType = "Image"
                self.lblName.text! = "\(randomString()).png"
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

extension ProofOfPaymentVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        self.docURL = myURL
        self.imageSelectedView.isHidden = true
        self.uploadLicenceView.isHidden = false
        self.selectedType = "Doc"
        self.lblName.text! = "\(randomString()).pdf"
        self.userImageView.image = UIImage(named: "pdf")
        self.isLicenseImageSelected = true
        self.docSendAPI()
       // viewModel.attachDocuments(at: urls)
    }

     func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
