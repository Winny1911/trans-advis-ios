//
//  LoginVM.swift
//  TA
//
//  Created by Dev on 06/12/21.
//

import Foundation

class LoginVM: NSObject {
    var model: LoginModel = LoginModel()
    var error: String? = .none
    
    func validateLoginModel(completion: (_ success:[String: Any]?, _ error: String?) -> Void) {
        error = nil
        
        if model.email.isEmpty {
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
        } else {
            var devToken = ""
            if let deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as? String {
                devToken = deviceToken
            } else {
                devToken = "01234567890"
            }
            let param = ["email": model.email, "password": model.password, "deviceType": "IOS", "deviceToken": devToken, "deviceIdentifier": devToken]
            completion(param, nil)
            
        }
    }
}

extension LoginVM {
    func loginUserApiCall(_ params :[String:Any],_ result:@escaping(UserProfileResponseModel?) -> Void){
        Progress.instance.show()
        ApiManager<UserProfileResponseModel>.makeApiCall(APIUrl.UserApis.login, params: params, headers: nil, method: .put) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
}
