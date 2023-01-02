//
//  PastProjectViewModel.swift
//  TA
//
//  Created by Applify on 02/02/22.
//

import UIKit

class PastProjectCOViewModel: NSObject {
    
    func getAllPastProjectssApi(_ params :[String:Any],_ result:@escaping(PastProjectCOResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<PastProjectCOResponseModel>.makeApiCall(APIUrl.UserApis.contratorPastProjects, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getPastProjectDetailsApi(_ params :[String:Any],_ result:@escaping(PastProjectDetailResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<PastProjectDetailResponseModel>.makeApiCall(APIUrl.UserApis.pastProjectDetail, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getPastProjectOrderListApi(_ params :[String:Any],_ result:@escaping(PastProjectOrderListCOResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<PastProjectOrderListCOResponseModel>.makeApiCall(APIUrl.UserApis.pastProjectOrderList, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getPastProjectTaskApi(_ params :[String:Any],_ result:@escaping(PastProjectTaskCOResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<PastProjectTaskCOResponseModel>.makeApiCall(APIUrl.UserApis.pastProjectTaskCO, params: params, headers: headers, method: .get) { (response, resultModel) in
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
