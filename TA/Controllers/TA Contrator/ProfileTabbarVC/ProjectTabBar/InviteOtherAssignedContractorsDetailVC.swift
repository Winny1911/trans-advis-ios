//
//  InviteOtherAssignedContractorsDetailVC.swift
//  TA
//
//  Created by Applify  on 14/02/22.
//

import UIKit
import Photos
import SDWebImage
import MobileCoreServices
import UniformTypeIdentifiers
import Alamofire

class InviteOtherAssignedContractorsDetailVC: BaseViewController {

    @IBOutlet weak var attachedFilesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var projectDeliverableLabel: UILabel!
    @IBOutlet weak var projectTypeLabel: UILabel!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var lblTopTitle: UILabel!
    @IBOutlet weak var blurVw: UIView!
    @IBOutlet weak var btnMarkCompleted: UIButton!
    @IBOutlet weak var btnSendMsg: UIButton!
    @IBOutlet weak var tblVwOrderList: UITableView!
    @IBOutlet weak var btnAddFiles: UIButton!
    @IBOutlet weak var collVw: UICollectionView!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblStartedDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var lblContract: UILabel!
    @IBOutlet weak var lblTaskDesc: UILabel!
    @IBOutlet weak var btnViewTransaction: UIButton!
    @IBOutlet weak var lblNAme: UILabel!
    
    @IBOutlet weak var imgVw: UIImageView!
    
    @IBOutlet weak var lbltaskName: UILabel!
    @IBOutlet weak var viewSelectedOrderlist: UIView!
    @IBOutlet weak var btnOrderList: UIButton!
    @IBOutlet weak var viewSelectedSubtask: UIView!
    @IBOutlet weak var btnSubtask: UIButton!
    
    var arrOfFiles = [[String : Any]]()
    var arrOfImages = [UIImage]()
    var arrOfImagesNames = [String]()
    private var userImage: String?
    var docURL:URL?
    var arrOfFilesFetchedFromServer = [[String:Any]]()
    var arrOfFilesManually = [[String:Any]]()
    var OngoingProjectsIAssignedTasksDetailsProject: OngoingProjectsIAssignedTasksDetailsProject?
    var bidFilesArray : [ProjectTaskFilesOngoing]?
    var ongoingProejctsCOViewModel:OngoingProejctsCOViewModel = OngoingProejctsCOViewModel()
    var projectId = 0
    var taskProjectStatus = 0
    var orderlistProjectId = 0
    var orderlistTaskId = 0
    var diverableData = [String]()
    var taskkId = 0
    var selectedType = ""
    var arrOfOrderList = [OrderListResponseModelDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblNoRecord.isHidden = true
        imgVw.setRoundCorners(radius: imgVw.frame.height / 2)
        handleTap(selectedBtn: btnSubtask, unselectedBtn: btnOrderList, selectedView: viewSelectedSubtask, unselectedView: viewSelectedOrderlist, tblVwHidden: true)
        self.collVw.register(UINib(nibName: "PlaceBidCollVwCell", bundle: nil), forCellWithReuseIdentifier: "PlaceBidCollVwCell")
        self.collVw.delegate = self
        self.collVw.dataSource = self
        
        self.tblVwOrderList.register(UINib.init(nibName: "OrderListItemTbllVwCell", bundle: nil), forCellReuseIdentifier: "OrderListItemTbllVwCell")
        self.tblVwOrderList.delegate = self
        self.tblVwOrderList.dataSource = self
        self.tblVwOrderList.separatorColor = UIColor.clear
        self.selectedType = "Task"
        self.btnSendMsg.borderColor = UIColor.appColorGreen
        self.btnSendMsg.layer.borderWidth = 1.0
        self.btnSendMsg.setRoundCorners(radius: 10.0)
        self.btnAddFiles.setRoundCorners(radius: 10.0)
    }

    override func viewWillAppear(_ animated: Bool) {
        lblNoRecord.isHidden = true
        if self.selectedType == "Task" {
            fetchOngoingTaskDetails()
        } else {
            fetchOrderList()
        }
        
    }
    
