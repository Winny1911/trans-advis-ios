//
//  AddPortfolioImageVM.swift
//  TA
//
//  Created by Applify on 18/01/22.
//

import UIKit

class AddPortfolioImageVM: NSObject {

    
}

extension AddPortfolioImageVM{
    
    func addPortfolioImageApi(keyToUploadData:String,fileNames:String, dataToUpload:Data, param:[String:Any], _ result:@escaping([String : Any]?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<PortfolioImageUploadModel>.multipartRequestSinglePost(APIUrl.UserApis.portfolioImageUpload, params: param, dataToUpload: dataToUpload, keyToUploadData: keyToUploadData, fileNames: fileNames, headers: headers) { (response) in
                Progress.instance.hide()
                print(response!)
                if response?["statusCode"] as! Int == 200{
                    result(response)
                }else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func uploadPortfolioApiCall(_ params :[String:Any],_ result:@escaping(UploadPortfolioModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<UploadPortfolioModel>.makeApiCall(APIUrl.UserApis.uploadPortfolioImage, params: params, headers: headers, method: .post) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    
    
    
    
    func getOngoingProjectDetailApi(_ params :[String:Any],_ result:@escaping(RatingImageResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<RatingImageResponseModel>.makeApiCall(APIUrl.UserApis.projectOngoingDetailsListHO, params: params, headers: headers, method: .get) { (response, resultModel) in
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
