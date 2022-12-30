//
//  AddNewTaskVC.swift
//  TA
//
//  Created by Applify  on 11/01/22.
//

import UIKit
import CoreLocation
import Photos
import SDWebImage
import MobileCoreServices
import UniformTypeIdentifiers

class AddNewTaskVC: BaseViewController {
    
    @IBOutlet weak var assignToOtherView: UIView!
    @IBOutlet weak var selfAssignView: UIView!
    @IBOutlet weak var txtFindLocation: FloatingLabelInput!
    @IBOutlet weak var mainScrollVw: UIScrollView!
    @IBOutlet weak var collVwProjectFiles: UICollectionView!
    @IBOutlet weak var btnAddProjectFiles: UIButton!
    @IBOutlet weak var txtFldZicode: FloatingLabelInput!
    @IBOutlet weak var txtFldStte: FloatingLabelInput!
    @IBOutlet weak var txtFldCity: FloatingLabelInput!
    @IBOutlet weak var txtFlldAddress: FloatingLabelInput!
    @IBOutlet weak var txtFldBudget: FloatingLabelInput!
    @IBOutlet weak var projectTypeTblVwHeight: NSLayoutConstraint!
    @IBOutlet weak var tblVwProjectType: UITableView!
    @IBOutlet weak var detailsTblVwHeight: NSLayoutConstraint!
    @IBOutlet weak var tblVwDetails: UITableView!
    
    @IBOutlet weak var btnAddNewDeliverables: UIButton!
    @IBOutlet weak var vwInviteOtherContractors: UIView!
    
    @IBOutlet weak var btnTopTitle: UILabel!
    @IBOutlet weak var bottomVw: UIView!
    @IBOutlet weak var btnAddTask: UIButton!
    @IBOutlet weak var txtFldTaskBudget: FloatingLabelInput!
    @IBOutlet weak var txtFldTaskName: FloatingLabelInput!
    @IBOutlet weak var btnOtherCOs: UIButton!
    @IBOutlet weak var btnSelfAssign: UIButton!
    @IBOutlet weak var vwwTop: UIView!
    
    var isFrom = ""
    var budget = ""
    var task = ""
    var taskId = ""
    var taskStatus = ""
    
    let addNewTaskViewModel: AddNewTaskViewModel = AddNewTaskViewModel()
    var selectedTypeTask = ""
    var projectId = 0
    
    var arrSkills = [SkillsResponseDetail]()
    var selectedSkill = ""
    var selectedSkillId = 0
    let locationManager = CLLocationManager()
    private var userImage: String?
    var isLicenseImageSelected = false
    var docURL:URL?
    var selectedType = ""
    var arrDeliverablesValue = NSMutableArray()
    
    var arrOfFiles = [[String : Any]]()
    var arrOfImages = [UIImage]()
    var arrOfImagesNames = [String]()
    
    var arrOfFilesFetchedFromServer = [[String:Any]]()
    var arrOfFilesManually = [[String:Any]]()
    var taskFilesArray : [ProjectTaskFilesOngoing]?
    var arrOfFilesToBeSent = [[String:Any]]()
    let viewModel: CreateAccountTACVM = CreateAccountTACVM()
    var completionHandlerGoToTaskListingOngoing: (() -> Void)?
    var projectIdEditTasks = 0
    var ongoingProejctsCOViewModel:OngoingProejctsCOViewModel = OngoingProejctsCOViewModel()
    var isEditableFlag = false
    var discriptionData = ""
    var longitude = ""
    var latitude = ""
    var projectCategoriesId = 0
    var amount = ""
    var amounts = ""
    var attachmentUrl = [String]()
    var attachmentType = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtFldTaskName.delegate = self
        self.txtFldZicode.delegate = self
        
        self.btnAddProjectFiles.setRoundCorners(radius: 8.0)
        
        self.txtFldCity.isUserInteractionEnabled = false
        self.txtFldStte.isUserInteractionEnabled = false
        
        self.navigationController?.navigationBar.isHidden = true
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        
        btnAddNewDeliverables.titleLabel?.font = UIFont(name: PoppinsFont.medium, size: 13.0)
        
        txtFldTaskName.setLeftPadding(14)
        txtFldTaskBudget.setLeftPadding(14)
        
        self.registerCell()
        
        self.tblVwDetails.delegate = self
        self.tblVwDetails.dataSource = self
        self.tblVwProjectType.delegate = self
        self.tblVwProjectType.dataSource = self
        self.collVwProjectFiles.delegate = self
        self.collVwProjectFiles.dataSource = self
        
