//
//  CORatingImageVM.swift
//  TA
//
//  Created by Applify on 25/01/22.
//

import UIKit

class CORatingImageVM: NSObject {

}

extension CORatingImageVM {
func getRatingImageApiCall(_ id :Int ,_ result:@escaping(CORatingImageResponseModel?) -> Void){
    Progress.instance.show()
    var param = [String:Any]()
    param ["id"] = id
    let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]

    ApiManager<CORatingImageResponseModel>.makeApiCall(APIUrl.UserApis.ratingImages, params:param , headers: headers, method: .get) { (response, resultModel) in
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
