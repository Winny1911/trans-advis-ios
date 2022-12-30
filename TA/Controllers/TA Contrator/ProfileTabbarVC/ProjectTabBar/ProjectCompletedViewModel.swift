//
//  ProjectCompletedViewModel.swift
//  TA
//
//  Created by Applify  on 12/01/22.
//

import Foundation

class ProjectCompletedViewModel: NSObject {
    
    func addDocApi(localFileUrl:URL,  keyToUploadData:String, fileNames:String, _ result:@escaping([String : Any]?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
           ApiManager<SignupResponseModel>.multipartRequest(APIUrl.UserApis.fileUpload, localFileUrl: localFileUrl, keyToUploadData:keyToUploadData, fileNames: fileNames, headers: headers) { (response) in
                 Progress.instance.hide()
                 print(response!)
                 if response?["statusCode"] as! Int == 200{
                     result(response)
                 }else{
                 showMessage(with: response?["message"] as? String ?? "")
             }
        }
    }
    
    func addImageeApi(keyToUploadData:String,fileNames:String, dataToUpload:Data, param:[String:Any], _ result:@escaping([String : Any]?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<SignupResponseModel>.multipartRequestSinglePost(APIUrl.UserApis.fileUpload, params: param, dataToUpload: dataToUpload, keyToUploadData: keyToUploadData, fileNames: fileNames, headers: headers) { (response) in
                Progress.instance.hide()
                print(response!)
                if response?["statusCode"] as! Int == 200{
                    result(response)
                }else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }

    func uploadFiles(params:[String:Any], _ result:@escaping(ProjectCompletedResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<ProjectCompletedResponseModel>.makeApiCall(APIUrl.UserApis.fileUserUpload, params: params, headers: headers, method: .post) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func updateStatus(params:[String:Any], _ result:@escaping(ProjectCompletedResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<ProjectCompletedResponseModel>.makeApiCall(APIUrl.UserApis.contractorProjectStatus, params: params, headers: headers, method: .put) { (response, resultModel) in
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
