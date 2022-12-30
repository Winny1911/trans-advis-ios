//
//  SetLocationVC.swift
//  TA
//
//  Created by Designer on 08/12/21.
//

import UIKit
import CoreLocation
import Alamofire
class SetLocationVC: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var vwProgress: UIProgressView!
    @IBOutlet weak var lblSteps: UILabel!
    @IBOutlet weak var txtFldFindLocation: FloatingLabelInput!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var addressLine1TextField: FloatingLabelInput!
    @IBOutlet weak var addressLine2TextField: FloatingLabelInput!
    @IBOutlet weak var cityTextField: FloatingLabelInput!
    @IBOutlet weak var stateTextField: FloatingLabelInput!
    @IBOutlet weak var zipcodeTextField: FloatingLabelInput!
    @IBOutlet weak var nextButton: UIButton!
    
    var createAccountModel = CreateAccountModel()
    var createAccountLicenseModel = CreateAccountLicenseModel()
    let locationManager = CLLocationManager()
    let viewModel: CreateAccountTACVM = CreateAccountTACVM()

    var isUpdateLocation = true
    var isFromEdit = false
    var isUserImageChangedFromEdit = false
    var isDocumentChangedFromEdit = false
    var userImageNotChangedStringFromEdit = ""
    var addressLine1 = ""
    var city = ""
    var state = ""
    
    var longitude = ""
    var latitude = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.zipcodeTextField.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.cityTextField.isUserInteractionEnabled = false
        self.stateTextField.isUserInteractionEnabled = false
        txtFldFindLocation.delegate = self
        
        nextButton.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 16.0)
        previousButton.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 16.0)
        txtFldFindLocation.isUserInteractionEnabled = false
        previousButton.layer.borderColor = (UIColor( red: 78/255, green: 199/255, blue:41/255, alpha: 1.0 )).cgColor
        previousButton.layer.borderWidth = 1.5
        txtFldFindLocation.setLeftPadding(14)
        addressLine1TextField.setLeftPadding(14)
        addressLine2TextField.setLeftPadding(14)
        cityTextField.setLeftPadding(14)
        stateTextField.setLeftPadding(14)
        zipcodeTextField.setLeftPadding(14)
