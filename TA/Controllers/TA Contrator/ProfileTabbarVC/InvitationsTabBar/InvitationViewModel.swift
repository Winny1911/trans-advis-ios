//
//  InvitationViewModel.swift
//  TA
//
//  Created by Applify  on 21/12/21.
//

import Foundation
import UIKit

class InvitationViewModel: NSObject {
    
    func getAllInvitationsApi(_ params :[String:Any],_ result:@escaping(InvitationResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<InvitationResponseModel>.makeApiCall(APIUrl.UserApis.contractorInvitations, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getAllManagedBidsApi(_ params :[String:Any],_ result:@escaping(ManageBidsResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<ManageBidsResponseModel>.makeApiCall(APIUrl.UserApis.contractorManageBids, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getFilterApi(_ params :[String:Any],_ result:@escaping(FilterResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<FilterResponseModel>.makeApiCall(APIUrl.UserApis.contractorinvitationFilters, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getOngoingProjectsFilterApi(_ params :[String:Any],_ result:@escaping(FilterOngoingResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<FilterOngoingResponseModel>.makeApiCall(APIUrl.UserApis.contractorProjectFilters, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getOngoingProjectsHOFilterApi(_ params :[String:Any],_ result:@escaping(HoFilterResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<HoFilterResponseModel>.makeApiCall(APIUrl.UserApis.filterHO, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getInvitationDetailApi(_ params :[String:Any],_ result:@escaping(FilterResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<FilterResponseModel>.makeApiCall(APIUrl.UserApis.contractorinvitationFilters, params: params, headers: headers, method: .get) { (response, resultModel) in
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
