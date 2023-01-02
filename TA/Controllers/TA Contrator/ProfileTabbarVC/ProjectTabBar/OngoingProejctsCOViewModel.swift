//
//  OngoingProejctsCOViewModel.swift
//  TA
//
//  Created by Applify  on 10/01/22.
//

import Foundation
import UIKit

class OngoingProejctsCOViewModel: NSObject {
    
    func getNotificationApi(_ params :[String:Any],_ result:@escaping(NotificationResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<NotificationResponseModel>.makeApiCall(APIUrl.UserApis.notificationHO, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getAllOngoingProjectssApi(_ params :[String:Any],_ result:@escaping(OngoingProjectsResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<OngoingProjectsResponseModel>.makeApiCall(APIUrl.UserApis.contractorOngoingProjects, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getOngoingProjectDetailsApi(_ params :[String:Any],_ result:@escaping(OngoingProjectDetailResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<OngoingProjectDetailResponseModel>.makeApiCall(APIUrl.UserApis.contractorOngoingProjectsById, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getOngoingProjectTasksApi(_ params :[String:Any],_ result:@escaping(SubTaskListReponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<SubTaskListReponseModel>.makeApiCall(APIUrl.UserApis.contractorOngoingtaskList, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getOrderListsApi(_ params :[String:Any],_ result:@escaping(OrderListResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<OrderListResponseModel>.makeApiCall(APIUrl.UserApis.contractorCarts, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func updatecartStatusApi(_ params :[String:Any],_ result:@escaping(CartStatusUpadteResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<CartStatusUpadteResponseModel>.makeApiCall(APIUrl.UserApis.contractorUpdateCartStatus, params: params, headers: headers, method: .put) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getDisputeRasonsAPI(_ params :[String:Any],_ result:@escaping(DiputeReasonsResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<DiputeReasonsResponseModel>.makeApiCall(APIUrl.UserApis.fetchDisputeReasons, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func submitDisputeRasonsAPI(_ params :[String:Any],_ result:@escaping(DiputeReasonsResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<DiputeReasonsResponseModel>.makeApiCall(APIUrl.UserApis.submitDispute, params: params, headers: headers, method: .post) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func deleteTaskApi(_ params :[String:Any],_ result:@escaping(DeleteTaskResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<DeleteTaskResponseModel>.makeApiCall(APIUrl.UserApis.contractorDeleteTask, params: params, headers: headers, method: .put) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func markCompletedTaskApi(_ params :[String:Any],_ result:@escaping(OngoingProjectDetailResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<OngoingProjectDetailResponseModel>.makeApiCall(APIUrl.UserApis.taskMarkCompleted, params: params, headers: headers, method: .put) { (response, resultModel) in
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
    
    func getAllOngoingTaskDetailsApi(_ params :[String:Any],_ result:@escaping(OngoingProjectsInviteTasksDetailsResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<OngoingProjectsInviteTasksDetailsResponseModel>.makeApiCall(APIUrl.UserApis.contractorSubTaskById, params: params, headers: headers, method: .get) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getAllOngoingAssignedTaskDetailsApi(projectId:Int, _ params :[String:Any],_ result:@escaping(OngoingProjectsAssignedTasksDetailsResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<OngoingProjectsAssignedTasksDetailsResponseModel>.makeApiCall("\(APIUrl.UserApis.contractorSubcontractorSubTaskById)?projectId=\(projectId)", params: params, headers: headers, method: .patch) { (response, resultModel) in
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
    
    func getOrderListApiCall(_ result:@escaping(SkillsResponseModel?) -> Void){
        Progress.instance.show()
        ApiManager<SkillsResponseModel>.makeApiCall(APIUrl.UserApis.contractorCarts, params: [:], headers: nil, method: .get) { (response, resultModel) in
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
    
    func deleteBidFileApi(_ params :[String:Any],_ result:@escaping(SignupResponseModel?) -> Void){
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
    
    func acceptRejectTaskApi(_ params :[String:Any],_ result:@escaping(OngoingProjectDetailResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<OngoingProjectDetailResponseModel>.makeApiCall(APIUrl.UserApis.taskMarkCompleted, params: params, headers: headers, method: .put) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func getOrderListDetailsApiCall(_ params :[String:Any], _ result:@escaping(OrderListDetaisResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<OrderListDetaisResponseModel>.makeApiCall(APIUrl.UserApis.cardDetails, params: params, headers: headers, method: .get) { (response, resultModel) in
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
