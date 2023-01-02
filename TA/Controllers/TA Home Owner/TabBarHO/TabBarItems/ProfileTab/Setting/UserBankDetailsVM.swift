//
//  UserBankDetailsVM.swift
//  TA
//
//  Created by Applify on 17/01/22.
//

import UIKit

class UserBankDetailsVM: NSObject {

}

extension UserBankDetailsVM {
    func getUserBankDetailsApiCall(_ result:@escaping(UserBankDetailsResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]

        ApiManager<UserBankDetailsResponseModel>.makeApiCall(APIUrl.UserApis.userBankDetails, headers: headers, method: .get) { (response, resultModel) in
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
