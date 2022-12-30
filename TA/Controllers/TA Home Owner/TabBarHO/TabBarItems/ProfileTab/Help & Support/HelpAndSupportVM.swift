//
//  HelpAndSupportVM.swift
//  TA
//
//  Created by applify on 08/03/22.
//

import UIKit

class HelpAndSupportVM: NSObject {
}
extension HelpAndSupportVM {
    func helpAndSupportApi(_ params :[String:Any],_ result:@escaping(HelpAndSupportResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<HelpAndSupportResponseModel>.makeApiCall(APIUrl.UserApis.helpAndSupport, params: params, headers: headers, method: .get) { (response, resultModel) in
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

