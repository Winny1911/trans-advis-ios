//
//  SignUpVM.swift
//  TA
//
//  Created by Dev on 06/12/21.
//

import UIKit

class SignUpVM: NSObject {
    var model: SignupModel = SignupModel()
    var error: String? = .none
    
    func validateSignUpModel(completion: (_ success:[String: Any]?, _ error: String?) -> Void) {
        error = nil
        if model.userType.isEmpty {
            error = ValidationError.selectUserType
            completion(nil, error)
            return
        }
        else if !model.email.isValidCompanyName && model.userType == UserType.contractor {
            error = ValidationError.invalidCompanyName
            completion(nil, error)
            return
        } else if model.email.isEmpty {
            error = ValidationError.emptyEmail
            completion(nil, error)
            return
        } else if !model.email.isValidEmailAddress {
            error = ValidationError.invalidEmail
            completion(nil, error)
            return
        } else if model.password.isEmpty {
            error = ValidationError.emptyPassword
            completion(nil, error)
        } else if model.password.contains(find: " ") {
            error = ValidationError.validPasswordSpace
            completion(nil, error)
        } else if !model.password.isValidPassword {
            error = ValidationError.invalidPasswordChar
            completion(nil, error)
        } else if model.termsAccepted == false {
            error = ValidationError.acceptTerms
            completion(nil, error)
        } else if !model.firstName.isValidFirstName {
            error = ValidationError.invalidFirstName
            completion(nil, error)
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
            return
        } else if !model.lastName.isValidLastName {
            error = ValidationError.invalidLastName
            completion(nil, error)
            return
        } else if model.addressLine1.isEmpty {
            error = ValidationError.emptyStreet
            completion(nil, error)
            return
        } else if model.city.isEmpty {
            error = ValidationError.emptyCity
            completion(nil, error)
            return
        } else if model.state.isEmpty {
            error = ValidationError.emptyState
            completion(nil, error)
            return
        } else if model.zipCode.isEmpty {
            error = ValidationError.emptyZipcode
            completion(nil, error)
            return
        } else if model.phoneNumber.isEmpty {
            error = ValidationError.emptyPhoneNumber
            completion(nil, error)
            return
        } else if !model.phoneNumber.isValidPhoneNumber {
            error = ValidationError.invalidPhoneNumber
            completion(nil, error)
            return
        } else {
            var devToken = ""
            if let deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as? String {
                devToken = deviceToken
            } else {
                devToken = "01234567890"
            }
            let param = ["email": model.email,
                         "password": model.password,
                         "userType": model.userType,
                         "deviceType": "IOS",
                         "deviceToken": devToken,
                         "deviceIdentifier": devToken,
                         "firstName": model.firstName,
                         "lastName": model.lastName,
                         "phoneNumber": model.phoneNumber,
                         "state": model.state,
                         "city": model.city,
                         "addressLine1": model.addressLine1,
                         "latitude": model.latitude,
                         "longitude": model.longitude,
                         "zipCode": model.zipCode,
                         "companyName": model.companyName
                         ] as [String : Any]
            completion(param, nil)
            
        }
    }
}

extension SignUpVM {
    func signUpUserApiCall(_ params :[String:Any],_ result:@escaping(SignupResponseModel?) -> Void){
        Progress.instance.show()
        ApiManager<SignupResponseModel>.makeApiCall(APIUrl.UserApis.register, params: params, headers: nil, method: .post) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200 || resultModel?.statusCode == 201 {
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func resendUserApiCall(_ params :[String:Any],_ result:@escaping(SignupResponseModel?) -> Void){
        Progress.instance.show()
        ApiManager<SignupResponseModel>.makeApiCall(APIUrl.UserApis.resendEmail, params: params, headers: nil, method: .put) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func checkEmailVerify(_ result:@escaping() -> Void) {
                
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<VerifyUser>.makeApiCall(APIUrl.UserApis.checkEmailVerfiy, params: [:], headers: headers, method: .get) { [weak self] (response, resultModel) in
            if resultModel?.statusCode == 200{
                result()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self?.checkEmailVerify(result)
                }
            }
        }
    }
}
