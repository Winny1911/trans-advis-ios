//
//  CreateProjectHOVC.swift
//  TA
//
//  Created by Dev on 13/12/21.
//

import UIKit
import CoreLocation
import Photos
import SDWebImage
import MobileCoreServices
import UniformTypeIdentifiers
import GBFloatingTextField

class CreateProjectHOVC: BaseViewController {

    @IBOutlet weak var filesTblVwHeight: NSLayoutConstraint!
    @IBOutlet weak var tblVwFiles: UITableView!
    @IBOutlet weak var lblTopTitle: UILabel!
    @IBOutlet weak var lblSuccess: UILabel!
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet weak var btnSucces: UIButton!
    @IBOutlet weak var successFulView: UIView!
    @IBOutlet weak var blackView: UIView!
    
    @IBOutlet weak var txtFldBudget: FloatingLabelInput!
    @IBOutlet weak var btnCreateProject: UIButton!
    @IBOutlet weak var createProjectButtonTap: UIView!
    @IBOutlet weak var btnAddDeliverables: UIButton!
//    @IBOutlet weak var txtVwProjectDescription: TextViewFloatingLable!
    
    @IBOutlet weak var txtVwProjectDescription: GBFloatingTextView! //
    @IBOutlet weak var txtFldProjectTtile: FloatingLabelInput! //
    @IBOutlet weak var projectTypeTblVwHeight: NSLayoutConstraint!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var projectTypeTableView: UITableView!
    
    @IBOutlet weak var createProjectView: UIView!
    
    @IBOutlet weak var findLocationTextField: FloatingLabelInput!
    @IBOutlet weak var streetTextField: FloatingLabelInput!
    @IBOutlet weak var stateTextField: FloatingLabelInput!
    @IBOutlet weak var cityTextField: FloatingLabelInput!
    @IBOutlet weak var zipcodeTextField: FloatingLabelInput!
    
    @IBOutlet weak var detailTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var uploadLicenceView: UIView!
    
    let createAccountTACVM: CreateAccountTACVM = CreateAccountTACVM()
    let createProjectHOViewModel: CreateProjectHOViewModel = CreateProjectHOViewModel()
    
    var arrSkills = [SkillsResponseDetail]()
    var selectedSkillId = 0
    var selectedSkill = ""
    let locationManager = CLLocationManager()
    private var userImage: String?
    var isLicenseImageSelected = false
    var docURL:URL?
    var selectedType = ""
    var arrDeliverablesValue = NSMutableArray()
    
    var projectId = 0
    let newProjectsHOViewModel: NewProjectsHOViewModel = NewProjectsHOViewModel()
    
    var arrOfFilesToBeSent = [[String:Any]]()
    
    var arrOfFilesFetchedFromServer = [[String:Any]]()
    var arrOfFilesManually = [[String:Any]]()
    var projectFilesArray : [ProjectFilesDetail]?
    
    var arrOfImages = [UIImage]()
    var arrOfNamesImages = [String]()
    
    var longitude = ""
    var latitude = ""
    var amount = ""
    var attachmentUrl = [String]()
    var attachmentType = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.zipcodeTextField.delegate = self
        
        self.txtVwProjectDescription.delegate = self
        self.txtFldProjectTtile.delegate = self
        
