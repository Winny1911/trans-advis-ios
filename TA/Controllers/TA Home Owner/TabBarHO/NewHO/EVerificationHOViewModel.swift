//
//  EVerificationHOViewModel.swift
//  TA
//
//  Created by Applify  on 18/01/22.
//

import Foundation

class EVerificationHOViewModel: NSObject {
 
    var model: EVerificationHOModel = EVerificationHOModel()
    var error: String? = .none
    
    func validateEVerificationModel(completion: (_ success:[String: Any]?, _ error: String?) -> Void) {
        error = nil
        if model.selectedType.isEmpty || model.selectedType == "" {
            error = ValidationError.emptyEVerificationDoc
            completion(nil, error)
            return
        } else {
            var devToken = ""
            if let deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as? String {
                devToken = deviceToken
            } else {
                devToken = "01234567890"
            }
            let param = ["type": model.selectedType, "deviceType": "IOS", "deviceToken": devToken, "deviceIdentifier": devToken]
            completion(param, nil)
        }
    }
    func validateEVerificationModelPayment(completion: (_ success:[String: Any]?, _ error: String?) -> Void) {
        error = nil
        if model.selectedType.isEmpty || model.selectedType == "" {
            error = ValidationError.emptyPaymentProof
            completion(nil, error)
            return
        } else {
            var devToken = ""
            if let deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as? String {
                devToken = deviceToken
            } else {
                devToken = "01234567890"
            }
            let param = ["type": model.selectedType, "deviceType": "IOS", "deviceToken": devToken, "deviceIdentifier": devToken]
            completion(param, nil)
        }
    }
    
    func addAgreementDocApi(localFileUrl:URL,  keyToUploadData:String, fileNames:String, _ result:@escaping([String : Any]?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
           ApiManager<SignupResponseModel>.multipartRequest(APIUrl.UserApis.projectFileUpload, localFileUrl: localFileUrl, keyToUploadData:keyToUploadData, fileNames: fileNames, headers: headers) { (response) in
                 Progress.instance.hide()
                 print(response!)
                 if response?["statusCode"] as! Int == 200{
                     result(response)
                 }else{
                 showMessage(with: response?["message"] as? String ?? "")
             }
        }
    }

    func addAgreementImageApi(keyToUploadData:String,fileNames:String, dataToUpload:Data, param:[String:Any], _ result:@escaping([String : Any]?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<SignupResponseModel>.multipartRequestSinglePost(APIUrl.UserApis.projectFileUpload, params: param, dataToUpload: dataToUpload, keyToUploadData: keyToUploadData, fileNames: fileNames, headers: headers) { (response) in
                Progress.instance.hide()
                print(response!)
                if response?["statusCode"] as! Int == 200{
                    result(response)
                }else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func submitAgreementApi(_ params :[String:Any],_ result:@escaping(EverificationHOResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<EverificationHOResponseModel>.makeApiCall(APIUrl.UserApis.projectAgreement, params: params, headers: headers, method: .post) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }

    
    func addInvitedAgreementImageApi(keyToUploadData:String,fileNames:String, dataToUpload:Data, param:[String:Any], _ result:@escaping([String : Any]?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<SignupResponseModel>.multipartRequestSinglePost(APIUrl.UserApis.contractorFileUpload, params: param, dataToUpload: dataToUpload, keyToUploadData: keyToUploadData, fileNames: fileNames, headers: headers) { (response) in
                Progress.instance.hide()
                print(response!)
                if response?["statusCode"] as! Int == 200{
                    result(response)
                }else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    
    func addInvitedAgreementDocApi(localFileUrl:URL,  keyToUploadData:String, fileNames:String, _ result:@escaping([String : Any]?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
           ApiManager<SignupResponseModel>.multipartRequest(APIUrl.UserApis.contractorFileUpload, localFileUrl: localFileUrl, keyToUploadData:keyToUploadData, fileNames: fileNames, headers: headers) { (response) in
                 Progress.instance.hide()
                 print(response!)
                 if response?["statusCode"] as! Int == 200{
                     result(response)
                 }else{
                 showMessage(with: response?["message"] as? String ?? "")
             }
        }
    }
    
    func submitInvitedAgreementApi(_ params :[String:Any],_ result:@escaping(EverificationHOResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<EverificationHOResponseModel>.makeApiCall(APIUrl.UserApis.projectAgreement, params: params, headers: headers, method: .post) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
 
    func rejectOrAcceptInvitedBidApiCall(_ params :[String:Any], result:@escaping(RejectBidResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<RejectBidResponseModel>.makeApiCall(APIUrl.UserApis.contractorRejectOrAcceptBid, params: params, headers: headers, method: .put) { (response, resultModel) in
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

