//
//  ChangePasswordVM.swift
//  TA
//
//  Created by Designer on 04/01/22.
//

import UIKit

class ChangePasswordVM: NSObject {

    var model: ChangePasswordModel = ChangePasswordModel()
    var error: String? = .none
    
    func validateChangePasswordModel(completion: (_ success:[String: Any]?, _ error: String?) -> Void) {
        error = nil
         if model.oldPassword.isEmpty {
            error = ValidationError.emptyOldPassword
            completion(nil, error)
        } else if model.oldPassword.contains(find: " ") {
            error = ValidationError.validPasswordSpace
            completion(nil, error)
        } else if !model.oldPassword.isValidPassword {
            error = ValidationError.invalidPasswordChar
            completion(nil, error)
        } else if model.newPassword.isEmpty {
            error = ValidationError.emptyNewPassword
            completion(nil, error)
        } else if model.newPassword.contains(find: " ") {
            error = ValidationError.validPasswordSpace
            completion(nil, error)
        } else if !model.newPassword.isValidPassword {
            error = ValidationError.invalidPasswordChar
            completion(nil, error)
        }else if model.confirmPassword.isEmpty {
            error = ValidationError.emptyConfirmPassword
            completion(nil, error)
        } else if model.confirmPassword.contains(find: " ") {
            error = ValidationError.validPasswordSpace
            completion(nil, error)
        } else if !model.confirmPassword.isValidPassword {
            error = ValidationError.invalidPasswordChar
            completion(nil, error)
        }else if (model.newPassword != model.confirmPassword) {
            error = ValidationError.notMatchPassword
            completion(nil, error)
        } else if (model.oldPassword == model.newPassword) {
            error = ValidationError.samePassword
            completion(nil, error)
        } else {
            var devToken = ""
            if let deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as? String {
                devToken = deviceToken
            } else {
                devToken = "01234567890"
            }
            let param = ["oldPassword": model.oldPassword, "newPassword": model.confirmPassword]
            completion(param, nil)
        }
    }
}

extension ChangePasswordVM {
    func changePasswordApiCall(_ params :[String:Any],_ result:@escaping(ChangePasswordResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<ChangePasswordResponseModel>.makeApiCall(APIUrl.UserApis.changePassword, params: params, headers: headers, method: .put) { (response, resultModel) in
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
