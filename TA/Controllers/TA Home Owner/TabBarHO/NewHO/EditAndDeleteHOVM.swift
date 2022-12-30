//
//  EditAndDeleteHOVM.swift
//  TA
//
//  Created by Designer on 20/12/21.
//

import UIKit
import Alamofire

class EditAndDeleteHOVM: NSObject {

}

extension EditAndDeleteHOVM {
    
    func deleteProjectHOApiCall(_ params :[String:Any], _ result:@escaping(DeleteProjectHOModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<DeleteProjectHOModel>.makeApiCall(APIUrl.UserApis.projectDelete, params: params, headers: headers, method: .put) { (response, resultModel) in
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
