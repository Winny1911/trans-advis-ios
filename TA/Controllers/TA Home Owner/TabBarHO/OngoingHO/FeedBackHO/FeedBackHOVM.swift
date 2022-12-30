//
//  FeedBackHOVM.swift
//  TA
//
//  Created by applify on 04/03/22.
//

import UIKit

class FeedBackHOVM: NSObject {

}
extension FeedBackHOVM {
    func postFeedbackHOApiCall(_ param: [String:Any], _ result:@escaping(FeedbackHOResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]

        ApiManager<FeedbackHOResponseModel>.makeApiCall(APIUrl.UserApis.feedBackHO, params:param , headers: headers, method: .post) { (response, resultModel) in
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
