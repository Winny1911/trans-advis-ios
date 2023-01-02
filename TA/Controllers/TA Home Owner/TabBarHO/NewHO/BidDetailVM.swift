//
//  BidDetailVM.swift
//  TA
//
//  Created by applify on 09/01/22.
//

import UIKit

class BidDetailVM: NSObject {
    var bidDetailData : BidDetailData?
    

}
extension BidDetailVM {
    func BidsDetailApiCall(_ params :[String:Any],_ result:@escaping(BidDetailResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<BidDetailResponseModel>.makeApiCall(APIUrl.UserApis.bidDetail, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            self.bidDetailData = resultModel?.data 
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func BidsInvitedDetailApiCall(_ params :[String:Any],_ result:@escaping(BidDetailResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<BidDetailResponseModel>.makeApiCall(APIUrl.UserApis.contractorBidDetailsById, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            self.bidDetailData = resultModel?.data
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
}
