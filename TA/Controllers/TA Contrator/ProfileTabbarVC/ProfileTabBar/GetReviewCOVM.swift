//
//  GetReviewCOVC.swift
//  TA
//
//  Created by Applify on 25/01/22.
//

import UIKit

class GetReviewCOVM: NSObject {

    var reviewData = [ReviewData]()
}

extension GetReviewCOVM {
//    func getCOReviewApiCall(_ id :Int ,_ result:@escaping(GetReviewResponseModel?) -> Void){
//        Progress.instance.show()
//        var param = [String:Any]()
//        param ["id"] = id
//        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
//
//        ApiManager<GetReviewResponseModel>.makeApiCall(APIUrl.UserApis.getReview, params:param , headers: headers, method: .get) { (response, resultModel) in
//            print ("GET_REQUEST:-\(resultModel)")
//            Progress.instance.hide()
////            self.reviewData = resultModel?.data?.reviews ?? []
//
//            if resultModel?.statusCode == 200{
//                result(resultModel)
//            }
//            else{
//                showMessage(with: response?["message"] as? String ?? "")
//            }
//       }
//    }
}




//}
extension GetReviewCOVM {
func getReviewApiCall(_ id :Int ,_ result:@escaping(ReviewResponseModel?) -> Void){
    Progress.instance.show()
    var param = [String:Any]()
    param ["id"] = id
    let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]

    ApiManager<ReviewResponseModel>.makeApiCall(APIUrl.UserApis.getReview, params:param , headers: headers, method: .get) { (response, resultModel) in
        print ("GET_REQUEST:-\(resultModel)")
        Progress.instance.hide()
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

