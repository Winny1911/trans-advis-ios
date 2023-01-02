//
//  ArchiveProjectCOViewModel.swift
//  TA
//
//  Created by Applify on 03/02/22.
//

import UIKit

class ArchiveProjectCOViewModel: NSObject {

    func getAllArchiveProjectssApi(_ params :[String:Any],_ result:@escaping(ArchiveProjectCOResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<ArchiveProjectCOResponseModel>.makeApiCall(APIUrl.UserApis.contratorArchiveProjects, params: params, headers: headers, method: .get) { (response, resultModel) in
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
