//
//  OngoingProjectResponseModel.swift
//  TA
//
//  Created by Designer on 07/01/22.
//

import Foundation

import Foundation

// MARK: - OngoingProjectResponseModel
struct OngoingProjectResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: OngoingProject?
}

// MARK: - DataClass
struct OngoingProject: Codable {
    let allProjects: [AllProject]?
}

struct OngoingProjectDetailsResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : AllProject?
}

// MARK: - AllProject
struct AllProject: Codable {
    let id: Int?
    let title, allProjectDescription: String?
    let status: Int?
    let type, amountCurrency: String?
    let price: Int?
    let country, state, city, addressLine1: String?
    let addressLine2: String?
    let zipCode: String?
    let userID, isBlocked, isDeleted: Int?
    let createdAt, updatedAt: String?
    let project, progress: Double?
    let projectAgreement: [ProjectAgreement]?
    let projectDeliverable: [ProjectDeliverable]?
    let projectFiles: [ProjectFile]?
    let bids: [Bid]?
    let tasks: [Task]?
    let mainProjectTasks: [Task]?
    let contractorProject: [ContractorProject]?

    enum CodingKeys: String, CodingKey {
        case id, title
        case allProjectDescription = "description"
        case status, type, amountCurrency, price, country, state, city, addressLine1, addressLine2, zipCode
        case userID = "userId"
        case isBlocked, isDeleted, createdAt, updatedAt, project, progress
        case projectAgreement = "project_agreement"
        case projectDeliverable = "project_deliverable"
        case projectFiles = "project_files"
        case bids, tasks, mainProjectTasks
        case contractorProject = "contractor_project"
    }
}

// MARK: - Bid
struct Bid: Codable {
    let id, userID, projectID: Int?
    let amountCurrency, bidAmount, amountRecievable, bidDescription: String?
    let proposedStartDate, proposedEndDate: String?
    let bidStatus, isDeleted: Int?
    let createdAt, updatedAt: String?
    let bidsDocuments: [ProjectFile]?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case projectID = "projectId"
        case amountCurrency, bidAmount, amountRecievable
        case bidDescription = "description"
        case proposedStartDate, proposedEndDate, bidStatus, isDeleted, createdAt, updatedAt
        case bidsDocuments = "bids_documents"
        case user
    }
}

// MARK: - ProjectFile
struct ProjectFile: Codable {
    let id: Int?
    let title: String?
    let file: String?
    let type: String?
    let isDeleted: Int?
    let createdAt, updatedAt: String?
    let userID: String?
    let userDetail: UserDetail?

    enum CodingKeys: String, CodingKey {
        case id, title, file, type, isDeleted, createdAt, updatedAt
        case userID
        case userDetail
    }
}

// MARK: - User
struct User: Codable {
    let id: Int?
    let firstName: String?
    let lastname: String?
    let profilePic: String?
    let lastName: String?
}

// MARK: - ContractorProject
struct ContractorProject: Codable {
    let id, userID, projectStatus: Int?
    let createdAt, updatedAt: String?
    let contractorDetails: User?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case projectStatus, createdAt, updatedAt
        case contractorDetails = "contractor_details"
    }
}

// MARK: - ProjectAgreement
struct ProjectAgreement: Codable {
    var id: Int?
    var title: String?
    var file: String?
    var userID: Int?
    var type: String?
    var projectID: Int?
    var userType: String?
    var isBlocked, isDeleted: Int?
    var createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
            case id
            case projectID = "projectId"
            case userID = "userId"
            case title, file, type, userType, isBlocked, isDeleted, createdAt, updatedAt
        }
    
    
}

// MARK: - ProjectDeliverable
struct ProjectDeliverable: Codable {
    let id: Int?
    let deliveralble: String?
    let deliveralbleOrder, userID: Int?

    enum CodingKeys: String, CodingKey {
        case id, deliveralble, deliveralbleOrder
        case userID = "userId"
    }
}

// MARK: - Task
struct Task: Codable {
    
    let id: Int?
    let task: String?
    let budget, userID, status, projectID: Int?
    let mainProjectID, isDeleted, isBlocked: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, task, budget
        case userID
        case status
        case projectID
        case mainProjectID, isDeleted, isBlocked, createdAt, updatedAt
    }
}