        txtFindLocation.setLeftPadding(14)
        txtFlldAddress.setLeftPadding(14)
        txtFldCity.setLeftPadding(14)
        txtFldStte.setLeftPadding(14)
        txtFldZicode.setLeftPadding(14)
        txtFldBudget.setLeftPadding(14)
        txtFldBudget.delegate = self
        txtFindLocation.setRightPaddingIconLocation(icon: UIImage(named: "ic_find_location")!)
        txtFlldAddress.layer.borderColor = UIColor.lightGray.cgColor
        txtFldCity.layer.borderColor = UIColor.lightGray.cgColor
        txtFldStte.layer.borderColor = UIColor.lightGray.cgColor
        txtFldZicode.layer.borderColor = UIColor.lightGray.cgColor

        self.getProjectType()
        self.mainScrollVw.scrollToTop()
        bottomVw.addCustomShadow()
        //self.handleSelfTap()
        self.txtFldTaskBudget.delegate = self
        self.initializeTask()
        NotificationCenter.default.addObserver(self, selector: #selector(self.isCreateNewTask(notification:)), name: Notification.Name("IsCreateNewTask"), object: nil)
        
        self.btnSelfAssign.isUserInteractionEnabled = true
        self.btnOtherCOs.isUserInteractionEnabled = true
        if isFrom == "Edit" {
            self.isEditableFlag = true
            if self.selectedTypeTask == "Self" {
                self.btnSelfAssign.isUserInteractionEnabled = false
                self.btnOtherCOs.isUserInteractionEnabled = false
                initializeTask()
                handleSelfTap()
                txtFldTaskName.text = task
                txtFldTaskBudget.text = "$ \(budget)"
                txtFldTaskName.resetFloatingLable()
                txtFldTaskBudget.resetFloatingLable()
                btnTopTitle.text = "Edit Task"
                btnAddTask.setTitle("Update Task", for: .normal)
            } else {
                initializeTask()
                handleOthersCOTap()
                self.fetchTaskDetail()
            }
        } else if isFrom == "AddNew" {
            self.selfAssignView.isHidden = false
            self.assignToOtherView.isHidden = false
            isFrom = ""
            btnTopTitle.text = "Add Task"
            btnAddTask.setTitle("Add Task", for: .normal)
            handleSelfTap()
            initializeTask()
        }
    }
    
    @objc func isCreateNewTask(notification: Notification) {
        handleSelfTap()
        initializeTask()
    }
    
