//
//  ManageBidDetailViewModel.swift
//  TA
//
//  Created by Applify  on 05/01/22.
//

import Foundation
class ManageBidDetailViewModel: NSObject {
    func getManageBidsDetailApi(_ params :[String:Any],_ result:@escaping(ManageBidDetailResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<ManageBidDetailResponseModel>.makeApiCall(APIUrl.UserApis.contractorBidDetailsById, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getManageBidsDetailApiV2(_ params :[String:Any],_ result:@escaping(ManageBidDetailResponseModelV2?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<ManageBidDetailResponseModelV2>.makeApiCall(APIUrl.UserApis.contractorBidDetailsById, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func confirmRecallBidApi(_ params :[String:Any],_ result:@escaping(ManageBidDetailResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<ManageBidDetailResponseModel>.makeApiCall(APIUrl.UserApis.contractorRecallBid, params: params, headers: headers, method: .put) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func viewBidLogApi(_ params :[String:Any],_ result:@escaping(GetBidLogResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<GetBidLogResponseModel>.makeApiCall(APIUrl.UserApis.contractorBidLog, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func deleteBidFileApi(_ params :[String:Any],_ result:@escaping(SignupResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<SignupResponseModel>.makeApiCall(APIUrl.UserApis.deleteBidFile, params: params, headers: headers, method: .delete) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getAgreementGeneratetApi(_ params :[String:Any],_ result:@escaping(GetAgreementGenerateResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<GetAgreementGenerateResponseModel>.makeApiCall(APIUrl.UserApis.agreementGenerate, params: params, headers: headers, method: .get) { (response, resultModel) in
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
