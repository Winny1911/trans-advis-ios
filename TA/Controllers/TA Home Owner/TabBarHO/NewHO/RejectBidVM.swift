//
//  RejectBidVM.swift
//  TA
//
//  Created by applify on 11/01/22.
//

import UIKit
import Foundation

class RejectBidVM: NSObject {
    
    func rejectOrAcceptBidApiCall(_ params :[String:Any], result:@escaping(RejectBidResponseModel?) -> Void){
        Progress.instance.show()
        print(params)
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<RejectBidResponseModel>.makeApiCall(APIUrl.UserApis.rejectOrAcceptBid, params: params, headers: headers, method: .put) { (response, resultModel) in
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
