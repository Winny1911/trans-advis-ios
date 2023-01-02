//
//  ContractorVM.swift
//  TA
//
//  Created by Dev on 17/12/21.
//

import UIKit

class ContractorVM: NSObject {
    var listing = [Listing]()
    var userData: ContractorUserData?
}

extension ContractorVM {
    
    func getProfileApiCall(_ id :Int ,_ result:@escaping(ContractorProfileModel?) -> Void){
        Progress.instance.show()
        var param = [String:Any]()
        param ["id"] = id
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]

        ApiManager<ContractorProfileModel>.makeApiCall(APIUrl.UserApis.profileHO, params:param , headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
       }
    }
    
    
    func contractorUserApiCall(_ param : [String:Any],_ result:@escaping(ContractorResponseModel?) -> Void){
        
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<ContractorResponseModel>.makeApiCall(APIUrl.UserApis.contractor, params:param, headers: headers, method: .get) { (response, resultModel) in
            //print ("GET_REQUEST:-\(resultModel)")
            Progress.instance.hide()
            self.listing = resultModel?.data?.listing ?? []
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func fetchContractorForBidsFilterApiCall(_ params :[String:Any], _ result:@escaping(ContractorResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<ContractorResponseModel>.makeApiCall(APIUrl.UserApis.contractorsForBid, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            self.listing = resultModel?.data?.listing ?? []
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func sendTaskToCOApi(_ params :[String:Any],_ result:@escaping(SentTaskResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<SentTaskResponseModel>.makeApiCall(APIUrl.UserApis.contractorSendTask, params: params, headers: headers, method: .post) { (response, resultModel) in
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
