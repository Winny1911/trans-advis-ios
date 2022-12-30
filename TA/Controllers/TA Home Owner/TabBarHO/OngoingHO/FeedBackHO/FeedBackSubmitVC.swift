//
//  FeedBackSubmitVC.swift
//  TA
//
//  Created by applify on 03/03/22.
//

import UIKit
import GBFloatingTextField
import SDWebImage
import MobileCoreServices
import UniformTypeIdentifiers
import Photos



class FeedBackSubmitVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var ratingBtn1: UIButton!
    @IBOutlet weak var ratingBtn2: UIButton!
    @IBOutlet weak var ratingBtn3: UIButton!
    @IBOutlet weak var ratingBtn4: UIButton!
    @IBOutlet weak var ratingBtn5: UIButton!
    @IBOutlet weak var emojiVw1: UIView!
    @IBOutlet weak var emojiVw2: UIView!
    @IBOutlet weak var emojiVw3: UIView!
    @IBOutlet weak var emojiVw4: UIView!
    @IBOutlet weak var emojiVw5: UIView!
    
    @IBOutlet weak var messageTextView: GBFloatingTextView!
    var completionHandlerGoToOnPastListing: (() -> Void)?
    var dataPass = [String]()
    var profileImage = String()
    var rating = 0
    var ratingOne = String()
    var ratingTwo = String()
    var ratingThree = String()
    var name = String()
    var lastName = String()
    var projectId = String()
    var contractorId = String()
    var imgArray = [UIImage]()
    
    private var userImage: String?
    var isLicenseImageSelected = false
    var selectedType = ""

    var feedBackHOVM: FeedBackHOVM = FeedBackHOVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        registerCell()
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
        topView.layer.shadowRadius = 3.0
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize.zero
        nameLbl.text = name + lastName
       

        
    }
    //MARK:- Register Cell
    func registerCell(){
        collectionView.register(UINib.init(nibName: "ImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImagesCollectionViewCell")
    }
   

    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func ratingBtn1Action(_ sender: Any) {
        emojiVw1.isHidden = true
        emojiVw2.isHidden = false
        emojiVw3.isHidden = false
        emojiVw4.isHidden = false
        emojiVw5.isHidden = false
        rating = 1
    }
    
    @IBAction func ratingBtn2Action(_ sender: Any) {
        emojiVw1.isHidden = false
        emojiVw2.isHidden = true
        emojiVw3.isHidden = false
        emojiVw4.isHidden = false
        emojiVw5.isHidden = false
        rating = 2
    }
    
    
    @IBAction func ratingBtn3Action(_ sender: Any) {
        emojiVw1.isHidden = false
        emojiVw2.isHidden = false
        emojiVw3.isHidden = true
        emojiVw4.isHidden = false
        emojiVw5.isHidden = false
        rating = 3
    }
    
    @IBAction func ratingBtn4Action(_ sender: Any) {
        emojiVw1.isHidden = false
        emojiVw2.isHidden = false
        emojiVw3.isHidden = false
        emojiVw4.isHidden = true
        emojiVw5.isHidden = false
        rating = 4
    }
    
    
    @IBAction func ratingBtn5Action(_ sender: Any) {
        emojiVw1.isHidden = false
        emojiVw2.isHidden = false
        emojiVw3.isHidden = false
        emojiVw4.isHidden = false
        emojiVw5.isHidden = true
        rating = 5
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        let firstName = name
        let lastName = lastName
        let contractorId = contractorId
        let image = userImage
        let projectId = projectId
        if image == ""{
            profileImage = "hjj"
        }
        else{
            profileImage = image!
        }
        var arr = [Any]()
        var ratingImg = [String:Any]()
        ratingImg = [
            "name" : name + lastName,
            "image" :  profileImage
        ] as [String : Any]
        arr.append(ratingImg)
        var param = [String:Any]()
        param = [
            "feedback1":ratingOne,
            "feedback2":ratingTwo,
            "feedback3":ratingThree,
            "overAllFeedback": messageTextView.text ?? "",
            "ratingImages": arr,
            "rating": rating,
            "contractorId": contractorId,
            "projectId": projectId
        ] as [String : Any]
        print(param)
        
        feedBackHOVM.postFeedbackHOApiCall(param) { model in
            print(model)
            self.completionHandlerGoToOnPastListing?()
        }
    }
    
    @IBAction func uploadImageBtnAction(_ sender: Any) {
       handleCameraOptions()
        
    }

}
extension FeedBackSubmitVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionViewCell", for: indexPath) as! ImagesCollectionViewCell
        cell.projectImage.image = imgArray[indexPath.row]
        return cell
    }
  
}
extension FeedBackSubmitVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height:60)
    }
}
//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension FeedBackSubmitVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            
//            if let _userImage = self.userImage, _userImage.count > 0 {
//                self.showPhotoBrowser(image: _userImage)
//            }
        }
        
        let removePhoto: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Remove photo"), style: .default) { action -> Void in
            DispatchQueue.main.async {
//                self.userImageView.image = #imageLiteral(resourceName: "ic_upload_image")
                self.isLicenseImageSelected = false
//                self.userImageView.contentMode = .scaleToFill
//                self.userImageView.setNeedsDisplay()
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
                imgArray.append(image!)
                collectionView.reloadData()
//                userImageView.image = image
//
//                self.imageSelectedView.isHidden = false
//                self.uploadLicenceView.isHidden = true
                self.selectedType = "Image"
//                self.lblName.text! = "\(Int(Date().timeIntervalSince1970)).png"
                self.isLicenseImageSelected = true
              //  self.uploadProjectImage(fileImageData: image?.jpegData(compressionQuality: 0.8) ?? Data())
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

extension FeedBackSubmitVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
       // self.docURL = myURL
//        self.imageSelectedView.isHidden = false
//        self.uploadLicenceView.isHidden = true
        self.selectedType = "Doc"
//        self.lblName.text! = "\(Int(Date().timeIntervalSince1970)).doc"
//        self.userImageView.image = UIImage(named: "doc")
        self.isLicenseImageSelected = true
       // self.uploadProjectDoc(docUrl: myURL)
       // viewModel.attachDocuments(at: urls)
    }

     func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