    @IBAction func actionFindLocation(_ sender: Any) {
        let destinationViewController = (Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController)
                destinationViewController?.btnTapAction3 = {
                    () in
                    
                    self.txtFlldAddress.text = destinationViewController?.addressLine1
                    self.txtFlldAddress.resetFloatingLable()
                    
                    self.txtFldCity.text = destinationViewController?.city ?? ""
                    self.txtFldCity.resetFloatingLable()
                    
                    self.txtFldStte.text = destinationViewController?.state ?? ""
                    self.txtFldStte.resetFloatingLable()
                    
                    self.txtFldZicode.text = destinationViewController?.zipcode
                    self.txtFldZicode.resetFloatingLable()
                    
                    self.longitude = ""
                    self.latitude = ""
                    self.longitude = "\(destinationViewController?.lng ?? Double(0.0))"
                    self.latitude = "\(destinationViewController?.lat ?? Double(0.0))"
                }
        self.navigationController?.present(destinationViewController!, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.isEditableFlag == false {
            if isFrom == "Edit" {
                if self.selectedTypeTask == "Self" {
                    self.assignToOtherView.isHidden = true
                    self.btnSelfAssign.isUserInteractionEnabled = false
                    self.btnOtherCOs.isUserInteractionEnabled = false
                    initializeTask()
                    handleSelfTap()
                    txtFldTaskName.text = task
                    txtFldTaskBudget.text = "$ \(budget)"
                    txtFldTaskName.resetFloatingLable()
                    txtFldTaskBudget.resetFloatingLable()
                    btnTopTitle.text = "Edit Task"
                    btnAddTask.setTitle("Update Task", for: .normal)
                } else {
                    self.selfAssignView.isHidden = true
                    initializeTask()
                    handleOthersCOTap()
                    self.fetchTaskDetail()
                }
            } else if isFrom == "AddNew" {
                self.discriptionData = ""
                self.selfAssignView.isHidden = false
                self.assignToOtherView.isHidden = false
                isFrom = ""
                btnTopTitle.text = "Add Task"
                btnAddTask.setTitle("Add Task", for: .normal)
                handleSelfTap()
                initializeTask()
            }
        } else if isFrom == "AddNew" {
            self.discriptionData = ""
            self.selfAssignView.isHidden = false
            self.assignToOtherView.isHidden = false
            self.mainScrollVw.scrollToTop()
            isFrom = ""
            btnTopTitle.text = "Add Task"
            btnAddTask.setTitle("Add Task", for: .normal)
            handleSelfTap()
            initializeTask()
        }
    }
    
    //MARK: Register Cell
    func registerCell() {
        self.collVwProjectFiles.register(UINib(nibName: "PlaceBidCollVwCell", bundle: nil), forCellWithReuseIdentifier: "PlaceBidCollVwCell")
        tblVwDetails.register(UINib.init(nibName: "AddTaskTblVwCell", bundle: nil), forCellReuseIdentifier: "AddTaskTblVwCell")
        tblVwProjectType.register(UINib.init(nibName: "ProjectTypeTableViewCellHO", bundle: nil), forCellReuseIdentifier: "ProjectTypeTableViewCellHO")
     }
    
    func fetchTaskDetail() {
        self.mainScrollVw.scrollToTop()
        ongoingProejctsCOViewModel.getAllOngoingTaskDetailsApi(["projectId":self.projectIdEditTasks]) { [self] model in
            self.selectedTypeTask = "OtherCO"
            self.btnSelfAssign.isUserInteractionEnabled = false
            self.btnOtherCOs.isUserInteractionEnabled = false
            self.arrOfFilesToBeSent.removeAll()
            self.arrOfFilesManually.removeAll()
            self.arrOfFilesFetchedFromServer.removeAll()
            self.arrOfImages.removeAll()
            self.taskFilesArray?.removeAll()
            
            self.txtFlldAddress.text = model?.data?.projectDetails?.addressLine1 ?? ""
            self.txtFldCity.text = model?.data?.projectDetails?.city ?? ""
            self.txtFldStte.text = model?.data?.projectDetails?.state ?? ""
            self.txtFldZicode.text = model?.data?.projectDetails?.zipCode ?? ""
            self.latitude = model?.data?.projectDetails?.latitude ?? ""
            self.longitude = model?.data?.projectDetails?.longitude ?? ""
            
            self.txtFldTaskName.text = model?.data?.projectDetails?.title ?? ""
            self.txtFldBudget.text = "$ \(model?.data?.projectDetails?.price ?? Double(0.0))"
            txtFldTaskName.resetFloatingLable()
            txtFldBudget.resetFloatingLable()
            
            self.arrDeliverablesValue.removeAllObjects()
            self.discriptionData = model?.data?.projectDetails?.tasks?[0].taskDescription ?? ""
            for i in 0 ..< (model?.data?.projectDetails?.project_deliverable?.count ?? 0)! {
                self.arrDeliverablesValue[i] = model?.data?.projectDetails?.project_deliverable?[i].deliveralble ?? ""
            }
            self.tblVwDetails.reloadData()
            self.tblVwDetails.layoutIfNeeded()
            self.detailsTblVwHeight.constant = 74.0
//            self.detailsTblVwHeight.constant = (CGFloat(self.arrDeliverablesValue.count) * 74.0)
            
            //self.selectedSkill = model?.data?.projectDetails?.type ?? ""
            
            self.selectedSkill = model?.data?.projectDetails?.projectCategory?.title ?? ""
            self.selectedSkillId = model?.data?.projectDetails?.projectCategoriesId ?? 0
            
            self.tblVwProjectType.reloadData()
            self.arrOfImagesNames.removeAll()
            self.arrOfFilesToBeSent.removeAll()
            self.arrOfImages.removeAll()
            
            btnTopTitle.text = "Edit Task"
            btnAddTask.setTitle("Update Task", for: .normal)
            
            let userImgVw = UIImageView()
            if model?.data?.projectDetails?.project_files?.count ?? 0 > 0 {
                for i in 0 ..< (model?.data?.projectDetails?.project_files!.count)! {
                    let fileStr = model?.data?.projectDetails?.project_files?[i].file ?? ""
                    userImgVw.image = nil
                    if fileStr.contains(".png") || fileStr.contains(".jpg") || fileStr.contains(".jpeg") {
                        userImgVw.sd_setImage(with: URL(string: fileStr), placeholderImage: UIImage(named: "doc"), completed: nil)
                        let imageStr = model?.data?.projectDetails?.project_files?[i].file
                        let strOfImage = imageStr?.replacingOccurrences(of: "https://transadvisor-dev.s3.amazonaws.com/projectUploads/", with: "")
                        let dict = ["image": "\(strOfImage ?? "")", "name":model?.data?.projectDetails?.project_files?[i].title]
                        self.arrOfFilesToBeSent.append(dict as [String : Any])
                        self.arrOfImagesNames.append("\(model?.data?.projectDetails?.project_files?[i].title ?? "").png")
                        self.arrOfImages.append(userImgVw.image!)
                    } else {
                        let imageStr = model?.data?.projectDetails?.project_files?[i].file
                        let strOfDoc = imageStr?.replacingOccurrences(of: "https://transadvisor-dev.s3.amazonaws.com/projectUploads/", with: "")
                        let dict = ["image": "\(strOfDoc ?? "")", "name":model?.data?.projectDetails?.project_files?[i].title]
                        self.arrOfFilesToBeSent.append(dict as [String : Any])
                        self.arrOfImagesNames.append("\(model?.data?.projectDetails?.project_files?[i].title ?? "").doc")
                        self.arrOfImages.append(UIImage(named: "doc")!)
                    }
                }
                self.taskFilesArray = model?.data?.projectDetails?.project_files
                self.arrOfFilesFetchedFromServer = self.arrOfFilesToBeSent
                self.collVwProjectFiles.reloadData()
            }
        }
    }
    
    func setLocationData() {
        if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
            self.txtFlldAddress.text = obj.addressLine1
            self.txtFlldAddress.resetFloatingLable()
            
            self.txtFldCity.text = obj.city
            self.txtFldCity.resetFloatingLable()
            
            self.txtFldStte.text = obj.state
            self.txtFldStte.resetFloatingLable()
            
            self.txtFldZicode.text = obj.zipCode
            self.txtFldZicode.resetFloatingLable()
            
            self.longitude = obj.longitude ?? "0.0"
            self.latitude = obj.latitude ?? "0.0"
        }
    }
    
