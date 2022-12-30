//
//  VerifyEmailVM.swift
//  TA
//
//  Created by Dev on 15/03/22.
//

import UIKit

class VerifyEmailVM: NSObject {
    

    func verifyEmailApiCall(_ param:[String:Any] ,_ result:@escaping(VerifyEmailResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<VerifyEmailResponseModel>.makeApiCall(APIUrl.UserApis.verifyEmail, params:param , headers: headers, method: .put) { (response, resultModel) in
            print ("GET_REQUEST:-\(resultModel)")
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