        self.navigationController?.navigationBar.isHidden = true
        setLocationData()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        
        btnSucces.isHidden = true
        successFulView.setRoundCorners(radius: 14.0)
        successFulView.isHidden = true
        blackView.isHidden = true
        arrDeliverablesValue[0] = ""
        self.arrOfFilesManually.removeAll()
        btnCreateProject.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 16.0)
        btnAddDeliverables.titleLabel?.font = UIFont(name: PoppinsFont.medium, size: 13.0)
        self.arrOfFilesFetchedFromServer.removeAll()
        self.projectFilesArray?.removeAll()
        self.setFloatingTextVw()
        txtFldProjectTtile.setLeftPadding(14)
        
        self.registerCell()
        
        self.tblVwFiles.delegate = self
        self.tblVwFiles.dataSource = self
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        self.projectTypeTableView.delegate = self
        self.projectTypeTableView.dataSource = self
        
        self.filesTblVwHeight.constant = CGFloat((self.arrOfFilesToBeSent.count) * 75)
        
        createProjectView.layer.shadowColor = UIColor.lightGray.cgColor
        createProjectView.layer.shadowOpacity = 0.5
        createProjectView.layer.shadowOffset = CGSize.zero
        createProjectView.layer.shadowRadius = 5
        
        self.txtVwProjectDescription.delegate = self
        findLocationTextField.setLeftPadding(14)
        streetTextField.setLeftPadding(14)
        cityTextField.setLeftPadding(14)
        stateTextField.setLeftPadding(14)
        zipcodeTextField.setLeftPadding(14)
        txtFldBudget.setLeftPadding(14)
        txtFldBudget.delegate = self
        findLocationTextField.setRightPaddingIconLocation(icon: UIImage(named: "ic_find_location")!)
        streetTextField.layer.borderColor = UIColor.lightGray.cgColor
        cityTextField.layer.borderColor = UIColor.lightGray.cgColor
        stateTextField.layer.borderColor = UIColor.lightGray.cgColor
        zipcodeTextField.layer.borderColor = UIColor.lightGray.cgColor
                
        txtVwProjectDescription.setLeftPadding(14.0)
        zipcodeTextField.isUserInteractionEnabled = true
        
        self.getProjectType()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.isCreateNewProject(notification:)), name: Notification.Name("IsCreateNewProject"), object: nil)
   }
    
    override func viewWillAppear(_ animated: Bool) {
        zipcodeTextField.isUserInteractionEnabled = true
        self.lblSuccess.text = "Project created successfully"
        self.btnCreateProject.setTitle("Create Project", for: .normal)
        self.lblTopTitle.text = "Create Project"
        if self.projectId != 0 {
            self.initializeProject()
            self.fetchProjectDetail()
        }
    }
    
    func setFloatingTextVw() {
        txtVwProjectDescription.isFloatingLabel = true
        txtVwProjectDescription.placeholder = "Project Description"
        txtVwProjectDescription.placeholderColor = UIColor.appBtnColorGrey
        txtVwProjectDescription.topPlaceholderColor = UIColor.appFloatText
        txtVwProjectDescription.selectedColor = UIColor.appFloatText
        txtVwProjectDescription.setLeftPadding(14.0)
    }
    
    func initializeProject() {
        self.navigationController?.navigationBar.isHidden = true
        setLocationData()
        self.stateTextField.isUserInteractionEnabled = false
        self.cityTextField.isUserInteractionEnabled = false
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        
        self.arrOfFilesManually.removeAll()
        self.projectFilesArray?.removeAll()
        self.arrOfFilesFetchedFromServer.removeAll()
        self.arrOfFilesToBeSent.removeAll()
        self.arrOfImages.removeAll()
        self.arrOfNamesImages.removeAll()
        self.filesTblVwHeight.constant = CGFloat((self.arrOfFilesToBeSent.count) * 75)
        self.tblVwFiles.reloadData()
        
        scrollVw.scrollToTop()
        self.txtFldProjectTtile.text = ""
        self.txtVwProjectDescription.text = ""
        self.arrDeliverablesValue.removeAllObjects()
        self.arrDeliverablesValue[0] = ""
        self.selectedSkillId = 0
        self.selectedSkill = ""
        self.txtFldBudget.text = ""
        
        setFloatingTextVw()
        
        self.stateTextField.resetFloatingLable()
        self.zipcodeTextField.resetFloatingLable()
        self.cityTextField.resetFloatingLable()
        self.streetTextField.resetFloatingLable()
        self.txtFldBudget.resetFloatingLable()
        self.txtFldProjectTtile.resetFloatingLable()
        
//        self.imageSelectedView.isHidden = true
        self.uploadLicenceView.isHidden = false
        self.selectedType = ""
//        self.lblName.text! = ""
        self.isLicenseImageSelected = false
        
        self.detailTableView.reloadData()
        self.detailTableView.layoutIfNeeded()
        self.detailTableViewHeight.constant = self.detailTableView.contentSize.height
        
        self.projectTypeTableView.reloadData()
    }
    
    func setLocationData() {
        if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
            self.streetTextField.text = obj.addressLine1
            self.streetTextField.resetFloatingLable()
            
            self.cityTextField.text = obj.city
            self.cityTextField.resetFloatingLable()
            
            self.stateTextField.text = obj.state
            self.stateTextField.resetFloatingLable()
            
            self.zipcodeTextField.text = obj.zipCode
            self.zipcodeTextField.resetFloatingLable()
            
            self.longitude = obj.longitude ?? "0.0"
            self.latitude = obj.latitude ?? "0.0"
        }
    }
    
    @objc func isCreateNewProject(notification: Notification) {
        initializeProject()
    }
    
    func fetchProjectDetail () {
        let params = ["id": projectId]
        self.projectFilesArray?.removeAll()
        self.arrOfFilesManually.removeAll()
        self.arrOfFilesFetchedFromServer.removeAll()
        newProjectsHOViewModel.getNewProjectDetailApi(params) { response in
            self.txtFldProjectTtile.text = response?.data?.title ?? ""
            self.txtFldProjectTtile.resetFloatingLable()
            self.txtVwProjectDescription.text = response?.data?.description ?? ""
            self.setFloatingTextVw()
            for i in 0 ..< (response?.data?.project_deliverable!.count)! {
                self.arrDeliverablesValue[i] = response?.data?.project_deliverable?[i].deliveralble ?? ""
            }
            
            self.selectedSkillId = response?.data?.projectCategoriesId ?? 0
            self.selectedSkill = response?.data?.type ?? ""
            self.projectTypeTableView.reloadData()
            self.txtFldBudget.text = "$ \(response?.data?.price ?? 0)"
            self.streetTextField.text = response?.data?.addressLine1 ?? ""
            self.cityTextField.text = response?.data?.city ?? ""
            self.stateTextField.text = response?.data?.state ?? ""
            self.zipcodeTextField.text = response?.data?.zipCode ?? ""
            
            self.latitude = response?.data?.latitude ?? "0.0"
            self.longitude = response?.data?.longitude ?? "0.0"
            
            self.stateTextField.resetFloatingLable()
            self.zipcodeTextField.resetFloatingLable()
            self.cityTextField.resetFloatingLable()
            self.streetTextField.resetFloatingLable()
            self.txtFldBudget.resetFloatingLable()
            let userImgVw = UIImageView()
            if response?.data?.project_files?.count ?? 0 > 0 {
                for i in 0 ..< (response?.data?.project_files!.count)! {
                    let fileStr = response?.data?.project_files?[i].file ?? ""
                    userImgVw.image = nil
                    if fileStr.contains(".png") || fileStr.contains(".jpg") || fileStr.contains(".jpeg") {
                        userImgVw.sd_setImage(with: URL(string: fileStr), placeholderImage: UIImage(named: "doc"), completed: nil)
                        let imageStr = response?.data?.project_files?[i].file
                        let strOfImage = imageStr?.replacingOccurrences(of: "https://transadvisor-dev.s3.amazonaws.com/projectUploads/", with: "")
                        let dict = ["image": "\(strOfImage ?? "")", "name":response?.data?.project_files?[i].title]
                        self.arrOfFilesToBeSent.append(dict as [String : Any])
                        self.arrOfNamesImages.append("\(response?.data?.project_files?[i].title ?? "").png")
                        self.arrOfImages.append(userImgVw.image!)
                    } else {
                        let imageStr = response?.data?.project_files?[i].file
                        let strOfDoc = imageStr?.replacingOccurrences(of: "https://transadvisor-dev.s3.amazonaws.com/projectUploads/", with: "")
                        let dict = ["image": "\(strOfDoc ?? "")", "name":response?.data?.project_files?[i].title]
                        self.arrOfFilesToBeSent.append(dict as [String : Any])
                        self.arrOfNamesImages.append("\(response?.data?.project_files?[i].title ?? "").doc")
                        self.arrOfImages.append(UIImage(named: "doc")!)
                    }
                }
                self.projectFilesArray = response?.data?.project_files
                self.arrOfFilesFetchedFromServer = self.arrOfFilesToBeSent
                self.filesTblVwHeight.constant = CGFloat((self.arrOfFilesToBeSent.count) * 75)
                self.tblVwFiles.reloadData()
            }
            self.detailTableView.reloadData()
            self.detailTableView.layoutIfNeeded()
            self.detailTableViewHeight.constant = (CGFloat(self.arrDeliverablesValue.count) * 74.0)
            self.btnCreateProject.setTitle("Update Project", for: .normal)
            self.lblTopTitle.text = "Edit Project"
        }
    }
    
    //MARK:- Register Cell
    func registerCell() {
        detailTableView.register(UINib.init(nibName: "detailsTableViewCellHO", bundle: nil), forCellReuseIdentifier: "detailsTableViewCellHO")
        projectTypeTableView.register(UINib.init(nibName: "ProjectTypeTableViewCellHO", bundle: nil), forCellReuseIdentifier: "ProjectTypeTableViewCellHO")
     }

    func getProjectType() {
        createAccountTACVM.getSkillListApiCall { response in
            self.arrSkills = response?.data?.listing ?? [SkillsResponseDetail]()
            self.projectTypeTblVwHeight.constant = 0.0
            self.projectTypeTblVwHeight.constant = CGFloat((self.arrSkills.count) * 40)
            self.projectTypeTableView.reloadData()
        }
    }

    @IBAction func actionChooseLicense(_ sender: Any) {
        let count = arrOfFilesToBeSent.count
                let limit  = 149
        if count <= limit {
                    handleCameraOptions()
                }else{
                    print("limit is 150")
                    showMessage(with: ValidationError.validImageCount, theme: .error)
                }
        //handleCameraOptions()
    }
    
    @IBAction func actinFindLocation(_ sender: Any) {
        zipcodeTextField.isUserInteractionEnabled = true
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        let destinationViewController = (Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController)
        destinationViewController?.btnTapAction3 = {
            () in
            
            self.streetTextField.text = destinationViewController?.addressLine1
            self.streetTextField.resetFloatingLable()
            
            self.cityTextField.text = destinationViewController?.city ?? ""
            self.cityTextField.resetFloatingLable()
            
            self.stateTextField.text = destinationViewController?.state ?? ""
            self.stateTextField.resetFloatingLable()
            
            self.zipcodeTextField.text = destinationViewController?.zipcode
            self.zipcodeTextField.resetFloatingLable()
            
            self.longitude = ""
            self.latitude = ""
            self.longitude = "\(destinationViewController?.lng ?? Double(0.0))"
            self.latitude = "\(destinationViewController?.lat ?? Double(0.0))"
        }
        self.navigationController?.present(destinationViewController!, animated: true)
        
    }
    
    @IBAction func addDeliverablesBtnAction(_ sender: Any) {
        arrDeliverablesValue[self.arrDeliverablesValue.count] = ""
        detailTableView.reloadData()
        detailTableView.layoutIfNeeded()
        detailTableViewHeight.constant = detailTableView.contentSize.height
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func actionHideSuccessfulView(_ sender: Any) {
        self.btnSucces.isHidden = true
        self.successFulView.isHidden = true
        self.blackView.isHidden = true
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func actionCreateProject(_ sender: Any) {
        let projectTitle = txtFldProjectTtile.text?.trimmed ?? ""
        let projectDesc = txtVwProjectDescription.text?.trimmed ?? ""
        var deliverablesArray = [[String : Any]]()
        for i in 0 ..< self.arrDeliverablesValue.count {
            let dict = ["deliveralble": "\(self.arrDeliverablesValue[i] as! String)", "deliveralbleOrder": "\(i)" ]
            deliverablesArray.append(dict)
        }
        let typeSkill = self.selectedSkillId
        let typeSkillStr = self.selectedSkill
        let price2 = txtFldBudget.text?.trimmed ?? ""
        let price3 = price2.replacingOccurrences(of: "$ ", with: "")
        let price = price3.replacingOccurrences(of: ",", with: "")
        let street = streetTextField.text?.trimmed ?? ""
        let city = cityTextField.text?.trimmed ?? ""
        let state = stateTextField.text?.trimmed ?? ""
        let zipcodde = zipcodeTextField.text?.trimmed ?? ""
        let selectedTaskImageDoc = arrOfFilesToBeSent.count
        
        let createProjectHOModel = CreateProjectHOModel(projecTitle: projectTitle, projecDescription: projectDesc, deliverables: deliverablesArray, projectType: typeSkill, price: Int(price) ?? 0, street: street, city: city, state: state, zipcode: zipcodde, selectedTaskImageDoc: selectedTaskImageDoc, typeSkillStr: typeSkillStr)
        createProjectHOViewModel.model = createProjectHOModel
        createProjectHOViewModel.validateCreateProjectModel { success, error in
            if error == nil {
                self.apiCreateNewProject(createProjectModel: success!)
            }
            else {
                if let errorMsg = self.createProjectHOViewModel.error {
                    showMessage(with: errorMsg)
                }
            }
        }
    }
    
    func imageSendAPI(imageData:Data, fileName:String) {
        createAccountTACVM.addImageLicenseApi(keyToUploadData: "file", fileNames: "\(fileName)", dataToUpload: imageData, param: [:]) { response in
            print(response!)
            if let data = response?["data"] as? [String: Any] {
                self.attachmentUrl.append(data["url"] as? String ?? "")
                self.attachmentType.append(data["extension"] as? String ?? "")
            }
            let dataDict = response!["data"] as! NSDictionary
            let randomName = "\(self.randomString())"
            let dict = ["name": randomName, "image":dataDict["name"] as! String]
            self.arrOfFilesToBeSent.append(dict)
            self.arrOfFilesManually.append(dict)
            self.filesTblVwHeight.constant = CGFloat((self.arrOfFilesToBeSent.count) * 75)
            self.tblVwFiles.reloadData()
            self.tblVwFiles.scrollToBottom()
        }
    }
    
    func docSendAPI(localFileURL:URL, fileName:String) {
        createAccountTACVM.addLicenseApi(localFileUrl: localFileURL, keyToUploadData: "file", fileNames: fileName) { response in
            print(response!)
            if let data = response?["data"] as? [String: Any] {
                self.attachmentUrl.append(data["url"] as? String ?? "")
                self.attachmentType.append(data["extension"] as? String ?? "")
            }
            let dataDict = response!["data"] as! NSDictionary
            let randomName = "\(self.randomString())"
            let dict = ["name": randomName, "image":dataDict["name"] as! String]
            self.arrOfFilesToBeSent.append(dict)
            self.arrOfFilesManually.append(dict)
            self.filesTblVwHeight.constant = CGFloat((self.arrOfFilesToBeSent.count) * 75)
            self.tblVwFiles.reloadData()
            self.tblVwFiles.scrollToBottom()
        }
    }
    
    func apiCreateNewProject(createProjectModel:CreateProjectHOModel) {
        var deliverablesArray = [[String : Any]]()
        for i in 0 ..< self.arrDeliverablesValue.count {
            let dict = ["deliveralble": "\(self.arrDeliverablesValue[i] as! String)", "deliveralbleOrder": "\(i)" ]
            deliverablesArray.append(dict)
        }
        let params = [
                        "title": createProjectModel.projecTitle,
                        "description": createProjectModel.projecDescription,
                        "type": createProjectModel.typeSkillStr,
                        "projectCategoriesId": createProjectModel.projectType,
                        "price": createProjectModel.price,
                        "address": createProjectModel.street,
                        "state": createProjectModel.state,
                        "city": createProjectModel.city,
                        "zipCode": createProjectModel.zipcode,
                        "ProjectFiles": self.arrOfFilesToBeSent.toJSONString(),
                        "ProjectDeliverable": deliverablesArray.toJSONString(),
                        "longitude": self.longitude,
                        "latitude": self.latitude
                        
                     ] as [String : Any]
        if self.projectId == 0 {
            createProjectHOViewModel.addNewProjectApi(params) { response in
                self.successFulView.isHidden = false
                self.btnSucces.isHidden = false
                self.blackView.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.lblSuccess.text = "Project created successfully"
                    self.successFulView.isHidden = true
                    self.btnSucces.isHidden = true
                    self.blackView.isHidden = true
                    let selectedIndex = self.tabBarController?.selectedIndex
                    if selectedIndex == 0 {
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        self.tabBarController?.selectedIndex = 0
                    }
                }
            }
        } else {
            let param = [
                            "title": createProjectModel.projecTitle,
                            "id": "\( self.projectId)",
                            "description": createProjectModel.projecDescription,
                            "type": createProjectModel.typeSkillStr,
                            "projectCategoriesId": createProjectModel.projectType,
                            "price": createProjectModel.price,
                            "address": createProjectModel.street,
                            "state": createProjectModel.state,
                            "city": createProjectModel.city,
                            "zipCode": createProjectModel.zipcode,
                            "ProjectFiles": self.arrOfFilesManually.toJSONString(),
                            "ProjectDeliverable": deliverablesArray.toJSONString(),
                            "longitude": self.longitude,
                            "latitude": self.latitude
                            
                         ] as [String : Any]
            createProjectHOViewModel.updateProjectApi(param) { response in
                self.lblSuccess.text = "Project updated successfully"
                self.successFulView.isHidden = false
                self.btnSucces.isHidden = false
                self.blackView.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.successFulView.isHidden = true
                    self.btnSucces.isHidden = true
                    self.blackView.isHidden = true
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
        
    }
}

extension CreateProjectHOVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFldBudget {
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
                                textField.text = "$ " + amount
                                txtFldBudget.resetFloatingLable()
                                return false
                            }
                    
                        }
            }
            
