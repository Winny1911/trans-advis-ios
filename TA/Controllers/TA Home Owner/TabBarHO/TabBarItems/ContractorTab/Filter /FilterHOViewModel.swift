//
//  FilterHOViewModel.swift
//  TA
//
//  Created by Designer on 21/12/21.
//

import UIKit

class FilterHOViewModel: NSObject {
//    var filterListing = FilterHoModel.
    
    func getFilterHOApi(_ params :[String:Any], _ result:@escaping(FilterHoModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<FilterHoModel>.makeApiCall(APIUrl.UserApis.filterHO, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
//            self.filterListing = resultModel?.data
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getFilterCOInviteBidsApi(_ params :[String:Any], _ result:@escaping(FilterCOModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<FilterCOModel>.makeApiCall(APIUrl.UserApis.filteCOInviteBids, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
//            self.filterListing = resultModel?.data
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
}
