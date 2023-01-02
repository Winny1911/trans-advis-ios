//
//  ProjectCompletedVC.swift
//  TA
//
//  Created by Applify  on 12/01/22.
//

import UIKit
import Photos
import SDWebImage
import MobileCoreServices
import UniformTypeIdentifiers

class ProjectCompletedVC: BaseViewController {

    @IBOutlet weak var filesTblVwHeight: NSLayoutConstraint!
    @IBOutlet weak var tblVwFiles: UITableView!
    @IBOutlet weak var popUpVw: UIView!
    @IBOutlet weak var blackVw: UIView!
    
    var completionHandlerGoToOnPastListing: (() -> Void)?
    var projectCompletedViewModel:ProjectCompletedViewModel = ProjectCompletedViewModel()
    var arrOfFilesToBeSent = [[String:Any]]()
    var arrOfImages = [UIImage]()
    var arrOfNamesImages = [String]()
    var isLicenseImageSelected = false
    var docURL:URL?
    var selectedType = ""
    var projectIdComplete = 0
    private var userImage: String?
    var dataPass = [String]()
    var fullViewImge = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpVw.setRoundCorners(radius: 14.0)
        popUpVw.isHidden = true
        blackVw.isHidden = true
        self.tblVwFiles.delegate = self
        self.tblVwFiles.dataSource = self
        self.filesTblVwHeight.constant = CGFloat((self.arrOfFilesToBeSent.count) * 75)
        
