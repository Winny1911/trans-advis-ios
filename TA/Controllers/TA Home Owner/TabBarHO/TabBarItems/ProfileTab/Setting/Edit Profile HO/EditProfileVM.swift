//
//  EditProfileVM.swift
//  TA
//
//  Created by Designer on 03/01/22.
//

import UIKit

class EditProfileVM: NSObject {
    
    var model: EditModel = EditModel()
    
    var error: String? = .none
    
    func validateEditProfileModel(isFromEdit:Bool, completion: (_ success:EditModel?, _ error: String?) -> Void) {
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
                    } else {
                        completion(model, nil)
                    }
                } else {
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
                    } else if model.street.isEmpty {
                        error = ValidationError.emptyAddress
                        completion(nil, error)
                        return
                    }else if model.city.isEmpty {
                        error = ValidationError.emptyCity
                        completion(nil, error)
                        return
                    }else if model.state.isEmpty {
                        error = ValidationError.emptyState
                        completion(nil, error)
                        return
                    }else if model.zipCode.isEmpty {
                        error = ValidationError.emptyZipcodes
                        completion(nil, error)
                        return
                    }else if model.licenceNumber.isEmpty {
                        error = ValidationError.emptyLicenseNumber
                        completion(nil, error)
                        return
                    }else {
                        completion(model, nil)
                    }
                }
            }
        } else {
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
            }
            else if model.phoneNumber.isEmpty {
                error = ValidationError.emptyPhoneNumber
                completion(nil, error)
            } else if !model.phoneNumber.isValidPhoneNumber {
                error = ValidationError.invalidPhoneNumber
                completion(nil, error)
            }
            else if model.street.isEmpty {
                error = ValidationError.emptyAddress
                completion(nil, error)
                return
            }else if model.city.isEmpty {
                error = ValidationError.emptyCity
                completion(nil, error)
                return
            }else if model.state.isEmpty {
                error = ValidationError.emptyState
                completion(nil, error)
                return
            }else if model.zipCode.isEmpty {
                error = ValidationError.emptyZipcodes
                completion(nil, error)
                return
            }else {
                completion(model, nil)
            }
        }
    }
}
extension EditProfileVM {
    func editProfileApiCall(keyToUploadData:String,fileNames:String, dataToUpload:Data, params :[String:Any],_ result:@escaping(EditProfileModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]

        ApiManager<EditProfileModel>.multipartRequestSingleWithoutImage(APIUrl.UserApis.updateProfile, params: params, dataToUpload: dataToUpload, keyToUploadData: keyToUploadData, fileNames: fileNames, headers: headers) { (response) in
            Progress.instance.hide()
            print(response!)
            if response?["statusCode"] as! Int == 200{
                showMessage(with: response?["message"] as? String ?? "")
            }else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func updateProfileApi(keyToUploadData:String,fileNames:String, dataToUpload:Data, param:[String:Any], _ result:@escaping([String : Any]?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<EditProfileModel>.multipartRequestSingle(APIUrl.UserApis.updateProfile, params: param, dataToUpload: dataToUpload, keyToUploadData: keyToUploadData, fileNames: fileNames, headers: headers) { (response) in
                Progress.instance.hide()
                print(response!)
                if response?["statusCode"] as! Int == 200{
                    fireBaseUserTable().updateOwnProfileOnFirebase()
                    result(["message": response?["message"] as! String])
                }else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
}
