//
//  TransactionHistoryVM.swift
//  TA
//
//  Created by Applify on 11/01/22.
//

import UIKit

class TransactionHistoryVM: NSObject {

    func getOngoingTransactionHistoryApi(_ params :[String:Any], _ result:@escaping(TransactionCOResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<TransactionCOResponseModel>.makeApiCall(APIUrl.UserApis.transactionHistory, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getTransactionHistoryCOApi(_ params :[String:Any], _ result:@escaping(TransactionCOResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<TransactionCOResponseModel>.makeApiCall(APIUrl.UserApis.transactionHistoryCO, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getSubTaskTransactionHistoryCOApi(_ params :[String:Any], _ result:@escaping(TransactionCOResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<TransactionCOResponseModel>.makeApiCall(APIUrl.UserApis.transactionHistorySubTaskCO, params: params, headers: headers, method: .get) { (response, resultModel) in
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
