//
//  NotificationVM.swift
//  TA
//
//  Created by applify on 02/03/22.
//

import UIKit

class NotificationVM: NSObject {
    func getNotificationApi(_ params :[String:Any],_ result:@escaping(NotificationResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<NotificationResponseModel>.makeApiCall(APIUrl.UserApis.notificationHO, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }

    func readNotificationApi(_ result:@escaping(NotificationResponseModel?) -> Void){

        let param = ["isRead": 1] as [String : Any]
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<NotificationResponseModel>.makeApiCall(APIUrl.UserApis.notificationHO, params: param, headers: headers, method: .put) { (response, resultModel) in

            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
}
