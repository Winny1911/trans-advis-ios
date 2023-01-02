//
//  PastProjectVM.swift
//  TA
//
//  Created by applify on 27/02/22.
//

import UIKit

class PastProjectVM: NSObject {
    
    func getPastProjectApi(_ params :[String:Any],_ result:@escaping(PastProjectResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<PastProjectResponseModel>.makeApiCall(APIUrl.UserApis.projectListHO, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    
    func getPastProjectDetailsApi(_ params :[String:Any],_ result:@escaping(PastProjectDetialHOModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<PastProjectDetialHOModel>.makeApiCall(APIUrl.UserApis.projectListDetailsHO, params: params, headers: headers, method: .get) { (response, resultModel) in
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
