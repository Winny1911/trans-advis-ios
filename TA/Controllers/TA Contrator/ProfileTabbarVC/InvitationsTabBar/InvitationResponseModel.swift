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

struct ManageBidDetailResponseModelV2 : Codable {
    var message : String?
    var statusCode : Int?
    var data : ManageBidsResponseDetailsV2?
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

struct ManageBidsResponseDetailsV2 : Codable {
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
    var cellPhone : String?
    var aegcRepresentativeDate : String?
    //var aegcRepresentative: String
    var antenna : Int?
    var homeOwnerSign1 : String?
    var homeOwner1: String?
    var homeOwner2: String?
    var streetAddress: String?
    var mailingAddress: String?
    var email: String?
    var hoa: String?
    var permit: Int?
    var insurance: String?
    var claimNumber: String?
    var insFullyApproved: Int?
    var insPartialApproved: Int?
    var retail1: Int?
    var retailDepreciation: Int?
    var mainDwellingRoofSQ: String?
    var shedSQ: String?
    var decking: String?
    var flatRoofSQ: String?
    var totalSQ: String?
    var total: String?
    var deducible: String?
    var fe: String?
    var retail2: String?
    var be: String?
    var brand: String?
    var style: String?
    var color1: String?
    var white: String?
    var brown: String?
    var aegc: String?
    var gaf: String?
    var ridgeVent: String?
    var cutInstallRidgeVent: Int?
    var black: String?
    var brownB: String?
    var whiteB: String?
    var copper: String?
    var blackB: String?
    var brownC: String?
    var grey: String?
    var whiteC: String?
    var removeReplace: String?
    var deatchReset: String?
    var removeCoverHoles: String?
    var permaBoot123: String?
    var permaBoot34: String?
    var pipeJack123: String?
    var pipeJack34: String?
    var color2: String?
    var satelliteDish: Int?
    var detachOnly: String?
    var lightningRod: String?
    var materialLocation: String?
    var dumpsterLocation: String?
    var specialInstructions: String?
    var notes: String?
    var roofing1: String?
    var roofing2: String?
    var debrisRemoval1: String?
    var debrisRemoval2: String?
    var overheadProfit1: String?
    var overheadProfit2: String?
    var codeUpgrades: String?
    var paymentTerms1: Int?
    var paymentTerms2: Int?
    var proposedEndDate : String?
    var proposedStartDate : String?
    var updatedAt : String?
    var turtleVents : String?
    var dripEdgeF55 : String?
    var counterFlashing : String?
    var syntheticUnderlayment : String?
    var user : ManageBidUser?
    var chimneyFlashing : String?
    var sprayPaint : String?
    var atticFan : String?
    var detachedGarageSQ : String?
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
