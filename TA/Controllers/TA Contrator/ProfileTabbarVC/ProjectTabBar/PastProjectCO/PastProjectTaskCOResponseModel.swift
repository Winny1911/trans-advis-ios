//
//  PastProjectTaskCOResponseModel.swift
//  TA
//
//  Created by Applify on 08/02/22.
//

import Foundation

// MARK: - PastProjectTaskCOResponseModel
struct PastProjectTaskCOResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: PastProjectCOTaskData?
}

// MARK: - DataClass
struct PastProjectCOTaskData: Codable {
    let getTasks: [GetTask]?
}

// MARK: - GetTask
struct GetTask: Codable {
    let id: Int?
    let task, type: String?
    let projectID, userID, assigneeID, status: Int?
    let taskType, budget, mainProjectID, bidsCount: Int?
    let taskProject: TaskProject?
    let assignedTo: AssignedTo?

    enum CodingKeys: String, CodingKey {
        case id, task, type
        case projectID = "projectId"
        case userID = "userId"
        case assigneeID = "assigneeId"
        case status, taskType, budget, mainProjectID, bidsCount, taskProject, assignedTo
    }
}

// MARK: - AssignedTo
struct AssignedTo: Codable {
    let id: Int?
    let firstName, lastName: String?
}

// MARK: - TaskProject
struct TaskProject: Codable {
    let id, status, projectType: Int?
}

