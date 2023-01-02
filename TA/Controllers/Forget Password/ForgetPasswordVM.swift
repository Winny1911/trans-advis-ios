//
//  ForgetPasswordVM.swift
//  TA
//
//  Created by Dev on 07/12/21.
//

import UIKit

class ForgetPasswordModel {
    var email: String = ""
    
    init() {
    }
    
    init(email: String) {
        self.email = email
    }
}


class ForgetPasswordVM: NSObject {
    var model: ForgetPasswordModel = ForgetPasswordModel()
    var error: String? = .none
    
    func validateForgotPasswordModel(completion: (_ success:[String: Any]?, _ error: String?) -> Void) {
        error = nil
        
        if model.email.isEmpty {
            error = ValidationError.emptyEmail
            completion(nil, error)
            return
        } else if !model.email.isValidEmailAddress {
            error = ValidationError.invalidEmail
            completion(nil, error)
            return
        }else {
            var devToken = ""
            if let deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as? String {
                devToken = deviceToken
            } else {
                devToken = "01234567890"
            }
            let param = ["email": model.email, "deviceType": "IOS", "deviceToken": devToken]
            completion(param, nil)
            
        }
    }
    
    func forgotPasswordApiCall(_ params :[String:Any],_ result:@escaping(ForgotPasswordResponseModel?) -> Void){
        Progress.instance.show()
        ApiManager<ForgotPasswordResponseModel>.makeApiCall(APIUrl.UserApis.forgotPassword, params: params, headers: nil, method: .put) { (response, resultModel) in
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

struct ForgotPasswordResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : ForgotPasswordData?
}

struct ForgotPasswordData : Codable {
    var customMessage : String?
    var remainingTime : Int?
}