//            txtFldBudget.resetFloatingLable()
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
            
        }else if textField == txtFldBudget{
            let currentText = txtFldBudget.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false}
            let updateText = currentText.replacingCharacters(in: stringRange, with: string)
            return updateText.count <= 7
        }
        
        if textField == txtFldProjectTtile {
            let currentText = txtFldProjectTtile.text ?? ""
            guard let stringRange = Range(range, in: currentText) else {
                return false
            }
            let updateText = currentText.replacingCharacters(in: stringRange, with: string)
            return updateText.count < 101
        }
        if textField == zipcodeTextField{
            let currentText = zipcodeTextField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false}
            let updateText = currentText.replacingCharacters(in: stringRange, with: string)
            return updateText.count <= 10
        }
        
        return true
    }
}

extension CreateProjectHOVC: UITableViewDelegate,UITableViewDataSource{
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if tableView == detailTableView{
           return arrDeliverablesValue.count
       } else if tableView == projectTypeTableView{
           return self.arrSkills.count
       } else if tableView == tblVwFiles {
           return arrOfFilesToBeSent.count
       }
     return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == detailTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailsTableViewCellHO", for: indexPath) as! detailsTableViewCellHO
            cell.deliverablesTextField.text = self.arrDeliverablesValue[indexPath.row] as? String
            cell.deliverablesTextField.resetFloatingLable()
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(deleteDeliverables(sender:)), for: .touchUpInside)
            if cell.deliverablesTextField.text != "" {
                cell.deliverablesTextField.resetFloatingLable()
            }
            if arrDeliverablesValue.count == 1 {
                cell.btnDelete.isHidden = true
            } else {
                if indexPath.row == 0 {
                    cell.btnDelete.isHidden = false
                } else {
                    cell.btnDelete.isHidden = false
                }
            }