    func initializeTask() {
        self.navigationController?.navigationBar.isHidden = true
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        
        
        self.txtFldStte.isUserInteractionEnabled = false
        self.txtFldCity.isUserInteractionEnabled = false
        
        self.arrOfFilesToBeSent.removeAll()
        self.arrOfFilesManually.removeAll()
        self.taskFilesArray?.removeAll()
        self.arrOfImages.removeAll()
        self.arrOfFilesFetchedFromServer.removeAll()
        self.arrOfFilesToBeSent.removeAll()
        self.arrOfImages.removeAll()
        
        self.txtFldTaskName.text = ""
        self.txtFldBudget.text = ""
        self.txtFldTaskBudget.text = ""
        self.txtFlldAddress.text = ""
        self.txtFldCity.text = ""
        self.txtFldZicode.text = ""
        self.txtFldStte.text = ""
        
        self.setLocationData()
        
        self.arrDeliverablesValue.removeAllObjects()
        self.arrDeliverablesValue[0] = ""
        self.selectedSkill = ""
        self.selectedSkillId = 0
        self.txtFldBudget.text = ""
        
        self.txtFldTaskName.resetFloatingLable()
        self.txtFldBudget.resetFloatingLable()
        self.txtFldTaskBudget.resetFloatingLable()
        self.txtFlldAddress.resetFloatingLable()
        self.txtFldCity.resetFloatingLable()
        self.txtFldStte.resetFloatingLable()
        self.txtFldZicode.resetFloatingLable()
        
//        self.imageSelectedView.isHidden = true
//        self.uploadLicenceView.isHidden = false
//        self.selectedType = ""
//        self.lblName.text! = ""
//        self.isLicenseImageSelected = false
        
        self.arrOfImages.removeAll()
        self.arrOfFilesManually.removeAll()
        self.collVwProjectFiles.reloadData()
        self.tblVwDetails.reloadData()
        self.tblVwDetails.layoutIfNeeded()
        self.detailsTblVwHeight.constant = self.tblVwDetails.contentSize.height
        
        self.tblVwProjectType.reloadData()
    }
        
    //MARK: FETCH PROJECT TYPE API
    func getProjectType() {
        addNewTaskViewModel.getSkillListApiCall { response in
            self.arrSkills = response?.data?.listing ?? [SkillsResponseDetail]()
            self.projectTypeTblVwHeight.constant = 0.0
            self.projectTypeTblVwHeight.constant = CGFloat((self.arrSkills.count) * 40)
            self.tblVwProjectType.reloadData()
        }
    }
    
    //MARK: SELF TAP
    func handleSelfTap() {
        self.btnAddTask.setTitle("Add Task", for: .normal)
        self.vwInviteOtherContractors.isHidden = true
        self.mainScrollVw.isScrollEnabled = false
        self.selectedTypeTask = "Self"
        self.txtFldTaskName.isHidden = false
        self.txtFldTaskBudget.isHidden = false
        btnSelfAssign.setImage(UIImage(named: "ic_radio_button"), for: .normal)
        btnOtherCOs.setImage(UIImage(named: "ic_radio_button 1"), for: .normal)
    }
    
    //MARK: OTHERS CONTRACTORS TAP
    func handleOthersCOTap() {
        self.btnAddTask.setTitle("Invite Contractors To Bid", for: .normal)
        self.vwInviteOtherContractors.isHidden = false
        self.mainScrollVw.isScrollEnabled = true
        self.selectedTypeTask = "OtherCO"
        self.txtFldTaskBudget.isHidden = true
        btnOtherCOs.setImage(UIImage(named: "ic_radio_button"), for: .normal)
        btnSelfAssign.setImage(UIImage(named: "ic_radio_button 1"), for: .normal)
    }
    
