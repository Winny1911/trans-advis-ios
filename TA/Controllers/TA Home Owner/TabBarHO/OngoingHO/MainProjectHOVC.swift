//
//  MainProjectHOVC.swift
//  TA
//
//  Created by Dev on 28/12/21.
//

import UIKit
import SDWebImage
import MobileCoreServices
import UniformTypeIdentifiers
import Photos

class MainProjectHOVC: BaseViewController{

    var newProjectsListing: AllProject?

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var projectDeliverableLabel: UILabel!
    @IBOutlet weak var projectTypeLabel: UILabel!
    @IBOutlet weak var ProjectFilesLabel: UILabel!
    @IBOutlet weak var lblContractDoc: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var progressVw: CircularProgressView!
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var imgVw: UIImageView!
    @IBInspectable public lazy var textColor: UIColor = UIColor.black
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var ongoingNameLbl: UILabel!
    @IBOutlet weak var ongoingTittleLbl: UILabel!
    @IBOutlet weak var ongoingDescriptionLbl: UILabel!
    @IBOutlet weak var ongoingAmountLbl: UILabel!
    @IBOutlet weak var ongoingStateOnLbl: UILabel!
    @IBOutlet weak var ongoingEndOnLbl: UILabel!
    
    let ongoingProjectsHOViewModel: OngoingProjectHOVM = OngoingProjectHOVM()
    let newProjectsHOViewModel: NewProjectsHOViewModel = NewProjectsHOViewModel()
    
    var id = 0
    var progres = Double(0.0)
    private var userImage: String?
    var isLicenseImageSelected = false
   // var docURL:URL?
    var selectedType = ""
    var projectFiles = [ProjectFile]()
    var bidFiles = [ProjectFile]()
    var downloadFileName = ""
    var downloadFileUrl = ""
    var diverableData = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnAdd.borderColor = UIColor.appColorGreen
        self.btnAdd.border = 1.5
        self.btnAdd.setRoundCorners(radius: 8.0)
        self.collectionVw.register(UINib(nibName: "ProjectFileCollecrtionView", bundle: nil), forCellWithReuseIdentifier: "ProjectFileCollecrtionView")

