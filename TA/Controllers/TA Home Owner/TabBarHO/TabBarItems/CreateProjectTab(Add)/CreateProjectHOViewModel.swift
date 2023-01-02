//
//  CreateProjectHOViewModel.swift
//  TA
//
//  Created by Applify  on 20/12/21.
//

import Foundation
import UIKit

class CreateProjectHOViewModel: NSObject {
    
    var model: CreateProjectHOModel = CreateProjectHOModel()
    var error: String? = .none
    
    func validateCreateProjectModel(completion: (_ success:CreateProjectHOModel?, _ error: String?) -> Void) {
        error = nil
        if model.projecTitle.isEmpty {
            error = ValidationError.emptyProjectTitle
            completion(nil, error)
            return
        } else if !model.projecTitle.isValidProjectTitle {
            error = ValidationError.invalidProjectTitle
            completion(nil, error)
            return
        } else if model.projecDescription.isEmpty {
            error = ValidationError.emptyProjectDescription
            completion(nil, error)
            return
        } else if !model.projecDescription.isValidProjectDesc {
            error = ValidationError.invalidProjectDesc
            completion(nil, error)
            return
        } else if model.deliverables.count <= 0 {
            error = ValidationError.emptyDeliverable
            completion(nil, error)
            return
        } else if model.selectedTaskImageDoc == 0{
            error = ValidationError.projectFiles
            completion(nil, error)
            return
        }else if model.deliverables.count > 0 {
            if (self.checkDeliverables(arr: model.deliverables)) == false {
                error = ValidationError.emptyFieldDeliverable
                completion(nil, error)
            } else {
                if model.projectType == 0 {
                    error = ValidationError.emptyProjectType
                    completion(nil, error)
                    return
                } else if model.price == 0 {
                    error = ValidationError.emptyProjectBudget
                    completion(nil, error)
                    return
                } else if model.street.isEmpty {
                    error = ValidationError.emptyAddress
                    completion(nil, error)
                    return
                } else if model.city.isEmpty {
                    error = ValidationError.emptyCity
                    completion(nil, error)
                    return
                } else if model.state.isEmpty {
                    error = ValidationError.emptyFindLocation
                    completion(nil, error)
                    return
                } else if model.zipcode.isEmpty {
                    error = ValidationError.emptyZipcode
                    completion(nil, error)
                    return
                } else {
                    completion(model, nil)
                }
            }
        }
        
    }
    
    func checkDeliverables(arr:[[String:Any]]) -> Bool{
        var valuee = false
        for i in 0 ..< arr.count {
            let dict = arr[i]
            if dict["deliveralble"] as! String == "" || (dict["deliveralble"] as? String) == nil {
                valuee = false
                break
            } else {
                valuee = true
            }
        }
        return valuee
    }
    
    func addNewProjectApi(_ params :[String:Any],_ result:@escaping(SignupResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<SignupResponseModel>.makeApiCall(APIUrl.UserApis.createProject, params: params, headers: headers, method: .post) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func updateProjectApi(_ params :[String:Any],_ result:@escaping(SignupResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<SignupResponseModel>.makeApiCall(APIUrl.UserApis.updateProject, params: params, headers: headers, method: .put) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func deleteProjectFileApi(_ params :[String:Any],_ result:@escaping(SignupResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<SignupResponseModel>.makeApiCall(APIUrl.UserApis.deleteProjectFile, params: params, headers: headers, method: .put) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func updateProjectFileApi(_ params :[String:Any],_ result:@escaping(SignupResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<SignupResponseModel>.makeApiCall(APIUrl.UserApis.updateProjectFile, params: params, headers: headers, method: .put) { (response, resultModel) in
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
