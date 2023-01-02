//
//  MaterialCOVM.swift
//  TA
//
//  Created by Applify on 31/01/22.
//

import UIKit

class MaterialCOVM: NSObject {

}

extension MaterialCOVM {
    func getMaterialApiCall(_ params :[String:Any], _ result:@escaping(MaterialCOResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]

        ApiManager<MaterialCOResponseModel>.makeApiCall(APIUrl.UserApis.MaterialCO, params:params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            } else{
                showMessage(with: response?["message"] as? String ?? "")
            }
       }
    }
    
    func getMaterialVendorApiCall(_ params :[String:Any], _ result:@escaping(MaterialVendorCOResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]

        ApiManager<MaterialVendorCOResponseModel>.makeApiCall(APIUrl.UserApis.contractorVendorProducts, params:params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            } else{
                showMessage(with: response?["message"] as? String ?? "")
            }
       }
    }
    
    func createCartApiCall(_ params :[String:Any], _ result:@escaping(MaterialVendorCOResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]

        ApiManager<MaterialVendorCOResponseModel>.makeApiCall(APIUrl.UserApis.contractorCartsCreate, params:params, headers: headers, method: .post) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            } else{
                showMessage(with: response?["message"] as? String ?? "")
            }
       }
    }
}