        let downloadTap = UITapGestureRecognizer(target: self, action: #selector(self.downloadContractTapped(_:)))
        self.lblContractDoc.isUserInteractionEnabled = true
        self.lblContractDoc.addGestureRecognizer(downloadTap)
//        self.collectionVw.delegate = self
//        self.collectionVw.dataSource = self
   }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProjectDetails()
    }

    func fetchProjectDetails() {
        let params = ["id": id]
        ongoingProjectsHOViewModel.getOngoingProjectDetailApi(params) { response in
            self.progres = response?.data?.progress ?? Double(0.0)
            let img = response?.data?.contractorProject?[0].contractorDetails?.profilePic
            self.imgVw.sd_setImage(with: URL(string: (img) as! String), placeholderImage: UIImage(named: "doc"), completed: nil)
            let firstName = response?.data?.contractorProject?[0].contractorDetails?.firstName
            let lastName = response?.data?.contractorProject?[0].contractorDetails?.lastName
            self.ongoingNameLbl.text = "\(firstName!) \(lastName!)"
            self.ongoingTittleLbl.text = response?.data?.title ?? ""
            self.ongoingDescriptionLbl.text = response?.data?.allProjectDescription ?? ""
            
            let progressData = response?.data?.progress ?? 0
            let data = Float(progressData)
            let currentProgress: Float = (data/100)
            self.progressVw.setProgressWithAnimation(duration: 1.0, value: currentProgress)
            
            self.progressLbl.text = "\(Int(Double(response?.data?.progress ?? 0) ?? Double(0.0)))%"
            
            self.projectFiles = response?.data?.projectFiles ?? [ProjectFile]()
            if response?.data?.bids?.count ?? 0 > 0 {
//                self.ongoingAmountLbl.text = "$\(response?.data?.bids?[0].bidAmount ?? "")"
                
                var realAmount = "\(response?.data?.bids?[0].bidAmount ?? "")"
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.decimal

                let amount = Double(realAmount)
                let formattedString = formatter.string(for: amount)
                self.ongoingAmountLbl.text =  "$ \(formattedString ?? "")"
                
                self.ongoingStateOnLbl.text = DateHelper.convertDateString(dateString: response?.data?.bids?[0].proposedStartDate ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
                self.ongoingEndOnLbl.text = DateHelper.convertDateString(dateString: response?.data?.bids?[0].proposedEndDate ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
                self.bidFiles = response?.data?.bids?[0].bidsDocuments ?? [ProjectFile]()
            }
            
            if self.projectFiles.count == 0 || self.projectFiles == nil {
                self.ProjectFilesLabel.text = "Project Files"
            } else {
                self.ProjectFilesLabel.text = "Project Files (\(self.projectFiles.count ?? 0))"
            }
            self.addressLabel.text = "\(response?.data?.addressLine1 ?? "" )"
//            if response?.data?.addressLine1 ?? "" == response?.data?.addressLine2 ?? "" {
//                self.addressLabel.text = "\(response?.data?.addressLine2 ?? "" ), \(response?.data?.zipCode ?? "")"
//            } else {
//                self.addressLabel.text = "\(response?.data?.addressLine1 ?? "" ), \(response?.data?.city ?? "" ), \(response?.data?.state ?? ""), \(response?.data?.zipCode ?? "")"
//            }
            
            self.projectTypeLabel.text = "\(response?.data?.type ?? "" )"
            
            for i in 0..<(response?.data?.projectDeliverable?.count ?? 0) {
                self.diverableData.append("\(String(describing: response?.data?.projectDeliverable?[i].deliveralble ?? ""))")
            }
            self.diverableData.removingDuplicates()
            self.diverableData.removeDuplicates()
            let diverable = self.diverableData.map{String($0)}.joined(separator: ", ")
            self.projectDeliverableLabel.text = "\(diverable)"
            self.diverableData.removeAll()
//            if let progress = response?.data?.progress {
//                let  floatProgress = (Double(progress) / Double(100.0))
//                if response?.data?.status == 9 && floatProgress >= 1 {
//                    NotificationCenter.default.post(name: Notification.Name("ApproveDeliveryCheck"), object: nil)
//                } else {
//                    NotificationCenter.default.post(name: Notification.Name("DisApproveDeliveryCheck"), object: nil)
//                }
//            } else {
//                NotificationCenter.default.post(name: Notification.Name("DisApproveDeliveryCheck"), object: nil)
//            }
            
//            if response?.data?.status == 10 {
//                NotificationCenter.default.post(name: Notification.Name("AdminAprovalCheck"), object: nil)
//            } else if response?.data?.tasks?.count ?? 0 <= 0 {
//                NotificationCenter.default.post(name: Notification.Name("ApproveDeliveryCheck"), object: nil)
//            } else {
//
//                if let progress = response?.data?.progress {
//                    let  floatProgress = (Double(progress) / Double(100.0))
//                    if response?.data?.status == 9 && floatProgress >= 1 {
//                        NotificationCenter.default.post(name: Notification.Name("ApproveDeliveryCheck"), object: nil)
//                    } else if response?.data?.status == 10 {
//                        NotificationCenter.default.post(name: Notification.Name("AdminAprovalCheck"), object: nil)
//                    } else {
//                        NotificationCenter.default.post(name: Notification.Name("DisApproveDeliveryCheck"), object: nil)
//                    }
//                } else {
//                    NotificationCenter.default.post(name: Notification.Name("DisApproveDeliveryCheck"), object: nil)
//                }
//
//            }
//
            
            if let progress = response?.data?.progress {
                let  floatProgress = (Double(progress) / Double(100.0))
                if response?.data?.status == 9 && floatProgress >= 1 {
                    NotificationCenter.default.post(name: Notification.Name("ApproveDeliveryCheck"), object: nil)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("DisApproveDeliveryCheck"), object: nil)
                }
            } else {
                if response?.data?.status == 9 {
                    NotificationCenter.default.post(name: Notification.Name("ApproveDeliveryCheck"), object: nil)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("DisApproveDeliveryCheck"), object: nil)
                }
            }
            
            if response?.data?.status == 10 {
                NotificationCenter.default.post(name: Notification.Name("AdminAprovalCheck"), object: nil)
            }
            
            
            if response?.data?.projectAgreement?.count ?? 0 > 0 {
                
                if let str = response?.data?.projectAgreement?[0].title ?? "" as? String {
                    if (str.contains(".png")) || (str.contains(".jpeg")) || (str.contains(".jpg")) {
                        self.lblContractDoc.text = "\(response?.data?.projectAgreement?[0].title ?? "").png"
                    } else {
                        self.lblContractDoc.text = "\(response?.data?.projectAgreement?[0].title ?? "").doc"
                    }
                } else {
                    self.lblContractDoc.text = "\(response?.data?.projectAgreement?[0].title ?? "").doc"
                }
//                self.lblContractDoc.text = response?.data?.projectAgreement?[0].title ?? ""
                self.downloadFileName = response?.data?.projectAgreement?[0].title ?? ""
                self.downloadFileUrl = response?.data?.projectAgreement?[0].file ?? ""
            }
            self.collectionVw.reloadData()
        }
    }
    
    @objc func downloadContractTapped(_ sender: UITapGestureRecognizer) {
        if downloadFileUrl != "" && downloadFileName != "" {
            let a = self.downloadFileUrl
            let last4 = String(a.suffix(4))
            if last4 == ".png" || last4 == ".jpg" || last4 == "jpeg" {
                if let url = URL(string: a),
                   let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    showMessage(with: "Agreement downloaded successfully.", theme: .success)
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
            } else {
                self.downLoadImagesAndSave(url: downloadFileUrl, fileName: downloadFileName)
            }
        }
    }
    
    func downLoadImagesAndSave(url:String, fileName:String) {
        DispatchQueue.main.async {
            Progress.instance.show()
        }
        let urlString = url
        //let url = URL(string: urlString)
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let destinationFileUrl = documentsUrl.appendingPathComponent("TA_\(fileName).pdf")
        //Create URL to the source file you want to download
        let fileURL = URL(string: urlString)
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url:fileURL!)
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            DispatchQueue.main.async {
                Progress.instance.hide()
            }
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    do {
                        //Show UIActivityViewController to save the downloaded file
                        let contents  = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                        
                        for indexx in 0..<contents.count {
                            if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
                                DispatchQueue.main.async {
                                    let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
                                    self.present(activityViewController, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                    catch (let err) {
                        print("error: \(err)")
                    }
                } catch (let writeError) {
                    DispatchQueue.main.async {
                        showMessage(with: "File already exists", theme: .success)
                    }
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
            } else {
                DispatchQueue.main.async {
                    Progress.instance.hide()
                }
                print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
            }
        }
        task.resume()
    }
    
    @IBAction func actionAddFiles(_ sender: UIButton) {
        var count = projectFiles.count + self.bidFiles.count
        let limit  = 149
        if count < limit {
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
            self.collectionVw.reloadData()
        }
    }
    
    func uploadProjectDoc(docUrl:URL) {
        let randomName = "\(randomString())"
        newProjectsHOViewModel.addProjectDocApi(localFileUrl: docUrl, keyToUploadData: "file", fileNames: "\(randomName).pdf") { response in
            self.setModelData(response: response!)
            self.collectionVw.reloadData()
        }
    }
    
    func setModelData(response: [String:Any]) {
        let randomName = "\(randomString())"
        var userFilesArray = [[String : Any]]()
        let dataDict = response["data"] as! NSDictionary
        let dict = ["name":randomName, "image":dataDict["name"] as! String] as [String : Any]
        userFilesArray.removeAll()
        userFilesArray.append(dict)
        newProjectsHOViewModel.updateProjectImagesAPI(["id": "\(self.id)", "ProjectFiles": userFilesArray.toJSONString()]) { result in
            self.fetchProjectDetails()
        }
    }
    
    @IBAction func tapDidTransactionButtonAction(_ sender: UIButton) {
        let destinationViewController = Storyboard.ongoingHO.instantiateViewController(withIdentifier: "TransactionHistoryVC") as? TransactionHistoryVC
        destinationViewController!.isFrom = "HO"
        destinationViewController!.projectId = id
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
}

// MARK: Extension CollectionDelegateFlowLayout
extension MainProjectHOVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row < self.projectFiles.count {
            return CGSize(width: getWidth(title: self.projectFiles[indexPath.row].title ?? ""), height:70)
        } else {
            return CGSize(width: getWidth(title: self.bidFiles[indexPath.row - self.projectFiles.count].title ?? ""), height:70)
        }
    }
}

