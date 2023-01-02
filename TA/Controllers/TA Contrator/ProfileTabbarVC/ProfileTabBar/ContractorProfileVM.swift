//
//  ContractorProfileVM.swift
//  TA
//
//  Created by Designer on 06/01/22.
//

import UIKit

class ContractorProfileVM: NSObject {

    var userData: ContractorUserData?
}

extension ContractorProfileVM {
    func getProfileApiCall(_ id :Int ,_ result:@escaping(ContractorProfileModel?) -> Void){
        Progress.instance.show()
        var param = [String:Any]()
        param ["id"] = id
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]

        ApiManager<ContractorProfileModel>.makeApiCall(APIUrl.UserApis.profileHO, params:param , headers: headers, method: .get) { (response, resultModel) in
            print ("GET_REQUEST:-\(resultModel)")
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                self.userData = resultModel?.data
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
       }
    }
}
