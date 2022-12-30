//
//  ProfileVM.swift
//  TA
//
//  Created by Designer on 31/12/21.
//

import UIKit

class ProfileVM: NSObject {

//    var profile = [profileUserDetail]()
}

extension ProfileVM {
    func getProfileApiCall(_ id :Int ,_ result:@escaping(ProfileHOModel?) -> Void){
        Progress.instance.show()
        var param = [String:Any]()
        param ["id"] = id
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]

        ApiManager<ProfileHOModel>.makeApiCall(APIUrl.UserApis.profileHO, params:param , headers: headers, method: .get) { (response, resultModel) in
            print ("GET_REQUEST:-\(resultModel)")
            Progress.instance.hide()
//            self.profile = resultModel?.data ?? []

            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
       }
    }
    
    
    func DeleteAccountApiCall(_ param : [String: Any], _ result: @escaping(DeleteAccountModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]

        ApiManager<DeleteAccountModel>.makeApiCall(APIUrl.UserApis.AccountDelete, params:param , headers: headers, method: .delete) { (response, resultModel) in
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