//        cityTextField.setRightPaddingIcon(icon: UIImage(named: "ic_dropdown")!)
//        stateTextField.setRightPaddingIcon(icon: UIImage(named: "ic_dropdown")!)
//        txtFldFindLocation.setRightPaddingIconLocation(icon: UIImage(named: "ic_find_location")!)
        addressLine1TextField.layer.borderColor = UIColor.lightGray.cgColor
        addressLine2TextField.layer.borderColor = UIColor.lightGray.cgColor
        cityTextField.layer.borderColor = UIColor.lightGray.cgColor
        stateTextField.layer.borderColor = UIColor.lightGray.cgColor
        zipcodeTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        if isFromEdit == true {
            if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
//                self.addressLine1TextField.text = obj.addressLine1
//                self.addressLine2TextField.text = obj.addressLine2
//                self.cityTextField.text = obj.city
//                self.stateTextField.text = obj.state
//                self.zipcodeTextField.text = obj.zipCode
                
//                self.addressLine1TextField.resetFloatingLable()
//                self.addressLine2TextField.resetFloatingLable()
//                self.cityTextField.resetFloatingLable()
//                self.stateTextField.resetFloatingLable()
//                self.zipcodeTextField.resetFloatingLable()
                self.setlocation(userId: obj.id ?? 0)
                
            }
        }
    }
    
    // MARK: TextField delegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if textField == zipcodeTextField {
            let currentText = zipcodeTextField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else {
                return false
            }
            let updateText = currentText.replacingCharacters(in: stringRange, with: string)
            return updateText.count < 11
        }
        return true
    }
    
    func setlocation(userId:Int) {
        viewModel.getUserProfileApi(params: ["id":userId]) { model in
            
            self.longitude = model?.data?.longitude ?? "0.0"
            self.latitude = model?.data?.latitude ?? "0.0"
            
            self.addressLine1TextField.text = model?.data?.addressLine1
            self.addressLine1TextField.resetFloatingLable()

            self.addressLine2TextField.text = model?.data?.addressLine2
            self.addressLine2TextField.resetFloatingLable()

            self.cityTextField.text = model?.data?.city
            self.cityTextField.resetFloatingLable()

            self.stateTextField.text = model?.data?.state
            self.stateTextField.resetFloatingLable()

            self.zipcodeTextField.text = model?.data?.zipCode
            self.zipcodeTextField.resetFloatingLable()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let obj = UserDefaults.standard.retrieve(object: signupDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
            if obj.userType == UserType.homeOwner {
                self.nextButton.setTitle("Let's Go", for: .normal)
                self.vwProgress.progress = 1.0
                self.lblSteps.text = "Step 2/2"
            }
        } else if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
            if obj.userType == UserType.homeOwner {
                self.nextButton.setTitle("Let's Go", for: .normal)
                self.vwProgress.progress = 1.0
                self.lblSteps.text = "Step 2/2"
            }
        }
    }
    
    @IBAction func actinFindLocation(_ sender: Any) {
        
        let destinationViewController = (Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController)
        destinationViewController?.btnTapAction3 = {
            () in
            
            self.addressLine1TextField.text = destinationViewController?.addressLine1
            self.addressLine1TextField.resetFloatingLable()
            
            self.addressLine2TextField.text = destinationViewController?.addressLine2
            self.addressLine2TextField.resetFloatingLable()
            
//            self.city = destinationViewController?.city ?? ""
            self.cityTextField.text = destinationViewController?.city ?? ""
            self.cityTextField.resetFloatingLable()
            
//            self.state = destinationViewController?.state ?? ""
            self.stateTextField.text = destinationViewController?.state ?? ""
            self.stateTextField.resetFloatingLable()
            
            self.zipcodeTextField.text = destinationViewController?.zipcode
//            self.zipcodeTextField.text?.trimmed ?? ""
            self.zipcodeTextField.resetFloatingLable()
            
            self.longitude = ""
            self.latitude = ""
            self.longitude = "\(destinationViewController?.lng ?? Double(0.0))"
            self.latitude = "\(destinationViewController?.lat ?? Double(0.0))"
        }
        self.navigationController?.present(destinationViewController!, animated: true)
    }
    
    @IBAction func tapDidPreviousButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- CREATE PROFILE
    func createProfile() {
        let findLocation = txtFldFindLocation.text?.trimmed ?? ""
        let street = addressLine1TextField.text?.trimmed ?? ""
        let street2 = addressLine2TextField.text?.trimmed ?? ""
        let city = cityTextField.text?.trimmed ?? ""
        let state = stateTextField.text?.trimmed ?? ""
        let zipcodde = zipcodeTextField.text?.trimmed ?? ""
        var params = [String : Any]()
        var userFilesArray = [[String : Any]]()
        let createAccountLocationModel = CreateAccountLocationModel(findLocation: findLocation, addressLine1: street , addressLine2: street2, city: city, state: state, zipcode: zipcodde)
        if let obj = UserDefaults.standard.retrieve(object: signupDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
            if obj.userType == UserType.homeOwner {
                params = [    "firstName": createAccountModel.firstName ,
                              "lastName": createAccountModel.lastName,
                              "phoneNumber": createAccountModel.phoneNumber ,
                              "addressLine1": createAccountLocationModel.addressLine1,
//                              "addressLine2": createAccountLocationModel.addressLine2,
                              "city": createAccountLocationModel.city ,
                              "state": createAccountLocationModel.state ,
                              "zipCode": createAccountLocationModel.zipcode,
                              "longitude": self.longitude,
                              "latitude": self.latitude
                         ] as [String : Any]
            } else {
                
                if createAccountLicenseModel.licenseSelectedName != nil {
                    for i in 0..<(createAccountLicenseModel.licenseSelectedName?.count ?? 0) {
                        var dictss = [String: Any]()
                        dictss["name"] = createAccountLicenseModel.licenseSelectedName?[i]
                        dictss["image"] = createAccountLicenseModel.licenseSelectedImage?[i]
                        userFilesArray.append(dictss as [String: Any])
                    }
//                    let dict = ["name":createAccountLicenseModel.licenseSelectedName, "image":createAccountLicenseModel.licenseSelectedImage] as [String : Any]
//                    userFilesArray.removeAll()
//                    userFilesArray.append(dict)
                    
                } else {
                    userFilesArray = []
                }
                var skillArr = [[String:Any]]()
                skillArr.removeAll()
                for i in 0 ..< createAccountModel.skillSet.count {
                    let dict = ["skillId": Int(createAccountModel.skillSet[i])]
                    skillArr.append(dict as [String : Any])
                }
                params = [    "firstName": createAccountModel.firstName ,
                              "lastName": createAccountModel.lastName,
                              "phoneNumber": createAccountModel.phoneNumber ,
                              "addressLine1": createAccountLocationModel.addressLine1,
//                              "addressLine2": createAccountLocationModel.addressLine2,
                              "licenceNumber": createAccountLicenseModel.licenseNumber ,
                              "skills": skillArr.toJSONString(),
                              "city": createAccountLocationModel.city ,
                              "state": createAccountLocationModel.state ,
                              "zipCode": createAccountLocationModel.zipcode,
                              "userFiles": userFilesArray.toJSONString(),
                              "longitude": self.longitude,
                              "latitude": self.latitude
                         ] as [String : Any]
            }
        } else if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
            if obj.userType == UserType.homeOwner {
                params = [    "firstName": createAccountModel.firstName ,
                              "lastName": createAccountModel.lastName,
                              "phoneNumber": createAccountModel.phoneNumber ,
                              "addressLine1": createAccountLocationModel.addressLine1,
                              "addressLine2": createAccountLocationModel.addressLine2,
                              "city": createAccountLocationModel.city ,
                              "state": createAccountLocationModel.state ,
                              "zipCode": createAccountLocationModel.zipcode,
                              "longitude": self.longitude,
                              "latitude": self.latitude
                         ] as [String : Any]
            } else {
                
                if createAccountLicenseModel.licenseSelectedName != nil {
                    for i in 0..<(createAccountLicenseModel.licenseSelectedName?.count ?? 0) {
                        var dictss = [String: Any]()
                        dictss["name"] = createAccountLicenseModel.licenseSelectedName?[i]
                        dictss["image"] = createAccountLicenseModel.licenseSelectedImage?[i]
                        userFilesArray.append(dictss as [String: Any])
                    }
//                    let dict = ["name":createAccountLicenseModel.licenseSelectedName, "image":createAccountLicenseModel.licenseSelectedImage] as [String : Any]
//                    userFilesArray.removeAll()
//                    userFilesArray.append(dict)
                    
                } else {
                    userFilesArray = []
                }
                var skillArr = [[String:Any]]()
                skillArr.removeAll()
                for i in 0 ..< createAccountModel.skillSet.count {
                    let dict = ["skillId": Int(createAccountModel.skillSet[i])]
                    skillArr.append(dict as [String : Any])
                }
                params = [    "firstName": createAccountModel.firstName ,
                              "lastName": createAccountModel.lastName,
                              "phoneNumber": createAccountModel.phoneNumber ,
                              "addressLine1": createAccountLocationModel.addressLine1,
                              "addressLine2": createAccountLocationModel.addressLine2,
                              "licenceNumber": createAccountLicenseModel.licenseNumber ,
                              "skills": skillArr.toJSONString(),
                              "city": createAccountLocationModel.city ,
                              "state": createAccountLocationModel.state ,
                              "zipCode": createAccountLocationModel.zipcode,
                              "userFiles": userFilesArray.toJSONString(),
                              "longitude": self.longitude,
                              "latitude": self.latitude
                         ] as [String : Any]
            }
        }
        
        if self.isFromEdit == false {
            if let obj = UserDefaults.standard.retrieve(object: signupDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
                if obj.userType == UserType.homeOwner {
                    if self.createAccountModel.isImageSelected == true {
                        let imageData = self.createAccountModel.userImage.jpegData(compressionQuality: 0.8)
                        viewModel.createProfileApi(keyToUploadData: "image", fileNames: createAccountModel.userImageName, dataToUpload: imageData!, param: params) { response in
                            TA_Storage.shared.iskProfileCreated = true
                            if let obj = UserDefaults.standard.retrieve(object: signupDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                                self.fetchUserProfileData(userId: obj.id ?? 0)
                            }
                        }
                    } else {
                        
                        let param = [ "firstName": createAccountModel.firstName ,
                                      "lastName": createAccountModel.lastName,
                                      "phoneNumber": createAccountModel.phoneNumber ,
                                      "addressLine1": createAccountLocationModel.addressLine1,
                                      "addressLine2": createAccountLocationModel.addressLine2,
                                      "licenceNumber": createAccountLicenseModel.licenseNumber ,
                                      //"skills": createAccountModel.skillSet,
                                      "city": createAccountLocationModel.city ,
                                      "state": createAccountLocationModel.state ,
                                      "zipCode": createAccountLocationModel.zipcode,
                                      "userFiles": userFilesArray.toJSONString(),
                                      "image": "",
                                      "longitude": self.longitude,
                                      "latitude": self.latitude
                                 ] as [String : Any]
                        let imageData = Data()
                        viewModel.createProfileApiWithoutImage(keyToUploadData: "image", fileNames: createAccountModel.userImageName, dataToUpload: imageData, param: param) { response in
                            TA_Storage.shared.iskProfileCreated = true
                            if let obj = UserDefaults.standard.retrieve(object: signupDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                                self.fetchUserProfileData(userId: obj.id ?? 0)
                            }
                        }
                    }
                } else {
                    let imageData = self.createAccountModel.userImage.jpegData(compressionQuality: 0.8)
                    viewModel.createProfileApi(keyToUploadData: "image", fileNames: createAccountModel.userImageName, dataToUpload: imageData!, param: params) { response in
                        TA_Storage.shared.iskProfileCreated = true
                        if let obj = UserDefaults.standard.retrieve(object: signupDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                            self.fetchUserProfileData(userId: obj.id ?? 0)
                        }
                    }
                }
            } else if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
                if obj.userType == UserType.homeOwner {
                    if self.createAccountModel.isImageSelected == true {
                        let imageData = self.createAccountModel.userImage.jpegData(compressionQuality: 0.8)
                        viewModel.createProfileApi(keyToUploadData: "image", fileNames: createAccountModel.userImageName, dataToUpload: imageData!, param: params) { response in
                            TA_Storage.shared.iskProfileCreated = true
                            if let obj = UserDefaults.standard.retrieve(object: signupDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                                self.fetchUserProfileData(userId: obj.id ?? 0)
                            } else if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                                self.fetchUserProfileData(userId: obj.id ?? 0)
                            }
                        }
                    } else {
                        
                        let param = [ "firstName": createAccountModel.firstName ,
                                      "lastName": createAccountModel.lastName,
                                      "phoneNumber": createAccountModel.phoneNumber ,
                                      "addressLine1": createAccountLocationModel.addressLine1,
                                      "addressLine2": createAccountLocationModel.addressLine2,
                                      "licenceNumber": createAccountLicenseModel.licenseNumber ,
                                      //"skills": createAccountModel.skillSet,
                                      "city": createAccountLocationModel.city ,
                                      "state": createAccountLocationModel.state ,
                                      "zipCode": createAccountLocationModel.zipcode,
                                      "userFiles": userFilesArray.toJSONString(),
                                      "image": "",
                                      "longitude": self.longitude,
                                      "latitude": self.latitude
                                 ] as [String : Any]
                        let imageData = Data()
                        viewModel.createProfileApiWithoutImage(keyToUploadData: "image", fileNames: createAccountModel.userImageName, dataToUpload: imageData, param: param) { response in
                            TA_Storage.shared.iskProfileCreated = true
                            if let obj = UserDefaults.standard.retrieve(object: signupDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                                self.fetchUserProfileData(userId: obj.id ?? 0)
                            } else if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                                self.fetchUserProfileData(userId: obj.id ?? 0)
                            }
                        }
                    }
                } else {
                    let imageData = self.createAccountModel.userImage.jpegData(compressionQuality: 0.8)
                    viewModel.createProfileApi(keyToUploadData: "image", fileNames: createAccountModel.userImageName, dataToUpload: imageData!, param: params) { response in
                        TA_Storage.shared.iskProfileCreated = true
                        if let obj = UserDefaults.standard.retrieve(object: signupDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                            self.fetchUserProfileData(userId: obj.id ?? 0)
                        } else if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                            self.fetchUserProfileData(userId: obj.id ?? 0)
                        }
                    }
                }
            }
        } else {
            let imageData = self.createAccountModel.userImage.jpegData(compressionQuality: 0.8)
            viewModel.createProfileApi(keyToUploadData: "image", fileNames: createAccountModel.userImageName, dataToUpload: imageData!, param: params) { response in
                TA_Storage.shared.iskProfileCreated = true
                if let obj = UserDefaults.standard.retrieve(object: signupDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                    self.fetchUserProfileData(userId: obj.id ?? 0)
                } else if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                    self.fetchUserProfileData(userId: obj.id ?? 0)
                }
            }
        }
    }
    
    // MARK:- UPDATE PROFILE
    func updateProfile() {
        let findLocation = txtFldFindLocation.text?.trimmed ?? ""
        let street = addressLine1TextField.text?.trimmed ?? ""
        let street2 = addressLine2TextField.text?.trimmed ?? ""
        let city = cityTextField.text?.trimmed ?? ""
        let state = stateTextField.text?.trimmed ?? ""
        let zipcodde = zipcodeTextField.text?.trimmed ?? ""
        var params = [String : Any]()
        let createAccountLocationModel = CreateAccountLocationModel(findLocation: findLocation, addressLine1: street , addressLine2: street2, city: city, state: state, zipcode: zipcodde)
        var userFilesArray = [[String : Any]]()
        
        if createAccountLicenseModel.licenseSelectedName != nil {
            for i in 0..<(createAccountLicenseModel.licenseSelectedName?.count ?? 0) {
                var dictss = [String: Any]()
                dictss["name"] = createAccountLicenseModel.licenseSelectedName?[i]
                dictss["image"] = createAccountLicenseModel.licenseSelectedImage?[i]
                userFilesArray.append(dictss as [String: Any])
            }
//            let dict = ["name":createAccountLicenseModel.licenseSelectedName,"image":createAccountLicenseModel.licenseSelectedImage] as [String : Any]
//            userFilesArray.removeAll()
//            userFilesArray.append(dict)
            
        } else {
            userFilesArray = []
        }
        var skillArr = [[String:Any]]()
        skillArr.removeAll()
        for i in 0 ..< createAccountModel.skillSet.count {
            let dict = ["skillId": Int(createAccountModel.skillSet[i])]
            skillArr.append(dict as [String : Any])
        }
        params = [    "firstName": createAccountModel.firstName ,
                        "lastName": createAccountModel.lastName,
                        "phoneNumber": createAccountModel.phoneNumber ,
                        "addressLine1": createAccountLocationModel.addressLine1,
                        "addressLine2": createAccountLocationModel.addressLine2,
                        "licenceNumber": createAccountLicenseModel.licenseNumber ,
                      "skills": skillArr.toJSONString(),
                        "city": createAccountLocationModel.city ,
                        "state": createAccountLocationModel.state ,
                        "zipCode": createAccountLocationModel.zipcode,
                        "userFiles": userFilesArray.toJSONString(),
                        "longitude": self.longitude,
                        "latitude": self.latitude
                    ] as [String : Any]
        
        let imageData = self.createAccountModel.userImage.jpegData(compressionQuality: 0.8)
        viewModel.updateProfileApi(keyToUploadData: "image", fileNames: createAccountModel.userImageName, dataToUpload: imageData!, param: params) { response in
            if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                self.fetchUserProfileData(userId: obj.id ?? 0)
            }
        }
    }
    
    // MARK:- UPDATE PROFILE
    func updateProfileImageAPI() {
        let findLocation = txtFldFindLocation.text?.trimmed ?? ""
        let street = addressLine1TextField.text?.trimmed ?? ""
        let street2 = addressLine2TextField.text?.trimmed ?? ""
        let city = cityTextField.text?.trimmed ?? ""
        let state = stateTextField.text?.trimmed ?? ""
        let zipcodde = zipcodeTextField.text?.trimmed ?? ""
        var params = [String : Any]()
        let createAccountLocationModel = CreateAccountLocationModel(findLocation: findLocation, addressLine1: street , addressLine2: street2, city: city, state: state, zipcode: zipcodde)
        var skillArr = [[String:Any]]()
        skillArr.removeAll()
        for i in 0 ..< createAccountModel.skillSet.count {
            let dict = ["skillId": Int(createAccountModel.skillSet[i])]
            skillArr.append(dict as [String : Any])
        }
        params = [    "firstName": createAccountModel.firstName ,
                        "lastName": createAccountModel.lastName,
                        "phoneNumber": createAccountModel.phoneNumber ,
                        "addressLine1": createAccountLocationModel.addressLine1,
                        "addressLine2": createAccountLocationModel.addressLine2,
                        "licenceNumber": createAccountLicenseModel.licenseNumber ,
                      "skills": skillArr.toJSONString(),
                        "city": createAccountLocationModel.city ,
                        "state": createAccountLocationModel.state ,
                        "zipCode": createAccountLocationModel.zipcode,
                        "userFiles":[],
                        "longitude": self.longitude,
                        "latitude": self.latitude
                    ] as [String : Any]
        
        let imageData = self.createAccountModel.userImage.jpegData(compressionQuality: 0.8)
        viewModel.updateProfileApi(keyToUploadData: "image", fileNames: createAccountModel.userImageName, dataToUpload: imageData!, param: params) { response in
            if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                self.fetchUserProfileData(userId: obj.id ?? 0)
            }
        }
    }
    
    func updateDocumentProfile() {
        let findLocation = txtFldFindLocation.text?.trimmed ?? ""
        let street = addressLine1TextField.text?.trimmed ?? ""
        let street2 = addressLine2TextField.text?.trimmed ?? ""
        let city = cityTextField.text?.trimmed ?? ""
        let state = stateTextField.text?.trimmed ?? ""
        let zipcodde = zipcodeTextField.text?.trimmed ?? ""
        var params = [String : Any]()
        let createAccountLocationModel = CreateAccountLocationModel(findLocation: findLocation, addressLine1: street , addressLine2: street2, city: city, state: state, zipcode: zipcodde)
        var userFilesArray = [[String : Any]]()
        if createAccountLicenseModel.licenseSelectedName != nil {
            for i in 0..<(createAccountLicenseModel.licenseSelectedName?.count ?? 0) {
                var dictss = [String: Any]()
                dictss["name"] = createAccountLicenseModel.licenseSelectedName?[i]
                dictss["image"] = createAccountLicenseModel.licenseSelectedImage?[i]
                userFilesArray.append(dictss as [String: Any])
            }
//            let dict = ["name":createAccountLicenseModel.licenseSelectedName,"image":createAccountLicenseModel.licenseSelectedImage] as [String : Any]
//            userFilesArray.removeAll()
//            userFilesArray.append(dict)
            
        } else {
            userFilesArray = []
        }
        var skillArr = [[String:Any]]()
        skillArr.removeAll()
        for i in 0 ..< createAccountModel.skillSet.count {
            let dict = ["skillId": Int(createAccountModel.skillSet[i])]
            skillArr.append(dict as [String : Any])
        }
        params = [    "firstName": createAccountModel.firstName ,
                        "lastName": createAccountModel.lastName,
                        "phoneNumber": createAccountModel.phoneNumber ,
                        "addressLine1": createAccountLocationModel.addressLine1,
                        "addressLine2": createAccountLocationModel.addressLine2,
                        "licenceNumber": createAccountLicenseModel.licenseNumber ,
                      "skills": skillArr.toJSONString(),
                        "city": createAccountLocationModel.city ,
                        "state": createAccountLocationModel.state ,
                        "zipCode": createAccountLocationModel.zipcode,
                        "userFiles": userFilesArray.toJSONString(),
                        "image": userImageNotChangedStringFromEdit,
                        "longitude": self.longitude,
                        "latitude": self.latitude
                    ] as [String : Any]
        
        viewModel.updateProfileApiWithoutImage(keyToUploadData: "", fileNames: "", dataToUpload: Data(), param: params) { response in
            if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                self.fetchUserProfileData(userId: obj.id ?? 0)
            }
        }
    }
    
    func updateProfileContent() {
        let findLocation = txtFldFindLocation.text?.trimmed ?? ""
        let street = addressLine1TextField.text?.trimmed ?? ""
        let street2 = addressLine2TextField.text?.trimmed ?? ""
        let city = cityTextField.text?.trimmed ?? ""
        let state = stateTextField.text?.trimmed ?? ""
        let zipcodde = zipcodeTextField.text?.trimmed ?? ""
        var params = [String : Any]()
        let createAccountLocationModel = CreateAccountLocationModel(findLocation: findLocation, addressLine1: street , addressLine2: street2, city: city, state: state, zipcode: zipcodde)
        var skillArr = [[String:Any]]()
        skillArr.removeAll()
        for i in 0 ..< createAccountModel.skillSet.count {
            let dict = ["skillId": Int(createAccountModel.skillSet[i])]
            skillArr.append(dict as [String : Any])
        }
        params = [    "firstName": createAccountModel.firstName ,
                        "lastName": createAccountModel.lastName,
                        "phoneNumber": createAccountModel.phoneNumber ,
                        "addressLine1": createAccountLocationModel.addressLine1,
                        "addressLine2": createAccountLocationModel.addressLine2,
                        "licenceNumber": createAccountLicenseModel.licenseNumber ,
                      "skills": skillArr.toJSONString(),
                        "city": createAccountLocationModel.city ,
                        "state": createAccountLocationModel.state ,
                        "zipCode": createAccountLocationModel.zipcode,
                        "userFiles":[],
                        "image": userImageNotChangedStringFromEdit,
                        "longitude": self.longitude,
                        "latitude": self.latitude
                    ] as [String : Any]
        
        viewModel.updateProfileApiWithoutImage(keyToUploadData: "", fileNames: "", dataToUpload: Data(), param: params) { response in
            if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                self.fetchUserProfileData(userId: obj.id ?? 0)
            }
        }
    }
    
    @IBAction func tapDidNextButtonAction(_ sender: UIButton) {
        let findLocation = txtFldFindLocation.text?.trimmed ?? ""
        let street = addressLine1TextField.text?.trimmed ?? ""
        let street2 = addressLine2TextField.text?.trimmed ?? ""
        let city = cityTextField.text?.trimmed ?? ""
        let state = stateTextField.text?.trimmed ?? ""
        let zipcodde = zipcodeTextField.text?.trimmed ?? ""
        let createAccountLocationModel = CreateAccountLocationModel(findLocation: findLocation, addressLine1: street , addressLine2: street2, city: city, state: state, zipcode: zipcodde)
        viewModel.modelLocation = createAccountLocationModel
        viewModel.validateLocationModel {[weak self] (success, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                if let model = success {
                    print("model: ", model)
                    if isFromEdit ==  true {
                        if self?.isDocumentChangedFromEdit == true && self?.isUserImageChangedFromEdit == true {
                            self?.updateProfile()
                        } else if self?.isDocumentChangedFromEdit == true && self?.isUserImageChangedFromEdit == false {
                            self?.updateDocumentProfile()
                        } else if self?.isDocumentChangedFromEdit == false && self?.isUserImageChangedFromEdit == true {
                            self?.updateProfileImageAPI()
                        } else if self?.isDocumentChangedFromEdit == false && self?.isUserImageChangedFromEdit == false {
                            self?.updateProfileContent()
                        }
                    } else {
//                        let address = "\(street), \(city)"
//                        let geoCoder = CLGeocoder()
//                        var zipcode = ""
//                        geoCoder.geocodeAddressString(address) { (placemarks, error) in
//                            guard
//                                let placemarks = placemarks,
//                                let placemark = placemarks.first
//                            else {
//                                // handle no location found
//
//                                return
//                            }
//
//                            // Use your location
//                            zipcode = "\(placemarks.first?.postalCode ?? "")"
//                            if zipcodde == zipcode{
//                                self!.createProfile()
//                            }else{
//                                showMessage(with: ValidationError.validZipcode, theme: .error)
//                            }
//
//                        }
//                        showMessage(with: ValidationError.validZipcode, theme: .error)
                        self!.createProfile()
                    }
                }
            }
            else {
                if let errorMsg = strongSelf.viewModel.error {
                    showMessage(with: errorMsg)
                }
            }
        }
    }
    
    func fetchUserProfileData(userId:Int) {
        viewModel.getUserProfileApi(params: ["id":userId]) { model in
            
            self.longitude = model?.data?.longitude ?? "0.0"
            self.latitude = model?.data?.latitude ?? "0.0"
            
            self.addressLine1TextField.text = model?.data?.addressLine1
            self.addressLine1TextField.resetFloatingLable()

            self.addressLine2TextField.text = model?.data?.addressLine2
            self.addressLine2TextField.resetFloatingLable()

            self.cityTextField.text = model?.data?.city
            self.cityTextField.resetFloatingLable()

            self.stateTextField.text = model?.data?.state
            self.stateTextField.resetFloatingLable()

            self.zipcodeTextField.text = model?.data?.zipCode
            self.zipcodeTextField.resetFloatingLable()
            
            UserDefaults.standard.save(customObject: model?.data, inKey:TA_Storage.TA_Storage_Constants.kPersonalDetailsData)
            if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData){
                if obj.userType == UserType.homeOwner {
                    self.changeRootController(storyboadrId: "TabBarHO", bundle: nil, controllerId: "TabBarHOVC")
                } else {
                    let vc = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "AddBankAccountVC") as? AddBankAccountVC
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
        }
    }
}

