//
//  ApplifyFilterVM.swift
//  TA
//
//  Created by Designer on 21/12/21.
//

import UIKit

class ApplifyFilterVM: NSObject {

    var listing = [Listing]()
    
//    func applifyFilterApiCall(_ params :[String:Any], _ result:@escaping(ContractorResponseModel?) -> Void){
//        Progress.instance.show()
//        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
//        ApiManager<ContractorResponseModel>.makeApiCall(APIUrl.UserApis.contractor, params: params, headers: headers, method: .get) { (response, resultModel) in
//            Progress.instance.hide()
//            self.listing = resultModel?.data?.listing ?? []
//            if resultModel?.statusCode == 200{
//                result(resultModel)
//            }
//            else{
//                showMessage(with: response?["message"] as? String ?? "")
//            }
//        }
//    }
    
    func applifyFilterApiCall(_ params :[String:Any], _ result:@escaping(ContractorResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<ContractorResponseModel>.makeApiCall(APIUrl.UserApis.contractorslist, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            self.listing = resultModel?.data?.listing ?? []
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func fetchContractorForBidsFilterApiCall(_ params :[String:Any], _ result:@escaping(ContractorResponseModel?) -> Void){
        Progress.instance.hide()
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<ContractorResponseModel>.makeApiCall(APIUrl.UserApis.contractorsForBid, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            self.listing = resultModel?.data?.listing ?? []
            if resultModel?.statusCode == 200 {
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
}