extension MainProjectHOVC: UICollectionViewDataSource{
    
    func getWidth(title:String) -> CGFloat{
        let font = UIFont(name: PoppinsFont.medium, size: 14)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let myText = title
        let size = (myText as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size.width + 25 + 45
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.projectFiles.count + self.bidFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectFileCollecrtionView", for: indexPath) as? ProjectFileCollecrtionView
        {
            if indexPath.row < self.projectFiles.count {
                cell.projectTitleLabel.text = self.projectFiles[indexPath.row].title ?? ""
                if self.projectFiles.count > 0 {
                    if self.projectFiles[indexPath.row].type == "png" || self.projectFiles[indexPath.row].type == "jpg" || self.projectFiles[indexPath.row].type == "jpeg" {
                        if var imgStr = self.projectFiles[indexPath.row].file {
                            imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                            cell.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed:nil)
                        }
                    } else {
                        if var imgStr = self.projectFiles[indexPath.row].file {
                            imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                            cell.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed:nil)
                        }
//                        cell.projectImageView.image = UIImage(named: "doc")
                    }
                }
            } else {
                cell.projectTitleLabel.text = self.bidFiles[indexPath.row - self.projectFiles.count].title ?? ""
                if self.bidFiles.count > 0 {
                    if self.bidFiles[indexPath.row - self.projectFiles.count].type == "png" || self.bidFiles[indexPath.row - self.projectFiles.count].type == "jpg" || self.bidFiles[indexPath.row - self.projectFiles.count].type == "jpeg" {
                        if var imgStr = self.bidFiles[indexPath.row - self.projectFiles.count].file {
                            imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                            cell.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed:nil)
                        }
                    } else {
                        if var imgStr = self.bidFiles[indexPath.row - self.projectFiles.count].file {
                            imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                            cell.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed:nil)
                        }
//                        cell.projectImageView.image = UIImage(named: "doc")
                    }
                }
            }
//            cell.projectTitleLabel.text = newProjectsListing?.projectFiles?[indexPath.row].title ?? ""
//            let img = newProjectsListing?.projectFiles?[indexPath.row].file ?? ""
//            cell.projectImageView.sd_setImage(with: URL(string: (img) ), placeholderImage: UIImage(named: "doc"), completed: nil)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < self.projectFiles.count {
            if self.projectFiles.count > 0 {
                if self.projectFiles[indexPath.row].type == "png" || self.projectFiles[indexPath.row].type == "jpg" || self.projectFiles[indexPath.row].type == "jpeg" {
                    if let imgStr = self.projectFiles[indexPath.row].file {
                        
                        let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
                        destinationViewController!.isImage = false
                        destinationViewController?.imsgeStrURL = imgStr
                        destinationViewController?.img = UIImage()
                        self.navigationController?.pushViewController(destinationViewController!, animated: true)
                        
                    }
                } else {
                    if let imgStr = self.projectFiles[indexPath.row].file {
                        if let url = URL(string: imgStr) {
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
extension MainProjectHOVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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

extension MainProjectHOVC: UIDocumentPickerDelegate {
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
