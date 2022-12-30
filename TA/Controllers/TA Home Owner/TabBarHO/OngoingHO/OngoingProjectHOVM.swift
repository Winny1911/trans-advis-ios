//
//  OngoingProjectHOVM.swift
//  TA
//
//  Created by Designer on 07/01/22.
//

import UIKit

class OngoingProjectHOVM: NSObject {

    func getOngoingProjectApi(_ params :[String:Any],_ result:@escaping(OngoingProjectResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<OngoingProjectResponseModel>.makeApiCall(APIUrl.UserApis.projectOngoingListHO, params: params,headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getOngoingProjectDetailApi(_ params :[String:Any],_ result:@escaping(OngoingProjectDetailsResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<OngoingProjectDetailsResponseModel>.makeApiCall(APIUrl.UserApis.projectOngoingDetailsListHO, params: params, headers: headers, method: .get) { (response, resultModel) in
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
