//
//  GetReviewVM.swift
//  TA
//
//  Created by Dev on 20/12/21.
//

import UIKit

class GetReviewVM: NSObject {
    var reviewData = [ReviewData]()
   

}
extension GetReviewVM {
    func getReviewApiCall(_ id :Int ,_ result:@escaping(ReviewResponseModel?) -> Void){
        Progress.instance.show()
        var param = [String:Any]()
        param ["id"] = id
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<ReviewResponseModel>.makeApiCall(APIUrl.UserApis.getReview, params:param , headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            self.reviewData.removeAll()
            self.reviewData = resultModel?.data?.reviews ?? []
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
       }
    }
}

