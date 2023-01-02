//
//  ViewBidsVM.swift
//  TA
//
//  Created by applify on 06/01/22.
//

import Foundation

class ViewBidsVM: NSObject {
    var viewBidData = [AllProjectViewBidData]()
    
}

extension ViewBidsVM {
    func ViewBidsApiCall(_ params :[String:Any],_ result:@escaping(ViewBidsResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<ViewBidsResponseModel>.makeApiCall(APIUrl.UserApis.viewBids, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func ViewInvitedBidsApiCall(_ params :[String:Any],_ result:@escaping(ViewBidsResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<ViewBidsResponseModel>.makeApiCall(APIUrl.UserApis.contractorTasksBids, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func saveAgreementApiCall(_ params :[String:Any],_ result:@escaping(SaveAgreementModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<SaveAgreementModel>.makeApiCall(APIUrl.UserApis.saveAgreements, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func saveAgreementSubTaskApiCall(_ params :[String:Any],_ result:@escaping(SaveAgreementModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<SaveAgreementModel>.makeApiCall(APIUrl.UserApis.subTaskAgreement, params: params, headers: headers, method: .get) { (response, resultModel) in
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
