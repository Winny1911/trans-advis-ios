//
//  FeedbackCOViewModel.swift
//  TA
//
//  Created by Applify on 28/02/22.
//

import UIKit

class FeedbackCOViewModel: NSObject {

}

extension FeedbackCOViewModel {
    func postFeedbackCOApiCall(_ param: [String:Any], _ result:@escaping(FeedBackCOModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]

        ApiManager<FeedBackCOModel>.makeApiCall(APIUrl.UserApis.feedBackCO, params:param , headers: headers, method: .post) { (response, resultModel) in
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