        self.arrOfFilesToBeSent.removeAll()
        self.arrOfImages.removeAll()
        self.arrOfNamesImages.removeAll()
        
    }
    
    
    func imageSendAPI(imageData:Data, fileName:String) {
        projectCompletedViewModel.addImageeApi(keyToUploadData: "file", fileNames: "\(fileName)", dataToUpload: imageData, param: [:]) { response in
            print(response!)
            let dataDict = response!["data"] as! NSDictionary
            let randomName = "\(self.randomString())"
            let dict = ["name": randomName, "image":dataDict["name"] as! String]
            self.arrOfFilesToBeSent.append(dict)
            self.filesTblVwHeight.constant = CGFloat((self.arrOfFilesToBeSent.count) * 75)
            if let a = response?["data"] as? [String: Any] {
                let url = a["url"] as? String
                self.fullViewImge.append(url ?? "")
            }
            self.tblVwFiles.reloadData()
            self.tblVwFiles.scrollToBottom()
        }
    }
    
    func docSendAPI(localFileURL:URL, fileName:String) {
        projectCompletedViewModel.addDocApi(localFileUrl: localFileURL, keyToUploadData: "file", fileNames: fileName) { response in
            print(response!)
            let dataDict = response!["data"] as! NSDictionary
            let randomName = "\(self.randomString())"
            let dict = ["name": randomName, "image":dataDict["name"] as! String]
            self.arrOfFilesToBeSent.append(dict)
            self.filesTblVwHeight.constant = CGFloat((self.arrOfFilesToBeSent.count) * 75)
            if let a = response?["data"] as? [String: Any] {
                let url = a["url"] as? String
                self.fullViewImge.append(url ?? "")
            }
            self.tblVwFiles.reloadData()
            self.tblVwFiles.scrollToBottom()
        }
    }
    
    @IBAction func actionChooseLicense(_ sender: Any) {
        handleCameraOptions()
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        if self.arrOfFilesToBeSent.count <= 0 {
            showMessage(with: "\(ValidationError.emptyMarkCompleteImage)")
        } else {
            let params = ["projectId": "\(self.projectIdComplete )","ProjectFiles": self.arrOfFilesToBeSent.toJSONString() ] as [String : Any]
            projectCompletedViewModel.uploadFiles(params: params) { response in
//                self.updateStatusOngoingProject()
                let destinationViewController = Storyboard.feedback.instantiateViewController(withIdentifier: "FeedBackScreenCOVC") as? FeedBackScreenCOVC
                
//                destinationViewController?.id  = userDetail?.id ?? 0
                destinationViewController?.projectIdComplete = self.projectIdComplete
                destinationViewController?.dataPass = self.dataPass
                destinationViewController?.completionHandlerGoToOnPastListing = { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                    self?.completionHandlerGoToOnPastListing?()
                }
                self.navigationController?.pushViewController(destinationViewController!, animated: true)
                
            }
        }
    }
    
    func updateStatusOngoingProject() {
        let params = ["id": "\(self.projectIdComplete )","status": "9"] as [String : Any]
        projectCompletedViewModel.updateStatus(params: params) { response in
            self.popUpVw.isHidden = false
            self.blackVw.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.popUpVw.isHidden = true
                self.blackVw.isHidden = true
                self.navigationController?.popViewController(animated: true)
                self.completionHandlerGoToOnPastListing?()
            }
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ProjectCompletedVC: UITableViewDelegate,UITableViewDataSource{
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return arrOfFilesToBeSent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddFilesTblVwCell", for: indexPath) as! AddFilesTblVwCell
        cell.lblFileName.text = self.arrOfNamesImages[indexPath.row]
//        cell.imageFile.image = self.arrOfImages[indexPath.row]
        let a = self.fullViewImge[indexPath.row]
        let last4 = String(a.suffix(4))
        if last4 == ".png" || last4 == ".jpg" || last4 == "jpeg" {
            cell.imageFile.sd_setImage(with: URL(string: fullViewImge[indexPath.row]), placeholderImage: UIImage(named: "doc"), completed: nil)
        } else {
            cell.imageFile.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "doc"), completed: nil)
        }
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(deleteImages(sender:)), for: .touchUpInside)
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
//        let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
//        destinationViewController!.isImage = true
//        destinationViewController?.imsgeStrURL = ""
//        destinationViewController?.img = self.arrOfImages[indexPath.row]
//        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
    
    @objc func deleteImages(sender: UIButton) {
        handleManualDeleteFile(indexOfFile:sender.tag)
    }
    
    func handleManualDeleteFile(indexOfFile:Int) {
        self.fullViewImge.remove(at: indexOfFile)
        self.arrOfImages.remove(at: indexOfFile)
        self.arrOfNamesImages.remove(at: indexOfFile)
        self.arrOfFilesToBeSent.remove(at: indexOfFile)
        self.filesTblVwHeight.constant = CGFloat((self.arrOfFilesToBeSent.count) * 75)
        self.tblVwFiles.reloadData()
    }
    
    func deleteProjectFile(fileId:Int, indexOfFile:Int) {
        let param = ["id":fileId]
//        createProjectHOViewModel.deleteProjectFileApi(param) { response in
//            self.projectFilesArray?.remove(at: indexOfFile)
//            self.arrOfFilesFetchedFromServer.remove(at: indexOfFile)
//            self.handleManualDeleteFile(indexOfFile: indexOfFile)
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProjectCompletedVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        
//        let viewPhoto: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "View photo"), style: .default) { action -> Void in
//
//            if let _userImage = self.userImage, _userImage.count > 0 {
//                self.showPhotoBrowser(image: _userImage)
//            }
//        }
        
//        let removePhoto: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Remove photo"), style: .default) { action -> Void in
//            DispatchQueue.main.async {
////                self.userImageView.image = #imageLiteral(resourceName: "ic_upload_image")
////                self.isLicenseImageSelected = false
////                self.userImageView.contentMode = .scaleToFill
////                self.userImageView.setNeedsDisplay()
//            }
//            self.userImage = nil
//            self.showImageInUserPhotoImageView()
//        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Cancel"), style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        
        actionCamera.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
        actionGallery.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
        actionDocuments.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
//        viewPhoto.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
//        removePhoto.setValue(UIColor.rbg(r: 255, g: 0, b: 0), forKey: "titleTextColor")
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
//            userImageView.contentMode = .scaleAspectFill
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
            self.showImageInUserPhotoImageView(fileName: "\(randomString()).png")
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
    func showImageInUserPhotoImageView(fileName:String)
    {
        self.view.endEditing(true)
        guard let userImage = userImage else
        {
//            let add_photo = UIFunction.getLocalizationString(text: "add_photo_title")
//            self.buttonAddImage .setTitle(add_photo, for: .normal)
//            self.userImageView.image = nil
            self.isLicenseImageSelected = false
            return
        }

//        self.buttonAddImage .setTitle(nil, for: .normal)

        if (userImage as String).count == 0
        {
           // let add_photo = UIFunction.getLocalizationString(text: "add_photo_title")
//            self.buttonAddImage .setTitle(add_photo, for: .normal)
//            self.userImageView.image = nil
            self.isLicenseImageSelected = false
        }
        else if ((userImage as String).hasPrefix("http") || (userImage as String).hasPrefix("https"))
        {
            // image from url
//            userImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//            userImageView.sd_setImage(with: URL(string: userImage), placeholderImage: nil)
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
                self.arrOfImages.append(image!)
                self.arrOfNamesImages.append(fileName)
                self.imageSendAPI(imageData: image!.jpegData(compressionQuality: 0.8)!, fileName: fileName)
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

extension ProjectCompletedVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        self.docURL = myURL
        self.arrOfImages.append(UIImage(named: "doc")!)
        self.arrOfNamesImages.append("\(randomString()).doc")
        self.docSendAPI(localFileURL: myURL, fileName: "\(randomString()).pdf")
    }

     func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
