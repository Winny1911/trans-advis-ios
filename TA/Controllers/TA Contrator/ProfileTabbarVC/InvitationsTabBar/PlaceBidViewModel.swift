//
//  PlaceBidViewModel.swift
//  TA
//
//  Created by Applify  on 01/01/22.
//

import Foundation
class PlaceBidViewModel: NSObject {
    var model: PlaceBidModel = PlaceBidModel()
    var error: String? = .none
    
    func validatePlaceBidnModel(completion: (_ success:PlaceBidModel?, _ error: String?) -> Void) {
        error = nil
//        if model.bidAmount.isEmpty {
//            error = ValidationError.emptyBidAmount
//            completion(nil, error)
//            return
//        } else if model.amountReceivable.isEmpty {
//            error = ValidationError.emptyAmountReceivable
//            completion(nil, error)
//            return
//        } else if model.startDate.isEmpty {
//            error = ValidationError.emptyStartDate
//            completion(nil, error)
//            return
//        } else if model.endDate.isEmpty {
//            error = ValidationError.emptyEndDate
//            completion(nil, error)
//            return
//        } else if validEndDate(startDateString: model.startDate, endDateString: model.endDate) == false {
//            error = ValidationError.validEndDate
//            completion(nil, error)
//            return
//        } else if model.description.isEmpty {
//            error = ValidationError.emptyTermsDesc
//            completion(nil, error)
//            return
//        } else if model.arrOfFilesCount <= 0 {
//            error = ValidationError.emptyProjectFile
//            completion(nil, error)
//            return
//        } else {
            completion(model, nil)
//        }
    }
    
    func validEndDate(startDateString:String, endDateString:String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        let startDate = formatter.date(from: startDateString)
        let endDate = formatter.date(from: endDateString)
        if startDate! > endDate! {
            return false
        } else {
            return true
        }
    }
    
    func addInvitationDocApi(localFileUrl:URL,  keyToUploadData:String, fileNames:String, _ result:@escaping([String : Any]?) -> Void){
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
    
    func addInvitationImageApi(keyToUploadData:String,fileNames:String, dataToUpload:Data, param:[String:Any], _ result:@escaping([String : Any]?) -> Void){
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
    
    func submitBidApi(_ params :[String:Any],_ result:@escaping(AddBankAccountResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<AddBankAccountResponseModel>.makeApiCall(APIUrl.UserApis.postContractorBid, params: params, headers: headers, method: .post) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func updateBidApi(_ params :[String:Any],_ result:@escaping(AddBankAccountResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<AddBankAccountResponseModel>.makeApiCall(APIUrl.UserApis.postContractorBid, params: params, headers: headers, method: .put) { (response, resultModel) in
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
