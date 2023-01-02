//
//  LogoutVM.swift
//  TA
//
//  Created by Designer on 06/01/22.
//

import UIKit

class LogoutVM: NSObject {

}
extension LogoutVM{
    func logOutApiCall(_ result:@escaping(LogoutResponseModel?) -> Void){
        Progress.instance.show()
        var param = [String:Any]()
        param ["deviceToken"] = "0123456789"
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<LogoutResponseModel>.makeApiCall(APIUrl.UserApis.logout, params: param, headers: headers, method: .put) { (response, resultModel) in
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