    //MARK: FETCH ORDER LIST API
    func fetchOrderList() {
        var params = [String:Any]()
//        params = [ "projectId" : self.projectId ,"subtaskId": self.taskkId] as [String : Any]
        params = [ "projectId" : orderlistProjectId ,"subtaskId": orderlistTaskId] as [String : Any]
        self.selectedType = "OrderList"
        ongoingProejctsCOViewModel.getOrderListsApi(params) { [self] model in
            self.arrOfOrderList.removeAll()
            self.arrOfOrderList = model?.data ?? [OrderListResponseModelDetails]()
            if self.arrOfOrderList.count <= 0 {
                self.lblNoRecord.isHidden = false
            } else {
                self.lblNoRecord.isHidden = true
            }
            self.tblVwOrderList.reloadData()
        }
    }
    
    var arrImagesURL = [String]()
    
    func fetchOngoingTaskDetails() {
        lblNoRecord.isHidden = true
        ongoingProejctsCOViewModel.getAllOngoingAssignedTaskDetailsApi(projectId:self.projectId, [:]) { [self] model in

            self.OngoingProjectsIAssignedTasksDetailsProject = model?.data?.projectDetails
            self.orderlistProjectId = model?.data?.projectDetails?.subProjectId ?? 0
            self.orderlistTaskId = model?.data?.projectDetails?.tasks?[0].projectId ?? 0
            if model?.data?.projectDetails?.tasks?.count ?? 0 > 0 {
                imgVw.sd_setImage(with: URL(string: model?.data?.projectDetails?.tasks?[0].assignedTo?.profilePic ?? ""), placeholderImage: UIImage(named: "Ic_profile"), completed:nil)
                lblNAme.text = "\(model?.data?.projectDetails?.tasks?[0].assignedTo?.firstName ?? "") \(model?.data?.projectDetails?.tasks?[0].assignedTo?.lastName ?? "")"
                lbltaskName.text = model?.data?.projectDetails?.title ?? ""
                lblTopTitle.text = "Tasks Details" //model?.data?.projectDetails?.title ?? ""
            }
            self.addressLabel.text = "\(model?.data?.projectDetails?.addressLine1 ?? "" )"
//            if model?.data?.projectDetails?.addressLine1 ?? "" == model?.data?.projectDetails?.addressLine2 ?? "" {
//                self.addressLabel.text = "\(model?.data?.projectDetails?.addressLine2 ?? "" ), \(model?.data?.projectDetails?.zipCode ?? "")"
//            } else {
//                self.addressLabel.text = "\(model?.data?.projectDetails?.addressLine1 ?? "" ), \(model?.data?.projectDetails?.city ?? "" ), \(model?.data?.projectDetails?.state ?? ""), \(model?.data?.projectDetails?.zipCode ?? "")"
//            }
            
            self.projectTypeLabel.text = model?.data?.projectDetails?.projectCategory?.title //"\(model?.data?.projectDetails?.type ?? "" )"
            diverableData.removeAll()
            for i in 0..<(model?.data?.projectDetails?.project_deliverable?.count ?? 0) {
                diverableData.append("\(String(describing: model?.data?.projectDetails?.project_deliverable?[i].deliveralble ?? ""))")
            }
            var diverable = diverableData.map{String($0)}.joined(separator: ", ")
            self.projectDeliverableLabel.text = model?.data?.projectDetails?.tasks?[0].taskDescription ?? "" //"\(diverable)"
            
            self.taskkId = 0
            if model?.data?.projectDetails?.tasks?.count ?? 0 > 0 {
                self.taskkId = model?.data?.projectDetails?.tasks?[0].id ?? 0
            }
            self.taskProjectStatus = 0
            self.taskProjectStatus = model?.data?.projectDetails?.status ?? 0
            if self.taskProjectStatus == 9 {
                self.btnSendMsg.setTitle("Reject Delivery", for: .normal)
                self.btnMarkCompleted.setTitle("Accept Delivery", for: .normal)
                self.blurVw.isHidden = true
            }
            if self.taskProjectStatus == 10 {
                self.btnMarkCompleted.setTitle("Completed", for: .normal)
                self.blurVw.isHidden = false
            }
            if model?.data?.projectDetails?.bids?.count ?? 0 > 0 {
                lblTaskDesc.text = model?.data?.projectDetails?.bids?[0].description ?? ""
//                lblAmount.text = "$\(model?.data?.projectDetails?.bids?[0].bidAmount ?? "")"
                
                var realAmount = "\(model?.data?.projectDetails?.bids?[0].bidAmount ?? "")"
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.decimal

                let amount = Double(realAmount)
                let formattedString = formatter.string(for: amount)
                lblAmount.text =  "$ \(formattedString ?? "")"
                
                lblStartedDate.text = DateHelper.convertDateString(dateString: model?.data?.projectDetails?.bids?[0].proposedStartDate ?? "2024-04-08T00:00:00.000Z", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
                lblEndDate.text = DateHelper.convertDateString(dateString: model?.data?.projectDetails?.bids?[0].proposedEndDate ?? "2024-04-08T00:00:00.000Z", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
            }
            
            if model?.data?.projectDetails?.project_agreement?.count ?? 0 > 0 {
                
                if let str = model?.data?.projectDetails?.project_agreement?[0].title ?? "" as? String {
                    if (str.contains(".png")) || (str.contains(".jpeg")) || (str.contains(".jpg")) {
                        lblContract.text = "\(model?.data?.projectDetails?.project_agreement?[0].title ?? "").png"
                    } else {
                        lblContract.text = "\(model?.data?.projectDetails?.project_agreement?[0].title ?? "").doc"
                    }
                } else {
                    lblContract.text = "\(model?.data?.projectDetails?.project_agreement?[0].title ?? "").doc"
                }
            }
            
            let userImgVw = UIImageView()
            self.arrOfImagesNames.removeAll()
            self.arrOfImages.removeAll()
            self.arrOfFiles.removeAll()
            self.arrOfFilesFetchedFromServer.removeAll()
            self.arrImagesURL.removeAll()
            
            if model?.data?.projectDetails?.project_files?.count ?? 0 > 0 {
                for i in 0 ..< (model?.data?.projectDetails?.project_files?.count)! {
                    self.arrImagesURL.append(model?.data?.projectDetails?.project_files?[i].file ?? "")
                    let fileStr = model?.data?.projectDetails?.project_files?[i].file ?? ""
                    userImgVw.image = nil
                    if fileStr.contains(".png") || fileStr.contains(".jpg") || fileStr.contains(".jpeg") {
                        userImgVw.sd_setImage(with: URL(string: fileStr), placeholderImage: UIImage(named: "doc"), completed: nil)
                        let imageStr = model?.data?.projectDetails?.project_files?[i].file
                        let strOfImage = imageStr?.replacingOccurrences(of: "https://transadvisor-dev.s3.amazonaws.com/projectUploads/", with: "")
                        let dict = ["image": "\(strOfImage ?? "")", "name":model?.data?.projectDetails?.project_files?[i].title]
                        self.arrOfFiles.append(dict as [String : Any])
                        let titleImage = model?.data?.projectDetails?.project_files?[i].title ?? ""
                        if titleImage.contains(".jpg") || titleImage.contains(".jpeg") || titleImage.contains(".png") {
                            self.arrOfImagesNames.append("\(model?.data?.projectDetails?.project_files?[i].title ?? "")")
                        } else {
                            self.arrOfImagesNames.append("\(model?.data?.projectDetails?.project_files?[i].title ?? "").png")
                        }
                        self.arrOfImages.append(userImgVw.image!)
                    } else {
                        let imageStr = model?.data?.projectDetails?.project_files?[i].file
                        let strOfDoc = imageStr?.replacingOccurrences(of: "https://transadvisor-dev.s3.amazonaws.com/projectUploads/", with: "")
                        let dict = ["image": "\(strOfDoc ?? "")", "name":model?.data?.projectDetails?.project_files?[i].title]
                        self.arrOfFiles.append(dict as [String : Any])
                        let titleDoc = model?.data?.projectDetails?.project_files?[i].title ?? ""
                        if titleDoc.contains(".pdf") || titleDoc.contains(".doc") {
                            self.arrOfImagesNames.append("\(model?.data?.projectDetails?.project_files?[i].title ?? "")")
                        } else {
                            self.arrOfImagesNames.append("\(model?.data?.projectDetails?.project_files?[i].title ?? "").doc")
                        }
                        self.arrOfImages.append(UIImage(named: "doc")!)
                    }
                }
                self.arrOfFilesFetchedFromServer = self.arrOfFiles
                if self.arrOfFiles.count == 0 || self.arrOfFiles == nil {
                    self.attachedFilesLabel.text = "Attached Files"
                } else {
                    self.attachedFilesLabel.text = "Attached Files (\(self.arrOfFiles.count))"
                }
                self.bidFilesArray = model?.data?.projectDetails?.project_files
                self.collVw.reloadData()
            }
        }
    }
    
    func handleTap(selectedBtn:UIButton, unselectedBtn: UIButton, selectedView: UIView, unselectedView: UIView, tblVwHidden:Bool) {
        selectedBtn.tintColor = UIColor.appSelectedBlack
        unselectedBtn.tintColor = UIColor.appUnSelectedBlack
        selectedView.backgroundColor = UIColor.appColorGreen
        unselectedView.backgroundColor = UIColor.appColorGrey
        tblVwOrderList.isHidden = tblVwHidden
    }
    
    func imageSendAPI(imageData: Data, fileName:String) {
        ongoingProejctsCOViewModel.addInvitationImageApi(keyToUploadData: "file", fileNames: "\(fileName)", dataToUpload: imageData, param: [:]) { response in
            print(response!)
            self.setModelData(response: response!)
        }
    }
    
    func docSendAPI(docLocalUrl:URL, fileName:String) {
        if self.docURL != nil {
            ongoingProejctsCOViewModel.addInvitationDocApi(localFileUrl: docLocalUrl, keyToUploadData: "file", fileNames: "\(fileName)") { response in
                print(response!)
                self.setModelData(response: response!)
            }
        }
    }
    
    func setModelData(response: [String:Any]) {
        let dataDict = response["data"] as! NSDictionary
        let randomName = randomString()
        let dict = ["image":dataDict["name"] as! String, "name": randomName ]
        self.arrOfFiles.append(dict)
        if self.arrOfFiles.count == 0 || self.arrOfFiles == nil {
            self.attachedFilesLabel.text = "Attached Files"
        } else {
            self.attachedFilesLabel.text = "Attached Files (\(self.arrOfFiles.count))"
        }
        self.arrOfFilesManually.append(dict)
        self.collVw.reloadData()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSendMsg(_ sender: Any) {
//        if self.taskProjectStatus == 9 {
//            acceptRejectTaskAPI(status: "11")
//        }
        let id = self.OngoingProjectsIAssignedTasksDetailsProject?.tasks?[0].TaskUser?.id ?? 0
        let user_id = String("ID_\(id )")
        let firstName = self.OngoingProjectsIAssignedTasksDetailsProject?.tasks?[0].TaskUser?.firstName  ?? ""
        let lastName = self.OngoingProjectsIAssignedTasksDetailsProject?.tasks?[0].TaskUser?.lastName ?? ""
        let user_name = (firstName + " " + lastName)
        let user_img = self.OngoingProjectsIAssignedTasksDetailsProject?.tasks?[0].TaskUser?.profilePic ?? ""
       
        openChatWindow(user_id: user_id, user_image: user_img, user_name: user_name)
    }
    
    func openChatWindow(user_id: String?, user_image: String?, user_name: String?) {
        DispatchQueue.main.async {
            if let chatController = Storyboard.messageHO.instantiateViewController(withIdentifier: "ChatWindowViewController") as? ChatWindowViewController {
                chatController.hidesBottomBarWhenPushed = true
                chatController.viewModel.user_id = user_id
                chatController.viewModel.user_name = user_name
                chatController.viewModel.user_image = user_image
                self.navigationController?.pushViewController(chatController, animated: true)
            }
        }
    }
    
    @IBAction func actionMarkCompleted(_ sender: Any) {
        if self.taskProjectStatus == 9 {
            acceptRejectTaskAPI(status: "10")
        }
    }
    
    func acceptRejectTaskAPI(status:String) {
        ongoingProejctsCOViewModel.acceptRejectTaskApi(["id":"\(self.taskkId)" , "status":status]) { [self] model in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func actionSubtask(_ sender: Any) {
        lblNoRecord.isHidden = true
        self.selectedType = "Task"
        handleTap(selectedBtn: btnSubtask, unselectedBtn: btnOrderList, selectedView: viewSelectedSubtask, unselectedView: viewSelectedOrderlist, tblVwHidden: true)
        fetchOngoingTaskDetails()
    }
    
    @IBAction func actionorderlist(_ sender: Any) {
        self.selectedType = "OrderList"
        handleTap(selectedBtn: btnOrderList, unselectedBtn: btnSubtask, selectedView: viewSelectedOrderlist, unselectedView: viewSelectedSubtask, tblVwHidden: false)
        fetchOrderList()
    }
    
    @IBAction func actionViewTrabnsactin(_ sender: Any) {
        let destinationViewController = Storyboard.ongoingHO.instantiateViewController(withIdentifier: "TransactionHistoryVC") as? TransactionHistoryVC
        destinationViewController!.isFrom = "SubTask"
        destinationViewController!.projectId = self.projectId
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
    
    @IBAction func actionAddFiles(_ sender: Any) {
        handleCameraOptions()
    }
}

extension InviteOtherAssignedContractorsDetailVC: UICollectionViewDelegateFlowLayout{
    func getWidth(title:String) -> CGFloat{
        let font = UIFont(name: PoppinsFont.medium, size: 14)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let myText = title
        let size = (myText as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size.width + 25 + 45
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: getWidth(title: self.arrOfImagesNames[indexPath.row]), height:72)
    }
}

extension InviteOtherAssignedContractorsDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceBidCollVwCell", for: indexPath) as!  PlaceBidCollVwCell
        cell.innerVw.setRoundCorners(radius: 5.0)
        cell.btnCross.tag = indexPath.row
        cell.btnCross.addTarget(self, action: #selector(deleteFile(sender:)), for: .touchUpInside)
        cell.btnCross.isHidden = true
        cell.projectImage.setRoundCorners(radius: 5.0)
        cell.projectImage.image = self.arrOfImages[indexPath.row]
        cell.projectTitle.text = self.arrOfImagesNames[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.arrImagesURL[indexPath.row].contains(".png") || self.arrImagesURL[indexPath.row].contains(".jpg") || self.arrImagesURL[indexPath.row].contains(".jpeg") {
            let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
            destinationViewController!.isImage = false
            destinationViewController?.imsgeStrURL = self.arrImagesURL[indexPath.row]
            destinationViewController?.img = UIImage()
            self.navigationController?.pushViewController(destinationViewController!, animated: true)
        } else {
//            if let imgStr = self.arrImagesURL[indexPath.row] {
                if let url = URL(string: self.arrImagesURL[indexPath.row]) {
                    UIApplication.shared.open(url)
                }
//            }
//            let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
//            destinationViewController!.isImage = true
//            destinationViewController?.imsgeStrURL = ""
//            destinationViewController?.img = UIImage(named: "doc") ?? UIImage()
//            self.navigationController?.pushViewController(destinationViewController!, animated: true)
        }
        
    }
    
    @objc func deleteFile(sender: UIButton) {
        if self.arrOfFilesFetchedFromServer.count > 0 {
            if sender.tag < self.arrOfFilesFetchedFromServer.count {
                self.deleteProjectFile(fileId: self.bidFilesArray?[sender.tag].id ?? 0, indexOfFile: sender.tag)
            } else {
                self.arrOfFilesManually.remove(at: (sender.tag - self.arrOfFilesFetchedFromServer.count))
                handleManualDeleteFile(indexOfFile:sender.tag)
            }
        } else {
            self.arrOfFilesManually.remove(at: (sender.tag - self.arrOfFilesFetchedFromServer.count))
            handleManualDeleteFile(indexOfFile:sender.tag)
        }
    }
    
    func handleManualDeleteFile(indexOfFile:Int) {
        self.arrOfImages.remove(at: indexOfFile)
        self.arrOfImagesNames.remove(at: indexOfFile)
        self.arrOfFiles.remove(at: indexOfFile)
        self.collVw.reloadData()
    }
    
    func deleteProjectFile(fileId:Int, indexOfFile:Int) {
        let param = ["id":fileId]
        ongoingProejctsCOViewModel.deleteBidFileApi(param) { response in
            self.bidFilesArray?.remove(at: indexOfFile)
            self.arrOfFilesFetchedFromServer.remove(at: indexOfFile)
            self.handleManualDeleteFile(indexOfFile: indexOfFile)
        }
    }
    
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension InviteOtherAssignedContractorsDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func handleCameraOptions() {
        
        self.view.endEditing(true)
        
        let actionSheetController: UIAlertController = UIAlertController(title: UIFunction.getLocalizationString(text: "Project File"), message: nil, preferredStyle: .actionSheet)
        
        let actionCamera: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Take photo"), style: .default) { action -> Void in
            
            self.choosePhotoFromCameraAction()
        }
        
        let actionGallery: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Choose from gallery"), style: .default) { action -> Void in
            
            self.choosePhotoFromGalleryAction()
        }
        
        let actionDocuments: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Choose Docs"), style: .default) { action -> Void in
            
            self.chooseFromDocs()
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Cancel"), style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        
        actionCamera.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
        actionGallery.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
        actionDocuments.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
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
            if  UIDevice.current.userInterfaceIdiom == .phone {
                if let imageData = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as! UIImage).jpegData(compressionQuality: 0.0)
                {
                    try imageData.write(to: fileURL)
                }
            } else {
                if let imageData = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage).jpegData(compressionQuality: 0.0) {
                    try imageData.write(to: fileURL)
                }
            }
            userImage = NSString(format:"%@",imageName as CVarArg) as String
            self.arrOfImagesNames.append("\(randomString()).png")
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
            return
        }

//        self.buttonAddImage .setTitle(nil, for: .normal)

        if (userImage as String).count == 0
        {
        }
        else if ((userImage as String).hasPrefix("http") || (userImage as String).hasPrefix("https"))
        {
            // image from url
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
                let imageData = image?.jpegData(compressionQuality: 0.8)
                self.imageSendAPI(imageData: imageData!, fileName: fileName)
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

extension InviteOtherAssignedContractorsDetailVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        self.docURL = myURL
        self.arrOfImagesNames.append("\(randomString()).doc")
        self.arrOfImages.append(UIImage(named: "doc")!)
        self.docSendAPI(docLocalUrl: myURL, fileName: "\(randomString()).doc")
    }

     func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}


//MARK: TABLE VIEW DELEGATES
extension InviteOtherAssignedContractorsDetailVC: UITableViewDelegate,UITableViewDataSource{

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOfOrderList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListItemTbllVwCell", for: indexPath) as! OrderListItemTbllVwCell
            cell.venderName.text = "\(self.arrOfOrderList[indexPath.row].vendor_detail?.firstName ?? "") \(self.arrOfOrderList[indexPath.row].vendor_detail?.lastName ?? "")"
            cell.itemLbl.text = "\(self.arrOfOrderList[indexPath.row].TotalItem ?? 0)"
            cell.categoryLbl.text = self.arrOfOrderList[indexPath.row].Cart_Item?[0].productsss?.category ?? ""
//            cell.PriceLbl.text = "$\(self.arrOfOrderList[indexPath.row].TotalPrice ?? Double(0.0))"
        
        var realAmount = "\(self.arrOfOrderList[indexPath.row].TotalPrice ?? Double(0.0))"
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal

        let amount = Double(realAmount)
        let formattedString = formatter.string(for: amount)
        cell.PriceLbl.text =  "$ \(formattedString ?? "")"
        
            cell.orderByLbl.text = "\(self.arrOfOrderList[indexPath.row].cart_contractor?.firstName ?? "") \((self.arrOfOrderList[indexPath.row].cart_contractor?.lastName ?? ""))"
            cell.dateLbl.text = DateHelper.convertDateString(dateString: "\(self.arrOfOrderList[indexPath.row].createdAt ?? "2024-04-08T00:00:00.000Z")", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
            
            cell.btnComplete.tag = indexPath.row
            cell.btnCancel.tag = indexPath.row
            
            cell.btnComplete.addTarget(self, action: #selector(updateComplete(sender:)), for: .touchUpInside)
            cell.btnCancel.addTarget(self, action: #selector(updateCancel(sender:)), for: .touchUpInside)
        cell.vwStatus.backgroundColor = UIColor.appBtnColorOrange
        cell.disputesStackView.isHidden = true
        cell.disputeStatusText.isHidden = true
        cell.vendorView.isHidden = true
        cell.disputeAdminView.isHidden = true
        cell.btnCancel.isHidden = true
        cell.btnComplete.isHidden = true
        if self.arrOfOrderList[indexPath.row].status == 0 {
            cell.lblStatus.text = "Requested"
        } else {
            cell.lblStatus.text = "Delivered"
        }
        if self.arrOfOrderList[indexPath.row].vendorRaisedDispute ?? 0 == 0 && self.arrOfOrderList[indexPath.row].vendorDisputeResolved ?? 0 == 0 {
            cell.vendorView.isHidden = true
        } else {
            if self.arrOfOrderList[indexPath.row].vendorRaisedDispute ?? 0 == 1 {
                cell.vendorView.isHidden = false
                cell.vendorStatusLabel.text = "Dispute raised by vendor"
            } else {
                cell.vendorView.isHidden = false
                cell.vendorStatusLabel.text = "Vendor dispute resolved by admin"
            }
        }
        if self.arrOfOrderList[indexPath.row].dispute?.count ?? 0 > 0 {
            if self.arrOfOrderList[indexPath.row].dispute?[0].isAdminResolved == 0 {
                if self.arrOfOrderList[indexPath.row].contractorRaisedDispute == 1 {
                    cell.disputeAdminView.isHidden = false
                    cell.disputeLabel.text = "Dispute raised by you"
                } else {
                    cell.disputeAdminView.isHidden = true
                }
            } else {
                cell.disputesStackView.isHidden = false
                cell.disputeStatusText.isHidden = false
                cell.disputeAdminView.isHidden = false
            }
        }
//            if self.arrOfOrderList[indexPath.row].dispute?.count ?? 0 > 0 {
//                if self.arrOfOrderList[indexPath.row].dispute?[0].isAdminResolved == 0 {
//                    if self.arrOfOrderList[indexPath.row].isContractor == 1 {
//                        cell.btnStckVw.isHidden = true
//                        cell.lblStatus.text = "Disputed"
//                    } else {
//                        cell.btnStckVw.isHidden = false
//                        if self.arrOfOrderList[indexPath.row].status == 0 {
//                            cell.btnComplete.isHidden = true
//                            cell.btnCancel.isHidden = false
//                            cell.btnCancel.setTitle("Cancel", for: .normal)
//                            cell.lblStatus.text = "Request Sent"
//                        } else if self.arrOfOrderList[indexPath.row].status == 1 {
//                            cell.btnCancel.isHidden = false
//                            cell.btnComplete.isHidden = false
//                            cell.btnComplete.setTitle("Accept Order", for: .normal)
//                            cell.btnCancel.setTitle("Decline", for: .normal)
//                            cell.lblStatus.text = "Quote Received"
//                        } else if self.arrOfOrderList[indexPath.row].status == 2 {
//                            cell.btnCancel.isHidden = false
//                            cell.btnComplete.isHidden = true
//                            cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
//                            cell.lblStatus.text = "Accepted"
//                        } else if self.arrOfOrderList[indexPath.row].status == 3 {
//                            cell.btnCancel.isHidden = true
//                            cell.btnComplete.isHidden = true
//                            cell.lblStatus.text = "Declined"
//                        } else if self.arrOfOrderList[indexPath.row].status == 4 {
//                            cell.btnCancel.isHidden = false
//                            cell.btnComplete.isHidden = false
//                            cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
//                            cell.btnComplete.setTitle("Mark As Received", for: .normal)
//                            cell.lblStatus.text = "Dispatch"
//                        } else if self.arrOfOrderList[indexPath.row].status == 5 {
//                            cell.btnCancel.isHidden = false
//                            cell.btnComplete.isHidden = true
//                            cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
//                            cell.vwStatus.backgroundColor = UIColor.appColorGreen
//                            cell.lblStatus.text = "Delivered"
//                        }
//                    }
//                } else {
//                    cell.btnStckVw.isHidden = false
//                    if self.arrOfOrderList[indexPath.row].status == 0 {
//                        cell.btnComplete.isHidden = true
//                        cell.btnCancel.isHidden = false
//                        cell.btnCancel.setTitle("Cancel", for: .normal)
//                        cell.lblStatus.text = "Request Sent"
//                    } else if self.arrOfOrderList[indexPath.row].status == 1 {
//                        cell.btnCancel.isHidden = false
//                        cell.btnComplete.isHidden = false
//                        cell.btnComplete.setTitle("Accept Order", for: .normal)
//                        cell.btnCancel.setTitle("Decline", for: .normal)
//                        cell.lblStatus.text = "Quote Received"
//                    } else if self.arrOfOrderList[indexPath.row].status == 2 {
//                        cell.btnCancel.isHidden = false
//                        cell.btnComplete.isHidden = true
//                        cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
//                        cell.lblStatus.text = "Accepted"
//                    } else if self.arrOfOrderList[indexPath.row].status == 3 {
//                        cell.btnCancel.isHidden = true
//                        cell.btnComplete.isHidden = true
//                        cell.lblStatus.text = "Declined"
//                    } else if self.arrOfOrderList[indexPath.row].status == 4 {
//                        cell.btnCancel.isHidden = false
//                        cell.btnComplete.isHidden = false
//                        cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
//                        cell.btnComplete.setTitle("Mark As Received", for: .normal)
//                        cell.lblStatus.text = "Dispatch"
//                    } else if self.arrOfOrderList[indexPath.row].status == 5 {
//                        cell.btnCancel.isHidden = false
//                        cell.btnComplete.isHidden = true
//                        cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
//                        cell.vwStatus.backgroundColor = UIColor.appColorGreen
//                        cell.lblStatus.text = "Delivered"
//                    }
//                }
                
//            } else {
//                cell.btnStckVw.isHidden = false
//                if self.arrOfOrderList[indexPath.row].status == 0 {
//                    cell.btnComplete.isHidden = true
//                    cell.btnCancel.isHidden = false
//                    cell.btnCancel.setTitle("Cancel", for: .normal)
//                    cell.lblStatus.text = "Request Sent"
//                } else if self.arrOfOrderList[indexPath.row].status == 1 {
//                    cell.btnCancel.isHidden = false
//                    cell.btnComplete.isHidden = false
//                    cell.btnComplete.setTitle("Accept Order", for: .normal)
//                    cell.btnCancel.setTitle("Decline", for: .normal)
//                    cell.lblStatus.text = "Quote Received"
//                } else if self.arrOfOrderList[indexPath.row].status == 2 {
//                    cell.btnCancel.isHidden = true
//                    cell.btnComplete.isHidden = true
////                    cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
//                    cell.lblStatus.text = "Accepted"
//                } else if self.arrOfOrderList[indexPath.row].status == 3 {
//                    cell.btnCancel.isHidden = true
//                    cell.btnComplete.isHidden = true
//                    cell.lblStatus.text = "Declined"
//                } else if self.arrOfOrderList[indexPath.row].status == 4 {
//                    cell.btnCancel.isHidden = false
//                    cell.btnComplete.isHidden = false
//                    cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
//                    cell.btnComplete.setTitle("Mark As Received", for: .normal)
//                    cell.lblStatus.text = "Dispatch"
//                } else if self.arrOfOrderList[indexPath.row].status == 5 {
//                    cell.btnCancel.isHidden = false
//                    cell.btnComplete.isHidden = true
//                    cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
//                    cell.vwStatus.backgroundColor = UIColor.appColorGreen
//                    cell.lblStatus.text = "Delivered"
//                }
//            }
            return cell        
    }

    @objc func updateComplete(sender: UIButton) {
        if self.arrOfOrderList[sender.tag].status == 1 {
            self.updateStatus(cardStatus: 2, cartId: self.arrOfOrderList[sender.tag].id  ?? 0)
        } else if self.arrOfOrderList[sender.tag].status == 4 {
            self.updateStatus(cardStatus: 5, cartId: self.arrOfOrderList[sender.tag].id  ?? 0)
        }
    }
    
    @objc func updateCancel(sender: UIButton) {
        if self.arrOfOrderList[sender.tag].status == 0 {
            self.updateStatus(cardStatus: 6, cartId: self.arrOfOrderList[sender.tag].id  ?? 0)
        } else if self.arrOfOrderList[sender.tag].status == 1 {
            self.updateStatus(cardStatus: 3, cartId: self.arrOfOrderList[sender.tag].id  ?? 0)
        } else if self.arrOfOrderList[sender.tag].status == 2 {
            //raise dispute
            self.goToRaiseDispute(indx: sender.tag)
        } else if self.arrOfOrderList[sender.tag].status == 4 {
            //raise dispute
            self.goToRaiseDispute(indx: sender.tag)
        } else if self.arrOfOrderList[sender.tag].status == 5 {
            //raise dispute
            self.goToRaiseDispute(indx: sender.tag)
        }
    }
    
    func goToRaiseDispute(indx:Int) {
        let destinationViewController = Storyboard.orderMaterial.instantiateViewController(withIdentifier: "RaiseADisputeVC") as? RaiseADisputeVC
        destinationViewController?.projectId = self.projectId
        destinationViewController?.subTaskId = self.taskkId
        destinationViewController?.price = self.arrOfOrderList[indx].TotalPrice ?? Double(0.0)
        destinationViewController?.cartId = self.arrOfOrderList[indx].id ?? 0
        destinationViewController?.completionHandlerGoToOrderListing = { [weak self] in
            self?.fetchOrderList()
        }
        self.present(destinationViewController!, animated: true)
    }
    
    func updateStatus(cardStatus:Int, cartId:Int) {
        let params = ["cartId":"\(cartId)" , "cardStatus":"\(cardStatus)"]
        ongoingProejctsCOViewModel.updatecartStatusApi(params) { [self] model in
            self.fetchOrderList()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = Storyboard.orderMaterial.instantiateViewController(withIdentifier: "OrderListDetailVC") as? OrderListDetailVC
        destinationVC?.isFrom = "AssignTask"
        destinationVC?.orderListItem = self.arrOfOrderList[indexPath.row]
        destinationVC?.projectId = self.projectId
        destinationVC?.subTaskId = self.taskkId
        self.navigationController?.pushViewController(destinationVC!, animated: true)
    }
}
