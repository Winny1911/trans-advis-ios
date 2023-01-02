//
//  InviteBidsToContractorResponseModel.swift
//  TA
//
//  Created by applify on 09/02/22.
//

import UIKit
import Foundation

// MARK: - Welcome

struct UpdateInviteBidsToContractor: Codable {
    let statusCode: Int?
    let message: String?
    let data: UpdateInviteBidsToContractorDetail?
}

struct UpdateInviteBidsToContractorDetail: Codable {
    let customMessage: String?
}

struct InviteBidsToContractor: Codable {
    let statusCode: Int?
    let message: String?
    let data: InviteBidsData?
}

// MARK: - DataClass
struct InviteBidsData: Codable {
    let createProjectHistory: CreateProjectHistoryDetails?
    let createSubProject: CreateSubProjectDetails?
    let createTask: CreateTaskDetails?
    let createTaskDeliverable: [CreateTaskDeliverableDetails]?
    let createTaskImages: [CreateTaskImagesDetails]?
}

struct CreateTaskImagesDetails: Codable {
    let createdAt: String?
    let file: String?
    let id: Int?
    let isBlocked: String?
    let isDeleted: String?
    let projectId: Int?
    let title: String?
    let type: String?
    let updatedAt: String?
    let userId: Int?
}


struct CreateTaskDeliverableDetails: Codable {
    let createdAt: String?
    let deliveralble: String?
    let deliveralbleOrder: String?
    let id: Int?
    let projectId: Int?
    let updatedAt: String?
    let userId: Int?
}

struct CreateTaskDetails: Codable {
    let assigneeId: String?
    let budget: String?
    let completDateByAdmin: String?
    let createdAt: String?
    let id: Int?
    let isBlocked: String?
    let isDeleted: String?
    let mainProjectId: String?
    let paymentStatus: String?
    let projectId: Int?
    let status: String?
    let task: String?
    let taskType: Int?
    let type: String?
    let updatedAt: String?
    let userId: Int?
}

struct CreateSubProjectDetails: Codable {
    let addressLine1: String?
    let amountCurrency: String?
    let city: String?
    let country: String?
    let createdAt: String?
    let finalPrice: String?
    let id: Int?
    let isAdminCompleted: String?
    let isAdminPermission: String?
    let isBlocked: String?
    let isDeleted: String?
    let price: String?
    let projectType: Int?
    let state: String?
    let status: String?
    let subProjectId: String?
    let title: String?
    let type: String?
    let updatedAt: String?
    let userId: Int?
    let zipCode: String?
}

struct CreateProjectHistoryDetails: Codable {
    let createdAt: String?
    let id: Int?
    let isBlocked: String?
    let isDeleted: String?
    let message: String?
    let projectId: String?
    let updatedAt: String?
}
