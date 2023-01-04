//
//  CreateAccountTACVM.swift
//  TA
//
//  Created by Designer on 07/12/21.
//

import Foundation
import UIKit
import CoreLocation

class CreateAccountTACVM: NSObject {

    var model: CreateAccountModel = CreateAccountModel()
    var modelLicense: CreateAccountLicenseModel = CreateAccountLicenseModel()
    var modelLocation: CreateAccountLocationModel = CreateAccountLocationModel()
    var modelBankAccount: CreateAccountBankModel = CreateAccountBankModel()
    
    var error: String? = .none
    
    func validateCreateAccountModel(isFromEdit:Bool, completion: (_ success:CreateAccountModel?, _ error: String?) -> Void) {
        error = nil
        if isFromEdit == false {
            if let obj = UserDefaults.standard.retrieve(object: signupDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
                if obj.userType == UserType.homeOwner {
                    if model.firstName.isEmpty {
                        error = ValidationError.emptyFirstName
                        completion(nil, error)
                        return
                    } else if !model.firstName.isValidFirstName {
                        error = ValidationError.invalidFirstName
                        completion(nil, error)
                        return
                    } else if model.lastName.isEmpty {
                        error = ValidationError.emptyLastName
                        completion(nil, error)
                    } else if !model.lastName.isValidLastName {
                        error = ValidationError.invalidLastName
                        completion(nil, error)
                    } else if model.phoneNumber.isEmpty {
                        error = ValidationError.emptyPhoneNumber
                        completion(nil, error)
                        return
                    } else if !model.phoneNumber.isValidPhoneNumber {
                        error = ValidationError.invalidPhoneNumber
                        completion(nil, error)
                    } else if model.skillSet.count == 0 {
                        error = ValidationError.emptySkillSet
                        completion(nil, error)
                        return
                    } else {
                        completion(model, nil)
                    }
                } else {
                    if model.isImageSelected == false {
                        error = ValidationError.emptyProfileImage
                        completion(nil, error)
                        return
                    } else if model.firstName.isEmpty {
                        error = ValidationError.emptyFirstName
                        completion(nil, error)
                        return
                    } else if !model.firstName.isValidFirstName {
                        error = ValidationError.invalidFirstName
                        completion(nil, error)
                        return
                    } else if model.lastName.isEmpty {
                        error = ValidationError.emptyLastName
                        completion(nil, error)
                    } else if !model.lastName.isValidLastName {
                        error = ValidationError.invalidLastName
                        completion(nil, error)
                    } else if model.phoneNumber.isEmpty {
                        error = ValidationError.emptyPhoneNumber
                        completion(nil, error)
                        return
                    } else if !model.phoneNumber.isValidPhoneNumber {
                        error = ValidationError.invalidPhoneNumber
                        completion(nil, error)
                    } else if model.skillSet.count == 0 {
                        error = ValidationError.emptySkillSet
                        completion(nil, error)
                        return
                    } else {
                        completion(model, nil)
                    }
                }
            } else if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
                if obj.userType == UserType.homeOwner {
                    if model.firstName.isEmpty {
                        error = ValidationError.emptyFirstName
                        completion(nil, error)
                        return
                    } else if !model.firstName.isValidFirstName {
                        error = ValidationError.invalidFirstName
                        completion(nil, error)
                        return
                    } else if model.lastName.isEmpty {
                        error = ValidationError.emptyLastName
                        completion(nil, error)
                    } else if !model.lastName.isValidLastName {
                        error = ValidationError.invalidLastName
                        completion(nil, error)
                    } else if model.phoneNumber.isEmpty {
                        error = ValidationError.emptyPhoneNumber
                        completion(nil, error)
                        return
                    } else if !model.phoneNumber.isValidPhoneNumber {
                        error = ValidationError.invalidPhoneNumber
                        completion(nil, error)
                    } else if model.skillSet.count == 0 {
                        error = ValidationError.emptySkillSet
                        completion(nil, error)
                        return
                    } else {
                        completion(model, nil)
                    }
                } else {
                    if model.isImageSelected == false {
                        error = ValidationError.emptyProfileImage
                        completion(nil, error)
                        return
                    } else if model.firstName.isEmpty {
                        error = ValidationError.emptyFirstName
                        completion(nil, error)
                        return
                    } else if !model.firstName.isValidFirstName {
                        error = ValidationError.invalidFirstName
                        completion(nil, error)
                        return
                    } else if model.lastName.isEmpty {
                        error = ValidationError.emptyLastName
                        completion(nil, error)
                    } else if !model.lastName.isValidLastName {
                        error = ValidationError.invalidLastName
                        completion(nil, error)
                    } else if model.phoneNumber.isEmpty {
                        error = ValidationError.emptyPhoneNumber
                        completion(nil, error)
                        return
                    } else if !model.phoneNumber.isValidPhoneNumber {
                        error = ValidationError.invalidPhoneNumber
                        completion(nil, error)
                    } else if model.skillSet.count == 0 {
                        error = ValidationError.emptySkillSet
                        completion(nil, error)
                        return
                    } else {
                        completion(model, nil)
                    }
                }
            }
        } else {
            if model.isImageSelected == false {
                error = ValidationError.emptyProfileImage
                completion(nil, error)
                return
            } else if model.firstName.isEmpty {
                error = ValidationError.emptyFirstName
                completion(nil, error)
                return
            } else if !model.firstName.isValidFirstName {
                error = ValidationError.invalidFirstName
                completion(nil, error)
                return
            } else if model.lastName.isEmpty {
                error = ValidationError.emptyLastName
                completion(nil, error)
            } else if !model.lastName.isValidLastName {
                error = ValidationError.invalidLastName
                completion(nil, error)
            } else if model.phoneNumber.isEmpty {
                error = ValidationError.emptyPhoneNumber
                completion(nil, error)
                return
            } else if !model.phoneNumber.isValidPhoneNumber {
                error = ValidationError.invalidPhoneNumber
                completion(nil, error)
            } else if model.skillSet.count == 0 {
                error = ValidationError.emptySkillSet
                completion(nil, error)
                return
            } else {
                completion(model, nil)
            }
        }
    }
    
    func validateLicenseModel(completion: (_ success:CreateAccountLicenseModel?, _ error: String?) -> Void) {
        error = nil
        if modelLicense.licenseNumber.isEmpty {
            error = ValidationError.emptyLicenseNumber
            completion(nil, error)
            return
        } else if modelLicense.licenseNumber.isValidLicence {
            error = ValidationError.invalidLicence
            completion(nil, error)
            return
        } else if !modelLicense.islicenseImageSelected {
            error = ValidationError.licenseDoc
            completion(nil, error)
            return
        } else {
            completion(modelLicense, nil)
        }
    }
    
    func validateLocationModel(completion: (_ success:CreateAccountLocationModel?, _ error: String?) -> Void) {
        
            self.error = nil
            if self.modelLocation.addressLine1.isEmpty {
                self.error = ValidationError.emptyAddress
                completion(nil, self.error)
                return
            } else if self.modelLocation.city.isEmpty {
                self.error = ValidationError.emptyCity
                completion(nil, self.error)
                return
            } else if self.modelLocation.state.isEmpty {
                self.error = ValidationError.emptyFindLocation
                completion(nil, self.error)
                return
            } else if self.modelLocation.zipcode.isEmpty {
                self.error = ValidationError.emptyZipcode
                completion(nil, self.error)
                return
            } else {
                completion(self.modelLocation, nil)
            }
    }
    
    func validateBankAccountModel(completion: (_ success:CreateAccountBankModel?, _ error: String?) -> Void) {
        error = nil
        if modelBankAccount.accountNumber.isEmpty {
            error = ValidationError.emptyAccountNumber
            completion(nil, error)
            return
        } else if !modelBankAccount.accountNumber.isValidAccountNumberr {
            error = ValidationError.invalidAccountNumber
            completion(nil, error)
        } else if modelBankAccount.routing.isEmpty {
            error = ValidationError.emptyRouting
            completion(nil, error)
            return
        } else if !modelBankAccount.routing.isValidRouting {
            error = ValidationError.invalidRouting
            completion(nil, error)
        } else if !modelBankAccount.ssn.isEmpty {
            if !modelBankAccount.ssn.isValidSSN {
                error = ValidationError.invalidSSN
                completion(nil, error)
            } else {
                completion(modelBankAccount, nil)
            }
        } else if modelBankAccount.bankName.isEmpty {
                error = ValidationError.emptyBankName
                completion(nil, error)
                return
        } else {
            completion(modelBankAccount, nil)
        }
    }
    
    func getSkillListApiCall(_ result:@escaping(SkillsResponseModel?) -> Void){
        Progress.instance.show()
        ApiManager<SkillsResponseModel>.makeApiCall(APIUrl.UserApis.projectCategoriesList, params: [:], headers: nil, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func addLicenseApi(localFileUrl:URL,  keyToUploadData:String, fileNames:String, _ result:@escaping([String : Any]?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
           ApiManager<SignupResponseModel>.multipartRequest(APIUrl.UserApis.fileUpload, localFileUrl: localFileUrl, keyToUploadData:keyToUploadData, fileNames: fileNames, headers: headers) { (response) in
                 Progress.instance.hide()
                 print(response!)
                 if response?["statusCode"] as! Int == 200{
                     result(response)
                 }else{
                 showMessage(with: response?["message"] as? String ?? "")
             }
        }
    }
    
    func addImageLicenseApi(keyToUploadData:String,fileNames:String, dataToUpload:Data, param:[String:Any], _ result:@escaping([String : Any]?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<SignupResponseModel>.multipartRequestSinglePost(APIUrl.UserApis.fileUpload, params: param, dataToUpload: dataToUpload, keyToUploadData: keyToUploadData, fileNames: fileNames, headers: headers) { (response) in
                Progress.instance.hide()
                print(response!)
                if response?["statusCode"] as! Int == 200{
                    result(response)
                }else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func createProfileApi(keyToUploadData:String,fileNames:String, dataToUpload:Data, param:[String:Any], _ result:@escaping([String : Any]?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<SignupResponseModel>.multipartRequestSingle(APIUrl.UserApis.createProfile, params: param, dataToUpload: dataToUpload, keyToUploadData: keyToUploadData, fileNames: fileNames, headers: headers) { (response) in
                Progress.instance.hide()
                print(response!)
                if response?["statusCode"] as! Int == 200{
                    result(["message": response?["message"] as! String])
                }else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func createProfileApiWithoutImage(keyToUploadData:String,fileNames:String, dataToUpload:Data, param:[String:Any], _ result:@escaping([String : Any]?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<SignupResponseModel>.multipartRequestSingleWithoutImage(APIUrl.UserApis.createProfile, params: param, dataToUpload: dataToUpload, keyToUploadData: keyToUploadData, fileNames: fileNames, headers: headers) { (response) in
                Progress.instance.hide()
                print(response!)
                if response?["statusCode"] as! Int == 200{
                    result(["message": response?["message"] as! String])
                }else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func updateProfileApi(keyToUploadData:String,fileNames:String, dataToUpload:Data, param:[String:Any], _ result:@escaping([String : Any]?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<SignupResponseModel>.multipartRequestSingle(APIUrl.UserApis.updateProfile, params: param, dataToUpload: dataToUpload, keyToUploadData: keyToUploadData, fileNames: fileNames, headers: headers) { (response) in
                Progress.instance.hide()
                print(response!)
                if response?["statusCode"] as! Int == 200{
                    result(["message": response?["message"] as! String])
                }else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func updateProfileApiWithoutImage(keyToUploadData:String,fileNames:String, dataToUpload:Data, param:[String:Any], _ result:@escaping([String : Any]?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<SignupResponseModel>.multipartRequestSingleWithoutImage(APIUrl.UserApis.updateProfile, params: param, dataToUpload: dataToUpload, keyToUploadData: keyToUploadData, fileNames: fileNames, headers: headers) { (response) in
                Progress.instance.hide()
                print(response!)
                if response?["statusCode"] as! Int == 200{
                    result(["message": response?["message"] as! String])
                }else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getUserProfileApi(params:[String:Any], _ result:@escaping(UserProfileResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<UserProfileResponseModel>.makeApiCall(APIUrl.UserApis.user, params: params, headers: headers, method: .get) { (response, model) in
            Progress.instance.hide()
            print(response)
            if model?.statusCode == 200{
                result(model)
            }else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func addBankAccountApi(_ params :[String:Any],_ result:@escaping(AddBankAccountResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<AddBankAccountResponseModel>.makeApiCall(APIUrl.UserApis.addBankAccount, params: params, headers: headers, method: .post) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }

    func getankAccountApi(_ bankId :Int,_ result:@escaping(GetBankAccountResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<GetBankAccountResponseModel>.makeApiCall("\(APIUrl.UserApis.getBankAccount)/\(bankId)", params: [:], headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func updateBankAccountApi(_ params :[String:Any],_ result:@escaping(AddBankAccountResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<AddBankAccountResponseModel>.makeApiCall(APIUrl.UserApis.updateBankAccount, params: params, headers: headers, method: .put) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func checkPhoneNumber(_ params :[String:Any], _ result:@escaping() -> Void) {
        Progress.instance.show()
        
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<VerifyUser>.makeApiCall(APIUrl.UserApis.checkPhoneNumber, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result()
            } else {
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
}