extension SetLocationVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if isUpdateLocation == true {
            let userLocation :CLLocation = locations[0] as CLLocation
            print("user latitude = \(userLocation.coordinate.latitude)")
            print("user longitude = \(userLocation.coordinate.longitude)")
            self.longitude = "\(userLocation.coordinate.longitude)"
            self.latitude = "\(userLocation.coordinate.latitude)"
            var latss = Double(latitude) ?? 0.0
            var longss = Double(longitude) ?? 0.0
            let geocoder = CLGeocoder()
            self.isUpdateLocation = false
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
    //                    self.addressLine1TextField.text = placemark.subLocality!
    //                    self.addressLine1TextField.resetFloatingLable()
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
            
            self.getAddressFromLatLong(latitude: latss, longitude: longss)
        } else {
            print("Search Location")
        }
        
    }
    
    func getAddressFromLatLong(latitude: Double, longitude : Double) {
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=AIzaSyA7TOKIXqW2q4yrJlWwmj1-chcx6x0vv10"
        
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:

                if let responseJson = response.value as? NSDictionary {
                    if let results = responseJson.object(forKey: "results") as? [NSDictionary] {
                        if results.count > 0 {
                            if let addressComponents = results[0]["address_components"] as? [NSDictionary] {
                                self.addressLine1TextField.text = results[0]["formatted_address"] as? String ?? ""
                                self.addressLine1TextField.resetFloatingLable()
                                for component in addressComponents {
                                    if let temp = component.object(forKey: "types") as? [String] {
                                        if (temp[0] == "postal_code") {
                                            self.zipcodeTextField.text = component["long_name"] as? String ?? ""
                                            self.zipcodeTextField.resetFloatingLable()
                                        }
                                        if (temp[0] == "locality") {
                                            self.cityTextField.text = component["long_name"] as? String ?? ""
                                            self.cityTextField.resetFloatingLable()
                                        }
                                        if (temp[0] == "administrative_area_level_1") {
                                            self.stateTextField.text = component["long_name"] as? String ?? ""
                                            self.stateTextField.resetFloatingLable()
                                        }
                                        if (temp[0] == "country") {
//                                            country = component["long_name"] as? String
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
}
 
