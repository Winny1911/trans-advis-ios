//
//  OngoingProejctsResponseModel.swift
//  TA
//
//  Created by Applify  on 10/01/22.
//

import Foundation


struct DeleteTaskResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : DeleteTaskResponseDetail?
}

struct DeleteTaskResponseDetail : Codable {
    var customMessage : String?
}

struct DiputeReasonsResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : DiputeReasonsResponseDetails?
}

struct DiputeReasonsResponseDetails : Codable {
    var allCarts : [String]?
}

struct OngoingProjectDetailResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : OngoingProjectDetailData?
}

struct OngoingProjectDetailData : Codable {
    var allProjects : OngoingProjectsDetail?
}

struct OngoingProjectsResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : OngoingProjectsDetailResponseModel?
}

struct OngoingProjectsDetailResponseModel : Codable {
    var allProjects : [OngoingProjectsDetail]?
}
struct OngoingProjectsDetail : Codable {
    var createdAt : String?
    var id : Int?
    var progress : String?
    var project : String?
    var projectId : Int?
    var project_agreements : [ProjectAgreementsDetail]?
    var project_details : OngoingProjecDetails?
}
struct HomeownerRatingDetails : Codable {
    var HomeOwnerRatingImages : [HomeOwnerRatingImages]?
    var createdAt : String?
    var feedback1 : String?
    var feedback2 : String?
    var feedback3 : String?
    var homeownerId : Int?
    var id : Int?
    var isBlocked : Int?
    var isDeleted : Int?
    var overAllFeedback : String?
    var projectId : Int?
    var rating : Int?
    var updatedAt : String?
    var userId : Int?
}

struct HomeOwnerRatingImages : Codable {
    var createdAt : String?
    var file : String?
    var id : Int?
    var isBlocked : Int?
    var isDeleted : Int?
    var projectId : Int?
    var ratingId : Int?
    var title : String?
    var type : String?
    var updatedAt : String?
    var userId : Int?
}

struct OngoingProjecDetails : Codable {
    var addressLine1 : String?
    var addressLine2 : String?
    var amountCurrency : String?
    var bids : [BidscDetails]?
    var city : String?
//    var contractor_rating : String?
    var country : String?
    var createdAt : String?
    var description : String?
    var homeowner_rating : HomeownerRatingDetails?
    var id : Int?
    var isBlocked : Int?
    var isDeleted : Int?
    var price : Int?
    var projectType : Int?
    var project_files : [ProjectFilesOngoing]?
    var state : String?
    var status : Int?
    var tasks : [TasksDetaills]?
    var title : String?
    var type : String?
    var updatedAt : String?
    var userId : Int?
    var user_data : UserDataOngoing?
    var zipCode : String?
    var project_deliverable: [ProjectDeliverablesss]?
    let projectCategory: ProjectCategorysssss?
}

struct ProjectCategorysssss: Codable {
    let id: Int?
    let title: String?
}


// MARK: - ProjectDeliverable
struct ProjectDeliverablesss: Codable {
    let id: Int?
    let deliveralble: String?
    let deliveralbleOrder, userID: Int?

    enum CodingKeys: String, CodingKey {
        case id, deliveralble, deliveralbleOrder
        case userID = "userId"
    }
}

struct UserDataOngoing : Codable  {
    var id : Int?
    var firstName : String?
    var lastName : String?
    var profilePic : String?
}

struct TasksDetaills : Codable {
    var budget : Int?
    var createdAt : String?
    var id : Int?
    var isBlocked : Int?
    var isDeleted : Int?
    var projectId : Int?
    var status : Int?
    var task : String?
    var updatedAt : String?
    var userId : Int?
    var mainProjectId: Int?
    var taskDescription: String?
    
}
struct ProjectFilesOngoing : Codable {
    var createdAt : String?
    var file : String?
    var id : Int?
    var isDeleted : Int?
    var title : String?
    var type : String?
    var updatedAt : String?
    var userId : String?
    var user_detail : UserDetail?
}

struct BidscDetails : Codable {
    var amountCurrency : String?
    var amountRecievable : String?
    var bidAmount : String?
    var bidStatus : Int?
    var bids_documents : [BidsDocumentsDetailss]?
    var createdAt : String?
    var description : String?
    var id : Int?
    var isDeleted : Int?
    var projectId : Int?
    var proposedEndDate : String?
    var proposedStartDate : String?
    var updatedAt : String?
    var userId : Int?
}

struct BidsDocumentsDetailss : Codable {
    var createdAt : String?
    var file : String?
    var id : Int?
    var isDeleted : Int?
    var title : String?
    var type : String?
    var updatedAt : String?
    
}

struct ProjectAgreementsDetail : Codable {
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

struct SubTaskListReponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : SubTaskListReponseModelData?
}