//            if indexPath.row == 0 {
//                cell.btnDelete.isHidden = true
//            } else {
//                cell.btnDelete.isHidden = false
//            }
            return cell
        } else if tableView == projectTypeTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTypeTableViewCellHO", for: indexPath) as! ProjectTypeTableViewCellHO
            cell.lblTitle.text = self.arrSkills[indexPath.row].title ?? ""
            cell.btnCheck.tag = indexPath.row
            cell.btnCheck.addTarget(self, action: #selector(selectSkill(sender:)), for: .touchUpInside)
            if selectedSkillId == (self.arrSkills[indexPath.row].id ?? 0) {
                cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled")
            } else {
                cell.imgCheckBox.image = UIImage(named: "ic_check_box")
            }
            return cell
        } else if tableView == tblVwFiles {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddFilesTblVwCell", for: indexPath) as! AddFilesTblVwCell
            cell.lblFileName.text = self.arrOfNamesImages[indexPath.row]
            cell.imageFile.image = self.arrOfImages[indexPath.row]
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(deleteImages(sender:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblVwFiles {
            if attachmentType[indexPath.row] == "jpg" || attachmentType[indexPath.row] == "png" || attachmentType[indexPath.row] == "jpeg" {
                let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
                destinationViewController!.isImage = false
                destinationViewController?.imsgeStrURL = attachmentUrl[indexPath.row] //""
                destinationViewController?.img = self.arrOfImages[indexPath.row]
                self.navigationController?.pushViewController(destinationViewController!, animated: true)
            } else {
                let imgStr = self.attachmentUrl[indexPath.row]
                if let url = URL(string: imgStr) {
                    UIApplication.shared.open(url)
                }
            }
//            if attachmentType[indexPath.row] == "pdf" {
//                let imgStr = self.attachmentUrl[indexPath.row]
//                if let url = URL(string: imgStr) {
//                    UIApplication.shared.open(url)
//                }
//            } else {
//                let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
//                destinationViewController!.isImage = false
//                destinationViewController?.imsgeStrURL = attachmentUrl[indexPath.row] //""
//                destinationViewController?.img = self.arrOfImages[indexPath.row]
//                self.navigationController?.pushViewController(destinationViewController!, animated: true)
//            }
        }
    }
    
    @objc func deleteImages(sender: UIButton) {
        attachmentUrl.remove(at: sender.tag)
        attachmentType.remove(at: sender.tag)
        if self.projectId != 0 {
            if self.arrOfFilesFetchedFromServer.count > 0 {
                if sender.tag < self.arrOfFilesFetchedFromServer.count {
                    self.deleteProjectFile(fileId: self.projectFilesArray?[sender.tag].id ?? 0, indexOfFile: sender.tag)
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
        self.tblVwFiles.reloadData()
    }
    
    func handleManualDeleteFile(indexOfFile:Int) {
        self.arrOfImages.remove(at: indexOfFile)
        self.arrOfNamesImages.remove(at: indexOfFile)
        self.arrOfFilesToBeSent.remove(at: indexOfFile)
        self.filesTblVwHeight.constant = CGFloat((self.arrOfFilesToBeSent.count) * 75)
        self.tblVwFiles.reloadData()
    }
    
    func deleteProjectFile(fileId:Int, indexOfFile:Int) {
        let param = ["id":fileId]
        createProjectHOViewModel.deleteProjectFileApi(param) { response in
            self.projectFilesArray?.remove(at: indexOfFile)
            self.arrOfFilesFetchedFromServer.remove(at: indexOfFile)
            self.handleManualDeleteFile(indexOfFile: indexOfFile)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == detailTableView {
            return UITableView.automaticDimension
        } else if tableView == projectTypeTableView{
            return 40
        } else if tableView == tblVwFiles{
            return 70
        }
        return 0
    }
    
    @objc func selectSkill(sender: UIButton) {
        if (self.selectedSkillId == (self.arrSkills[sender.tag].id ?? 0)) {
            selectedSkill = ""
            selectedSkillId = 0
        } else {
            selectedSkill = (self.arrSkills[sender.tag].title ?? "")
            self.selectedSkillId = (self.arrSkills[sender.tag].id ?? 0)
        }
        self.projectTypeTableView.reloadData()
    }
    
    @objc func deleteDeliverables(sender: UIButton) {
        if self.arrDeliverablesValue.count <= 1 {
            
        } else {
            self.arrDeliverablesValue.removeObject(at: sender.tag)
            let indxPath = IndexPath(row: sender.tag, section: 0)
            self.detailTableView.deleteRows(at: [indxPath], with: .automatic)
            self.detailTableView.reloadData()
            self.detailTableView.layoutIfNeeded()
            self.detailTableViewHeight.constant = self.detailTableView.contentSize.height
        }
    }
}

extension CreateProjectHOVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == self.txtVwProjectDescription {
            if textView.textColor == UIColor.init(named: "#B2B2B2") {
                textView.text = nil
                textView.textColor = UIColor.appColorText
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if textView == txtVwProjectDescription {
                let currentText = txtVwProjectDescription.text ?? ""
                guard let stringRange = Range(range, in: currentText) else {
                    return false
                }
                let updateText = currentText.replacingCharacters(in: stringRange, with: text)
                return updateText.count < 501
            }
            return true
        }
}

//extension CreateProjectHOVC: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let userLocation :CLLocation = locations[0] as CLLocation
//        print("user latitude = \(userLocation.coordinate.latitude)")
//        print("user longitude = \(userLocation.coordinate.longitude)")
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
//            if (error != nil){
//                print("error in reverseGeocode")
//            }
//            let placemark = placemarks! as [CLPlacemark]
//            if placemark.count>0{
//                let placemark = placemarks![0]
//                print(placemark.locality!)
//                print(placemark.administrativeArea!)
//                print(placemark.country!)
//
//                if placemark.subLocality != nil {
//                    self.streetTextField.text = placemark.subLocality!
//                    self.streetTextField.resetFloatingLable()
//                }
//                if placemark.locality != nil {
//                    self.cityTextField.text = placemark.locality!
//                    self.cityTextField.resetFloatingLable()
//                }
//                if placemark.administrativeArea != nil {
//                    self.stateTextField.text = placemark.administrativeArea!
//                    self.stateTextField.resetFloatingLable()
//                }
//                if placemark.postalCode != nil {
//                    self.zipcodeTextField.text = placemark.postalCode!
//                    self.zipcodeTextField.resetFloatingLable()
//                }
//                self.locationManager.stopUpdatingLocation()
//            }
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Error \(error)")
//    }
//
//}


//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension CreateProjectHOVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
                    self.showImageInUserPhotoImageView(fileName: userImage ?? "")
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

extension CreateProjectHOVC: UIDocumentPickerDelegate {
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

extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
   }
}

extension Double{
    func thousands() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