    func imageSendAPI(imageData: Data, fileName:String) {
        viewModel.addImageLicenseApi(keyToUploadData: "file", fileNames: "\(fileName)", dataToUpload: imageData, param: [:]) { response in
            print(response!)
            // ---
            if let data = response?["data"] as? [String: Any] {
                self.attachmentUrl.append(data["url"] as? String ?? "")
                self.attachmentType.append(data["extension"] as? String ?? "")
            }
            // - ----
            self.setModelData(response: response!)
        }
    }
    
    func docSendAPI(docLocalUrl:URL, fileName:String) {
        if self.docURL != nil {
            viewModel.addLicenseApi(localFileUrl: docLocalUrl, keyToUploadData: "file", fileNames: "\(fileName)") { response in
                print(response!)
                //-----
                if let data = response?["data"] as? [String: Any] {
                    self.attachmentUrl.append(data["url"] as? String ?? "")
                    self.attachmentType.append(data["extension"] as? String ?? "")
                }
                // -------
                self.setModelData(response: response!)
            }
        }
    }
    
    func setModelData(response: [String:Any]) {
        let dataDict = response["data"] as! NSDictionary
        let randomName = "\(randomString())"
        let dict = ["image":dataDict["name"] as! String, "name": randomName ]
        self.arrOfFiles.append(dict)
        self.arrOfFilesManually.append(dict)
        var a = Array(arrOfFiles[0].values)[0]
        self.collVwProjectFiles.reloadData()
    }
    
    //MARK: ACTIONBACK
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: ACTION SELF
    @IBAction func actionSelfAssign(_ sender: Any) {
        if isFrom == "Edit" {
        } else {
            self.handleSelfTap()
        }
    }
    
    //MARK: ACTION OTHERS CONTRACTORS
    @IBAction func actionOtherCOs(_ sender: Any) {
        if isFrom == "Edit" {
        } else {
            self.handleOthersCOTap()
        }
    }
    
    //MARK: ACTION ADD NEW DELIVERABLES
    @IBAction func actionAddNewDeliverables(_ sender: Any) {
        arrDeliverablesValue[self.arrDeliverablesValue.count] = ""
        tblVwDetails.reloadData()
        tblVwDetails.layoutIfNeeded()
        detailsTblVwHeight.constant = tblVwDetails.contentSize.height
    }
    
    @IBAction func actionAddFiles(_ sender: Any) {
        var count = arrOfImages.count
                let limit  = 149
                if count <= limit {
                    handleCameraOptions()
                }else{
                    print("limit is 150")
                    showMessage(with: ValidationError.validImageCount, theme: .error)
                }
        //handleCameraOptions()
    }
    
