//
//  InvitationResponseModel.swift
//  TA
//
//  Created by Applify  on 21/12/21.
//

import Foundation

struct InvitationResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : InvitationResponseModelDetail?
}

struct InvitationResponseModelDetail : Codable {
    var count : Int?
    var listing : [InvitationsDetails]?
}

struct InvitationsDetails : Codable {
    var createdAt : String?
    var homeownerId : Int?
    var id : Int?
    var project_data : ProjectDataDetail?
    var notification : NotificationId?
    var userId : Int?
    
}

struct NotificationId : Codable {
    var id : Int?
}

struct ProjectDataDetail : Codable {
    var addressLine1 : String?
    var addressLine2 : String?
    var amountCurrency : String?
    var city : String?
    var country : String?
    var description : String?
    var id : Int?
    var price : Int?
    var project_files : [ProjectFilesDetail]?
    var state : String?
    var status : Int?
    var title : String?
    var projectType :Int?
    var type : String?
    var updatedAt : String?
    var userId : Int?
    var user_data : UserDataDetail?
    var zipCode : String?
    var project_deliverable : [ProjectDeliverableDetail]?
    var taskDescription : String?
    var projectCategories : projectCategoriessese?
}

struct projectCategoriessese : Codable {
    var id : Int?
    var title : String?
}

struct UserDataDetail : Codable {
    var accessToken : String?
    var addressLine1 : String?
    var addressLine2 : String?
    var city : String?
    var country : String?
    var email : String?
    var emailVerified : Int?
    var firstName : String?
    var id : Int?
    var lastName : String?
    var phoneNumber : String?
    var profilePic : String?
    var rating : String?
    var state : String?
    var user_files : UserFilesDetail?
    var zipCode : String?
}

struct UserFilesDetail : Codable {
    
}

struct ManageBidDetailResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : ManageBidsResponseDetails?
}

struct ManageBidsResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : [ManageBidsResponseDetails]?
}
struct ManageBidsResponseDetails : Codable {
    var amountCurrency : String?
    var amountRecievable : String?
    var bidAmount : String?
    var bidStatus : Int?
    var bids_documents : [BidsDocumentsDetails]?
    var project_agreement : [ProjectAgreementDetails]?
    
    var createdAt : String?
    var description : String?
    var id : Int?
    var isBlocked : Int?
    var isDeleted : Int?
    var projectId : Int?
    var project_details : ProjectDetails?
    
    var proposedEndDate : String?
    var proposedStartDate : String?
    var updatedAt : String?
    var user : ManageBidUser?
    
}

struct ProjectAgreementDetails : Codable {
    var createdAt : String?
    var file : String?
    var id : Int?
    var isBlocked : Int?
    var isDeleted : Int?
    var projectId : Int?
    var title : String?
    var type : String?
    var updatedAt : String?
    var userId : Int?
    var userType : String?
}

struct ManageBidUser : Codable {
    var addressLine1 : String?
    var addressLine2 : String?
    var city : String?
    var completedProjectCount : Int?
    var country : String?
    var email : String?
    var emailVerified : Int?
    var firstName : String?
    var id : Int?
    var isBlocked : Int?
    var lastName : String?
    var phoneNumber : String?
    var profilePic : String?
    var rating : String?
    var skillSet : String?
    var state : String?
    var user_files : [UserFilesManage]?
    var zipCode : String?
    
}
struct UserFilesManage : Codable{

}

struct ProjectDetails : Codable{
    var addressLine1 : String?
    var addressLine2 : String?
    var amountCurrency : String?
    var city : String?
    var country : String?
    var createdAt : String?
    var description : String?
    var id : Int?
    var isBlocked : Int?
    var isDeleted : Int?
    var price : Int?
    var project_files : [ProjectFiles]?
    var state : String?
    var projectType :Int?
    var title : String?
    var type : String?
    var updatedAt : String?
    var userId : Int?
    var zipCode : String?
    var user_ProjectDetail : UserProjectDetail?
    let userData: UserData?
    var bids: [Bid]?
    var tasks: [Task]?
    var project_deliverable : [ProjectDeliverableDetail]?
    var taskDescription : String?
    let projectCategory: ProjectCategoryessss?
}

// MARK: - ProjectCategory
struct ProjectCategoryessss: Codable {
    let id: Int?
    let title: String?
}

struct UserProjectDetail : Codable {
    var deviceType : String?
    var firstName : String?
    var id : Int?
    var lastName : String?
    var profilePic : String?
}

struct ProjectFiles : Codable {
    var createdAt : String?
    var file : String?
    var id : Int?
    var isDeleted : Int?
    var title : String?
    var type : String?
    var updatedAt : String?
    var userId : String?
    var user_detail : UserDetailManage?
}
struct UserDetailManage : Codable {
    var firstName : String?
    var lastName : String?
}

struct BidsDocumentsDetails : Codable {
    var createdAt : String?
    var file : String?
    var id : Int?
    var isDeleted : Int?
    var title : String?
    var type : String?
    var updatedAt : String?
}

struct GetBidLogResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : GetBidLogResponseModelDetail?
}

struct GetBidLogResponseModelDetail : Codable {
    var getBidLog : [GetBidLoglDetail]?
}

struct GetBidLoglDetail : Codable {
    var bidLogMessage : String?
    var createdAt : String?
    var id : Int?
    var message : String?
    var notificationType : Int?
    var title : String?
}


struct GetAgreementGenerateResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : GetAgreementGenerateResponseDetail?
}
struct GetAgreementGenerateResponseDetail : Codable {
    var app: GetAgreementGenerateAppDetail?
    var web: GetAgreementGenerateAppDetail?
}

struct GetAgreementGenerateAppDetail : Codable {
    var downloadUrl : String?
    var filename : String?
}
