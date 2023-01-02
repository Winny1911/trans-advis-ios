//
//  ApproveDeliveryVM.swift
//  TA
//
//  Created by Applify on 10/01/22.
//

import UIKit

class ApproveDeliveryVM: NSObject {

    func approveDeliveryApiCall(_ params :[String:Any],_ result:@escaping(ApproveDeliveryResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<ApproveDeliveryResponseModel>.makeApiCall(APIUrl.UserApis.approveDelivery, params: params, headers: headers, method: .put) { (response, resultModel) in
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