struct SubTaskListReponseModelData : Codable {
    var getTasks : [SubTaskListReponseModelDetail]?
}

struct SubTaskListReponseModelDetail : Codable {
    var assignedTo : AssignedToDetail?
    var assigneeId : Int?
    var bidsCount : Int?
    var budget : Double?
    var id : Int?
    var mainProjectID : Int?
    var projectId : Int?
    var status : Int?
    var task : String?
    var taskProject : TaskProjectDetail?
    var taskType : Int?
    var type : String?
    var userId : Int?
}


struct AssignedToDetail : Codable {
    var firstName : String?
    var lastName : String?
    var id : Int?
}

struct TaskProjectDetail : Codable {
    var id : Int?
    var projectType : Int?
    var status : Int?
}



struct OngoingProjectsInviteTasksDetailsResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : OngoingProjectsInviteTasksDetailss?
}

struct OngoingProjectsInviteTasksDetailss : Codable {
    var projectDetails : OngoingProjectsInviteTasksDetailsProject?
}

struct OngoingProjectsInviteTasksDetailsProject : Codable {
    var addressLine1 : String?
    var addressLine2 : String?
    var bids : [BidscDetails]?
    var city : String?
    var latitude : String?
    var longitude : String?
    var country : String?
    var id : Int?
    var isAdminPermission : Int?
    var price : Double?
    var project_deliverable : [ProjectDeliverableDetail]?
    var project_files : [ProjectTaskFilesOngoing]?
    var state : String?
    var status : Int?
    var subProjectId : Int?
    var projectCategoriesId : Int?
    var tasks : [SubTasksListReponseModelDetail]?
    var title : String?
    var zipCode : String?
    var type : String?
    var projectCategory : projectCategoryessess?
}

struct projectCategoryessess : Codable {
    var id : Int?
    var title : String?
}

struct SubTasksListReponseModelDetail : Codable {
    var assignedTo : String?
    var assigneeId : Int?
    var completDateByAdmin : String?
    var createdAt : String?
    var budget : Double?
    var id : Int?
    var isBlocked : Int?
    var isDeleted : Int?
    var mainProjectID : Int?
    var mainProjectId : Int?
    var paymentStatus : Int?
    var taskDescription : String?
}

struct ProjectTaskFilesOngoing : Codable {
    var createdAt : String?
    var file : String?
    var id : Int?
    var isDeleted : Int?
    var title : String?
    var type : String?
    var updatedAt : String?
    var userId : String?
}

struct OngoingProjectsAssignedTasksDetailsResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : OngoingProjectsAssignedTasksDetailsResponse?
}

struct OngoingProjectsAssignedTasksDetailsResponse : Codable {
    var createTaskFiles : String?
    var projectDetails : OngoingProjectsIAssignedTasksDetailsProject?
}

struct OngoingProjectsIAssignedTasksDetailsProject : Codable {
    var addressLine1 : String?
    var addressLine2 : String?
    var bids : [ProjectAssignedTasksDetails]?
    var city : String?
    var country : String?
    var id : Int?
    var isAdminPermission : Int?
    var price : Double?
    var project_agreement: [ProjectAgreementsDetail]?
    var projectType :Int
    var project_deliverable : [ProjectDeliverableDetail]?
    var project_files : [ProjectTaskFilesOngoing]?
    var state : String?
    var status : Int?
    var subProjectId : Int?
    var tasks : [ProjectAssignedTaskssDetails]?
    var title : String?
    var zipCode : String?
    var type : String?
    let projectCategory: ProjectCategoryeseses?
}

// MARK: - ProjectCategory
struct ProjectCategoryeseses: Codable {
    let id: Int?
    let title: String?
}

struct TaskUsersDetails : Codable {
    var firstName : String?
    var id : Int?
    var lastName : String?
    var profilePic : String?
}

struct ProjectAssignedTaskssDetails : Codable {
    var TaskUser : TaskUsersDetails?
    var assignedTo : TaskUsersDetails?
    var assigneeId : Int?
    var completDateByAdmin : String?
    var createdAt : String?
    var budget : Double?
    var id : Int?
    var isBlocked : Int?
    var isDeleted : Int?
    var mainProjectID : Int?
    var mainProjectId : Int?
    var paymentStatus : Int?
    var projectId : Int?
    var status : Int?
    var task : String?
    var taskType : Int?
    var type : String?
    var updatedAt : String?
    var userId : Int?
    var taskDescription : String?
}

struct ProjectAssignedTasksDetails : Codable {
    var amountCurrency : String?
    var amountRecievable : String?
    var bidAmount : String?
    var bidStatus : Int?
    var bids_documents : [BidsDocumentsDetailss]?
    var createdAt : String?
    var description : String?
    var id : Int?
    var isDeleted : Int?
    var projectId : Int?
    var proposedEndDate : String?
    var proposedStartDate : String?
    var updatedAt : String?
}
