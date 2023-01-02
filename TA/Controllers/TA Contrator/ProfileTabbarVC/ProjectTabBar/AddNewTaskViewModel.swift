//
//  AddNewTaskViewModel.swift
//  TA
//
//  Created by Applify  on 11/01/22.
//

import Foundation
class AddNewTaskViewModel: NSObject {
    var model: AddNewTaskModel = AddNewTaskModel()
    var addNewOtherTaskModel: AddNewOtherTaskModel = AddNewOtherTaskModel()
    
    var error: String? = .none
    
    func validateAddTaskModel(completion: (_ success:AddNewTaskModel?, _ error: String?) -> Void) {
        error = nil
        
        if model.taskName.isEmpty {
            error = ValidationError.emptyTaskName
            completion(nil, error)
            return
        } else if model.bidBudget.isEmpty {
            error = ValidationError.emptyTaskBudget
            completion(nil, error)
            return
        } else {
            completion(model, nil)
        }
    }
    
    func validateAddOtherTaskModel(completion: (_ success:AddNewTaskModel?, _ error: String?) -> Void) {
        error = nil
        
        if addNewOtherTaskModel.taskName.isEmpty {
            error = ValidationError.emptyTaskName
            completion(nil, error)
            return
        } else if addNewOtherTaskModel.deliverables.count <= 0 {
            error = ValidationError.emptyDiscription
            completion(nil, error)
            return
        } else if addNewOtherTaskModel.deliverables.count > 0 {
            if (self.checkDeliverables(arr: addNewOtherTaskModel.deliverables)) == false {
                error = ValidationError.emptyDiscription
                completion(nil, error)
            } else {
                if addNewOtherTaskModel.projectType.isEmpty || addNewOtherTaskModel.projectType == "" {
                    error = ValidationError.emptyProjectType
                    completion(nil, error)
                    return
                } else if addNewOtherTaskModel.budget == "0" || addNewOtherTaskModel.budget == "" {
                    error = ValidationError.emptyProjectBudget
                    completion(nil, error)
                    return
                } else if addNewOtherTaskModel.address.isEmpty {
                    error = ValidationError.emptyAddress
                    completion(nil, error)
                    return
                } else if addNewOtherTaskModel.city.isEmpty {
                    error = ValidationError.emptyCity
                    completion(nil, error)
                    return
                } else if addNewOtherTaskModel.state.isEmpty {
                    error = ValidationError.emptyFindLocation
                    completion(nil, error)
                    return
                } else if addNewOtherTaskModel.zipcode.isEmpty {
                    error = ValidationError.emptyZipcode
                    completion(nil, error)
                    return
                } else if addNewOtherTaskModel.isMediaSelected == false {
                    error = ValidationError.emptyTaskImage
                    completion(nil, error)
                    return
                } else {
                    completion(model, nil)
                }
            }
        } else {
            completion(model, nil)
        }
    }
    
    func checkDeliverables(arr:[[String:Any]]) -> Bool{
        var valuee = false
        for i in 0 ..< arr.count {
            let dict = arr[i]
            if dict["deliverable"] as! String == "" || (dict["deliverable"] as? String) == nil {
                valuee = false
                break
            } else {
                valuee = true
            }
        }
        return valuee
    }
    
    func deleteTaskFileApi(_ params :[String:Any],_ result:@escaping(SignupResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<SignupResponseModel>.makeApiCall(APIUrl.UserApis.deleteBidFile, params: params, headers: headers, method: .delete) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func addInvitationDocApi(localFileUrl:URL,  keyToUploadData:String, fileNames:String, _ result:@escaping([String : Any]?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
           ApiManager<SignupResponseModel>.multipartRequest(APIUrl.UserApis.contractorFileUpload, localFileUrl: localFileUrl, keyToUploadData:keyToUploadData, fileNames: fileNames, headers: headers) { (response) in
                 Progress.instance.hide()
                 print(response!)
                 if response?["statusCode"] as! Int == 200{
                     result(response)
                 }else{
                 showMessage(with: response?["message"] as? String ?? "")
             }
        }
    }
    
    
    func addInvitationImageApi(keyToUploadData:String,fileNames:String, dataToUpload:Data, param:[String:Any], _ result:@escaping([String : Any]?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<SignupResponseModel>.multipartRequestSinglePost(APIUrl.UserApis.contractorFileUpload, params: param, dataToUpload: dataToUpload, keyToUploadData: keyToUploadData, fileNames: fileNames, headers: headers) { (response) in
                Progress.instance.hide()
                print(response!)
                if response?["statusCode"] as! Int == 200{
                    result(response)
                }else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func addNewTaskApi(_ params :[String:Any],_ result:@escaping(AddBankAccountResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<AddBankAccountResponseModel>.makeApiCall(APIUrl.UserApis.postContractorTasks, params: params, headers: headers, method: .post) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func updateTaskApi(_ params :[String:Any],_ result:@escaping(AddBankAccountResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<AddBankAccountResponseModel>.makeApiCall(APIUrl.UserApis.postContractorTasks, params: params, headers: headers, method: .put) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getSkillListApiCall(_ result:@escaping(SkillsResponseModel?) -> Void){
        Progress.instance.show()
        ApiManager<SkillsResponseModel>.makeApiCall(APIUrl.UserApis.projectCategoriesList, params: [:], headers: nil, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
   
    func addInviteBidsToContractors(_ params : [String: Any] ,_ result:@escaping(InviteBidsToContractor?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<InviteBidsToContractor>.makeApiCall(APIUrl.UserApis.inviteBidsToContractor, params: params, headers: headers, method: .post) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func updateInviteBidsToContractors(_ params : [String: Any] ,_ result:@escaping(UpdateInviteBidsToContractor?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<UpdateInviteBidsToContractor>.makeApiCall(APIUrl.UserApis.postContractorTasks, params: params, headers: headers, method: .put) { (response, resultModel) in
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
