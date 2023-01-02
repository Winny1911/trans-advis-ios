//
//  VendorProfileCOVM.swift
//  TA
//
//  Created by Applify on 17/02/22.
//

import UIKit

class VendorProfileCOVM: NSObject {

    func getVendorProfileCODataApi(_ params :[String:Any],_ result:@escaping(VendorProfileCOResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<VendorProfileCOResponseModel>.makeApiCall(APIUrl.UserApis.vendorProfileCO, params: params, headers: headers, method: .get) { (response, resultModel) in
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
