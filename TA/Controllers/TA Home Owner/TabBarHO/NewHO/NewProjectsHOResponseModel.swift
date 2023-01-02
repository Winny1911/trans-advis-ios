//
//  NewProjectsHOResponseModel.swift
//  TA
//
//  Created by Applify  on 20/12/21.
//

import Foundation

struct NewProjectsHOResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : NewProjectsHOResponseDetail?
}

struct NewProjectsHOResponseDetail : Codable {
    var allProjects : [NewProjectsDetail]?
}

struct NewProjectsHOResponseDetailModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : NewProjectsDetail?
}

struct NewProjectsDetail : Codable {
    var addressLine1 : String?
    var addressLine2 : String?
    var amountCurrency : String?
    var bids : [BidscDetails]?
    var city : String?
    var contractor_project : [ContractorProjectDetail]?
//    var contractor_rating : String?
    var country : String?
    var createdAt : String?
    var description : String?
    var homeowner_rating : String?
    var id : Int?
    var price : Int?
    var projectCategoriesId : Int?
    var project_deliverable : [ProjectDeliverableDetail]?
    var project_files : [ProjectFilesDetail]?
    var project_agreement : [ProjectsAgreement]?
    var state : String?
    var latitude : String?
    var longitude : String?
    var status : Int?
    var tasks : [TasksDetail]?
    var title : String?
    var type : String?
    var userId : Int?
    var zipCode : String?
    var ischeck : Bool?
}

struct ProjectsAgreement : Codable {
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

struct TasksDetail : Codable {
    
}

struct ContractorProjectDetail : Codable {
    
}

struct ProjectDeliverableDetail : Codable {
    var deliveralble : String?
    var deliveralbleOrder : Int?
    var id : Int?
    var userId : Int?
}

struct ProjectFilesDetail : Codable {
    var createdAt : String?
    var file : String?
    var id : Int?
    var title : String?
    var type : String?
    var updatedAt : String?
    var userId : String?
    var user_detail : UserDetail?
}

struct UserDetail : Codable {
    var firstName : String?
    var lastName : String?
}
