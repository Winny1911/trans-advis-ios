//
//  SendProjectVM.swift
//  TA
//
//  Created by Dev on 23/12/21.
//

import UIKit

class SendProjectVM: NSObject {
    var sentProject: SentProject?

}
extension SendProjectVM {
    func sendProjectApiCall(_ id :String ,_ projectId : [String],  _ result:@escaping(SentProjectModel?) -> Void){
        Progress.instance.show()
        var param = [String:Any]()
        param ["contractorId"] = id
        param ["projectIds"] = projectId
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]

        ApiManager<SentProjectModel>.makeApiCall(APIUrl.UserApis.sendProject, params:param , headers: headers, method: .post) { (response, resultModel) in
            Progress.instance.hide()
            self.sentProject = resultModel?.data
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
       }
    }
}
