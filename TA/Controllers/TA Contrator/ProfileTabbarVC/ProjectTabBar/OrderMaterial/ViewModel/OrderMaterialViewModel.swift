//
//  OrderMaterialViewModel.swift
//  TA
//
//  Created by Shikha Pandey on 07/02/22.
//

import Foundation
import UIKit

class OrderMaterialViewModel: NSObject {

    func getAllMaterialsApi(_ params :[String:Any],_ result:@escaping(VendorDataResponse?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<VendorDataResponse>.makeApiCall(APIUrl.OrderMaterialApis.vendorList, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getAllCategoryApi(_ result:@escaping([Categories]?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<CategoryResponse>.makeApiCall(APIUrl.productCategoriesList, params: [:], headers: nil, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel?.data?.listing!)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    
}