    //MARK: ACTION ADD TASK
    @IBAction func actionAddTask(_ sender: Any) {
        if self.selectedTypeTask == "Self" {
            let taskname = self.txtFldTaskName.text?.trimmed ?? ""
            let budgetAmount2 = self.txtFldTaskBudget.text?.trimmed ?? ""
            let budgetAmount3 = budgetAmount2.replacingOccurrences(of: "$ ", with: "")
            let budgetAmount = budgetAmount3.replacingOccurrences(of: ",", with: "")
            let addNewTaskModel  = AddNewTaskModel(bidBudget: budgetAmount, taskName: taskname)
            addNewTaskViewModel.model = addNewTaskModel
            addNewTaskViewModel.validateAddTaskModel {[weak self] (success, error) in
                guard let strongSelf = self else { return }
                if error == nil {
                    if isFrom == "Edit" {
                        let params = ["task":taskname, "budget": budgetAmount, "id": "\(taskId)", "status" :"\(taskStatus)"] as [String : Any]
                        addNewTaskViewModel.updateTaskApi(params) { response in
                            showMessage(with: "Task updated successfully", theme: .success)
                            self?.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        let params = ["task":taskname, "budget": budgetAmount, "projectId": "\(projectId)", "type" :"PROJECT"] as [String : Any]
                        addNewTaskViewModel.addNewTaskApi(params) { response in
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                else {
                    if let errorMsg = strongSelf.addNewTaskViewModel.error {
                        showMessage(with: errorMsg)
                    }
                }
            }
        } else {
                let taskname = self.txtFldTaskName.text?.trimmed ?? ""
                let budgetAmount2 = self.txtFldBudget.text?.trimmed ?? ""
                let budgetAmount3 = budgetAmount2.replacingOccurrences(of: "$ ", with: "")
                let budgetAmount = budgetAmount3.replacingOccurrences(of: ",", with: "")
                let typeSkill = self.selectedSkill
                
                var deliverablesArray = [[String : Any]]()
                for i in 0 ..< self.arrDeliverablesValue.count {
                    let dict = ["deliverable": "\(self.arrDeliverablesValue[i] as! String)", "deliverableOrder": "\(i)" ]
                    deliverablesArray.append(dict)
                }
                var isMediaSelected = false
                if self.arrOfImages.count > 0 {
                    isMediaSelected = true
                }
                let addNewOtherTaskModel  = AddNewOtherTaskModel(taskName: taskname, deliverables: deliverablesArray, projectType: typeSkill, budget: budgetAmount, address: txtFlldAddress.text ?? "", city: txtFldCity.text ?? "", state: txtFldStte.text ?? "", zipcode: txtFldZicode.text ?? "", isMediaSelected: isMediaSelected)
                addNewTaskViewModel.addNewOtherTaskModel = addNewOtherTaskModel
                addNewTaskViewModel.validateAddOtherTaskModel {[weak self] (success, error) in
                    guard let strongSelf = self else { return }
                    if error == nil {
                        if isFrom == "Edit" {
                            
                            
                            let params = ["id": "\(taskId)", "task":taskname, "budget": budgetAmount, "type" :typeSkill ,"addressLine1": txtFlldAddress.text ?? "", "city": txtFldCity.text ?? "", "state": txtFldStte.text ?? "" , "zipCode" : txtFldZicode.text ?? "" , "taskFiles" : self!.arrOfFilesManually.toJSONString() , "taskDeliverables" : deliverablesArray.toJSONString() ,
                                          "longitude": self?.longitude ?? "0.0",
                                          "latitude": self?.latitude ?? "0.0","projectCategoriesId":self?.selectedSkillId ?? 0, "taskDescription" : arrDeliverablesValue[0]] as [String : Any]
                                addNewTaskViewModel.updateInviteBidsToContractors(params) { response in
                                    showMessage(with: response?.data?.customMessage ?? "", theme: .success)
                                    self?.navigationController?.popViewController(animated: true)
                                    
                                }
                        } else {
                            let params = ["task":taskname, "budget": budgetAmount, "type" :typeSkill, "projectId": "\(projectId)" ,"addressLine1": txtFlldAddress.text ?? "", "city": txtFldCity.text ?? "", "state": txtFldStte.text ?? "" , "zipCode" : txtFldZicode.text ?? "" , "taskFiles" : self!.arrOfFilesManually.toJSONString() , "taskDeliverables" : deliverablesArray.toJSONString(),
                                          "longitude": self?.longitude ?? "0.0",
                                          "latitude": self?.latitude ?? "0.0","projectCategoriesId":self?.selectedSkillId ?? 0, "taskDescription" : arrDeliverablesValue[0]] as [String : Any]
                                addNewTaskViewModel.addInviteBidsToContractors(params) { response in
                                    let vc = Storyboard.contractorHO.instantiateViewController(withIdentifier: "ContractorHOVC") as? ContractorHOVC
                                    vc!.projectId = self!.projectId
//                                    vc!.isFrom = "InviteContractorsToBid"
                                    vc!.completionHandlerGoToTaskListing = { [weak self] in
                                        self!.completionHandlerGoToTaskListingOngoing?()
                                        self?.navigationController?.popViewController(animated: true)
                                    }
                                    vc!.inviteSubtaskIdToContractor = response?.data?.createSubProject?.id ?? 0
                                    vc!.isFrom = "InviteContractorsToBid"
                                    vc!.projectCategoriesId = self?.selectedSkillId ?? 0
                                    self?.navigationController?.pushViewController(vc!, animated: true)
                                }
                        }
                    } else {
                        if let errorMsg = strongSelf.addNewTaskViewModel.error {
                            showMessage(with: errorMsg)
                        }
                    }
                }
        }
    }
}

extension AddNewTaskVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFldTaskBudget {
            if (textField.text?.isEmpty ?? true), string == "0" {
                return false
            } else if textField.text?.count ?? 0 > 9 && !string.isEmpty {
                return false
            }

            let str = "\(textField.text!)\(string)"
            let str2 = str.replacingOccurrences(of: "$ ", with: "")
//            textField.text! = "$ \(str2)"
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = Locale.current
            formatter.maximumFractionDigits = 0
            
            if let groupingSeparator = formatter.groupingSeparator {

                    if string == groupingSeparator {
                        return true
                    }
                if let textWithoutGroupingSeparator = textField.text?.replacingOccurrences(of: groupingSeparator, with: "") {
                            var totalTextWithoutGroupingSeparators = textWithoutGroupingSeparator + string
                            if string.isEmpty { // pressed Backspace key
                                totalTextWithoutGroupingSeparators.removeLast()
                            }
                    let totalTextWithoutGroupingSeparator = totalTextWithoutGroupingSeparators.replacingOccurrences(of: "$ ", with: "")
                            if let numberWithoutGroupingSeparator = formatter.number(from: totalTextWithoutGroupingSeparator),
                                let formattedText = formatter.string(from: numberWithoutGroupingSeparator) {

                                textField.text = formattedText
                                amount = formattedText
                                textField.text = "$ \(amount)"
                                txtFldTaskBudget.resetFloatingLable()
                                return false
                            }
                    
                        }
            }
            txtFldTaskBudget.resetFloatingLable()
            if str == "$ " {
                textField.text! = ""
                txtFldTaskBudget.resetFloatingLable()
                return true
            }
            if str2.count > 0 {
                if string == "" {
                    if str2.count == 1 {
                        textField.text! = ""
                        txtFldTaskBudget.resetFloatingLable()
                    }
                    return true
                }
                return false
            } else {
                return true
            }
            
        } else if textField == txtFldBudget {
            if (textField.text?.isEmpty ?? true), string == "0" {
                return false
            } else if textField.text?.count ?? 0 > 9 && !string.isEmpty {
                return false
            }

            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = Locale.current
            formatter.maximumFractionDigits = 0
            
            let str = "\(textField.text!)\(string)"
            let str2 = str.replacingOccurrences(of: "$ ", with: "")
//            textField.text! = "$ \(str2)"
            
            if let groupingSeparator = formatter.groupingSeparator {

                    if string == groupingSeparator {
                        return true
                    }
                if let textWithoutGroupingSeparator = textField.text?.replacingOccurrences(of: groupingSeparator, with: "") {
                            var totalTextWithoutGroupingSeparators = textWithoutGroupingSeparator + string
                            if string.isEmpty { // pressed Backspace key
                                totalTextWithoutGroupingSeparators.removeLast()
                            }
                    let totalTextWithoutGroupingSeparator = totalTextWithoutGroupingSeparators.replacingOccurrences(of: "$ ", with: "")
                            if let numberWithoutGroupingSeparator = formatter.number(from: totalTextWithoutGroupingSeparator),
                                let formattedText = formatter.string(from: numberWithoutGroupingSeparator) {

                                textField.text = formattedText
                                amounts = formattedText
                                textField.text = "$ \(amounts)"
                                txtFldBudget.resetFloatingLable()
                                return false
                            }
                    
                        }
            }
            txtFldBudget.resetFloatingLable()
            if str == "$ " {
                textField.text! = ""
                txtFldBudget.resetFloatingLable()
                return true
            }
            if str2.count > 0 {
                if string == "" {
                    if str2.count == 1 {
                        textField.text! = ""
                        txtFldBudget.resetFloatingLable()
                    }
                    return true
                }
                return false
            } else {
                return true
            }
            
        }
        if textField == txtFldTaskName {
            let currentText = txtFldTaskName.text ?? ""
            guard let stringRange = Range(range, in: currentText) else {
                return false
            }
            let updateText = currentText.replacingCharacters(in: stringRange, with: string)
            return updateText.count < 101
        }
        
        if textField == txtFldZicode {
            let currentText = txtFldZicode.text ?? ""
            guard let stringRange = Range(range, in: currentText) else {
                return false
            }
            let updateText = currentText.replacingCharacters(in: stringRange, with: string)
            return updateText.count < 11
        }
        return true
    }
}


extension AddNewTaskVC: CLLocationManagerDelegate {
    
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
                    self.txtFlldAddress.text = placemark.subLocality!
                    self.txtFlldAddress.resetFloatingLable()
                }
                if placemark.locality != nil {
                    self.txtFldCity.text = placemark.locality!
                    self.txtFldCity.resetFloatingLable()
                }
                if placemark.administrativeArea != nil {
                    self.txtFldStte.text = placemark.administrativeArea!
                    self.txtFldStte.resetFloatingLable()
                }
                if placemark.postalCode != nil {
                    self.txtFldZicode.text = placemark.postalCode!
                    self.txtFldZicode.resetFloatingLable()
                }
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
}

//MARK: COLLECTION VIEW DELEGATES
extension AddNewTaskVC: UICollectionViewDelegateFlowLayout{
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

extension AddNewTaskVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceBidCollVwCell", for: indexPath) as!  PlaceBidCollVwCell
        cell.innerVw.setRoundCorners(radius: 5.0)
        cell.btnCross.tag = indexPath.row
        cell.btnCross.addTarget(self, action: #selector(deleteFile(sender:)), for: .touchUpInside)
        cell.projectImage.setRoundCorners(radius: 5.0)
        cell.projectImage.image = self.arrOfImages[indexPath.row]
        cell.projectTitle.text = self.arrOfImagesNames[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if attachmentType[indexPath.row] == "pdf" {
            let imgStr = self.attachmentUrl[indexPath.row]
            if let url = URL(string: imgStr) {
                UIApplication.shared.open(url)
            }
        } else {
            let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
            destinationViewController!.isImage = false
            destinationViewController?.imsgeStrURL = attachmentUrl[indexPath.row] //""
            destinationViewController?.img = self.arrOfImages[indexPath.row]
            self.navigationController?.pushViewController(destinationViewController!, animated: true)
        }
//        let a = Array(arrOfFiles[indexPath.row].values)[0] as? String
//        let last4 = a?.suffix(4)
//        if last4 == ".png" || last4 == ".jpg" || last4 == "jpeg" {
//            let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
//            destinationViewController!.isImage = true
//            destinationViewController?.imsgeStrURL = ""
//            destinationViewController?.img = self.arrOfImages[indexPath.row]
//            self.navigationController?.pushViewController(destinationViewController!, animated: true)
//        } else {
//            if let imgStr = a {
//                if let url = URL(string: imgStr) {
//                    UIApplication.shared.open(url)
//                }
//            }
//        }
//        let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
//        destinationViewController!.isImage = true
//        destinationViewController?.imsgeStrURL = ""
//        destinationViewController?.img = self.arrOfImages[indexPath.row]
//        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
    
    @objc func deleteFile(sender: UIButton) {
        attachmentUrl.remove(at: sender.tag)
        attachmentType.remove(at: sender.tag)
        if Int(self.taskId) != 0 {
            if self.arrOfFilesFetchedFromServer.count > 0 {
                if sender.tag < self.arrOfFilesFetchedFromServer.count {
                    self.deleteProjectFile(fileId: self.taskFilesArray?[sender.tag].id ?? 0, indexOfFile: sender.tag)
                } else {
                    self.arrOfFilesManually.remove(at: (sender.tag - self.arrOfFilesFetchedFromServer.count))
                    handleManualDeleteFile(indexOfFile:sender.tag)
                }
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
        self.collVwProjectFiles.reloadData()
    }
    
    func deleteProjectFile(fileId:Int, indexOfFile:Int) {
        let param = ["id":fileId]
        addNewTaskViewModel.deleteTaskFileApi(param) { response in
            self.taskFilesArray?.remove(at: indexOfFile)
            self.arrOfFilesFetchedFromServer.remove(at: indexOfFile)
            self.handleManualDeleteFile(indexOfFile: indexOfFile)
        }
    }
}

//MARK: TABLE VIEW DELEGATES
extension AddNewTaskVC: UITableViewDelegate,UITableViewDataSource{
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if tableView == tblVwDetails{
           print("---------\(arrDeliverablesValue)")
           return 1 //arrDeliverablesValue.count
       } else if tableView == tblVwProjectType{
           return self.arrSkills.count
       }
     return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblVwDetails {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskTblVwCell", for: indexPath) as! AddTaskTblVwCell
            cell.deliverablesTextField.text = discriptionData //self.arrDeliverablesValue[indexPath.row] as? String
            cell.deliverablesTextField.resetFloatingLable()
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(deleteDeliverables(sender:)), for: .touchUpInside)
            if cell.deliverablesTextField.text != "" {
                cell.deliverablesTextField.resetFloatingLable()
            }
            if indexPath.row == 0 {
                cell.btnDelete.isHidden = true
            }
            return cell
        } else if tableView == tblVwProjectType {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTypeTableViewCellHO", for: indexPath) as! ProjectTypeTableViewCellHO
            cell.lblTitle.text = self.arrSkills[indexPath.row].title ?? ""
            cell.btnCheck.tag = indexPath.row
            cell.btnCheck.addTarget(self, action: #selector(selectSkill(sender:)), for: .touchUpInside)
            if selectedSkill == (self.arrSkills[indexPath.row].title ?? "") {
                cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled")
            } else {
                cell.imgCheckBox.image = UIImage(named: "ic_check_box")
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblVwDetails {
            return UITableView.automaticDimension
        } else if tableView == tblVwProjectType{
            return 40
        }
        return 0
    }
    
    @objc func selectSkill(sender: UIButton) {
        if (self.selectedSkill == (self.arrSkills[sender.tag].title ?? "")) {
            selectedSkillId = 0
            selectedSkill = ""
        } else {
            selectedSkillId = (self.arrSkills[sender.tag].id ?? 0)
            self.selectedSkill = (self.arrSkills[sender.tag].title ?? "")
        }
        self.tblVwProjectType.reloadData()
    }
    
    @objc func deleteDeliverables(sender: UIButton) {
        if self.arrDeliverablesValue.count <= 1 {
            
        } else {
            self.arrDeliverablesValue.removeObject(at: sender.tag)
            let indxPath = IndexPath(row: sender.tag, section: 0)
            self.tblVwDetails.deleteRows(at: [indxPath], with: .automatic)
            self.tblVwDetails.reloadData()
            self.tblVwDetails.layoutIfNeeded()
            self.detailsTblVwHeight.constant = self.tblVwDetails.contentSize.height
        }
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension AddNewTaskVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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

extension AddNewTaskVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        self.docURL = myURL
        self.arrOfImagesNames.append("\(randomString()).doc")
        self.arrOfImages.append(UIImage(named: "doc")!)
        self.docSendAPI(docLocalUrl: myURL, fileName: "\(randomString()).pdf")
    }

     func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
