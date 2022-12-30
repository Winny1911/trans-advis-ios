//
//  NewDetailsHOVC.swift
//  TA
//
//  Created by Designer on 20/12/21.
//

import UIKit
import SDWebImage
import MobileCoreServices
import UniformTypeIdentifiers
import Photos

class NewDetailsHOVC: BaseViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var projectDeliverableLabel: UILabel!
    @IBOutlet weak var projectTypeLabel: UILabel!
    @IBOutlet weak var projectFileLabel: UILabel!
    @IBOutlet weak var btnOptions: UIButton!
    @IBOutlet weak var blurVwBtn: UIView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var projectFileCollectionView: UICollectionView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var findContractorsButton: UIButton!
    @IBOutlet weak var viewBidsButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var createdOnLabel: UILabel!
    
    let newProjectsHOViewModel: NewProjectsHOViewModel = NewProjectsHOViewModel()
    var completionHandlerGoToOngoingProjectListScreen: (() -> Void)?
    var projectId = Int()
    var projetcDetail = NewProjectsDetail()
    private var userImage: String?
    var isLicenseImageSelected = false
   // var docURL:URL?
    var selectedType = ""
    var projectCity = ""
    var projectCategoriesId = 0
    var diverableData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.blurVwBtn.isHidden = true
        self.btnAdd.borderColor = UIColor.appColorGreen
        self.btnAdd.border = 1.5
        self.btnAdd.setRoundCorners(radius: 8.0)
        findContractorsButton.layer.borderColor = (UIColor( red: 78/255, green: 199/255, blue:41/255, alpha: 1.0 )).cgColor
        findContractorsButton.layer.borderWidth = 1.5
        
        projectFileCollectionView.delegate = self
        projectFileCollectionView.dataSource = self
        
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
        topView.layer.shadowRadius = 5.0
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize.zero
        
        self.projectFileCollectionView.register(UINib(nibName: "ProjectFileCollecrtionView", bundle: nil), forCellWithReuseIdentifier: "ProjectFileCollecrtionView")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchProjectDetails()
    }
    
    func fetchProjectDetails() {
        let params = ["id": projectId]
        newProjectsHOViewModel.getNewProjectDetailApi(params) { [self] response in
            self.projetcDetail = response?.data ?? NewProjectsDetail()
            if self.projetcDetail.project_files?.count == 0 || self.projetcDetail.project_files == nil {
                self.projectFileLabel.text = "Project Files"
            } else {
                self.projectFileLabel.text = "Project Files (\(self.projetcDetail.project_files?.count ?? 0))"
            }
            self.blurVwBtn.isHidden = true
            self.findContractorsButton.isHidden = false
            self.viewBidsButton.setTitle("View Bids", for: .normal)
            self.titleLabel.text = "Project Details"//response?.data?.title
            self.newTitleLabel.text = response?.data?.title
            self.projectCity = response?.data?.city ?? ""
            self.descriptionLabel.text = response?.data?.description
//            self.amountLabel.text = "$ \( response?.data?.price ?? 0)"
            self.addressLabel.text = "\(projetcDetail.addressLine1 ?? "" )"
//            if self.projetcDetail.addressLine1 ?? "" == self.projetcDetail.addressLine2 ?? "" {
//                self.addressLabel.text = "\(self.projetcDetail.addressLine2 ?? "" ), \(projetcDetail.zipCode ?? "")"
//            } else {
//                self.addressLabel.text = "\(projetcDetail.addressLine1 ?? "" ), \(projetcDetail.city ?? "" ), \(projetcDetail.state ?? ""), \(projetcDetail.zipCode ?? "")"
//            }
            
            self.projectTypeLabel.text = "\(self.projetcDetail.type ?? "" )"
            self.diverableData.removeAll()
            for i in 0..<(self.projetcDetail.project_deliverable?.count ?? 0) {
                diverableData.append("\(String(describing: self.projetcDetail.project_deliverable?[i].deliveralble ?? ""))")
            }
            diverableData.removingDuplicates()
            diverableData.removeDuplicates()
            var diverable = diverableData.map{String($0)}.joined(separator: ", ")
            self.projectDeliverableLabel.text = "\(diverable)"
            diverableData.removeAll()
            var realAmount = "\(response?.data?.price ?? 0)"
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal

            let amount = Double(realAmount)
            let formattedString = formatter.string(for: amount)
            self.amountLabel.text =  "$ \(formattedString ?? "")"
            
            self.projectCategoriesId = response?.data?.projectCategoriesId ?? 0
            self.createdOnLabel.text = DateHelper.convertDateString(dateString: response?.data?.createdAt, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
            var bidCount = 0
            for i in 0 ..< self.projetcDetail.bids!.count {
                if self.projetcDetail.bids?[i].bidStatus == 1 {
                    bidCount = bidCount + 1
                }
            }
            self.viewBidsButton.backgroundColor = UIColor.appColorGreen
            self.viewBidsButton.setTitleColor(UIColor.appBtnColorWhite, for: .normal)
            self.btnOptions.isHidden = false
            self.viewBidsButton.setTitle("View Bids(\(bidCount))", for: .normal)
            self.projectFileCollectionView.reloadData()
            if response?.data?.project_agreement?.count ?? 0 > 0 {
                if response?.data?.status == 2 {
                    self.findContractorsButton.isHidden = true
                    self.blurVwBtn.isHidden = true
                    self.btnOptions.isHidden = true
                    self.viewBidsButton.backgroundColor = UIColor.appBtnColorWhite
                    self.viewBidsButton.setTitleColor(UIColor.appColorGreen, for: .normal)
                    self.viewBidsButton.setTitle("Waiting for Admin Approval", for: .normal)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func actionAddFiles(_ sender: Any) {
//        handleCameraOptions()
        var count = projetcDetail.project_files?.count
                let limit  = 149
                if count! <= limit {
                    handleCameraOptions()
                }else{
                    print("limit is 150")
                    showMessage(with: ValidationError.validImageCount, theme: .error)
                }
    }
    
    func uploadProjectImage(fileImageData:Data) {
        let randomName = "\(randomString())"
        newProjectsHOViewModel.addProjectImageApi(keyToUploadData: "file", fileNames: "\(randomName).png", dataToUpload: fileImageData, param: [:]) { response in
            self.setModelData(response: response!)
        }
    }
    
    func uploadProjectDoc(docUrl:URL) {
        let randomName = "\(randomString())"
        newProjectsHOViewModel.addProjectDocApi(localFileUrl: docUrl, keyToUploadData: "file", fileNames: "\(randomName).pdf") { response in
            self.setModelData(response: response!)
        }
    }
    
    func setModelData(response: [String:Any]) {
        let randomName = "\(randomString())"
        var userFilesArray = [[String : Any]]()
        let dataDict = response["data"] as! NSDictionary
        let dict = ["name":randomName, "image":dataDict["name"] as! String] as [String : Any]
        userFilesArray.removeAll()
        userFilesArray.append(dict)
        newProjectsHOViewModel.updateProjectImagesAPI(["id": "\(self.projectId)", "ProjectFiles": userFilesArray.toJSONString()]) { result in
            self.fetchProjectDetails()
        }
    }
    
    @IBAction func actionFindContractors(_ sender: Any) {
        let vc = Storyboard.contractorHO.instantiateViewController(withIdentifier: "ContractorHOVC") as? ContractorHOVC
        vc!.projectId = self.projectId
        vc!.projectCategoriesId = self.projectCategoriesId
        vc!.projectCity = self.projectCity
        vc!.isFrom = "NewProjectDetails"
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func tapDidOnEditAndDeleteButton(_ sender: UIButton) {
        let destinationViewController = Controllers.editAndDeleteHO
        destinationViewController!.completionHandlerdeleteProject = { [weak self] in
            showMessage(with: "Project Deleted Successfully", theme: .success)
            self?.navigationController?.popViewController(animated: true)
        }
        destinationViewController!.completionHandlerdEditProject = { [weak self] in
            let vc = Controllers.createProjectHO
            //Storyboard.createProjectHO.instantiateViewController(withIdentifier: "CreateProjectHOVC") as? CreateProjectHOVC
            vc?.projectId = self?.projectId ?? 0
            self?.navigationController?.pushViewController(vc!, animated: true)
        }
//        destinationViewController!.modalPresentationStyle = .overFullScreen
        destinationViewController?.projectId = self.projectId
        self.present(destinationViewController!, animated: true)
    }
    
    
    @IBAction func actionBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewBidsButtonDidTap(_ sender: Any) {
//        if self.projetcDetail.bids?.count ?? 0 > 0 {
            let destinationViewController = Storyboard.newHO.instantiateViewController(withIdentifier: "ViewBidsVC") as? ViewBidsVC
            destinationViewController!.id = self.projectId
            destinationViewController!.completionHandlerGoToNewProjectDetailScreen = { [weak self] in
                self!.navigationController?.popViewController(animated: true)
                //self!.completionHandlerGoToOngoingProjectListScreen?()
                NotificationCenter.default.post(name: Notification.Name("GoToOngoingProjectListScreen"), object: nil)
            }
            self.navigationController?.pushViewController(destinationViewController!, animated: true)
//        }
    }
}

// MARK: Extension CollectionDelegateFlowLayout
extension NewDetailsHOVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: getWidth(title: self.projetcDetail.project_files?[indexPath.row].title ?? ""), height:70)
    }
}

extension NewDetailsHOVC:UICollectionViewDelegate{
    
}

extension NewDetailsHOVC:UICollectionViewDataSource{
    
    func getWidth(title:String) -> CGFloat{
        let font = UIFont(name: PoppinsFont.medium, size: 14)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let myText = title
        let size = (myText as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size.width + 25 + 45
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.projetcDetail.project_files?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectFileCollecrtionView", for: indexPath) as? ProjectFileCollecrtionView
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        cell!.projectTitleLabel.text = self.projetcDetail.project_files?[indexPath.row].title ?? ""
            if self.projetcDetail.project_files?.count ?? 0 > 0 {
                if var imgStr = self.projetcDetail.project_files?[indexPath.row].file {
                    imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    cell!.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed: nil)
                }
            }
        return cell!
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.projetcDetail.project_files?.count ?? 0 > 0 {
            if let imgStr = self.projetcDetail.project_files?[indexPath.row].file {
                var imsgeStrURL = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                if self.projetcDetail.project_files?[indexPath.row].type == "png" || self.projetcDetail.project_files?[indexPath.row].type == "jpg" || self.projetcDetail.project_files?[indexPath.row].type == "jpeg" {
                    let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
                    destinationViewController!.isImage = false
                    destinationViewController?.imsgeStrURL = imgStr
                    destinationViewController?.img = UIImage()
                    self.navigationController?.pushViewController(destinationViewController!, animated: true)
                } else {
                    if let imgStr = self.projetcDetail.project_files?[indexPath.row].file {
                        let imsgeStrURL = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        if let url = URL(string: imsgeStrURL) {
                            UIApplication.shared.open(url)
                        }
                    }
//                    let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
//                    destinationViewController!.isImage = true
//                    destinationViewController?.imsgeStrURL = ""
//                    destinationViewController?.img = UIImage(named: "doc") ?? UIImage()
//                    self.navigationController?.pushViewController(destinationViewController!, animated: true)
                }
            }
        }
    }    
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension NewDetailsHOVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
//                userImageView.image = image
//
//                self.imageSelectedView.isHidden = false
//                self.uploadLicenceView.isHidden = true
                self.selectedType = "Image"
//                self.lblName.text! = "\(Int(Date().timeIntervalSince1970)).png"
                self.isLicenseImageSelected = true
                self.uploadProjectImage(fileImageData: image?.jpegData(compressionQuality: 0.8) ?? Data())
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

extension NewDetailsHOVC: UIDocumentPickerDelegate {
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
        self.uploadProjectDoc(docUrl: myURL)
       // viewModel.attachDocuments(at: urls)
    }

     func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
